####### Include common settings
include ../Makefile.inc
#############################################################################
LOCAL_LIB   =  bhw.a 
LIB_OBJECTS =  bhwide.o bhwid1.o model1.o model2.o matrel.o repi.o
#############
AR = ar
ARFLAGS = rsv
##############   What has to be built
.PHONY: all clean
all: $(LOCAL_LIB) 
%.o: %.f
	$(FFC) $(FFLAGS) -c $<
$(LOCAL_LIB): $(LIB_OBJECTS)
	$(AR) $(ARFLAGS) $@ $?
clean:
	rm -f *.o; rm -f *.a; rm -f *~ lmap
