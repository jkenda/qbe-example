all: example

example: example.o syscalls.o
	ld -o example example.o syscalls.o

example.o: example.ssa
	cat example.ssa | qbe | cc -c -o example.o -pipe -nostdlib -xassembler -s -

syscalls.o: syscalls.s
	cc -c -o syscalls.o syscalls.s

clean:
	rm -f example *.o
