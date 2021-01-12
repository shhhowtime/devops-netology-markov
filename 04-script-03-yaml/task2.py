#!/usr/bin/env python3

from socket import gethostbyname
from json import dumps
from yaml import dump
import time

sites=('drive.google.com', 'mail.google.com', 'google.com')
old_addresses = {}

while 1:
    new_addresses = {}
    for site in sites:
        address = gethostbyname(site)
        print(f'{site} - {address}')
        new_addresses[site] = address
        if old_addresses != {}:
            if old_addresses[site] != address:
                print(f'[ERROR] {site} IP mismatch: {old_addresses[site]} {address}')

    old_addresses = new_addresses

    f = open('previous_addresses.json', 'w')
    for host in new_addresses:
        current_address = { host : new_addresses[host] }
        f.write(dumps(current_address))
        f.write("\n")
    f.close()
    f = open('previous_addresses.yaml', 'w')
    for host in new_addresses:
        current_address = { host : new_addresses[host] }
        f.write("- ")
        f.write(dump(current_address))
    f.close()
    time.sleep(5)
