#! /usr/bin/env python

import os
import glob
import ngccli
from setuptools import setup, find_packages

requires = []

setup_options = dict(
	name = 'ngccli',
	version = ngccli.__version__,
	description = 'Command Line Environment for NGC',
	long_description = open('README.rst').read(),
	author = 'Ben Bergen',
	author_email = 'bergen@lanl.gov',
	scripts = ['bin/ngc'],
	packages = find_packages('.', exclude=['tests*']),
	package_dir = {'ngccli': 'ngccli'},
	license = 'NONE'
)

setup(**setup_options)
