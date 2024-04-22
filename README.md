# QBE Example

This hello world example written in SSA form is able to be compiled for x86_64 UNIX, x86_64 Linux, ARM64 UNIX, and ARM64 Linux
because the foundational blocks - the system call wrappers - are modular and can be swapped for different architectures and operating systems.

The Makefile is meant to only be executed on an x86_64 Linux machine (because that's my development setup) but it can be adapted to other systems without much effort.
I won't be porting it because this is just a small experiment that's part of a larger project.

If you want make executables, just run
```
make
```
