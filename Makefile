# PROGRAMA
        PROG = matmult
        OBJS = $(PROG).o matriz.o utils.o

# Compilador
           CC = gcc

       CFLAGS = -Wall -O3 -mavx2 -march=native -DLIKWID_PERFMON
       LFLAGS = -lm -llikwid -L$(LIKWID_LIB)

# Lista de arquivos para distribuição
DISTFILES = *.c *.h README.md Makefile perfctr
DISTDIR = `basename ${PWD}`

.PHONY: all debug clean purge dist

%.o: %.c %.h
	$(CC) $(CFLAGS) -c $<

all: $(PROG)

debug:         CFLAGS += -g -D_DEBUG_
debug:         $(PROG)

$(PROG): $(OBJS) 
	$(CC) $(CFLAGS) -o $@ $^ $(LFLAGS)

clean:
	@echo "Limpando ...."
	@rm -f *~ *.bak *.tmp core 

purge:   clean
	@echo "Faxina ...."
	@rm -f  $(PROG) *.o a.out $(DISTDIR) $(DISTDIR).tar
	@rm -f *.png marker.out

dist: purge
	@echo "Gerando arquivo de distribuição ($(DISTDIR).tar) ..."
	@ln -s . $(DISTDIR)
	@tar -cvf $(DISTDIR).tar $(addprefix ./$(DISTDIR)/, $(DISTFILES))
	@rm -f $(DISTDIR)

