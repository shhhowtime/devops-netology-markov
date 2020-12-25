#!/usr/bin/env python3

from socket import gethostbyname
from os import path, remove

if path.isfile('previous_addresses.txt'):
    try:
        f = open('previous_addresses.txt', 'r')
        cont=f.read()
        f.close()
    except:
        print('File with previous addresses does not exist, will be created a new one')
    if 'cont' in locals():
        try:
            old_addresses = eval(cont)
        except:
            print('File with previous addresses corrupted, removing file')
            remove('previous_addresses.txt')

sites=('drive.google.com', 'mail.google.com', 'google.com')
new_addresses = {}
for site in sites:
    address = gethostbyname(site)
    print(f'{site} - {address}')
    new_addresses[site] = address
    if 'old_addresses' in locals():
        if old_addresses[site] != address:
            print(f'[ERROR] {site} IP mismatch: {old_addresses[site]} {address}')

f = open('previous_addresses.txt', 'w')
f.write(str(new_addresses))
f.close()

