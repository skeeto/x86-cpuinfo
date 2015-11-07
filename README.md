# x86_64 CPU feature listing

`cpuinfo` is an x86_64 command line program for Windows and otherwise
that prints the `cpuid` CPU features of wherever it happens to run.
This information is trivial to obtain on Linux through
`/proc/cpuinfo`, so the primary target is Windows (`cpuinfo.exe`).
Assembly requires [NASM][nasm] the GNU linker.

[nasm]: http://www.nasm.us/
