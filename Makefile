CC_OPTS = -pipe -nostdlib -nodefaultlibs -xassembler -g0

all: example

example: example.o syscalls.o
	ld -o example example.o syscalls.o
	strip example

example.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe | cc -c -o example.o $(CC_OPTS) -

syscalls.o: syscalls.s
	cc -c -o syscalls.o syscalls.s

qbe/qbe: qbe/*.c qbe/*.h
	cd qbe && make

clean: qbe_clean
	rm -f example *.o

qbe_clean:
	cd qbe && make clean
