####### Include common settings
include ../Makefile.inc
#############################################################################
CFNAME = demo
COMMAND = ../bin/bhwide
OBJECTS = $(CFNAME).o
EVENTS ?= 100000
SEED ?= 54217137
LHE_FILE ?= demo.lhe
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
	mkdir -p $(dir $@)
	$(LD) -o $@ $(LDFLAGS) $(OBJECTS) \
	$(EXTER_LIB1) $(EXTER_LIB2) $(EXTER_LIB3) $(EXTER_LIB4)
#---------------------------------------------------------------------------
#                            Demo run
#---------------------------------------------------------------------------
demo:  $(COMMAND)
run:  $(COMMAND)
	./$< --events $(EVENTS) --seed $(SEED) --lhe "$(LHE_FILE)"
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
