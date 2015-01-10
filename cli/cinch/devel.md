<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(CLI) -->

## Adding services

The Cinch CLI can easily be extended with new services.
To add a new service, first
take a look at one of the files under 'cinch/services' (other than
\_init\_.py or any of the .pyc files).  Each of these services inherits
from the Service base class (defined in 'cinch/base.py').  The important
parts to include in a new service are captured in the following example:

~~~~ {#serviceexample .python .numberLines startFrom="0"}
   # example_service.py

    from cinch.base import Service

    class MyService(Service):

    def __init__(self, subparsers):

        # add a parser for this service
        self.parser = subparsers.add_parser('name of service',
            help='description of service')
  
        # set the callback for this service
        self.parser.set_defaults(func=self.main)
  
    # __init__
  
    def main(self, args=None)
        print 'Hello World'
    # main
  
    class Factory:
        def create(self, subparsers): return MyService(subparsers)
~~~~


In this strawman example, we import the Service base class definition on
line 02.  Line 04 defines our new service class.  In lines 06 through 15,
we define the class initialization.  Lines 09 and 10 request a parser
for our service that was passed in from the main command-line interface
class (defined in 'cinch/clidriver.py').  To add new options, take a look
at the python documentation for the argparse module.  Line 13 sets the
callback method associated with our service name to the main method of
our new service class.  In this example, the main method just prints out
the familiar 'Hello World'.  This method can be modified and extended to
implement the actual details of the new service.

The last detail is the factory class defined on lines 21 through 22. This
class defines a single method 'create' that returns a new instance of our
service class. The naming conventions used in the factory class definition
and create method must be observed for this pattern to automatically
recognize and add new services.  NOTE: The factory class is nested within
the service class.

That's it!  Put your new .py file into the services subdirectory and it
should automatically be recognized by the cinch command-line script.  If you
have a more complex implementation that requires multiple files, you can
create a new subdirectory in 'services' (an example is the 'source_drivers'
directory).

The new service 'myservice' can be called using:

*% cinch myservice*

Help for the service is available with:

*% cinch myservice -h*
