# 1 Von Neumann Architecture

This diagram shows that the CPU has three components: the Arithmetic Logic Unit (ALU), the Control Unit, and the Registers. The CPU interacts with memory and I/O devices outside the CPU. 
Let's learn about each of the components mentioned in the diagram below.

![[CPU_Architecture.png|700]]

**Control Unit**: Gets instructions from the main memory. The address to the next instruction to execute is stored in a register called the Instruction Pointer or IP (x32 -EIP, x64 - RIP)

**Arithmetic Logic Unit (ALU)**: Executes the instruction fetched from the Memory

**Registers**: The Registers are the CPU's storage. Registers are generally much smaller than the Main Memory, which is outside the CPU, and help save time in executing instructions by placing important data in direct access to the CPU.

**Memory**: Also called Main Memory or Random Access Memory (RAM), contains all the code and data for a program to run.

**I/O Devices**: All other devices that interact with a computer.

## 1.1 Registers Overview

#### Instruction Pointer
The Instruction Pointer is a register that contains the address of the next instruction to be executed by the CPU. It is also called the Program Counter.

#### General Purpose Registers

**`EAX` or `RAX`**: Accumulator Register. Results of arithmetic operations are often stored in this register. In 32-bit systems, a 32-bit EAX register is present, while a 64-bit RAX register is present in 64-bit systems. The last 16 bits of this register can be accessed by addressing AX. Similarly, it can also be addressed in 8 bits by using AL for the lower 8 bits and AH for the higher 8 bits.

![[Reg_RAX.png|700]]


**`EBX` or `RBX`**: This register is also called the Base Register, which is often used to store the Base address for referencing an offset. Similar to the EAX/RAX, it can be addressed as 64-bit RBX, 32-bit EBX, 16-bit BX, and 8-bit BH and BL registers.

![[Reg_RBX.png|700]]

**`ECX` or `RCX`**: This register is also called the Counter Register and is often used in counting operations such as loops, etc. Similar to the above two registers, it can be addressed as 64-bit RCX, 32-bit ECX, 16-bit CX, and 8-bit CH and CL registers.

![[Reg_RCX.png|700]]

**`EDX` or `RDX`**: This register is also called the Data Register. It is often used in multiplication/division operations. Similar to the above registers, it can be addressed as 64-bit RDX, 32-bit EDX, 16-bit DX, and 8-bit DH and DL registers.

![[Reg_RDX.png|700]]

**`ESP` or `RSP`**: This register is called the Stack Pointer. It points to the top of the stack and is used in conjunction with the Stack Segment register. It is a 32-bit register called ESP in 32-bit systems and a 64-bit register called RSP in 64-bit systems. It can not be addressed as smaller registers.

![[Reg_RSP.png|700]]

**`EBP` or `RBP`**: This register is called the Base Pointer. It is used to access parameters passed by the stack. It is also used in conjunction with the Stack Segment register. It is a 32-bit register called EBP in 32-bit systems and a 64-bit register called RBP in 64-bit systems.

![[Reg_RBP.png|700]]

**`ESI` or `RSI`**: This register is called the Source Index register. It is used for string operations. It is used with the Data Segment (DS) register as an offset. It is a 32-bit register called ESI in 32-bit systems and a 64-bit register called RSI in 64-bit systems.

![[Reg_RSI.png|700]]

**`EDI` or `RDI`**: This register is called the Destination Index register. It is also used for string operations. It is used with the Extra Segment (ES) register as an offset. It is a 32-bit register called EDI in 32-bit systems and a 64-bit register called RDI in 64-bit systems.

![[Reg_RDI.png|700]]

**`R8` or `R15`**: These 64-bit general-purpose registers are not present in 32-bit systems. They were introduced in the 64-bit systems. They are also addressable in 32-bit, 16-bit, and 8-bit modes. For example, for the R8 register, we can use R8D for lower 32-bit addressing, R8W for lower 16-bit addressing, and R8B for lower 8-bit addressing. Here, the suffix D stands for Double-word, W stands for Word, and B stands for Byte.

## 1.2 Status Flags Registers

**Zero Flags**: Denoted by ZF, the Zero Flag indicates when the result of the last executed instruction was zero. For example, if an instruction is executed that subtracts a RAX from itself, the result will be 0. In this situation, the ZF will be set to 1.

**Carry Flag**: Denoted by CF, the Carry Flag indicates when the last executed instruction resulted in a number too big or too small for the destination. For example, if we add 0xFFFFFFFF and 0x00000001 and store the result in a 32-bit register, the result will be too big for the register. In this case, CF will be set to 1.

**Sign Flag**: The Sign Flag or SF indicates if the result of an operation is negative or the most significant bit is set to 1. If these conditions are met, the SF is set to 1; otherwise, it is set to 0.

**Trap Flag**: The Trap Flag or TF indicates if the processor is in debugging mode. When the TF is set, the CPU will execute one instruction at a time for debugging purposes. This can be used by malware to identify if they are being run in a debugger.

#### Segment Registers

**Code Segment:** The Code Segment (CS) register points to the Code section in the memory.

**Data Segment:** The Data Segment (DS) register points to the program's data section in the memory.

**Stack Segment:** The Stack Segment (SS) register points to the program's Stack in the memory.

**Extra Segments (ES, FS, and GS):** These extra segment registers point to different data sections. These and the DS register divide the program's memory into four distinct data sections.

## 1.3 Stack Layout

![[StackLayout.png|248]]

Malware often exploits the stack to hijack the control flow of the program. Therefore it is important to understand the stack, its layout, and its working. The CPU uses two registers to keep track of the stack. One is the **Stack Pointer** (the ESP or RSP), and the other is the **Base Pointer** (the EBP or RBP).

**Stack Pointer**: The Stack Pointer points to the top of the stack. When any new element is pushed on the stack, the location of the Stack Pointer changes to consider the new element that was pushed on the stack. Similarly, when an element is popped off the stack, the stack pointer adjusts itself to reflect that change.

**Base Pointer**: The Base Pointer for any program remains constant. This is the reference address where the current program stack tracks its local variables and arguments.

When a function is called, the stack is prepared for the function to execute. This means that the arguments are pushed to the stack before the start of the function execution. After that, the Return Address and the Old Base Pointer are pushed onto the stack. Once these elements are pushed, the Base Pointer address is changed to the top of the stack (which will be the Stack Pointer of the caller function at that time). As the function executes, the Stack Pointer moves as per the requirements of the function. This portion of code that pushes the arguments, the Return Address, and the Base Pointer onto the Stack and rearranges the Stack and Base Pointers is called the Function Prologue.

Similarly, the Old Base Pointer is popped off the stack and onto the Base Pointer when the function exits. The Return address is popped off to the Instruction Pointer, and the Stack Pointer is rearranged to point to the top of the stack. The part of the code that performs this action is called the Function Epilogue.


# 2 x86-64 Assembly

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
