#!/bin/bash

wget -O python-dist.tar.xz "https://output.circle-artifacts.com/output/job/ebca3f51-5ea5-4f65-8e4d-57725ef64642/artifacts/0/artifact/python-3.11.2.tar.xz"

sudo tar --extract --directory /usr/local --strip-components=2 --file python-dist.tar.xz

sudo update-alternatives --install /usr/bin/python python /usr/local/python-3.11.2/bin/python3.11 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/python-3.11.2/bin/python3.11 1
