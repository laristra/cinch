#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Service factory to create instances of classes that derive from Service.
#------------------------------------------------------------------------------#

class ServiceFactory:
	factories = {}

	def add_factory(id, factory):
		factories.put[id] = factory
	add_factory = staticmethod(add_factory)

	def add_service(id):
		if not factories.has_key(id):
			factories[id] = eval(id + '.factory()')
		return factories[id].create();

#------------------------------------------------------------------------------#
		# Service base class
#------------------------------------------------------------------------------#

class Service(object): pass
