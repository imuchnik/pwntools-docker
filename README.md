pwntools
========

This image contains the [pwntools](https://github.com/Gallopsled/pwntools) CTF framework with all its dependencies.

Usage
-----

### Run `shellcraft`

    $ docker run --rm robertlarsen/pwntools shellcraft -f h i386.linux.sh
    68010101018134247269010131d2526a045a01e25289e26a68682f2f2f73682f62696e6a0b5889e389d199cd80

### Run `constgrep`

    $ docker run --rm robertlarsen/pwntools constgrep -c amd64 SYS_open
    #define SYS_open   2
    #define SYS_openat 257

### Run `asm`

    $ echo 'xor rax, rax' | docker run -i --rm robertlarsen/pwntools asm -c amd64 | xxd
    00000000: 4831 c0                                  H1.

### Run `disasm`

    $ echo -en '\x48\x31\xc0' | docker run -i --rm robertlarsen/pwntools disasm -c amd64
       0:   48 31 c0                xor    rax,rax

### Run `cyclic`
    $ docker run --rm robertlarsen/pwntools cyclic -n 8 100
    aaaaaaaabaaaaaaacaaaaaaadaaaaaaaeaaaaaaafaaaaaaagaaaaaaahaaaaaaaiaaaaaaajaaaaaaakaaaaaaalaaaaaaamaaa
    $ docker run --rm robertlarsen/pwntools cyclic -n 8 -l aaaaaaal
    81

### Run an exploit 

Here one for the md5 calculator challenge from pwnable.kr.

	$ docker run -it -v $(pwd)/exploit.py:/exploit.py -v $(pwd)/hash:/hash robertlarsen/pwntools python /exploit.py
	[*] '/hash'
	    Arch:     i386-32-little
	    RELRO:    Partial RELRO
	    Stack:    Canary found
	    NX:       NX enabled
	    PIE:      No PIE
	[+] Opening connection to pwnable.kr on port 9002: Done
	[*] Switching to interactive mode
	MD5(data) : 6e65eb34744af4f64b664e1526c67df8
	$ ls
	flag
	log
	log2
	md5calculator
	super.pl
	$

### Run `ROPgadget` ():

It's not a pwntools tool but it's inthere so use it.

    $ docker run --rm -v $(pwd)/libc.so:/libc.so robertlarsen/pwntools ROPgadget --binary /libc.so
    Gadgets information
    ============================================================
    0x00000000001949c8 : adc ah, ah ; sti ; call qword ptr [rax]
    0x00000000001876ec : adc ah, ch ; int1 ; jmp qword ptr [rax]
    ....
    0x0000000000039fb6 : xor rdx, qword ptr [0x30] ; call rdx
    0x0000000000039fb5 : xor rdx, qword ptr fs:[0x30] ; call rdx
    0x00000000001aab38 : xor rsi, rdx ; call qword ptr [rax]
    
    Unique gadgets found: 21630
