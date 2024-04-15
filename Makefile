CC_OPTS=-c -pipe -nostdlib -nodefaultlibs -xassembler -g0

all: example

example: example.o syscalls.o
	ld -o example example.o syscalls.o

example.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe | cc $(CC_OPTS) -o example.o -

syscalls.o: syscalls.s
	cc -c -o syscalls.o syscalls.s

qbe/qbe: qbe/*.c qbe/*.h
	cd qbe && make

clean:
	rm -f example *.o
