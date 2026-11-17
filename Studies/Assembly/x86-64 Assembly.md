
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

## Different Syntaxes

There are two main syntaxes for x86-64 assembly: AT&T and Intel.

**AT&T Syntax**:
- Register names are prefixed with `%`
- Immediate values are prefixed with `$`
- Memory operands are enclosed in parentheses
- The order of operands is `source, destination`

**Intel Syntax**:
- Register names are not prefixed
- Immediate values are not prefixed
- Memory operands are enclosed in square brackets
- The order of operands is `destination, source`

## Instruction Suffixes

| Suffix | Size | Example |
|---|---|---|
| `b` | 8 bits | `movb` |
| `w` | 16 bits | `movw` |
| `l` | 32 bits | `movl` |
| `q` | 64 bits | `movq` |



**Little Endian**: 