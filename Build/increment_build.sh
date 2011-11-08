#!/bin/sh
expr `cat build.dat` + 1 > tmp
mv tmp build.dat
