#########################################################################################
# Adjust names/flags according to your system 
#########################################################################################
#=== Compiler name and flags of g77 
#FFLAGS  = -O -fno-automatic -finit-local-zero -fno-emulate-complex
#FFLAGS  = -g -fdebug-kludge
#FFC = g77
#=== Compiler name and flags of gfortran
#FFLAGS  = -O3 -fno-automatic -ffixed-line-length-none
#FFC = gfortran
########### ACTUAL flags and COMPILER name ###########
FFLAGS  = -O3 -fno-automatic -ffixed-line-length-none
FFC = gfortran
########################################################################################
# Directories of some other libraries, if necessary
SYSNAME = $(shell uname -s)
# Linux
ifeq ($(SYSNAME), Linux)
LIBDIR =
endif
# macOS
ifeq ($(SYSNAME), Darwin)
LIBDIR = -Wl,-ld_classic -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
endif
#######################################################################################
# Linker and its flags
LD  = $(FFC)
LDFLAGS = $(FFLAGS) $(LIBDIR)
#######################################################################################
