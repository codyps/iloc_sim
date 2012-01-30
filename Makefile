CFLAGS = -g -Wall -MMD
LDFLAGS= -lm

CC     = gcc
CCLD   = gcc
LEX    = lex
YACC   = yacc
RM     = rm -rf

PURIFY = /usr/site/purify/purify $(CC)
PURIFY_FLAGS = $(CCLD) $(CFLAGS) $(LDFLAGS)

OBJ = sim.o machine.o instruction.o hash.o iloc.yy.o iloc.tab.o

sim: $(OBJ)
	$(CCLD) $(CFLAGS) $(LDFLAGS) -o $@ $^

pure: $(OBJ)
	$(PURIFY) $(PURIFY_FLAGS) -o $@ $^

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

sim.o:		instruction.h machine.h sim.h
machine.o:	machine.h
instruction.o:	instruction.h hash.h
hash.o:		hash.h
iloc.tab.c:	instruction.h

%.yy.c: %.l %.tab.c
	$(LEX) -t $< | sed 's/<stdout>/$@/g' > $@

%.tab.c: %.y
	$(YACC) -dtv -b $(<:.y=) $<

clean:
	$(RM) $(OBJ) iloc.yy.c iloc.tab.c iloc.tab.h y.output sim pure *.d

wc:
	wc iloc.y iloc.l hash.h hash.c instruction.h instruction.c machine.h machine.c sim.h sim.c

-include $(wildcard *.d)
