#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import re

cxx_syntax = {
    'begin' : '/*~',
    'bstart' : 10,
    'bend' : 2,
    'end' : ' *~-',
    'estart' : 11,
    'eend' : 3,
    'set' : '~',
    'unset' : '-',
    'suffixes' : ('.cc', '.h'),
    'prepend' : ' * '
}

cmake_syntax = {
    'begin' : '#~-',
    'bstart' : 10,
    'bend' : 2,
    'end' : '#~-',
    'estart' : 10,
    'eend' : 2,
    'set' : '~',
    'unset' : '-',
    'suffixes' : ('.cmake', '.txt'),
    'prepend' : '# '
}

python_syntax = {
    'begin' : '#~-',
    'bstart' : 10,
    'bend' : 2,
    'end' : '#~-',
    'estart' : 10,
    'eend' : 2,
    'set' : '~',
    'unset' : '-',
    'suffixes' : ('.py'),
    'prepend' : '# '
}

latex_syntax = {
    'begin' : '%~-',
    'bstart' : 10,
    'bend' : 2,
    'end' : '%~-',
    'estart' : 10,
    'eend' : 2,
    'set' : '~',
    'unset' : '-',
    'suffixes' : ('.tex'),
    'prepend' : '# '
}

comment_syntax = {
    'cxx' : cxx_syntax,
    'cmake' : cmake_syntax,
    'python' : python_syntax,
    'latex' : latex_syntax
}

def begin_identifier(line, syntax, refs):
    # This conditional only looks at the last n-10 characters
    # of the line so that we can use '~' as a delimiter at the
    # start of the comment.
    if syntax['begin'] in line and syntax['set'] in line[10:]:
        signature = re.sub(syntax['set'], '1', re.sub(syntax['unset'], '0',
            line[len(line)-syntax['bstart']:len(line)-syntax['bend']]))
        refs['index'] = int(signature, base=2)
        refs['begin'] = line.rstrip('\n')
        return True

    return False
# begin_identifier

def end_identifier(line, syntax, refs):
    # This conditional only looks at the last n-10 characters
    # of the line so that we can use '~' as a delimiter at the
    # start of the comment.
    if syntax['end'] in line and syntax['set'] in line[10:]:
        signature = re.sub(syntax['set'], '1', re.sub(syntax['unset'], '0',
            line[len(line)-syntax['estart']:len(line)-syntax['eend']]))
        refs['end'] = line.rstrip('\n')
        return True

    return False
# begin_identifier

def init_refs():
    return {
        'index' : '0',
        'begin' : "ERROR",
        'end' : "ERROR"
    }
# init_ref

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
