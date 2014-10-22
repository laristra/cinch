#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ngccli.base import Service

#------------------------------------------------------------------------------#
# Unit test handler.
#------------------------------------------------------------------------------#

class NGCUnitTest(Service):

	#---------------------------------------------------------------------------#
	# Initialization.
	#---------------------------------------------------------------------------#

	def __init__(self, subparsers):

		"""
		"""

		# get a command-line parser
		self.parser = subparsers.add_parser('unit',
			help='Service to generate unit test templates.')

		# set the callback for this sub-command
		self.parser.set_defaults(func=self.main)

	# __init__

	#---------------------------------------------------------------------------#
	# Main.
	#---------------------------------------------------------------------------#

	def main(self, args=None):

		"""
		"""

	# main

	#---------------------------------------------------------------------------#
	# Object factory for service creation.
	#---------------------------------------------------------------------------#

	class Factory:
		def create(self, subparsers): return NGCUnitTest(subparsers)

# class NGCSource
