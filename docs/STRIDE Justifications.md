# STRIDE Threat Model — Explanation of Every Matrix Cell

Let's analyze your **Kouci STRIDE-per-Element matrix** systematically, explaining why each element receives its corresponding classification.

This is particularly important for your dissertation because **every classification should have a technical justification**. Otherwise, the matrix becomes a subjective checklist rather than a defensible threat-modeling artifact.

I'll also identify a few classifications that I would reconsider before including the matrix in your final dissertation.

## 1. Understanding the classifications

Your matrix uses three symbols:

|Symbol|Meaning|Interpretation|
|---|---|---|
|●|Relevant threat|A credible threat scenario has been identified for this element.|
|○|Conditional threat|A threat may apply, depending on attacker capabilities, implementation details, or experimental conditions.|
|—|No principal scenario|No principal threat scenario has been identified within the defined experimental scope.|

**Important:** A `●` does not mean the system is vulnerable. It means that a credible threat exists and deserves consideration.

Similarly, `—` does not mean an element is inherently secure.

### STRIDE categories

|Category|Security property|Fundamental question|
|---|---|---|
|**S — Spoofing**|Authentication|Can an attacker impersonate an entity or identity?|
|**T — Tampering**|Integrity|Can an attacker modify something without authorization?|
|**R — Repudiation**|Accountability|Can an actor deny an action because reliable evidence is unavailable?|
|**I — Information Disclosure**|Confidentiality|Can information be exposed to unauthorized parties?|
|**D — Denial of Service**|Availability|Can an attacker disrupt the system?|
|**E — Elevation of Privilege**|Authorization|Can an attacker gain capabilities beyond those they are authorized to exercise?|

---

# 2. P1 — APK / Local Code

**Element:** The installed Android application, including executable code, resources, and local protection mechanisms.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|○|●|○|●|●|○|

### S — Spoofing: ○

An attacker may modify the original APK, repackage it, and distribute it while presenting it as the legitimate Kouci application.

For example, an attacker could create a modified APK containing a license bypass and distribute it under Kouci's name.

This constitutes application impersonation.

**Why conditional?**

Repackaging does not automatically establish successful spoofing. The attack becomes relevant when the modified package is presented or accepted as authentic.

Android's signing mechanisms also influence what forms of impersonation are possible.

### T — Tampering: ●

The attacker can attempt to modify the application code.

Possible modifications include:

- Removing license validation.
- Changing conditional branches.
- Modifying hardcoded values.
- Disabling local security checks.

For example, suppose Kouci contains:

```
if (license.isValid()) {
    enablePremiumFeatures();
}
```

An attacker could attempt to modify the compiled implementation so that the paid feature becomes available regardless of the license result.

**Why relevant?**

The attacker controls the device and can obtain the APK. Consequently, executable-code modification is a central attack path in your dissertation.

This is directly relevant to evaluating R8 and local signing-certificate verification.

### R — Repudiation: ○

An attacker may modify or execute the application without leaving reliable evidence of those actions.

For example, if modified application builds do not produce trustworthy audit information, it may be difficult to determine which version performed a particular action.

**Why conditional?**

Your experimental application does not necessarily require attribution of users' actions.

Repudiation becomes relevant mainly when considering audit records, license activity, or experimental evidence.

**My assessment:** This is a relatively weak STRIDE association for P1. I would consider marking it `—` unless you explicitly model a relevant accountability requirement.

### I — Information Disclosure: ●

An attacker may inspect the APK to extract information that the developer intended to conceal.

Examples include:

- License validation algorithms.
- Embedded configuration values.
- Hardcoded secrets, if present.
- Information about the application's internal architecture.
- Proprietary implementation details.

**Why relevant?**

Reverse engineering is a core part of your research.

However, distinguish between **obtaining access to code**, which is expected when distributing an APK, and **recovering information with an explicit confidentiality requirement**.

R8 may complicate code comprehension, but it does not make application code confidential.

### D — Denial of Service: ●

A modified APK or manipulated execution environment may cause the application to crash or become unusable.

For example, altering executable instructions or runtime dependencies could prevent Kouci from starting.

**Why relevant?**

The application must continue operating correctly despite the addition of protection mechanisms.

However, there is an important distinction:

A device owner deliberately crashing their own application is not necessarily a meaningful attack against Kouci's availability.

**My assessment:** I would classify this as `○` for your dissertation unless the attacker can disrupt another user's application or a shared service. Ordinary local crashes should primarily be evaluated as robustness issues.

### E — Elevation of Privilege: ○

A modification to the application could enable access to restricted functionality.

For example, an attacker might bypass the licensing system and activate premium features.

**Why conditional?**

This depends on how premium access is represented and enforced.

An unauthorized entitlement is an authorization violation, but not necessarily operating-system privilege escalation.

For your study, treating license bypass as application-level elevation of privilege is reasonable, provided you define this interpretation explicitly.

---

# 3. P2 — License Validator

**Element:** The component responsible for evaluating the license state and deciding whether a user may access premium functionality.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|●|●|○|○|●|●|

### S — Spoofing: ●

An attacker may attempt to make the validator accept a forged license or a falsified licensing state.

For example:

```
LicenseStatus status = LicenseStatus.VALID;
```

If an attacker can replace an invalid license state with a valid-looking one, the validator may accept the forged entitlement.

**Why relevant?**

The attacker attempts to impersonate a valid licensing identity or credential.

This is directly related to your license-bypass objective, G1.

Note that simply forcing the validator to return `true` is better classified as tampering. Spoofing specifically involves presenting a false identity or credential as legitimate.

### T — Tampering: ●

An attacker may modify the license validation logic or its inputs.

Examples include:

- Replacing a failed validation result.
- Changing an expiration date.
- Modifying stored license information.
- Disabling an integrity check.

**Why relevant?**

This is probably the **most important Tampering scenario in your entire threat model**.

Your experiments explicitly investigate whether protection mechanisms increase the effort required to bypass local licensing.

### R — Repudiation: ○

An attacker may activate premium functionality without a reliable record of how access was obtained.

For example, an altered application might not preserve evidence of license-check failures.

**Why conditional?**

Your offline-first model does not necessarily include trusted license auditing.

If reliable attribution is not a security objective, repudiation may have limited relevance.

### I — Information Disclosure: ○

An attacker may examine the license validator and discover:

- The format of licensing information.
- Validation algorithms.
- Local configuration values.
- Embedded cryptographic material, if present.

**Why conditional?**

Not every aspect of the license validator is confidential.

Discovering its algorithm is not necessarily a security failure. Exposure becomes significant when confidential information, such as a secret signing key, is recoverable.

### D — Denial of Service: ●

An attacker could interfere with the license validation process, preventing legitimate users from accessing premium functionality.

For example, maliciously modified licensing state or malformed license inputs could make validation fail.

**Why relevant?**

License validation is a dependency for paid functionality.

**However:** For your experimental scope, I would downgrade this to `○` unless you define a scenario in which the attacker disrupts somebody else's legitimate access. Causing the attacker's own unlicensed application to fail is not a particularly meaningful DoS scenario.

### E — Elevation of Privilege: ●

An attacker may bypass licensing restrictions and gain access to premium functionality.

Example:

```
boolean premium = licenseValidator.isValid();

if (premium) {
    enableAdvancedAnalytics();
}
```

The attacker manipulates execution so that `enableAdvancedAnalytics()` runs without a valid license.

**Why relevant?**

This directly corresponds to G1.

In this model, elevation of privilege refers to gaining an application-level entitlement, not Android root privileges.

---

# 4. P3 — Paid Feature

**Element:** A restricted Kouci functionality that should only execute when a valid license authorizes access.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|○|●|○|○|●|●|

### S — Spoofing: ○

An attacker might impersonate a licensed user or provide a falsified entitlement to the paid feature.

**Why conditional?**

This threat depends on how the paid feature obtains or verifies authorization.

If the feature simply receives a Boolean from the license validator, spoofing may be less appropriate than tampering.

### T — Tampering: ●

An attacker may modify the implementation of the premium feature or interfere with the conditions required for execution.

For example, an attacker could modify the call site to invoke the paid functionality without consulting the validator.

**Why relevant?**

This is an alternative route to G1.

Importantly, the attacker may not need to compromise the license validator itself.

They could instead bypass the component entirely.

### R — Repudiation: ○

An attacker might execute premium functionality without leaving a reliable audit record.

**Why conditional?**

This matters only if accountability for premium-feature usage is a security requirement.

Since your minimum experimental scope does not include a trusted audit service, this is secondary.

### I — Information Disclosure: ○

A premium feature might expose information beyond what an unlicensed user should access.

For example, an advanced scouting functionality might reveal information about opponents that should only be accessible to authorized users.

**Why conditional?**

Your proposal distinguishes feature authorization from dataset confidentiality.

A premium feature being accessed without a license is not automatically equivalent to recovering the protected dataset.

The threat depends on the data that the feature exposes.

### D — Denial of Service: ●

An attacker may cause the paid feature to crash or become unavailable.

For example, malformed input or manipulation of the feature's execution state could interrupt analytics processing.

**Why relevant?**

Availability is important for normal application operation.

Nevertheless, a deliberate crash on the attacker's own device has little business-security significance. I would use `○` unless you model an attack affecting legitimate users.

### E — Elevation of Privilege: ●

An attacker activates the premium functionality without possessing the required entitlement.

**Why relevant?**

This is the exact success condition for G1.

A successful attack requires the feature to **actually operate**, rather than merely displaying an unlocked button.

---

# 5. D1 — Local Dataset

**Element:** The synthetic scouting dataset stored on the Android device.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|—|●|○|●|●|—|

### S — Spoofing: —

The dataset is a passive data store rather than an entity that authenticates itself to another component.

**Why not applicable as a principal scenario?**

Your study does not define dataset-origin authentication as an attack objective.

However, if Kouci trusted the origin of imported data, an attacker could potentially impersonate that source.

### T — Tampering: ●

An attacker might modify local scouting records.

For example, an attacker could change a player's recorded shooting accuracy or alter match statistics.

**Why relevant?**

Unauthorized modification compromises data integrity and could affect the application's analytical results.

Although your dissertation primarily evaluates confidentiality, data tampering is a credible threat to the Kouci ecosystem.

### R — Repudiation: ○

An attacker could modify or delete scouting records without leaving evidence identifying the responsible actor.

**Why conditional?**

The dataset is not necessarily an audit log.

Repudiation becomes relevant if Kouci requires reliable attribution of changes to scouting data.

For the minimum experimental scope, this could reasonably be `—`.

### I — Information Disclosure: ●

An attacker may attempt to extract the complete dataset.

Two principal paths exist:

**At-rest extraction:** Obtain the stored files and reconstruct the dataset without running the application during the extraction.

**Runtime interception:** Observe the dataset after the application has loaded or decrypted it.

**Why relevant?**

This corresponds directly to your second experimental objective, G2.

It is also the primary reason for evaluating Android Keystore-backed encryption.

### D — Denial of Service: ●

An attacker may delete, corrupt, or otherwise make the stored dataset unavailable.

For example, deleting the application's database could prevent Kouci from producing its scouting analyses.

**Why relevant?**

Loss of the dataset affects the availability of the application.

However, because the attacker controls the experimental device, distinguish deliberate self-destruction of local data from meaningful attacks against another user's data.

### E — Elevation of Privilege: —

The dataset is a passive data store and does not independently perform authorization.

**Why no principal scenario?**

Accessing the dataset without authorization is an information-disclosure threat.

An escalation of privileges may be a prerequisite, but it is not necessarily a threat originating from the dataset itself.

---

# 6. P4 — Processing / Decryption

**Element:** The application component that reads, processes, and potentially decrypts scouting data.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|○|●|○|●|●|○|

### S — Spoofing: ○

An attacker may attempt to impersonate a trusted component or provide fraudulent inputs to the processing routine.

For example, runtime instrumentation could replace a callback or an object representing a trusted data source.

**Why conditional?**

The threat requires an identifiable trust relationship.

If no component identity is authenticated, simple input manipulation is more accurately classified as Tampering.

### T — Tampering: ●

An attacker may modify the behavior of data-processing or decryption routines.

Examples include:

- Hooking methods.
- Changing function arguments.
- Modifying return values.
- Redirecting execution.

**Why relevant?**

The attacker controls the execution environment, making runtime instrumentation an important part of your research.

### R — Repudiation: ○

The processing component could perform operations without generating trustworthy records of those operations.

**Why conditional?**

Repudiation is relevant only if the system requires attribution of processing actions.

Your minimum scope does not establish this requirement.

### I — Information Disclosure: ●

This is one of the **most significant threats in the dissertation**.

Consider the Keystore variant:

```
Encrypted dataset
       |
       v
Android Keystore-backed operation
       |
       v
Plaintext available to application
       |
       v
Data processing
       |
       v
Aggregated results
```

Even if the encryption key cannot be exported, plaintext may become available during processing.

An attacker with sufficient instrumentation capabilities might observe that plaintext.

**Why relevant?**

This is the foundation of your runtime data-recovery experiment.

It demonstrates an important limitation: protecting cryptographic key material does not automatically protect plaintext while it is being used.

### D — Denial of Service: ●

An attacker may disrupt data processing by causing crashes, exhausting resources, or interfering with required cryptographic operations.

**Why relevant?**

The processing component is necessary for the application to operate correctly.

This is a credible availability scenario, although not one of the two experimental objectives.

### E — Elevation of Privilege: ○

An attacker may manipulate the processing component to perform operations that would otherwise be restricted.

For example, a function intended to return aggregate results might be redirected to expose the entire dataset.

**Why conditional?**

The classification depends on whether the operation crosses an authorization boundary.

If the attacker simply reads plaintext from a compromised process, Information Disclosure is the stronger classification.

---

# 7. P5 — Aggregates UI

**Element:** The interface displaying aggregated scouting results.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|○|●|—|○|●|○|

### S — Spoofing: ○

An attacker could imitate or replace the legitimate user interface.

For example, a malicious overlay could present itself as a legitimate Kouci screen.

**Why conditional?**

The experimental scope does not involve user-interface impersonation.

Such an attack would require a defined identity or trust relationship.

### T — Tampering: ●

An attacker may modify displayed scouting statistics.

For example, the UI might display an attacker-controlled shooting percentage rather than the result calculated by the application.

**Why relevant?**

This compromises the integrity of the displayed analytics.

However, visual modification alone does not constitute successful dataset recovery or license bypass.

### R — Repudiation: —

The UI does not serve as the principal audit mechanism in the experimental model.

No accountability requirement has been defined for it.

### I — Information Disclosure: ○

The interface might accidentally expose information beyond the intended aggregated results.

For example, a debugging screen or improperly restricted UI component could display individual scouting records.

**Why conditional?**

Your experimental workflow explicitly limits normal output to aggregated results.

The threat becomes relevant if the implementation exposes additional information.

### D — Denial of Service: ●

An attacker may disrupt the UI by causing crashes, rendering failures, or resource exhaustion.

**Why relevant?**

An unavailable interface prevents users from interacting with the analytics.

However, availability testing is outside your minimum dissertation objectives.

### E — Elevation of Privilege: ○

An attacker may manipulate the UI to access screens or operations normally restricted to licensed users.

**Why conditional?**

A navigation bypass is relevant only if it enables unauthorized functionality.

Simply displaying a hidden screen without executing the corresponding feature is insufficient to demonstrate G1.

---

# 8. E2 — Android Keystore / Interface

**Element:** The Android platform's Keystore facilities and the interface through which the application requests cryptographic operations.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|○|○|—|○|●|○|

### S — Spoofing: ○

An attacker may attempt to impersonate an authorized caller or manipulate the environment in which the application uses cryptographic services.

**Why conditional?**

The feasibility depends on Android's isolation mechanisms, key authorization policies, and the attacker's privileges.

Ordinary device ownership does not imply the ability to impersonate another application's identity.

### T — Tampering: ○

An attacker may attempt to modify the application's requests to the Keystore or interfere with the handling of cryptographic results.

For example, an attacker could instrument the application's code around a decryption operation.

**Why conditional?**

Manipulating application-side code is not equivalent to modifying the Android Keystore implementation.

These are different trust boundaries.

### R — Repudiation: —

The Android Keystore is not being used as an accountability or audit mechanism.

No relevant repudiation scenario is defined.

### I — Information Disclosure: ○

An attacker may attempt to recover:

- Cryptographic key material.
- Cryptographic outputs.
- Plaintext produced or subsequently handled by the application.

**Why conditional?**

The actual security guarantees depend on the generated key's security level, access requirements, and the state of the device.

An important distinction:

**The attacker may recover plaintext without extracting the cryptographic key.**

This is why runtime interception and key extraction must remain separate concepts in your threat model.

### D — Denial of Service: ●

An attacker may interfere with cryptographic operations, making the application unable to access encrypted data.

Examples include invalidating required keys or making key-use authorization unavailable.

**Why relevant?**

If the application cannot perform the necessary cryptographic operations, it may become unable to access its dataset.

This is a legitimate availability concern, particularly when evaluating authentication requirements and key lifecycle behavior.

### E — Elevation of Privilege: ○

An attacker may attempt to use cryptographic keys or operations beyond the permissions granted to their security context.

**Why conditional?**

This requires bypassing an actual authorization boundary enforced by Android.

Calling an already authorized decryption operation from an instrumented application is not necessarily privilege escalation.

---

# 9. E3 — PackageManager / Signing

**Element:** Android package-management and signing-information services used to obtain the application's signing identity.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|●|○|—|○|○|○|

### S — Spoofing: ●

An attacker may attempt to make a modified application appear to have the expected signing identity.

For example, an attacker could interfere with the application's local interpretation of signing-certificate information.

**Why relevant?**

Your dissertation evaluates a local certificate-verification mechanism intended to detect repackaging and re-signing.

**Important distinction:** Bypassing the application's local certificate check is not the same as forging a valid Android signing certificate.

The attacker may bypass the local verification logic without compromising Android's package-signature enforcement.

### T — Tampering: ○

An attacker may modify the application code responsible for checking signing-certificate information.

For example, they might alter how the application processes the result returned by `PackageManager`.

**Why conditional?**

This affects application-side logic.

It does not imply that the attacker can modify the underlying Android package-management service.

### R — Repudiation: —

PackageManager is not being used as an audit or accountability component.

No principal repudiation scenario is identified.

### I — Information Disclosure: ○

An attacker may inspect package metadata or application signing information.

**Why conditional?**

Signing certificates are generally public information.

Their disclosure does not inherently constitute a confidentiality failure.

This classification would require a more specific scenario involving genuinely sensitive information.

**My assessment:** I would change this cell to `—` unless you identify such a scenario.

### D — Denial of Service: ○

An attacker may interfere with certificate verification, causing the application to reject execution or restricted functionality.

**Why conditional?**

The application must actually depend on the check for its availability to be affected.

Additionally, causing the attacker's own modified application to fail is not necessarily a meaningful DoS attack.

### E — Elevation of Privilege: ○

An attacker may bypass a local integrity check and subsequently execute premium functionality without authorization.

**Why conditional?**

Bypassing certificate verification alone does not grant additional privileges.

Elevation occurs only if the bypass enables access to an otherwise restricted capability.

---

# 10. F4 — Authorization Flow

**Element:** The data flow carrying authorization information between the license validator and the premium functionality.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|●|●|○|—|○|●|

### S — Spoofing: ●

An attacker may attempt to inject a fraudulent authorization result that appears to originate from a trusted validator.

For example, the attacker might replace an authorization response with a forged positive result.

**Why relevant?**

The premium feature may incorrectly trust the authorization information.

This scenario assumes that the validator's identity or the authenticity of its result is meaningful to the receiving component.

### T — Tampering: ●

An attacker modifies authorization information during its production, transmission, or consumption.

For example:

```
boolean authorized = false;
```

An attacker could attempt to change the effective result to:

```
boolean authorized = true;
```

**Why relevant?**

This is a direct route to G1.

If the validator and the paid feature are within the same application process, this is runtime-state manipulation rather than interception of a network message.

### R — Repudiation: ○

An attacker may modify the authorization flow without leaving reliable evidence.

**Why conditional?**

The experimental model does not require trusted auditing of local authorization decisions.

Repudiation is relevant only if accountability for these actions is explicitly required.

### I — Information Disclosure: —

The authorization flow does not necessarily contain confidential information.

For example, observing a Boolean result indicating whether a user is licensed is not, by itself, a meaningful disclosure.

**Why no principal scenario?**

Your research focuses on modifying the authorization decision, not keeping its existence or ordinary result secret.

If the flow carries confidential tokens or credentials, this classification should be reconsidered.

### D — Denial of Service: ○

An attacker may interfere with the authorization flow, preventing the premium functionality from receiving a valid decision.

**Why conditional?**

The effect depends on whether the application fails closed, retries, or handles errors gracefully.

### E — Elevation of Privilege: ●

An attacker changes the effective authorization decision to gain access to premium functionality.

**Why relevant?**

This is a direct violation of the licensing policy and corresponds to G1.

---

# 11. F5 / F7 / F10 — Data Flows

**Element:** The flows associated with retrieving, decrypting, processing, and presenting scouting data.

**Classification:**

|S|T|R|I|D|E|
|---|---|---|---|---|---|
|○|●|—|●|○|○|

Because these flows may cross different trust boundaries, the exact implications depend on the endpoints of each flow.

### S — Spoofing: ○

An attacker may attempt to impersonate a trusted source of scouting data or cryptographic results.

For example, a manipulated data source could supply records that appear to originate from legitimate application storage.

**Why conditional?**

Spoofing requires an identity or source-authentication relationship.

If the application does not authenticate the origin of local data, manipulation may be better classified as Tampering.

### T — Tampering: ●

An attacker may modify data as it moves between components.

Examples include:

- Altering scouting records before processing.
- Manipulating data after decryption.
- Replacing calculated results.
- Changing function arguments through runtime instrumentation.

**Why relevant?**

The attacker controls the execution environment and may be able to interfere with the application's internal data flows.

### R — Repudiation: —

These flows do not represent an audit trail or another mechanism requiring reliable attribution.

No principal repudiation scenario is identified.

### I — Information Disclosure: ●

An attacker may observe scouting information as it moves between storage, decryption, and processing components.

For example:

```
Encrypted database
       |
       v
Decryption operation
       |
       v
Plaintext scouting records  <--- Attacker observes data
       |
       v
Analytics processing
       |
       v
Aggregated results
```

**Why relevant?**

This is directly related to G2.

The attacker attempts to recover the complete dataset outside the intended application interface.

### D — Denial of Service: ○

An attacker may interrupt or corrupt a data flow, preventing the application from processing scouting information.

**Why conditional?**

The consequences depend on error handling, process isolation, and whether the disrupted flow is essential.

### E — Elevation of Privilege: ○

An attacker may manipulate a data flow to access information or operations that should be unavailable to their authorization context.

**Why conditional?**

Reading plaintext from an already compromised process is primarily Information Disclosure.

Elevation of Privilege requires a separate authorization boundary to be crossed.

---

# 12. Summary: Which STRIDE Categories Matter Most for Your Dissertation?

Not every threat identified by STRIDE needs to become an experimental objective.

Your proposal focuses on two specific outcomes:

**G1 — License Bypass**

The attacker successfully executes a paid feature without a valid license.

**G2 — Dataset Recovery**

The attacker obtains the complete synthetic scouting dataset in plaintext outside the application's authorized access path.

These objectives map most strongly to the following STRIDE categories:

|Category|Relevance to dissertation|Explanation|
|---|---|---|
|**Spoofing**|High|Forged licensing identities or authorization results may facilitate license bypass.|
|**Tampering**|Critical|Modification of local code, authorization logic, and runtime behavior is central to G1.|
|**Repudiation**|Low|Trusted auditing and action attribution are not principal experimental objectives.|
|**Information Disclosure**|Critical|Recovery of protected scouting data is the central objective of G2.|
|**Denial of Service**|Low|Availability attacks are relevant to the broader application but are not directly evaluated.|
|**Elevation of Privilege**|High|Unauthorized access to paid functionality is an application-level authorization violation.|

## 13. Classifications I Would Reconsider

After examining every cell, I would make a few adjustments before finalizing the model.

|Element|Category|Current|Suggested|Reason|
|---|---|---|---|---|
|P1 APK/local code|Repudiation|○|—|No explicit accountability requirement.|
|P1 APK/local code|DoS|●|○|Crashing an attacker's own APK is not necessarily a meaningful availability attack.|
|P2 license validator|DoS|●|○|Availability attacks are not central to the experimental objectives.|
|P3 paid feature|DoS|●|○|Local disruption alone has limited relevance without effects on legitimate users.|
|D1 local dataset|Repudiation|○|—|The dataset is not an audit record.|
|E3 PackageManager/signing|Information Disclosure|○|—|Signing certificates and ordinary package metadata are not confidential.|

These are methodological recommendations rather than corrections to demonstrated vulnerabilities.

One additional point deserves attention: **the F4 authorization flow should only receive a Spoofing classification if there is a meaningful identity or authenticity claim associated with the source of the authorization result.** Otherwise, changing the result is Tampering.

Likewise, local premium-feature bypass is reasonably treated as application-level Elevation of Privilege, but that definition should be explicit.

---

## 14. How to Defend This Matrix in Your Dissertation

I recommend adding the following explanation immediately after the matrix:

The STRIDE-per-Element matrix systematically evaluates the applicability of each STRIDE threat category to the components and data flows identified in the system's Data Flow Diagram (DFD).

Each element is assessed against the six STRIDE categories, considering its security responsibilities, interactions with other components, relevant trust boundaries, and the capabilities of the defined adversary.

Three classifications are used: a filled circle (●) indicates an identified and relevant threat scenario; an empty circle (○) indicates a threat whose applicability depends on specific implementation details, attacker capabilities, or experimental conditions; and a dash (—) indicates that no principal threat scenario has been identified within the defined scope.

These classifications represent potential security threats rather than confirmed vulnerabilities. In particular, a relevant classification does not imply that the associated attack is feasible or successful under the experimental conditions.

Although the matrix covers all six STRIDE categories, the experimental evaluation focuses primarily on Tampering, Information Disclosure, and application-level Elevation of Privilege. These categories correspond most directly to the two research objectives: unauthorized activation of paid functionality (G1) and unauthorized recovery of the complete synthetic scouting dataset (G2).

Other identified threats contribute to understanding the broader security implications of executing an offline-first Android application on an attacker-controlled device but are not necessarily subjected to experimental evaluation.

The threat catalogue subsequently refines the matrix by associating relevant threats with concrete attack scenarios, affected assets, trust boundaries, attacker capabilities, and experimental success criteria.

### One important methodological distinction

Your threat model currently combines two levels of analysis:

1. **Threats to the broader Kouci ecosystem**, such as the integrity and availability of scouting statistics.
2. **Threats evaluated in the dissertation**, specifically license bypass and full dataset recovery.

That is perfectly acceptable, but you should distinguish them explicitly.

For example, the local dataset may be vulnerable to unauthorized modification (Tampering), but your dissertation's Keystore experiment is designed to evaluate confidentiality, not necessarily integrity. Encryption alone does not establish protection against unauthorized modification; that depends on the encryption scheme and associated integrity controls.

**My recommendation:** Keep the full STRIDE matrix for systematic threat identification, then use your threat catalogue to mark each scenario as either **Experimentally Evaluated**, **Contextual**, or **Out of Scope**.

This gives you a defensible STRIDE methodology without unnecessarily expanding the experimental scope of your master's dissertation.