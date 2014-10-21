#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ngccli.base import Service

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

class NGCUnitTest(Service):

	def __init__(self, subparsers):
		# get a command-line parser
		self.parser = subparsers.add_parser('unit', help='unit help')

	def main(self, args=None):
		"""
		"""

	#---------------------------------------------------------------------------#
	#---------------------------------------------------------------------------#

	class Factory:
		def create(self, subparsers): return NGCUnitTest(subparsers)

# class NGCSource
