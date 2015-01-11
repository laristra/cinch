#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import re

cxx_syntax = {
    'begin' : '/*-',
    'bstart' : 10,
    'bend' : 2,
    'end' : ' *--',
    'estart' : 11,
    'eend' : 3,
    'set' : '~',
    'unset' : '-',
    'suffixes' : ('.cc', '.h'),
    'prepend' : ' * '
}

shell_syntax = {
    'begin' : '#--',
    'bstart' : 10,
    'bend' : 2,
    'end' : '#=-',
    'estart' : 10,
    'eend' : 2,
    'set' : '~',
    'unset' : '-',
    'suffixes' : ('.cmake', '.txt'),
    'prepend' : '# '
}

comment_syntax = {
    'cxx' : cxx_syntax,
    'shell' : shell_syntax
}

def begin_identifier(line, syntax, refs):
    if syntax['begin'] in line and syntax['set'] in line:
        signature = re.sub(syntax['set'], '1', re.sub(syntax['unset'], '0',
            line[len(line)-syntax['bstart']:len(line)-syntax['bend']]))
        refs['index'] = int(signature, base=2)
        refs['begin'] = line.rstrip('\n')
        return True

    return False
# begin_identifier

def end_identifier(line, syntax, refs):
    if syntax['end'] in line and syntax['set'] in line:
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
