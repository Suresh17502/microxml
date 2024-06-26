#
# Makefile for microxml, a micro XML-like file parsing library.
#
# Copyright 2003-2011 by Michael R Sweet.
# Copyright 2011-2012 by Luka Perkov.
#
# These coded instructions, statements, and computer programs are the
# property of Michael R Sweet and Luka Perkov. They are protected by
# Federal copyright law. Distribution and use rights are outlined in
# the file "COPYING" which should have been included with this file.
# If this file is missing or damaged, see the license at:
#
#     http://www.minixml.org/
#

#
# Compiler tools definitions...
#

AR			=	/usr/bin/ar
ARFLAGS			=	crvs
ARCHFLAGS		=	
CC			=	gcc
CFLAGS			=	$(OPTIM) $(ARCHFLAGS) -Wall   -D_THREAD_SAFE -D_REENTRANT
CP			=	/usr/bin/cp
DSO			=	$(CC)
DSOFLAGS		=	 -Wl,-soname,libmicroxml.so.1,-rpath,$(libdir) -shared $(OPTIM)
LDFLAGS			=	$(OPTIM) $(ARCHFLAGS)  -Wl,-rpath,$(libdir)
INSTALL			=	/usr/bin/install -c
LIBMICROXML_SHARED	=	libmicroxml.so.1.0
LIBMICROXML_STATIC	=	libmicroxml.a
LIBS			=	 -lpthread
LN			=	/usr/bin/ln -s
MKDIR			=	/usr/bin/mkdir
OPTIM			=	-fPIC -Os -g
RANLIB			=	ranlib
RM			=	/usr/bin/rm -f
SHELL			=	/bin/sh


#
# Configured directories...
#

prefix		=	/usr/local
exec_prefix	=	/usr/local
bindir		=	${exec_prefix}/bin
datarootdir	=	${prefix}/share
includedir	=	${prefix}/include
libdir		=	${exec_prefix}/lib
BUILDROOT	=	$(DSTROOT)


#
# Install commands...
#

INSTALL_BIN	=	$(LIBTOOL) $(INSTALL) -m 755 -s
INSTALL_DATA	=	$(INSTALL) -m 644
INSTALL_DIR	=	$(INSTALL) -d
INSTALL_LIB	=	$(LIBTOOL) $(INSTALL) -m 755
INSTALL_MAN	=	$(INSTALL) -m 644
INSTALL_SCRIPT	=	$(INSTALL) -m 755


#
# Rules...
#

.SILENT:
.SUFFIXES:	.c .o
.c.o:
	echo Compiling $<
	$(CC) $(CFLAGS) -c -o $@ $<


#
# Targets...
#

PUBLIBOBJS	=	mxml-attr.o mxml-entity.o mxml-file.o mxml-get.o \
			mxml-index.o mxml-node.o mxml-search.o mxml-set.o
LIBOBJS		=	$(PUBLIBOBJS) mxml-private.o mxml-string.o
TARGETS		=	$(LIBMICROXML_SHARED) $(LIBMICROXML_STATIC)


#
# Make everything...
#

all:		Makefile config.h $(TARGETS)


#
# Clean everything...
#

clean:
	echo Cleaning build files...
	$(RM) $(OBJS) $(TARGETS) $(LIBOBJS)
	$(RM) libmicroxml.a libmicroxml.so.1.0 libmicroxml.so.1 libmicroxml.so libmicroxml.sl.1 libmicroxml.1.dylib


#
# Really clean everything...
#

distclean:	clean
	echo Cleaning distribution files...
	$(RM) config.cache config.log config.status
	$(RM) Makefile config.h microxml.list microxml.pc
	$(RM) -r autom4te*.cache
	$(RM) *.bck *.bak
	$(RM) -r clang


#
# Run the clang.llvm.org static code analysis tool on the C sources.
#

.PHONY: clang clang-changes
clang:
	echo Doing static code analysis of all code using CLANG...
	$(RM) -r clang
	scan-build -V -k -o `pwd`/clang $(MAKE) $(MFLAGS) clean all
clang-changes:
	echo Doing static code analysis of changed code using CLANG...
	scan-build -V -k -o `pwd`/clang $(MAKE) $(MFLAGS) all


#
# Install everything...
#

install:	$(TARGETS) install-$(LIBMICROXML_SHARED)  install-$(LIBMICROXML_STATIC)
	echo Installing header files in $(BUILDROOT)$(includedir)...
	$(INSTALL_DIR) $(BUILDROOT)$(includedir)
	$(INSTALL_DATA) microxml.h $(BUILDROOT)$(includedir)
	echo Installing pkgconfig files in $(BUILDROOT)$(libdir)/pkgconfig...
	$(INSTALL_DIR) $(BUILDROOT)$(libdir)/pkgconfig
	$(INSTALL_DATA) microxml.pc $(BUILDROOT)$(libdir)/pkgconfig

install-:

install-libmicroxml.a:
	echo Installing libmicroxml.a to $(BUILDROOT)$(libdir)...
	$(INSTALL_DIR) $(BUILDROOT)$(libdir)
	$(INSTALL_LIB) libmicroxml.a $(BUILDROOT)$(libdir)
	$(RANLIB) $(BUILDROOT)$(libdir)/libmicroxml.a

install-libmicroxml.so.1.0:
	echo Installing libmicroxml.so to $(BUILDROOT)$(libdir)...
	$(INSTALL_DIR) $(BUILDROOT)$(libdir)
	$(INSTALL_LIB) libmicroxml.so.1.0 $(BUILDROOT)$(libdir)
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.so
	$(LN) libmicroxml.so.1.0 $(BUILDROOT)$(libdir)/libmicroxml.so
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.so.1
	$(LN) libmicroxml.so.1.0 $(BUILDROOT)$(libdir)/libmicroxml.so.1

install-libmicroxml.sl.1:
	echo Installing libmicroxml.sl to $(BUILDROOT)$(libdir)...
	$(INSTALL_DIR) $(BUILDROOT)$(libdir)
	$(INSTALL_LIB) libmicroxml.sl.1 $(BUILDROOT)$(libdir)
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.so
	$(LN) libmicroxml.sl.1 $(BUILDROOT)$(libdir)/libmicroxml.sl

install-libmicroxml.1.dylib:
	echo Installing libmicroxml.dylib to $(BUILDROOT)$(libdir)...
	$(INSTALL_DIR) $(BUILDROOT)$(libdir)
	$(INSTALL_LIB) libmicroxml.1.dylib $(BUILDROOT)$(libdir)
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.dylib
	$(LN) libmicroxml.1.dylib $(BUILDROOT)$(libdir)/libmicroxml.dylib


#
# Uninstall everything...
#

uninstall: uninstall-$(LIBMICROXML_SHARED) uninstall-$(LIBMICROXML_STATIC)
	echo Uninstalling headers from $(BUILDROOT)$(includedir)...
	$(RM) $(BUILDROOT)$(includedir)/microxml.h
	echo Uninstalling pkgconfig files from $(BUILDROOT)$(libdir)/pkgconfig...
	$(RM) $(BUILDROOT)$(libdir)/pkgconfig/microxml.pc

uninstall-:

uninstall-libmicroxml.a:
	echo Uninstalling libmicroxml.a from $(BUILDROOT)$(libdir)...
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.a

uninstall-libmicroxml.so.1.0:
	echo Uninstalling libmicroxml.so from $(BUILDROOT)$(libdir)...
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.so
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.so.1
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.so.1.0

uninstall-libmicroxml.sl.1:
	echo Uninstalling libmicroxml.sl from $(BUILDROOT)$(libdir)...
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.sl
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.sl.1

uninstall-libmicroxml.1.dylib:
	echo Uninstalling libmicroxml.dylib from $(BUILDROOT)$(libdir)...
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.dylib
	$(RM) $(BUILDROOT)$(libdir)/libmicroxml.1.dylib


#
# autoconf stuff...
#

Makefile:	configure Makefile.in
	echo Updating makefile...
	if test -f config.status; then \
		./config.status --recheck; \
		./config.status; \
	else \
		./configure; \
	fi
	touch config.h


config.h:	configure config.h.in
	echo Updating config.h...
	autoconf
	if test -f config.status; then \
		./config.status --recheck; \
		./config.status; \
	else \
		./configure; \
	fi
	touch config.h


#
# Figure out lines-of-code...
#

.PHONY: sloc

sloc:
	echo "libmicroxml: \c"
	sloccount $(LIBOBJS:.o=.c) microxml-private.c microxml.h 2>/dev/null | \
		grep "Total Physical" | awk '{print $$9}'


#
# libmicroxml.a
#

libmicroxml.a:	$(LIBOBJS)
	echo Creating $@...
	$(RM) $@
	$(AR) $(ARFLAGS) $@ $(LIBOBJS)
	$(RANLIB) $@

$(LIBOBJS):	microxml.h
mxml-entity.o mxml-file.o mxml-private.o: mxml-private.h


#
# libmicroxml.so.1.0
#

libmicroxml.so.1.0:	$(LIBOBJS)
	echo Creating $@...
	$(DSO) $(DSOFLAGS) -o libmicroxml.so.1.0 $(LIBOBJS)
	$(RM) libmicroxml.so libmicroxml.so.1
	$(LN) libmicroxml.so.1.0 libmicroxml.so
	$(LN) libmicroxml.so.1.0 libmicroxml.so.1


#
# libmicroxml.sl.1
#

libmicroxml.sl.1:	$(LIBOBJS)
	echo Creating $@...
	$(DSO) $(DSOFLAGS) -o libmicroxml.sl.1 $(LIBOBJS)
	$(RM) libmicroxml.sl
	$(LN) libmicroxml.sl.1 libmicroxml.sl


#
# libmicroxml.1.dylib
#

libmicroxml.1.dylib:	$(LIBOBJS)
	echo Creating $@...
	$(DSO) $(DSOFLAGS) -o libmicroxml.1.dylib \
		-install_name $(libdir)/libmicroxml.dylib \
		-current_version 1.0.0 \
		-compatibility_version 1.0.0 \
		$(LIBOBJS)
	$(RM) libmicroxml.dylib
	$(LN) libmicroxml.1.dylib libmicroxml.dylib

#
# All object files depend on the makefile...
#

$(OBJS):	Makefile config.h

