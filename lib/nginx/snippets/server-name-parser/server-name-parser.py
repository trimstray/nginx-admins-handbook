#!/usr/bin/env python3.6

import sys
import re

def main(argv):

    if len(argv) != 2:
        print('\x1b[1;31;40m' + 'ERROR:' + '\x1b[0m' + ' I need two args: server-name-parser.py <filename> <domain>')
        return

    input_file = argv[0]
    domain = re.escape(argv[1])

    with open (input_file, "r", encoding="utf-8") as myfile:

        data = myfile.read()

        s_server = re.findall('([ \#]*server\s\{[.\s\na-zA-Z\/0-9\;\_\{\:\#\-]*server_name\s[.\s\na-zA-Z\/0-9\~\^\.\*\-*\;\_\{\:\#]*%s[\s\n;][\s\S]*?(?<=\n)[\#\s]})' % domain, data, re.MULTILINE | re.DOTALL)

        dash_f = '>' * 10
        dash_l = '<' * 10

        if not s_server:
            print('\x1b[0;33;40m' + 'WARNING:' + '\x1b[0m' + ' The following domain could not be found.')

        else:
            for line in s_server:
                print('\x1b[0;33;40m' + dash_f + '\x1b[0m' + '\x1b[1;36;40m' + ' BEG ' + '\x1b[0;33;40m' + dash_f + '\x1b[0m')
                print(line)
                print('\x1b[0;33;40m' + dash_l + '\x1b[0m' + '\x1b[1;36;40m' + ' END ' + '\x1b[0;33;40m' + dash_l + '\x1b[0m' + '\n')

if __name__ == "__main__":
  main(sys.argv[1:])
