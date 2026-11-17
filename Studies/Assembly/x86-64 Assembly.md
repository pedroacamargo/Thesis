
# x86-64 Assembly

## Memory Access

To fetch a value inside a instruction in assembly, we use the \[], like `[0x00401000]`

```s
;# Similar as *pointer
;# Get the value of this line and write to rdx
mov rdx, [0x00401000]
```

### Arithmetic

`add <to>, <from>` - Plus 
`sub <to>, <from>` - Minus
`inc <reg>` - Increments register
`dec <reg>` - Decrements register

## Function Arguments

The first 6 arguments are passed in registers, the rest are passed on the stack.
Below is the list of registers used for function arguments:

```txt
RAX
RDI
RSI
RDX
RCX
R8
R9
```

**Little Endian**: 