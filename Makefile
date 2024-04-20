PIPE_OPTS=-xassembler
CC_OPTS=-nostdlib -pipe -Os
LD_OPTS=-static -T linker.ld
LD_OPTS_MACOS=-arch arm64 -platform_version macos 11.0 11.0
all: amd64_linux arm64_apple


amd64_linux: example-amd64_linux.o syscalls-amd64_linux.o linker.ld ELFkickers/bin/sstrip
	ld $(LD_OPTS) -o $@ example-$@.o syscalls-$@.o
	objcopy -S $@ # optional, reduces binary size
	ELFkickers/bin/sstrip $@ # optional, reduces binary size

arm64_apple: example-arm64_apple.o syscalls-arm64_apple.o
	ld64.lld $(LD_OPTS_MACOS) -o $@ example-$@.o syscalls-$@.o


example-amd64_linux.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe -t amd64_sysv | cc -c $(CC_OPTS) $(PIPE_OPTS) -o example-amd64_linux.o -

example-arm64_apple.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe -t arm64_apple | clang -c $(CC_OPTS) $(PIPE_OPTS) -target arm64-apple-darwin -o example-arm64_apple.o -


syscalls-amd64_linux.o: syscalls-amd64_linux.s
	cc -c $(CC_OPTS) -o syscalls-amd64_linux.o syscalls-amd64_linux.s

syscalls-arm64_apple.o: syscalls-arm64_apple.s
	clang -target arm64-apple-darwin -c $(CC_OPTS) -o syscalls-arm64_apple.o syscalls-arm64_apple.s


qbe/qbe: qbe/*.c qbe/*.h
	cd qbe && make

ELFkickers/bin/sstrip: ELFkickers/sstrip/*.c
	cd ELFkickers && make sstrip

clean:
	rm -f amd64_linux arm64_apple *.o
