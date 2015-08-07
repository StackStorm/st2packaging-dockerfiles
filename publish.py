#!/usr/bin/env python
import os.path
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
TAG_FMT = '{registry}{image}:{suite}{variant}'
BUILD_FMT = 'docker build {options} -f {path} -t {tag} .'
TAGLATEST_FMT = 'docker tag -f {tag} {registry}{image}:latest'
PUSH_FMT = 'docker push {tag}'


def main():
    """Reads suite Dockerfile files
    """
    cli = PublishCLI()
    opts = cli.process_options()
    args = cli.arguments
    suite = Suite(workdir=opts['image_dir'], suites=opts['suites'])

    build_opts = ['no_cache', 'rm']
    build_opts = get_build_opts(build_opts, args)

    for ctx in suite.process():
        variant = ''
        if ctx['variant']:
            variant = '-{}'.format(ctx['variant'])

        _ctx = {'variant': variant}
        _ctx.update(ctx)
        tag = TAG_FMT.format(**_ctx)

        # Run docker build
        shell_out(BUILD_FMT.format(path=dockerfile_path(ctx),
                                   options=build_opts,
                                   tag=tag))

        # Tag latestest if suite.yml contains latest option
        if ctx['suite'] + ctx['variant'] == suite.latest:
            shell_out(TAGLATEST_FMT.format(registry=ctx['registry'],
                                           image=ctx['image'],
                                           tag=tag))

        # Push image
        if not args['no_push']:
            shell_out(PUSH_FMT.format(tag=tag))


if __name__ == '__main__':
    main()
