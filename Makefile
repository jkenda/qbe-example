PIPE_OPTS=-xassembler-with-cpp
CC_OPTS=-nostdlib -pipe -Os
LD_OPTS=-static -T linker.ld
LD_OPTS_MACOS_AMD=-arch x86_64 -platform_version macos 11.0 11.0
LD_OPTS_MACOS_ARM=-arch arm64 -platform_version macos 11.0 11.0
LD_OPTS_LINUX_ARM=--nostdlib

all: amd64_linux amd64_apple arm64_linux arm64_apple


amd64_linux: example-amd64_linux.o syscalls-amd64_linux.o linker.ld ELFkickers/bin/sstrip
	ld $(LD_OPTS) -o $@ example-$@.o syscalls-$@.o
	objcopy -S $@ # optional, reduces binary size
	ELFkickers/bin/sstrip $@ # optional, reduces binary size

amd64_apple: example-amd64_apple.o syscalls-amd64_apple.o
	ld64.lld $(LD_OPTS_MACOS_AMD) -o $@ example-$@.o syscalls-$@.o

arm64_linux: example-arm64_linux.o syscalls-arm64_linux.o
	ld.lld $(LD_OPTS_LINUX_ARM) -s -o $@ example-$@.o syscalls-$@.o

arm64_apple: example-arm64_apple.o syscalls-arm64_apple.o
	ld64.lld $(LD_OPTS_MACOS_ARM) -o $@ example-$@.o syscalls-$@.o


example-amd64_linux.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe -t amd64_sysv | cc -c $(CC_OPTS) $(PIPE_OPTS) -o $@ -

example-amd64_apple.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe -t amd64_apple | clang -c $(CC_OPTS) $(PIPE_OPTS) -target x86_64-apple-darwin -o $@ -

example-arm64_linux.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe -t arm64 | clang -c $(CC_OPTS) $(PIPE_OPTS) -target aarch64-linux-gnu -o $@ -

example-arm64_apple.o: qbe/qbe example.ssa
	cat example.ssa | qbe/qbe -t arm64_apple | clang -c $(CC_OPTS) $(PIPE_OPTS) -target arm64-apple-darwin -o $@ -


syscalls-amd64_linux.o: syscalls-amd64-header.s syscalls-amd64_linux.s
	cat syscalls-amd64-header.s syscalls-amd64_linux.s \
	| cc -c $(PIPE_OPTS) $(CC_OPTS) -o $@ -

syscalls-amd64_apple.o: syscalls-amd64-header.s syscalls-amd64_apple.s
	cat syscalls-amd64-header.s syscalls-amd64_apple.s \
	| clang -c -target x86_64-apple-darwin $(PIPE_OPTS) $(CC_OPTS) -o $@ -

syscalls-arm64_linux.o: syscalls-arm64-header.s syscalls-arm64_linux.s
	cat syscalls-arm64-header.s syscalls-arm64_linux.s \
	| clang -c -target aarch64-linux-gnu $(PIPE_OPTS) $(CC_OPTS) -o $@ -

syscalls-arm64_apple.o: syscalls-arm64-header.s syscalls-arm64_apple.s
	cat syscalls-arm64-header.s syscalls-arm64_apple.s \
	| clang -c -target arm64-apple-darwin -DAPPLE $(PIPE_OPTS) $(CC_OPTS) -o $@ -


qbe/qbe: qbe/*.c qbe/*.h
	cd qbe && make

ELFkickers/bin/sstrip: ELFkickers/sstrip/*.c
	cd ELFkickers && make sstrip


clean:
	-rm -f *.o amd64_linux amd64_apple arm64_linux arm64_apple
