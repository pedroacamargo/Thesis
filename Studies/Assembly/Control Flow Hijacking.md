# Control Flow Hijacking Studies

When learning assembly, I found the instruction `endbr64`, which I thought intriguing and wanted to learn more about it. After some research, I discovered that it is related to a security feature from Intel called Control Flow Enforcement Technology (CET), which is designed to prevent control flow hijacking attacks.

Control flow hijacking is a type of attack where an attacker takes control of the execution flow of a program, often by exploiting vulnerabilities such as buffer overflows or return-oriented programming (ROP). CET aims to mitigate these attacks by enforcing certain rules on the control flow of a program.

## Understanding `endbr64` and Intel CET (IBT)

Consider the following assembly code snippet:

```s
call print_hello

print_hello:
    mov rax, 1
    ret
```

The instruction `call print_hello` is a **direct call**. The destination is encoded in the instruction. The CPU knows where it should jump.

Now consider this code snippet:

```s
lea rax, [rip + print_hello]
call rax
```

This is an **indirect call**.

Instead of specifying the destination directly, we're placing an address in RAX and telling the CPU:

> "Execute the function whose address is stored in RAX."

Inside /src/ControlFlowHijacking/ibt.s, we have an example of the `endbr64` instruction. This instruction is used to mark the beginning of a function that can be called indirectly. It is part of Intel's CET and is used to enforce control flow integrity.

When a function is marked with `endbr64`, it indicates that the function can be safely called indirectly, and the CPU will check that the call is valid. If an attacker tries to hijack the control flow and call a function that is not marked with `endbr64`, the CPU will raise an exception, preventing the attack.

### What will happen is we uncomment the line `add rax, 4` in the code snippet?

There are two possibilities.

**Case A**: The program executes normally. Why? Because ENDBR64 doesn't enforce anything by itself. Without active IBT enforcement, jumping directly to `mov eax, 42` is permitted. The CPU doesn't check the validity of the call, and the program continues executing as expected.

**Case B**: The program crashes. Why? Because the CPU enforces IBT, and the jump to `mov eax, 42` is not valid. The CPU raises a control-protection exception. The process typically terminates with a signal.

### Important Note

The presence of endbr64 in the executable does not prove that userspace IBT is active. Linux support and enforcement depend on the kernel configuration and runtime environment. In particular, Linux userspace IBT support was still undergoing upstream development during 2026. Don't assume that your Ubuntu installation enforces it merely because GCC generates the instruction.

### Can an attacker still bypass IBT?

Imagine two functions:

```s
normal_function:
    endbr64
    mov eax, 1
    ret

secret_function:
    endbr64
    mov eax, 999
    ret
```

The program is supposed to call `normal_function` but an attacker wants to call `secret_function` instead. **What happens?**

**R:** Both functions begin with ENDBR64, so IBT alone cannot distinguish the intended destination from the unintended one.

This is one of the fundamental limitations of IBT, It provides a relatively coarse form of control-flow integrity. It doesn't verify that a particular call is authorized to reach a particular function.

To fix this, researchers have proposed a more fine-grained approach like [FineIBT](https://arxiv.org/pdf/2303.16353)

### TO DO

Check if your CPU and kernel support CET and IBT.

```bash
# 1. Processor
lscpu | grep 'Model name'

# 2. CET support
grep -m1 -oE 'user_shstk|ibt' /proc/cpuinfo

# 3. Kernel
uname -r

# 4. Kernel configuration
grep -E 'CONFIG_X86_USER_SHADOW_STACK|CONFIG_X86_KERNEL_IBT|CONFIG_X86_USER_IBT' /boot/config-$(uname -r)
```

Activate CET and IBT in the kernel configuration and run the program with kernel enforcement enabled. Then, uncomment the line `add rax, 4` and observe the behavior of the program (it should return a control-protection exception if IBT is enforced).
	