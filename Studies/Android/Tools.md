# Essential Android Reverse Engineering Tools

First, a list enumerating each tool:
- **JADX / JADX-GUI**: Decompile DEX into readable Java
- **Apktool**: Decode resources, inspect and modify Smali
- **Frida**: Runtime instrumentation and method interception
- **Ghidra**: Analyze native ARM, ARM64, and x86 binaries
- **ADB**: Interact with Android devices and applications
- **Android Studio**: Debug Android applications
- **MobSF**: Automated mobile security analysis
- **Objection**: Runtime exploration using Frida
- **Androguard**: Programmatic APK and DEX analysis
- **Burp Suite**: Intercept and analyze HTTP/HTTPS traffic
- **Radare2/Rizin**: Disassemble and analyze native binaries
- **APKLab**: APK analysis and modification in VS Code

### Useful tools for the dissertation

| Rank | Tool                      | Why you need it                                 |
| ---- | ------------------------- | ----------------------------------------------- |
| 1    | **JADX**                  | Understand APK application logic                |
| 2    | **Apktool**               | Analyze and modify DEX/Smali                    |
| 3    | **Frida**                 | Observe and change runtime behavior             |
| 4    | **ADB**                   | Control your Android testing environment        |
| 5    | **Ghidra**                | Study native code and advanced protections      |
| 6    | **Android Studio / LLDB** | Debug app and native components                 |
| 7    | **Androguard**            | Automate APK comparisons                        |
| 8    | **MobSF**                 | Obtain an initial application security overview |
| 9    | **APKiD**                 | Identify obfuscation and packing signatures     |
| 10   | **Python + Pandas**       | Analyze experimental results                    |
| 11   | **Perfetto**              | Measure runtime overhead                        |
| 12   | **angr + Z3**             | Explore advanced program analysis               |

**JADX → Smali → Apktool → Frida → Ghidra → Androguard → Experimental measurement**

## The Skills That Matter Most

| Skill                                     | Importance for Kouci | Long-term importance |
| ----------------------------------------- | -------------------- | -------------------- |
| DEX and Smali analysis                    | Very high            | Very high            |
| Java/Kotlin runtime instrumentation       | Very high            | Very high            |
| ARM64 and ELF reverse engineering         | Medium               | Very high            |
| Cryptographic implementation analysis     | Very high            | Very high            |
| Obfuscation and control-flow analysis     | High                 | Very high            |
| Symbolic execution and automated analysis | Optional             | High                 |
**Software protection should not be evaluated solely by whether reverse engineering is possible. It should also be evaluated by how much additional effort a protection imposes, under which conditions, and at what cost to the developer and the application's performance.**