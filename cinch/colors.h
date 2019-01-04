/*
    :::::::: ::::::::::: ::::    :::  ::::::::  :::    :::
   :+:    :+:    :+:     :+:+:   :+: :+:    :+: :+:    :+:
   +:+           +:+     :+:+:+  +:+ +:+        +:+    +:+
   +#+           +#+     +#+ +:+ +#+ +#+        +#++:++#++
   +#+           +#+     +#+  +#+#+# +#+        +#+    +#+
   #+#    #+#    #+#     #+#   #+#+# #+#    #+# #+#    #+#
    ######## ########### ###    ####  ########  ###    ###

   Copyright (c) 2016, Los Alamos National Security, LLC
   All rights reserved.
                                                                              */
#pragma once

/*! @file */

#include <cinch-config.h>

//----------------------------------------------------------------------------//
// Set color output macros depending on whether or not CLOG_COLOR_OUTPUT
// is defined.
//----------------------------------------------------------------------------//

#ifndef CLOG_COLOR_OUTPUT

#define CLOG_COLOR_BLACK ""
#define CLOG_COLOR_DKGRAY ""
#define CLOG_COLOR_RED ""
#define CLOG_COLOR_LTRED ""
#define CLOG_COLOR_GREEN ""
#define CLOG_COLOR_LTGREEN ""
#define CLOG_COLOR_BROWN ""
#define CLOG_COLOR_YELLOW ""
#define CLOG_COLOR_BLUE ""
#define CLOG_COLOR_LTBLUE ""
#define CLOG_COLOR_PURPLE ""
#define CLOG_COLOR_LTPURPLE ""
#define CLOG_COLOR_CYAN ""
#define CLOG_COLOR_LTCYAN ""
#define CLOG_COLOR_LTGRAY ""
#define CLOG_COLOR_WHITE ""
#define CLOG_COLOR_PLAIN ""

#define CLOG_OUTPUT_BLACK(s) s
#define CLOG_OUTPUT_DKGRAY(s) s
#define CLOG_OUTPUT_RED(s) s
#define CLOG_OUTPUT_LTRED(s) s
#define CLOG_OUTPUT_GREEN(s) s
#define CLOG_OUTPUT_LTGREEN(s) s
#define CLOG_OUTPUT_BROWN(s) s
#define CLOG_OUTPUT_YELLOW(s) s
#define CLOG_OUTPUT_BLUE(s) s
#define CLOG_OUTPUT_LTBLUE(s) s
#define CLOG_OUTPUT_PURPLE(s) s
#define CLOG_OUTPUT_LTPURPLE(s) s
#define CLOG_OUTPUT_CYAN(s) s
#define CLOG_OUTPUT_LTCYAN(s) s
#define CLOG_OUTPUT_LTGRAY(s) s
#define CLOG_OUTPUT_WHITE(s) s

#else

#define CLOG_COLOR_BLACK    "\033[0;30m"
#define CLOG_COLOR_DKGRAY   "\033[1;30m"
#define CLOG_COLOR_RED      "\033[0;31m"
#define CLOG_COLOR_LTRED    "\033[1;31m"
#define CLOG_COLOR_GREEN    "\033[0;32m"
#define CLOG_COLOR_LTGREEN  "\033[1;32m"
#define CLOG_COLOR_BROWN    "\033[0;33m"
#define CLOG_COLOR_YELLOW   "\033[1;33m"
#define CLOG_COLOR_BLUE     "\033[0;34m"
#define CLOG_COLOR_LTBLUE   "\033[1;34m"
#define CLOG_COLOR_PURPLE   "\033[0;35m"
#define CLOG_COLOR_LTPURPLE "\033[1;35m"
#define CLOG_COLOR_CYAN     "\033[0;36m"
#define CLOG_COLOR_LTCYAN   "\033[1;36m"
#define CLOG_COLOR_LTGRAY   "\033[0;37m"
#define CLOG_COLOR_WHITE    "\033[1;37m"
#define CLOG_COLOR_PLAIN    "\033[0m"

#define CLOG_OUTPUT_BLACK(s) CLOG_COLOR_BLACK << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_DKGRAY(s) CLOG_COLOR_DKGRAY << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_RED(s) CLOG_COLOR_RED << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_LTRED(s) CLOG_COLOR_LTRED << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_GREEN(s) CLOG_COLOR_GREEN << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_LTGREEN(s) CLOG_COLOR_LTGREEN << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_BROWN(s) CLOG_COLOR_BROWN << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_YELLOW(s) CLOG_COLOR_YELLOW << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_BLUE(s) CLOG_COLOR_BLUE << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_LTBLUE(s) CLOG_COLOR_LTBLUE << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_PURPLE(s) CLOG_COLOR_PURPLE << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_LTPURPLE(s) CLOG_COLOR_LTPURPLE << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_CYAN(s) CLOG_COLOR_CYAN << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_LTCYAN(s) CLOG_COLOR_LTCYAN << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_LTGRAY(s) CLOG_COLOR_LTGRAY << s << CLOG_COLOR_PLAIN
#define CLOG_OUTPUT_WHITE(s) CLOG_COLOR_WHITE << s << CLOG_COLOR_PLAIN

#endif // CLOG_COLOR_OUTPUT
