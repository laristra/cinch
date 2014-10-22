#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Helper strings
#------------------------------------------------------------------------------#

begin_cmnt = '/*--------------------------------------------'
begin_cmnt += '--------------------------------*\n'
end_cmnt = ' *--------------------------------------------'
end_cmnt += '--------------------------------*/\n'

copyright =   ' * Copyright (c) 2014 Los Alamos National Security, LLC\n'
copyright +=  ' * All rights reserved.\n'

newline = '\n'
tab = '\t'

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def create_header_template(args):

	"""
	"""
	
	if not args.filename == None:
		header = args.filename + '.hh'
	else:
		header = args.classname + '.hh'

	fd = open(header, 'w')

	# write copyright and opening define
	fd.write(begin_cmnt)
	fd.write(copyright)
	fd.write(end_cmnt + newline)

	fd.write('#ifndef ' + args.classname + '_hh' + newline)
	fd.write('#define ' + args.classname + '_hh' + newline)
	fd.write(newline)

	#---------------------------------------------------------------------------#
	# Doxygen class stubs
	#---------------------------------------------------------------------------#

	fd.write('/*!' + newline)
	fd.write('\t\\class ' + args.classname + ' ' +
		args.classname + '.hh' + newline)
	fd.write('\t\\brief ' + args.classname + ' provides...' + newline)
	fd.write(' */' + newline)

	if args.template:
		fd.write('template<typename T>' + newline)

	#---------------------------------------------------------------------------#
	# open class
	#---------------------------------------------------------------------------#

	fd.write('class ' + args.classname + newline + '{' + newline)

	#---------------------------------------------------------------------------#
	# public methods and members
	#---------------------------------------------------------------------------#

	fd.write('public:')
	fd.write(newline)
	fd.write(newline)

	fd.write(tab + '//! Default constructor' + newline)
	fd.write(tab + args.classname + '() {}\n')

	fd.write(newline)

	fd.write(tab + '//! Destructor' + newline)
	if args.baseclass:
		fd.write(tab + 'virtual ~' + args.classname + '() {}' + newline)
	else:
		fd.write(tab + '~' + args.classname + '() {}' + newline)

	fd.write(newline)

	#---------------------------------------------------------------------------#
	# protected methods and members
	#---------------------------------------------------------------------------#

	if args.baseclass:
		fd.write('protected:' + newline)
		fd.write(newline)

	#---------------------------------------------------------------------------#
	# private methods and members
	#---------------------------------------------------------------------------#

	fd.write('private:' + newline)
	fd.write(newline)

	fd.write(tab + '//! Copy constructor' + newline)
	fd.write(tab + args.classname + '(const & ' + args.classname +
		') {} = delete;' + newline)
	fd.write(newline)

	fd.write(tab + '//! Assignment operator' + newline)
	fd.write(tab + args.classname + ' & operator = (const & ' +
		args.classname + ') {} = delete;' + newline)
	fd.write(newline)

	#---------------------------------------------------------------------------#
	# close class
	#---------------------------------------------------------------------------#

	fd.write('}; // class ' + args.classname + newline)
	fd.write(newline)


	#---------------------------------------------------------------------------#
	# closing define
	#---------------------------------------------------------------------------#

	fd.write('#endif // ' + args.classname + '_hh' + newline)

	#---------------------------------------------------------------------------#
	# close file handle
	#---------------------------------------------------------------------------#

	fd.close()

# create_header_template

def create_source_template(args):

	"""
	"""

	if not args.filename == None:
		source = args.filename + '.cc'
	else:
		source = args.classname + '.cc'

	fd = open(source, 'w')

	# write copyright and opening define
	fd.write(begin_cmnt)
	fd.write(copyright)
	fd.write(end_cmnt + newline)

	# include header
	fd.write('#include <' + args.classname + '.hh>' + newline)
	fd.write(newline)

	# method stub
	fd.write('/*' + newline)
	fd.write(' * Method description (not doxygen)' + newline)
	fd.write(' * Doxygen documentaiton should go in the header' + newline)
	fd.write(' */' + newline)
	fd.write(args.classname + '::method()' + newline)
	fd.write('{' + newline)
	fd.write('} // ' + args.classname + '::method' + newline)

# create_source_template
