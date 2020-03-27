#!/usr/bin/env python3 -s

# Searches passed files for TODO comments.
#
# Prints out (and exits non-zero) if any TODO comments are not in the form:
#
#       TODO(DEV-1234): some text
#
# Ensuring all TODOs are either complete when opening the PR, or have a JIRA
# ticket to track the future change.

import argparse
import re
import sys

parser = argparse.ArgumentParser()
parser.add_argument('-t', '--tag', type=str,
                    help="The JIRA tag (i.e. DEV) to search for", default="DEV", dest='tag')
parser.add_argument('files', metavar='FILES', type=str, nargs='+',
                    help='Files to search')

args = parser.parse_args()

# This regex matches all TODO comments (prefixed by // or #) that are not
# immediately followed by "($TAG-0000)"
pattern = re.compile(
    r"(\/\/|#)+\s?TODO((?!\("+args.tag+r"-[0-9]+\)).)*$", re.IGNORECASE)

ret = 0
for f in args.files:
    for i, line in enumerate(open(f)):
        for match in re.finditer(pattern, line):
            print('%s:%s %s' % (f, i+1, match.string.strip()))
            ret += 1

exit(ret)
