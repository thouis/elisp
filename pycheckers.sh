#!/bin/bash
# epylint "$1" 2>/dev/null
# pyflakes "$1"
pep8 --repeat "$1"
# pep8 --ignore=E501,E293 --repeat "$1"
true
