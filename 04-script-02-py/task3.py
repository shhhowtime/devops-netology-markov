#!/usr/bin/env python3

import os
import sys

current_path=sys.argv[1]
if os.path.isdir(f'{current_path}/.git'):
    bash_command = "git status"
    result_os = os.popen(f'cd {current_path} && {bash_command}').read()
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', current_path)
            print(prepare_result)
else:
    print('Directory is not a git repository')
