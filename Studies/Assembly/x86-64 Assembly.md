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



**Little Endian**: 