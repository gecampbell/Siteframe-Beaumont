#!/bin/sh
awk '/^[Vv]ersion/ {print $2; exit}' ../CHANGELOG.txt
