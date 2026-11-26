**Defense against Reverse Engineering**: Obfuscation, a process that renders software unintelligible but still functional.

**Defense against Piracy**: Watermarking, a process that makes it possible to determine the origin of software.

**Defense against Tampering**: Tamper-Proofing, so that unauthorized modifications to software (for example, to remove a watermark) will result in nonfunctional code.

See after: [54] ProtectSourceCode_With_ANDF

![[AttacksSoftware.png]]

In Fig. 2b, Bob decompiles and reverse engineers an application he has bought from Alice in order to reuse one of her modules in his own program.

### Defenses against Malicious Host Attacks

To defend a host against a malicious client, all that is needed is to restrict the actions that the client is allowed to perform.

**Promising Techniques:** traitor tracing, secret sharing, reference states and secure evaluation. Are still in the hand of theorists.

**Obfuscation:** Obfuscation attempts to transform a program into an equivalent one that is harder to reverse engineer.
**Tamper-Proofing**: Tamper-proofing causes a program to malfunction when it detects that it has been modified.
**Watermarking**: Software watermarking embeds a copyright notice in the software code to allow the owners of the software to assert their intellectual property rights.

# Obfuscation

Code obfuscation is very similar to code optimization, except that, with obfuscation, we are maximizing obscurity while minimizing execution time; whereas, with optimization, we are just minimizing execution time.

Given a set of obfuscating transformations $T = \{T_1, \ldots, T_n\}$ and a program $P$ consisting of
source code objects (classes, methods, statements, etc.) $\{S_1, \ldots, S_k\}$, find a new program
$P' = \{\ldots, S'_j = T_i(S_j), \ldots\}$ such that:

- $P'$ has the same observable behavior as $P$, i.e., the transformations are semantics-preserving.
- The **obscurity** of $P'$ is maximized, i.e., understanding and reverse engineering $P'$ will be strictly more time-consuming than understanding and reverse engineering $P$.
- The **resilience** of each transformation $T_i(S_j)$ is maximized, i.e., it will either be difficult to construct an automatic tool to undo the transformations or executing such a tool will be extremely time-consuming.
- The **stealth** of each transformation $T_i(S_j)$ is maximized, i.e., the statistical properties of $S'_j$ are similar to those of $S_j$.
- The **cost** (the execution time/space penalty incurred by the transformations) of $P'$ is minimized.


### Lexical Transformations

Typically, they do nothing more than scramble identifiers. Such lexical transforms will surely be annoying to a reverse engineer and, therefore, will prevent some thievery of intellectual property in software. **However, any determined reverse engineer will be able to read past the scrambling of identifiers in order to discover what the code is really doing.**

### Control Transformations

These control transformations rely on the existence of opaque predicates. A predicate $P$ is opaque if its outcome is known at obfuscation time, but is "difficult" for the deobfuscator to deduce. We write $P^F$ ($P^T$) if $P$ always evaluates to False (True) and $P^?$ if $P$ may sometimes evaluate to True and sometimes to False.

##### Opaque predicates are the central concept of this section.
A **predicate** is simply an expression that evaluates to either `true` or `false`.

![[ControlTransformations.png]]

Equally important is the cost and stealth of opaque predicates. An introduced predicate that differs wildly from what is in the original program will be unacceptable since it will be easy for a reverse engineer to detect. Similarly, a predicate is unacceptable if it introduces excessive computational overhead.

||Transformation A|Transformation B|Transformation C|
|---|---|---|---|
|Predicate|$P^T$|$P^?$|$P^T$|
|Number of reachable branches|1|2|1|
|Additional implementation|None|Equivalent code|Incorrect code|
|Main purpose|Hide unconditional execution|Increase analysis complexity|Mislead the attacker|
|Preserves original behavior|Yes|Yes|Yes|

![[AliasAnalysis.png]]


### Data Transformations

As an example, consider the Variable Splitting transformation in Fig. 6. In this example, a Boolean variable V is split into two integer variables p and q using the new representation shown in Fig. 6a. Given this new representation, we create new implementations for the built-in Boolean operations.


![[DataTransformations.png]]


### Other Defenses against Reverse Engineering

**Anti-disassembly:** We may write the machine code in an executable distribution in such a way that a disassembler is unlikely to be able to print out an accurate rendition of the assembly code.

**Anti-debugging:** We may disable or confuse a debugger, for example, by writing code that actively uses all available interrupts (including the breakpoint interrupt). If we know what debugger the reverse-engineer is likely to be using, then our code may be able to "attack" the debugger by writing into its address area. We can write time sensitive code, for example, involving races between processes on two CPUs that will terminate its operation whenever a debugger is probing a process intensively because this will slow down its operation

# Watermarking

Watermarking embeds a secret message into a cover message.

Embed a structure $W$ (the watermark) into a program $P$ such that:
- $W$ can be reliably located and extracted from $P$ (the embedding is **resilient** to dewatermarking attacks).
- $W$ is large (the embedding has a **high data rate**).
- Embedding $W$ into $P$ does not adversely affect the performance of $P$ (the embedding is **cheap**).
- Embedding $W$ into $P$ does not change any statistical properties of $P$ (the embedding is **stealthy**).
- $W$ has a mathematical property that allows us to argue that its presence in $P$ is the result of deliberate actions.

### Threat Model

![[WatermarkAttacks.png]]

Assume the following scenario: Alice watermarks a program $P$ with watermark $W$ and key $K$ and then sells $P$ to Bob. Before Bob can sell $P$ on to Douglas, he must ensure that the watermark has been rendered useless or else Alice will be able to prove that her program has been stolen.

Fig. 7 illustrates the kinds of dewatermarking attacks available to Bob:

- **Additive attack (Fig. 7a):** Bob launches an additive attack by adding his own watermark $W_1$ to Alice's watermarked program $P'$. This is an effective attack if it is impossible to detect that Alice's mark temporally precedes Bob's.

- **Distortive attack (Fig. 7b):** Bob launches a distortive attack on Alice's watermarked program $P'$. A distortive attack applies a sequence of semantics-preserving transformations uniformly over the entire program, in the hope that:
    1. The distorted watermark $W'$ can no longer be recognized.
    2. The distorted program $P''$ does not become so degraded (i.e., slow or large) that it no longer has any value to Bob.

- **Collusive attack (Fig. 7c):** Bob buys several copies of Alice's program $P$, each with a different fingerprint (serial number) $F$. By comparing the different copies of the program, Bob is able to locate the fingerprints and can then easily remove them.

### Static Watermarking

In 2002 -> Thus, unfortunately, all currently known static watermarks are susceptible to simple distortive dewatermarking attacks. For example, any code motion optimization technique will destroy Davidson's method. Code obfuscation techniques that radically change the control flow or reorganize data will also successfully thwart the recognition of static watermarks.

### Dynamic Watermarking

- **Easter Egg Watermarks**
- **Execution Trace Watermarks**
- **Data Structure Watermarks**

#### Dynamic Graph Watermarking

Dynamic Graph Watermarking embeds a watermark into the topology of a dynamically constructed graph rather than directly storing it in the executable.

The technique exploits the difficulty of pointer alias analysis to make the watermark-building code difficult to analyse and detect.

The watermarking algorithm consists of three steps:

1. Select a number $n$ with a unique mathematical property, such as $n = p \times q$, where $p$ and $q$ are prime numbers.
2. Encode $n$ into the topology of a graph $G$, using techniques such as radix-k encoding or enumeration encoding.
3. Embed a program $W$ into the original application that constructs $G$ when a predetermined input sequence $I$ is provided.

To recognize the watermark, the application is executed with input sequence $I$, the graph $G$ is extracted from the heap, the number $n$ is recovered, and its mathematical property is verified through factorization.

The technique is designed to resist dewatermarking attacks based on code optimization and obfuscation, while making the watermark difficult to locate through static analysis.

# Tamper-Proofing

There are many situations where we would like to stop anyone from executing our program if it has been altered in any way. For example, a program $P$ should not be allowed to run if:

1. $P$ is watermarked and the code that builds the mark has been altered.
2. A virus has been attached to $P$.
3. $P$ is an e-commerce application and the security-sensitive part of its code has been modified.

To prevent such tampering attacks, we can add **tamper-proofing code** to our program. This code should:

- **Detect** if the program has been altered.
- **Cause the program to fail** when tampering is evident.

There are three principal ways to detect tampering:

1. **Executable integrity checking:** We can examine the executable program itself to see if it is identical to the original one. To speed up the test, a message-digest algorithm such as SHA-256 can be used.

2. **Program (or result) checking:** We can examine the validity of intermediate results produced by the program. This technique is known as program (or result) checking and has been touted as an alternative to program verification and testing.

3. **Executable encryption:** We can encrypt the executable, thereby preventing anyone from modifying it successfully unless they are able to decrypt it. The decryption routines must be protected from reverse-engineering by hardware means, by obfuscation, or both.