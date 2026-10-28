####### Include common settings
include ../Makefile.inc
#############################################################################
CFNAME = demo
COMMAND = $(CFNAME).exe
OBJECTS = $(CFNAME).o
#############################################################################
DIRNBW = bhw
DIRNEW = ewc
DIRNIN = interface
DIRNGL = glib
#############################################################################
PATHBW = ../$(DIRNBW)
PATHEW = ../$(DIRNEW)
PATHIN = ../$(DIRNIN)
PATHGL = ../$(DIRNGL)
#############################################################################
EXTER_LIB1  =  $(PATHBW)/$(DIRNBW).a
EXTER_LIB2  =  $(PATHGL)/$(DIRNGL).a
EXTER_LIB3  =  $(PATHIN)/$(DIRNIN).a
EXTER_LIB4  =  $(PATHEW)/$(DIRNEW).a
#############################################################################
all: $(COMMAND)
###############
%.o: %.f
	$(FFC) $(FFLAGS) -c $<
$(EXTER_LIB1): $(PATHBW)/*.f
	cd $(PATHBW); make
$(EXTER_LIB2): $(PATHGL)/*.f   
	cd $(PATHGL); make
$(EXTER_LIB3): $(PATHIN)/*.f
	cd $(PATHIN); make
$(EXTER_LIB4): $(PATHEW)/*.f   
	cd $(PATHEW); make
# Link procedure
$(COMMAND): $(OBJECTS) \
	$(EXTER_LIB1) $(EXTER_LIB2) $(EXTER_LIB3) $(EXTER_LIB4)
	$(LD) -o $@ $(LDFLAGS) $(OBJECTS) \
	$(EXTER_LIB1) $(EXTER_LIB2) $(EXTER_LIB3) $(EXTER_LIB4)
#---------------------------------------------------------------------------
#                            Demo run
#---------------------------------------------------------------------------
demo:  $(COMMAND)
	time ./$<
	pdflatex $(CFNAME).tex
	gv $(CFNAME).pdf
	diff -s $(CFNAME).output $(CFNAME)_100k.output
#---------------------------------------------------------------------------
#                   Cleaning
#---------------------------------------------------------------------------
clean:
	(rm -f  *.o  *.a  *~  *.exe  *.aux  *.dvi  *.log  core  *.gz lmap)
Clean:  clean
	cd $(PATHBW); make clean
	cd $(PATHEW); make clean
	cd $(PATHIN); make clean
	cd $(PATHEW); make clean
	cd $(PATHGL); make clean
#---------------------------------------------------------------------------
