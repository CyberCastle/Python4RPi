#!/bin/bash

wget -O python-dist.tar.xz "https://output.circle-artifacts.com/output/job/88d52ee6-147b-4c4d-aa06-514d7e60b6ae/artifacts/0/artifact/python-3.11.2.tar.xz"

sudo tar --extract --directory /usr/local --strip-components=2 --file python-dist.tar.xz

sudo update-alternatives --install /usr/bin/python python /usr/local/python-3.11.2/bin/python3.11 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/python-3.11.2/bin/python3.11 1
