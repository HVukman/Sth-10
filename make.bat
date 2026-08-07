@echo off
mkdir build 2>nul
odin build . -no-bounds-check -o:speed -out:sth10.exe