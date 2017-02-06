pwntools
========

This image contains the [pwntools](https://github.com/Gallopsled/pwntools) CTF framework with all its dependencies.
Also, I've added the `requests` and `z3` modules as they often come in handy.

Usage
-----

### Run `checksec`

	$ docker run --rm -v $(pwd):/work robertlarsen/pwntools checksec ./starcraft
	[*] '/work/starcraft'
	    Arch:     amd64-64-little
	    RELRO:    Partial RELRO
	    Stack:    Canary found
	    NX:       NX enabled
	    PIE:      PIE enabled

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

	$ docker run -it -v $(pwd)/:/work robertlarsen/pwntools python ./exploit.py
	[*] '/work/hash'
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

### Use the `z3` theorem solver:

The `z3` module proves solvability and can show the solution that satisfies a set of pre conditions such as these from a reversing challenge:

	$ cat alexctf_2017_catalyst_username.py 
	#!/usr/bin/env python
	
	from z3 import *
	from pwn import *
	
	# void __fastcall sub_400CDD(char *username)
	# {
	#   __int64 c; // [sp+10h] [bp-20h]@1
	#   __int64 b; // [sp+18h] [bp-18h]@1
	#   __int64 a; // [sp+20h] [bp-10h]@1
	# 
	#   a = *(_DWORD *)username;
	#   b = *((_DWORD *)username + 1);
	#   c = *((_DWORD *)username + 2);
	#   if ( a - b + c != 0x5C664B56 || b + 3 * (c + a) != 0x2E700C7B2LL || c * b != 0x32AC30689A6AD314LL )
	#   {
	#     puts("invalid username or password");
	#     exit(0);
	#   }
	# }
	
	a, b, c = BitVecs('a b c', 64)
	s = Solver()
	s.add(a & 0xffffffff00000000 == 0,
	      b & 0xffffffff00000000 == 0,
	      c & 0xffffffff00000000 == 0,
	      a - b + c == 0x5c664b56,
	      b + 3 * (c + a) == 0x2e700c7b2,
	      c * b == 0x32ac30689a6ad314)
	s.check()
	m = s.model()
	print p32(m[a].as_long()) + p32(m[b].as_long()) + p32(m[c].as_long())
	$ docker run --rm -v $(pwd):/work robertlarsen/pwntools python ./alexctf_2017_catalyst_username.py
	catalyst_ceo

### Run `ROPgadget` ():

It's not a `pwntools` tool but it's inthere so use it.

    $ docker run --rm -v $(pwd):/work robertlarsen/pwntools ROPgadget --binary ./libc.so
    Gadgets information
    ============================================================
    0x00000000001949c8 : adc ah, ah ; sti ; call qword ptr [rax]
    0x00000000001876ec : adc ah, ch ; int1 ; jmp qword ptr [rax]
    ....
    0x0000000000039fb6 : xor rdx, qword ptr [0x30] ; call rdx
    0x0000000000039fb5 : xor rdx, qword ptr fs:[0x30] ; call rdx
    0x00000000001aab38 : xor rsi, rdx ; call qword ptr [rax]
    
    Unique gadgets found: 21630
