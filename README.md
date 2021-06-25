# asm required
I wanted to play with `ia_64` assembly and linker(s).

## introduction

In the beginning, I wanted to learn more about linking and system calls, two different subjects. I thought that the simplest program is done in assembly and that this simplest program needs the simplest linking command. After that, system calls where an evidence because the easiest way to ensure a program works well is writing something on the console.

### tools

I use [`nasm`](https://www.nasm.us/) which use the Intel assembly syntax that I learned nearly 40 years ago. [`Ghidra`](https://ghidra-sre.org/) shows me all the internals of the final program. 

## projects

### *`acat`*, a simple *`cat`*

This program do only one thing: copy `stdout` to `stdin`. With redirections and pipes, we can do things like that:

```shell
$ ./acat < *.asm | grep -w db | wc
    16      89     431
$
```

It was done to test the `syscall` instruction.

___Note___: why `acat`? Because _acat ze bluez_.

`ld` can be used as linker because we don't call `libc`, we just make 3 `syscall`:

- `read` from `stdin`,
- `write` to `stdout` or `stderr`,
- `exit` from the program.

### `cpuid`, a (too) simple `cpuid` program

Today, it only prints one line of the processor characteristics. It only exists to play with the `cpuid` instruction.

`ld` can be used as linker because we don't call `libc`, we just make 2 `syscall`:

- `write` to `stdout` or `stderr`,
- `exit` from the program.

