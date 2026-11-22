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