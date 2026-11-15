# 1 Introduction

> [!NOTE] Why is Threat Modeling important?
> *Stratford's network has hundreds of hosts, dozens of services, and multiple application layers. Ten business days is not enough to test everything. If you start scanning blindly, you will spend three days mapping low-priority internal file shares while the payment database with 200,000 customer credit card records sits untouched. The client's CISO does not care that you found a missing patch on a print server. They care about whether an attacker can reach the data that keeps their business alive.*

Build a structured understanding of _what_ the client needs to protect, _what_ could go wrong, and _where_ to focus your limited testing time. A threat model is not a compliance checkbox or an architect's exercise; for a penetration tester, it is a targeting document. It transforms a vague scope into a prioritized attack plan.
%% https://tryhackme.com/room/threatmodelingforpentesters %%
## Where Threat Modeling Fits in the Pentest Lifecycle

1. Pre-Engagement Interactions
2. Intelligence Gathering
3. **Threat Modeling**
4. Vulnerability Analysis
5. Exploitation
6. Post-Exploitation
7. Reporting

Threat modeling is where you decide which components represent the highest risk to the business and deserve the most testing time.

# 2 Four Questions and Three Frameworks

**What are we working on?** 
Decompose the system into its components, data flows, and boundaries. Understand the architecture before you attack it.

**What can go wrong?** 
Systematically identify threats against each component. This is where frameworks like STRIDE, PASTA, and MITRE ATT&CK provide structure.

**What are we going to do about it?**
Determine the response for each identified threat: mitigate, eliminate, transfer, or accept the risk.

**Did we do a good enough job?**
Validate your analysis, review completeness, and update the model as the system evolves.

When you perform threat modeling, you begin to recognize what can go wrong in a system. It also allows you to pinpoint design and implementation issues that require mitigation, whether it is early in or throughout the lifetime of the system. The output of the threat model, which are known as threats, informs decisions that you might make in subsequent design, development, testing, and post-deployment phases.

## 2.1 Three Frameworks, Three Perspectives

Three frameworks that answer question 2 from different angles. Each one adds a layer of depth that the others lack.
### 2.1.1 STRIDE
Answers the question with _systematic categories_. It gives you a structured checklist of six threat types (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege) and a method for applying them to every component in your target architecture. You will also learn **DREAD**, a companion scoring model that helps prioritize the threats STRIDE identifies.

### 2.1.2 PASTA
Process for Attack Simulation and Threat Analysis answers the question with _business risk context_. Its seven-stage process starts from the client's business objectives and works toward technical threats, ensuring your pentest priorities align with what the organization actually cares about.

### 2.1.3 MITRE ATT&CK
Answers the question with _real adversary intelligence_. Instead of theoretical categories, ATT&CK catalogs the specific tactics and techniques that observed threat groups use in the wild. If a company operates in financial services, ATT&CK tells you exactly which attack techniques groups like FIN7 have used against similar organizations.

### 2.1.4 Conclusion
None of these frameworks is a silver bullet on its own. STRIDE is systematic but does not prioritize. PASTA is thorough but time-intensive. ATT&CK is evidence-based but requires threat intelligence maturity. Used together, they give you a layered, actionable threat model that translates directly into a penetration test plan.

## 2.2 What Are We Protecting?

**Asset**: anything of value that an attacker might target or that the organization needs to protect

**Data assets**:  information the system stores, processes, or transmits. These include customer Personally Identifiable Information (PII), payment card numbers, authentication credentials, and transaction logs. Data assets are often the primary target; they are what attackers monetize.

**System assets**: Infrastructure components that host and move data. Servers, databases, APIs, network devices, and cloud services all qualify. Compromising a system asset is often a means to reach a data asset, not an end in itself.

**Business process assets**: Workflows and operations that generate revenue or maintain compliance. The payment processing workflow is a business process asset. If an attacker disrupts it, the company loses revenue regardless of whether any data is stolen.

Your threat model should identify assets in all three categories.

## 2.3 Data Flow Diagrams: Mapping the System

Once you know what assets exist, you need to understand how they connect. A **Data Flow Diagram (DFD)** is a visual representation of how data moves through a system. DFDs were originally developed in the 1970s for software engineering, but the security community adopted and extended them by adding one critical element: trust boundaries.

![[TableDFD.png]]

1. Identify the External Entity. (Outside our control)
2. Draw the first Trust Boundary
3. Add the First Process
4. Draw the Second Trust Boundary
5. Add the Second Process
6. Add Data Flows
7. Add the Data Store

In a real engagement, you would expand each process into its own sub-diagram showing internal logic, authentication mechanisms, and error handling paths.

### 2.3.1 Trust Boundaries: Where Vulnerabilities Concentrate

Trust boundaries deserve special attention because they are where most vulnerabilities live. Every time data crosses a trust boundary, it moves between zones with different levels of trust, and that transition creates opportunity for exploitation.

Consider the boundary between the customer's browser and the Kouci Web Application. On the customer's side, all data is untrusted; a malicious user can craft any HTTP request they want. On the Kouci side, the application must decide what to trust. If the application fails to validate input at this boundary, the result is injection attacks, cross-site scripting, parameter manipulation, and a long list of vulnerabilities.

As a pentester, **trust boundaries on a DFD are your initial target list.** Every data flow crossing a trust boundary is a point where security controls must exist and where you should test whether they actually work. This is why building an accurate DFD is not just an academic exercise; it is the foundation of your engagement's test plan.

### 2.3.2 Attack Surface

The **attack surface** of a system is the total set of points where an unauthorized user can attempt to enter data, extract data, or interact with the system. If trust boundaries tell you _where_ controls should exist, the attack surface tells you _how many entry points_ an attacker has to work with.

A smaller attack surface is easier to defend and easier to test. Part of your threat modeling work is identifying whether the attack surface is larger than it needs to be. Does the admin dashboard need to be accessible over VPN, or could it be restricted to a hardened jump box? Does the API gateway expose endpoints that are only used internally? These are questions that arise naturally from mapping the attack surface on a DFD.

A smaller attack surface is easier to defend and easier to test. Part of your threat modeling work is identifying whether the attack surface is larger than it needs to be. Does the admin dashboard need to be accessible over VPN, or could it be restricted to a hardened jump box? Does the API gateway expose endpoints that are only used internally? These are questions that arise naturally from mapping the attack surface on a DFD.

### 2.3.3 DFD Tools

- **OWASP Threat Dragon** is a free, open-source tool specifically designed for security-focused DFDs. It supports STRIDE-based threat annotation directly on the diagram and runs as both a web application and a desktop app.
- **Microsoft Threat Modeling Tool** is a free Windows application that auto-generates STRIDE threats from DFD elements. It is useful for structured workshops but limited to Windows.
- **Draw.io or Excalidraw** works well for quick sketches during scoping calls or informal threat modeling sessions. These general-purpose diagramming tools lack security-specific features but are fast and collaborative.


# 3 STRIDE

STRIDE was created in **1999 by Loren Kohnfelder and Praerit Garg** at Microsoft. Adam Shostack later popularized it through Microsoft's **Security Development Lifecycle (SDL)**, embedding it as the default threat identification method in the Microsoft Threat Modeling Tool.

### 3.1 The Six Categories

#### 3.1.1 Spoofing - Violates Authentication
> _Can an attacker impersonate a legitimate user or system?_

Spoofing occurs when an attacker pretends to be someone or something they are not, bypassing authentication controls to gain unauthorized access. This includes credential theft, session hijacking, IP spoofing, and forged authentication tokens.

In February 2024, [attackers compromised Change Healthcare](https://www.ibm.com/think/news/change-healthcare-22-million-ransomware-payment) by using stolen credentials to access a Citrix remote access portal that lacked Multi-Factor Authentication (MFA). The attackers impersonated a legitimate user, moved laterally for nine days, and ultimately deployed ransomware that compromised 190 million healthcare records. A threat model of the Citrix portal would have flagged the absence of MFA as a spoofing risk at the external trust boundary.

#### 3.1.2 Tampering - Violates Integrity
> _Can an attacker modify data in transit or at rest?_

Tampering covers any unauthorized modification of data, whether it is intercepting and altering network traffic, manipulating database records, injecting malicious code, or modifying configuration files.

**Real-world anchor:** [The SolarWinds attack](https://www.ncsc.gov.uk/collection/ncsc-annual-review-2021/the-threat/solarwinds), disclosed in December 2020, involved a Russian APT group injecting the Sunburst backdoor into the Orion software build pipeline. The compromised updates were distributed to over 30,000 organizations, including multiple US government agencies. The attackers tampered with the software supply chain itself, and the malicious code persisted undetected for over a year. Threat modeling the build and distribution pipeline would have identified code integrity verification as a critical control at each stage.

#### 3.1.3 Repudiation - Violates Non-Repudiation

> _Can an attacker perform actions without being traced?_

Repudiation threats arise when a system cannot prove that a specific action was performed by a specific actor. If logging is insufficient, disabled, or easily tampered with, an attacker can act without leaving a reliable audit trail. This makes incident response slower and forensic reconstruction difficult.

**Real-world anchor:** [The National Public Data breach in 2024](https://support.microsoft.com/en-us/defender/national-public-data-breach-what-you-need-to-know) involved attackers exfiltrating 2.9 billion records through low-volume API queries designed to avoid triggering alerts. Without adequate logging and anomaly detection, the organization could not reconstruct the timeline of exfiltration for months. IBM's 2025 research found that organizations without centralized logging take significantly longer to identify and contain breaches.

#### 3.1.4 Information Disclosure - Violates Confidentiality
> _Can an attacker access data they should not see?_

Information disclosure covers any scenario where sensitive data is exposed to unauthorized parties. This includes SQL injection that dumps database contents, directory traversal that exposes configuration files, verbose error messages that reveal internal architecture, and insecure API responses that return more data than intended.

**Real-world anchor:** In May 2023, the [CL0P ransomware group](https://www.cisa.gov/news-events/cybersecurity-advisories/aa23-158a) exploited a SQL injection zero-day (CVE-2023-34362) in MOVEit Transfer, a managed file transfer application. The vulnerability allowed attackers to extract data from over 1,062 organizations, affecting more than 65 million individuals, including employees of the BBC, British Airways, and the US Department of Energy. A DFD of the file transfer workflow would have identified SQL injection risk at the web interface trust boundary.

#### 3.1.5 Denial of Service - Violates Availability

> _Can an attacker disrupt service for legitimate users?_

Denial of Service (DoS) threats target the availability of a system, making it unresponsive or entirely unavailable. This includes network-level volumetric attacks, application-layer resource exhaustion, logic bombs, and targeted crashes triggered by malformed input.

**Real-world anchor:** [The Mirai botnet](https://www.cisa.gov/news-events/alerts/2016/10/14/heightened-ddos-threat-posed-mirai-and-other-botnets), originally responsible for a 620 Gbps attack in 2016, continues to evolve. In 2024, [Cloudflare](https://blog.cloudflare.com/ddos-threat-report-for-2024-q4/) blocked a record-setting Distributed Denial of Service (DDoS) attack peaking at 5.6 Terabits per second, launched from over 13,000 compromised IoT devices. Cloudflare reported blocking 21.3 million DDoS attacks in 2024, a 53% increase over the prior year.

#### 3.1.6 Elevation of Privilege - Violates Authorization

> _Can an attacker gain permissions beyond their intended role?_

Elevation of Privilege (EoP) occurs when an attacker escalates from a lower privilege level to a higher one, gaining access to functionality or data they were never meant to reach. This includes exploiting broken access controls, kernel vulnerabilities, misconfigured permissions, and application logic flaws.

**Real-world anchor:** [Log4Shell (CVE-2021-44228)](https://nvd.nist.gov/vuln/detail/cve-2021-44228), disclosed in December 2021, allowed remote code execution through a JNDI lookup injection in the widely used Apache Log4j library. An attacker who could control a single log message could execute arbitrary code with the full privileges of the application. Over 830,000 attack attempts were detected within 72 hours of public disclosure. A DFD showing user input flowing through the application to Log4j and then to an external JNDI/LDAP server would have exposed the trust boundary violation where user-controlled data triggered an unrestricted external lookup.



### 3.2 DFD to STRIDE mapping table

![[TableDFD_STRIDE.png]]

Two observations stand out. First, **processes are susceptible to all six STRIDE categories**, making them the highest-priority elements in any analysis. Every process on your DFD should receive full STRIDE treatment. Second, the asterisk on Data Store / Repudiation reflects a specific case: data stores are generally not subject to repudiation threats _unless_ the data store serves as an audit log. If an attacker can tamper with log files, they can erase evidence of their actions, which is a repudiation threat enabled by tampering.

### 3.3 Analysis Approach

**STRIDE-per-Element** visits every component on the DFD and checks each applicable STRIDE category. This is comprehensive but time-intensive. For a DFD with 15 elements, you are evaluating up to 90 threat combinations (15 elements × 6 categories, minus the non-applicable cells from the mapping table). This approach works well for smaller systems or high-assurance environments where thoroughness is more important than speed.

**STRIDE-per-Interaction** focuses specifically on data flows that cross trust boundaries. Instead of analyzing every element, you analyze every _interaction_ between elements in different trust zones. For penetration testers, this is often the more efficient choice because trust-boundary-crossing data flows are exactly where vulnerabilities concentrate, as we discussed in Task 2.
### 3.4 Limitations of STRIDE

- **No built-in prioritization.** STRIDE identifies threats but does not rank them by severity or likelihood. A list of 30 threats with no priority guidance is not actionable without a companion scoring model.
- **Resource-intensive for complex systems.** A microservices architecture with 50 services, each with its own DFD, generates hundreds of threat combinations. Without scoping discipline, the analysis can become unwieldy.
- **Static and design-time focused.** STRIDE analyzes the system as designed, not as it behaves at runtime. It does not account for zero-day vulnerabilities, configuration drift, or dynamic attack patterns that emerge from unexpected interactions.
- **Quality depends on DFD accuracy.** An incomplete or inaccurate DFD produces an incomplete threat model. If you miss a data flow or misplace a trust boundary, the corresponding threats go unidentified.

