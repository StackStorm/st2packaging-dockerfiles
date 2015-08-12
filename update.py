#!/usr/bin/env python
import argparse
import os.path
import sys
import yaml
import re
import glob
import jinja2
import difflib


def dockerfile_template_name(variant):
    tpl_list = filter(None, ("Dockerfile.template", variant))
    filepath = '-'.join(tpl_list)
    # Abort if template not found, this is misconfiguration.
    if not os.path.isfile(filepath):
        print("Error: template file `{}' not found!".format(filepath))
        sys.exit(1)
    return filepath


def dockerfile_path(suite=None, variant=None, **_):
    tgt_list = filter(None, (suite, variant, 'Dockerfile'))
    return '/'.join(tgt_list)


def template_exists(basepath='', abort=False):
    template_path = os.path.join(basepath, 'Dockerfile.template')
    exists = os.path.isfile(template_path)
    if not exists and abort is True:
        print("Error: {} file not found!".format(template_path))
        sys.exit(1)
    return exists


def eqauls_or_matches(s, str_or_regex):
    """Returns true or regex match.
    """
    _type = type(re.compile(''))
    if isinstance(str_or_regex, _type):
        return re.match(str_or_regex, s)
    elif s == str_or_regex:
        return True


def match_and_fetch(value, item_or_hash):
    """Expands a list of hashes or just strings. Returns actual item or hash key
    on string or regex match.
    """
    def matches(s, match_list):
        for str_or_regex in match_list:
            if eqauls_or_matches(s, str_or_regex):
                return True

    item = item_or_hash
    if isinstance(item, dict):
        item, match_list = item.items()[0]
    else:
        match_list = [value]

    if matches(value, match_list):
        return item


def render_template(ctx):
    """Renderes Dockerfile jinja2 template.
        - template_name is name or a relative path.
    """
    jenv = jinja2.Environment(loader=jinja2.FileSystemLoader('.'))
    template_name = dockerfile_template_name(variant=ctx['variant'])
    template = jenv.get_template(template_name)
    return template.render(ctx)


class UpdateCLI(object):
    CLIDESC = """Generate Dockerfile(s) from suite template files.
    """

    def __init__(self):
        self.parser = argparse.ArgumentParser(description=self.CLIDESC)
        self.options = {}
        self.arguments = {}

    def parse(self):
        self.parser.add_argument('image', nargs='?',
                                 help='Path to an image directory containing Dockerfile.template.')
        self.parser.add_argument('suites', metavar='suite', nargs='*',
                                 help='Specifies a list of suites to work on.')
        self.arguments = vars(self.parser.parse_args())
        return self.arguments

    def process_options(self, abort_on_missing_template=True):
        """Process options, parse command line arguments and construct an
        options hash.
        """
        self.parse()

        image = self.arguments['image']
        suites = self.arguments['suites']
        image_dir = os.path.abspath(os.getcwd())

        if image:
            if template_exists():
                # template exists in ./ ,so the first argument is a suite
                suites.insert(0, os.path.basename(image_dir))
            else:
                image_dir = os.path.abspath(image)
                # check and abort if required
                template_exists(basepath=image, abort=abort_on_missing_template)

        # no arguments given, so we must be inside a directory with a suite template.
        else:
            template_exists(abort=abort_on_missing_template)

        self.options = {
            'image_dir': image_dir,
            'suites': suites
        }
        return self.options


class Suite(object):
    def __init__(self, workdir, suites):
        self.distmap_cache = {}
        self.workdir = workdir
        self.image = os.path.basename(os.path.abspath(workdir))
        self.registry = ''
        self.suites = suites
        self.variants = [None]
        self.latest = None
        self.load_suite_config()

    def load_suite_config(self):
        yaml.add_constructor('!regexp', lambda l, n: re.compile(l.construct_scalar(n)))

        confpath = os.path.join(self.workdir, 'suite.yml')
        if os.path.isfile(confpath):
            fd = open(confpath, 'r')
            for opt, value in yaml.load(fd).items():
                if value:
                    setattr(self, opt, value)
            fd.close()

    def load_distmap(self):
        """Looks up dist.yml starting in the current directory and up the tree,
        if it's found returns its content.
        """
        found = None
        path = os.getcwd()
        while path != '/':
            ymlpath = os.path.join(path, 'dist.yml')
            if ymlpath in self.distmap_cache:
                return self.distmap_cache[ymlpath]
            if os.path.isfile(ymlpath):
                found = ymlpath
                break
            path = os.path.dirname(path)
        if not found:
            print("Error: file `dist.yml' not found in current or its parent directories!")
            sys.exit(1)

        fd = open(found, 'r')
        data = (yaml.load(fd) or {})
        fd.close()
        self.distmap_cache[found] = data
        return (data or {})

    def process(self):
        curd = os.getcwd()
        os.chdir(self.workdir)
        # Specific suites haven't been set, so list all directories
        if not self.suites:
            self.suites = (s.rstrip('/') for s in glob.glob('*/'))

        for suite in self.suites:
            for variant in self.variants:
                # Variant is None what means default, so empty string
                if variant is None:
                    yield(self.suite_context(suite, ''))
                else:
                    # Variant matches suite list of names or regexes
                    variant = match_and_fetch(suite, variant)
                    if variant:
                        yield(self.suite_context(suite, variant))
        os.chdir(curd)

    def suite_context(self, suite, variant):
        """Return context of a process suite. Hash of variables.
        """
        dist, version = self.find_distver(suite)
        return {
            'suite': suite,
            'variant': variant,
            'dist': dist,
            'version': version,
            'image': self.image,
            'registry': self.registry
        }

    def find_distver(self, suite):
        """Find dist and its version by a suite name. Uses mappings from dist.yaml.
        """
        for dist, mappings in self.load_distmap().items():
            for str_or_regex in mappings:
                ematch = eqauls_or_matches(suite, str_or_regex)
                if ematch is True:
                    return (dist, suite)
                elif ematch:
                    return (dist, ematch.group(1) or suite)
        print("Warn: suite to dist mapping not found! Check dist.yml for `{}' mapping."
              .format(suite))
        return ('', suite)


def main():
    """Reads Dockerfile.template* files and genterates corresponding Dockerfile files.
    """
    cli = UpdateCLI()
    opts = cli.process_options()
    sp = Suite(workdir=opts['image_dir'], suites=opts['suites'])

    for ctx in sp.process():
        rendered = render_template(ctx)
        target_filepath = dockerfile_path(suite=ctx['suite'], variant=ctx['variant'])
        target_abspath = os.path.abspath(target_filepath)
        target_filepath_parent = os.path.dirname(target_abspath)

        # ensure we have parent directory
        if not os.path.isdir(target_filepath_parent):
            os.makedirs(target_filepath_parent)

        mode = 'r+' if os.path.isfile(target_filepath) else 'w+'
        fd = open(target_filepath, mode)
        current_lines = fd.read().splitlines()
        fd.seek(0)
        fd.truncate()

        for line in difflib.unified_diff(current_lines, rendered.splitlines(),
                                         fromfile=target_abspath + '.~',
                                         tofile=target_abspath,
                                         lineterm='', n=0):
            print line

        fd.write("{}\n".format(rendered))
        fd.close()

if __name__ == '__main__':
    main()
