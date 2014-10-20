#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from __future__ import generators
import random
import sys
import argparse
from ngccli.factory import *
from ngccli.services import *

def main():
	driver = create_clidriver()
	return driver.main()

def create_clidriver():
	driver = CLIDriver()
	return driver

#------------------------------------------------------------------------------#
# CLIDriver class
#------------------------------------------------------------------------------#

class CLIDriver():

	def __init__(self):
		self.parser = argparse.ArgumentParser()
		self.subparsers = self.parser.add_subparsers(help='sub-command help',
			dest='subparser_name')

	def main(self, args=None):
		"""
		"""
		print "Here I Am"
		
		for t in Service.__subclasses__():
			print t.__name__

#		if args is None:
#			args = sys.argv[1:]
#		commands = self._build_commands()
#		print commands

#	def _build_commands(self):
#		commands = { 'source': NGCSource() }
#		return commands

# class CLIDriver
