PIPE_OPTS=-xassembler
CC_OPTS=-nostdlib -nostartfiles -ffreestanding -pipe -Os
LD_OPTS=-static --build-id=none -T linker.ld

all: example

example: example.o syscalls.o linker.ld ELFkickers/bin/sstrip
	ld $(LD_OPTS) -o example example.o syscalls.o
	objcopy -S example # optional, reduces binary size
	ELFkickers/bin/sstrip example # optional, reduces binary size

example.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe | cc -c $(CC_OPTS) $(PIPE_OPTS) -o example.o -

syscalls.o: syscalls.s
	cc -c $(CC_OPTS) -o syscalls.o syscalls.s

qbe/qbe: qbe/*.c qbe/*.h
	cd qbe && make

ELFkickers/bin/sstrip: ELFkickers/sstrip/*.c
	cd ELFkickers && make sstrip

clean:
	rm -f example *.o
