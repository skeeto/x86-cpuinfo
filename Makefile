HOST_LINUX ?= x86_64-linux-gnu
HOST_WIN32 ?= x86_64-w64-mingw32
NASM       ?= nasm

all : cpuinfo cpuinfo.exe

cpuinfo.exe : cpuinfo.win64.o
	$(HOST_WIN32)-gcc -s -o $@ $^

cpuinfo : cpuinfo.elf64.o
	$(HOST_LINUX)-gcc -s -o $@ $^

cpuinfo.win64.o : cpuinfo.s
	$(NASM) -fwin64 -o $@ $^

cpuinfo.elf64.o : cpuinfo.s
	$(NASM) -felf64 -Fdwarf -o $@ $^

clean :
	$(RM) cpuinfo.elf64.o cpuinfo.win64.o cpuinfo cpuinfo.exe
