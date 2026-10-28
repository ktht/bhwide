####### Include common settings
include ../Makefile.inc
#############################################################################
LOCAL_LIB   =  ewc.a 
LIB_OBJECTS =  alibaba.o babamc.o
#############
AR = ar
ARFLAGS = rsv
##############   What has to be built
.PHONY: all clean
all:	$(LOCAL_LIB) 
%.o: %.f
	$(FFC) $(FFLAGS) -c $<
$(LOCAL_LIB): $(LIB_OBJECTS)
	$(AR) $(ARFLAGS) $@ $?
clean:
	rm -f *.o; rm -f *.a; rm -f *~ lmap
