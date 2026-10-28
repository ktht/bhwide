#=============================================================================
#
#	makecClean    -> cleans up this directory
#	make Clean    -> cleans up all MC program directories
#	make CLEAN    -> cleans up all directories
#       make export   -> creates a program export-archive
#       make tar-all  -> creates a program full-archive
#       make count-wh-lines  -> counts line of the WINHAC program source code
#       make count-all-lines -> counts line of the full package source code
#
#=============================================================================
####### Include common settings
include ./Makefile.inc
###############################################################################
#=============================================================================
#  Name and version of MC program -> main directory name
MCNAME = bhwide-1.07
#=============================================================================
COMMAND = demo.exe
#  Paths  to all subdirectories
PATHDE = ./demo
PATHBW = ./bhw
PATHEW = ./ewc
PATHIN = ./interface
PATHGL = ./glib
PATHLE = ./lep-ws95
PATHTE = ./tests
#=============================================================================
.PHONY: demo clean Clean CLEAN export tar-all count-bhw-lines count-all-lines 
#=============================================================================
# Run a simple demo program for BHWIDE
demo:
	(cd ./$(PATHDE); make demo)
#=============================================================================
clean:
	\rm -f *~
Clean:	clean
	cd $(PATHDE); make clean
	cd $(PATHBW); make clean
	cd $(PATHEW); make clean
	cd $(PATHIN); make clean
	cd $(PATHEW); make clean
	cd $(PATHGL); make clean
CLEAN:	Clean
	cd $(PATHLE); make clean
	cd $(PATHTE); make clean
#-----------------------------------------------------------------------
#  Create a program export-archive  
MCEXP = $(MCNAME)-export
export: Clean
	mkdir $(MCEXP); 
	(cp -a ./Makefile $(MCEXP)/; cp -a ./Makefile.inc $(MCEXP)/; \
	cp -a ./README $(MCEXP)/; cp -a ./RELEASE.NOTES $(MCEXP)/; \
	cp -a $(PATHDE) $(MCEXP)/; cp -a $(PATHBW) $(MCEXP)/; \
	cp -a $(PATHEW) $(MCEXP)/; cp -a $(PATHIN) $(MCEXP)/; \
	cp -a $(PATHGL) $(MCEXP) )
	tar cvzf $(MCEXP).tar.gz $(MCEXP)
	chmod -w $(MCEXP).tar.gz
	(mv $(MCEXP).tar.gz ../; rm -R $(MCEXP) )
#-----------------------------------------------------------------------
#  Create a program full-archive  
MCALL = $(MCNAME)-all
tar-all: CLEAN
	(cd ../; tar cvzf $(MCALL).tar.gz  $(MCALL) )
	(cd ../; chmod -w $(MCALL).tar.gz)
#-----------------------------------------------------------------------
#################### Lines counting ####################################
count-bhw-lines:	
	( cat bhw/*.f | wc -l )
#
count-all-lines:
	( find . -name '*.f' -exec cat {} \; | wc -l )
#-----------------------------------------------------------------------

