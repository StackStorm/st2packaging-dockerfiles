#!/usr/bin/env python
import os
import sys
import subprocess
import copy

scriptdir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(scriptdir)

from update import UpdateCLI, Suite, dockerfile_path
from string import maketrans


class PublishCLI(UpdateCLI):
    CLIDESC = """Generate Dockerfile(s) from suite template files.
    """

    def parse(self):
        self.parser.add_argument('--rm', action='store_true',
                                 help='Remove intermediate containers after a successful build.')
        self.parser.add_argument('--no-cache', action='store_true',
                                 help='Do not use cache when building the image.')
        self.parser.add_argument('--no-push', action='store_true',
                                 help='Do not use cache when building the image.')
        super(PublishCLI, self).parse()


def shell_out(command):
    rs = subprocess.call(command, shell=True)
    if rs != 0:
        sys.exit(rs)


def convert_to_dash(s):
    dashtbl = maketrans('_', '-')
    return s.translate(dashtbl)


def get_build_opts(option_list, args):
    build_opts = ('--{}'.format(convert_to_dash(a)) for a in option_list if args[a])
    return ' '.join(build_opts)


# String formats
TAG = '{registry}{image}:{suite}{variant}'
BUILD = 'docker build {options} -f {path} -t {tag} .'
TAG_LATEST = 'docker tag -f {tag} {registry}{image}:latest'
PUSH = 'docker push {tag}'


def main():
    """Reads suite Dockerfile files
    """
    cli = PublishCLI()
    opts = cli.process_options(abort_on_missing_template=False)
    args = cli.arguments
    suite = Suite(workdir=opts['image_dir'], suites=opts['suites'])

    build_opts = ['no_cache', 'rm']
    build_opts = get_build_opts(build_opts, args)

    for ctx in suite.process():
        fmt = ctx.copy()
        fmt['path'] = dockerfile_path(suite=fmt['suite'], variant=fmt['variant'])
        try:
            os.stat(fmt['path'])
        except os.error:
            msg = "Dockerfile for {} {} is empty or missing. Skipping..."
            print(msg.format(fmt['suite'], fmt['variant'] or "(default variant)"))
            continue
        fmt['variant'] = '-{}'.format(fmt['variant']) if fmt['variant'] else ''
        fmt['tag'] = TAG.format(**fmt)
        fmt['options'] = build_opts

        # Run docker build
        shell_out(BUILD.format(**fmt))

        # Tag latestest if suite.yml contains latest option
        if fmt['suite'] + fmt['variant'] == suite.latest:
            shell_out(TAG_LATEST.format(**fmt))
            if not args['no_push']:
                shell_out(PUSH.format(tag='{registry}{image}:latest'.format(**fmt)))

        # Push image
        if not args['no_push']:
            shell_out(PUSH.format(**fmt))


if __name__ == '__main__':
    main()
