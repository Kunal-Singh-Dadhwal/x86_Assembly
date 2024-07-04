section .data
    text1 db "Enter the year to check:- "
    text2 db " is a leap year"
    text3 db " is not a leap year"
section .bss
    name rsb 4

section .text
    global _start

_start:
    call _getyear

