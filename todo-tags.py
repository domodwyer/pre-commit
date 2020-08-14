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

DEFAULT_TAG = "DEV"

parser = argparse.ArgumentParser()
parser.add_argument('-t', '--tag', 
                    type=str,
                    help="A JIRA-like tag (i.e. DEV) to search for", 
                    default=DEFAULT_TAG, 
                    dest='tag')
					
parser.add_argument('-r', '--regex', 
					type=str,
                    help="Specify the regex to match inner in TODO(inner)",
                    dest='regex')

parser.add_argument('files', metavar='FILES', type=str, nargs='+',
                    help='Files to search')

args = parser.parse_args()

# Do not allow specifying a tag and --regex
if args.regex and args.tag != DEFAULT_TAG:
	sys.exit("cannot provide tag with --regex")

# Figure out what regex to use
tag = args.tag + "-[0-9]+"
if args.regex:
	tag = args.regex

# This regex matches all TODO comments (prefixed by // or #) that are not
# immediately followed by "($TAG)"
pattern = re.compile(
    r"(\/\/|#)+\s?TODO((?!\("+tag+r"\)).)*$", re.IGNORECASE)

ret = 0
for f in args.files:
    for i, line in enumerate(open(f)):
        for match in re.finditer(pattern, line):
            print('%s:%s %s' % (f, i+1, match.string.strip()))
            ret += 1

exit(ret)
