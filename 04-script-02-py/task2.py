#!/usr/bin/env python3

import os

bash_command = ["cd ~/repos/netology/devops-netology-markov", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False   - это вообще лишнее
current_path=os.path.expanduser("~/repos/netology/devops-netology-markov/")
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', current_path)
        print(prepare_result)
