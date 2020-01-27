set auto-load safe-path /
set disassembly-flavor intel
set history save on
set follow-fork-mode parent

# make gdb & real stack same
set environment _=/usr/bin/gdb
unset environment LINES
unset environment COLUMNS

#source /home/bin/pwndbg-git/gdbinit.py

