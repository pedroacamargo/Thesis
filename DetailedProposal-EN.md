# Protecting an Android App on the Attacker's Device

Master's Degree in Cyber security.
Supervisor: Vítor Fonte.

## Context

Kouci is a water polo analytics application for coaches and teams, developed by the master's student. It records matches and opponent scouting data and includes paid features. It follows an offline-first approach: during operation, part of the application logic, data, and license verification must reside on the device, without continuous communication with a trusted server.

An attacker with control over their device can analyze and modify the application. Obfuscation, local signature verification, and key protection may make specific attacks more difficult; however, the usefulness of each measure depends on the attacker's objectives and capabilities [1–4].

Kouci provides the context for a limited and reproducible evaluation; the dissertation does not require comprehensive commercial hardening of the product.

## Research Questions

In an offline-first Android scenario, what attack effort does the developer observe when attempting to activate a paid feature without a valid license in the baseline version, the R8-protected version, and the version with local signing certificate verification?

What effort is observed when attempting to recover a fixed dataset of scouting information in plaintext, when the data is stored either unencrypted or encrypted using an Android Keystore key?

Furthermore, what implementation, application size, and performance costs are associated with each protection variant?

## Methodology

The assets, two attack objectives, and attacker capabilities will first be defined. For each attack attempt, the initial conditions will be recorded, including root access, process instrumentation, application and license state, and authentication requirements and status for using the cryptographic key.

For the data recovery attack, the application will process a fixed synthetic dataset and display aggregated results, without providing the attacker with authorized access to or export of the complete dataset. Recovery is defined as obtaining the complete plaintext dataset outside this normal workflow.

Two attack approaches will be considered: extracting files at rest without executing the application, and intercepting data during processing, after decryption in the Keystore-protected variant. The prerequisites and evidence required to demonstrate success for each approach will be established before measurements begin. Legitimate access through the user interface or authorized data export will not be considered an attack.

A small Android experimental testbed will be developed using Kouci's licensing and data processing workflows to enable a controlled comparison. The testbed will preserve the relevant technologies and behavior of each workflow, while documenting any simplifications compared with Kouci.

The baseline version will implement the same workflows but store data in plaintext and exclude the three evaluated protections.

Three separate protection variants will then be developed:

1. **R8 obfuscation** [5], documenting whether the configuration also performs code shrinking or optimization.
2. **Local APK signing certificate verification**, in which the application compares the certificate used to sign the APK against an expected certificate to detect repackaging and re-signing [6].
3. **Data encryption using a non-exportable Android Keystore key** [4].

The dataset, device, functionality, and build settings unrelated to each protection will remain unchanged. All modifications specific to each variant will be documented.

The security level of the cryptographic key actually used will be obtained and reported, rather than inferred solely from the device's capabilities.

Additional obfuscation using open-source tools will be considered optional.

An initial calibration pilot will be conducted using a separate sample, such as a training application or workflow. The time spent during this pilot will not be included in the experimental results.

Before any measurements, including those involving the baseline version, an experimental protocol will be finalized and frozen. This protocol will define the order of the variants, the permitted categories of tools and techniques (such as static decompilation or dynamic instrumentation), the rules for adapting to obstacles, a time budget of T active hours per attempt (for example, 20 hours), and the evidence required to establish success.

Examples of successful outcomes include activating a paid feature without a valid license or recovering a dataset identical to the original synthetic dataset.

The protocol will allow decisions within these predefined rules without imposing a rigid sequence of steps.

A dated activity log will record the active time spent on each step, the tools used, the operations performed, the obstacles encountered, and unsuccessful attempts.

The analyst's prior knowledge of the implementation and the knowledge acquired between attempts will also be documented.

For the licensing objective, attacks will target the baseline version, the R8-protected version, and the version with signing certificate verification.

For the data recovery objective, attacks will target the baseline version and the Android Keystore-protected version.

For each attempt, the following information will be reported: the outcome, active time until success, categories of tools used, whether static or dynamic analysis was required, device prerequisites, number of steps, and the size of any scripts or modifications used.

An attempt that does not achieve its objective within the established time budget will be reported as **"unsuccessful within T active hours."**

This constitutes a censored observation: the attempt ended after T hours without success, meaning that T represents a lower bound on the time required to succeed. Such observations will be reported separately from successful attack times.

On the implementation side, the time spent learning about a protection mechanism and the time required to integrate it will be recorded separately.

APK size, application startup time, and data access time will be measured under both cold and warm conditions, using repeated measurements and reporting the median and dispersion.

A non-exportable key makes it more difficult to obtain the cryptographic key material. However, a compromised process may still expose plaintext data when the application processes it [4]. This limitation will form part of the comparison.

The developer implementing the protections will also be responsible for executing the attacks. Their prior knowledge of the implementation will be explicitly acknowledged.

Knowledge of the source code and learning between attack attempts may influence the observed times, preventing generalization of the results to other attackers.

The observed differences will therefore describe the behavior of this particular analyst, these application variants, and these experimental conditions. They will not establish an isolated causal contribution of each protection mechanism or of hardware-backed key storage.

The independent pilot, the protocol frozen before baseline measurements, the declared execution order, the observable indicators, and the step-by-step time records will reduce the scope for methodological decisions during measurement and make these limitations verifiable.

## Minimum Viable Scope

The minimum scope of the dissertation includes an Android experimental testbed implementing both workflows, a baseline version, and three separate protection variants.

It also includes a threat model, a frozen experimental protocol, the attack attempts relevant to each objective, and a comparison of observed attack effort against implementation, application size, and performance costs.

A rigorous negative result, including attempts that remain unsuccessful within the established time budget, is considered sufficient.

The Android Keystore evaluation will report the security level available on the test device, without claiming to provide an isolated comparison between hardware-backed and software-backed key storage.

The following extensions are optional: combining protection mechanisms, evaluating a second Android device, extending the study to iOS, implementing remote attestation with occasional connectivity, and detecting runtime tampering.

## Out of Scope

The following topics are excluded from the minimum scope:

- Comprehensive commercial hardening of Kouci.
    
- In-depth desktop security evaluation.
    
- White-box cryptography.
    
- Production licensing services.
    
- Continuous online verification.
    
- Build pipeline security.
    
- Real data from teams or customers.
    

Remote attestation and runtime tampering detection are also excluded from the minimum scope.

## Initial Requirements

The initial requirements include access to Kouci's licensing and data workflows so they can be reproduced in the experimental testbed, an Android development environment, a physical test device, commonly used APK analysis and instrumentation tools, and a synthetic dataset.

The first task will be to define the threat model and prepare the calibration pilot and measurement protocol.

## Required Profile

The project requires familiarity with Android development and command-line tools, as well as an interest in reverse engineering and empirical security evaluation.

The master's student is already developing Kouci.

During the first few weeks, guided practical exercises involving static APK analysis and dynamic instrumentation will be conducted.

## Work Plan and Timeline

The dissertation will be developed between November 2026 and July 2027.

The state-of-the-art review will be prepared and presented as part of the Seminars course.

The practical research will proceed in parallel. By the end of January, the experimental testbed should be operational, the threat model defined, the calibration pilot completed, and the experimental protocol frozen.

Measurements of the baseline version should be completed by mid-February, and the first protected variant should be ready by the end of February or early March.

The minimum scope is sufficient for completing the dissertation. A rigorous negative result is considered a complete research outcome.

If insufficient data is collected or the evaluation remains incomplete, the scope will be adjusted in agreement with the supervisor.

Regular meetings will be held, weekly during the first few months, accompanied by a one-page progress report every two weeks.

An accelerated completion path is also planned: a complete dissertation draft covering the minimum scope should be ready by the end of May, allowing early submission if permitted by the academic calendar, without optional extensions.

**Keywords:** Android security, reverse engineering, offline-first applications, obfuscation, Android Keystore, empirical evaluation.

## References

[1] C. S. Collberg and C. Thomborson. "Watermarking, Tamper-Proofing, and Obfuscation: Tools for Software Protection." _IEEE Transactions on Software Engineering_, 28(8), 2002. [https://doi.org/10.1109/TSE.2002.1027797](https://doi.org/10.1109/TSE.2002.1027797)

[2] S. Schrittwieser, S. Katzenbeisser, J. Kinder, G. Merzdovnik, and E. Weippl. "Protecting Software through Obfuscation: Can It Keep Pace with Progress in Code Analysis?" _ACM Computing Surveys_, 49(1), Article 4, 2016. [https://doi.org/10.1145/2886012](https://doi.org/10.1145/2886012)

[3] OWASP. _Mobile Application Security Verification Standard (MASVS)_ and _Mobile Application Security Testing Guide (MASTG)._ [https://mas.owasp.org/](https://mas.owasp.org/)

[4] Android Developers. "Android Keystore system." [https://developer.android.com/privacy-and-security/keystore](https://developer.android.com/privacy-and-security/keystore)

[5] Android Developers. "Enable app optimization with R8." [https://developer.android.com/topic/performance/app-optimization/enable-app-optimization](https://developer.android.com/topic/performance/app-optimization/enable-app-optimization)

[6] Android Developers. "PackageManager", `hasSigningCertificate` method. [https://developer.android.com/reference/android/content/pm/PackageManager.html](https://developer.android.com/reference/android/content/pm/PackageManager.html)

---

Master's Degree in Cybersecurity, University of Minho. Dissertation proposal for the 2026/2027 academic year.