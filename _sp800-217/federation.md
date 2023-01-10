---
layout: default
title: Choosing Federation
navOrder: 4
navTitle: Federation
permalink: /federation/
anchor: s-4
section: 4
---

# Federation Assurance Level (FAL) {#s-4}

_This section is normative._

The federation assurance level, or FAL, is defined in [[SP800-63C]](references.md#ref-SP-800-63C) as a set of requirements for the federation process. A higher FAL indicates a greater degree of trust that the RP can place in the results of the federation process&mdash;namely, that the subscriber present at the RP is the subscriber identified in the federation protocol.

As discussed in [[SP800-63C]](references.md#ref-SP-800-63C), federation provides a means of conveying the proofing and authentication processes associated with the lifecycle of the subscriber account. For PIV federation, the PIV identity account is proofed at IAL3, and all PIV credentials are either AAL2 or AAL3, depending on the type of credential. PIV federation **MAY** be conducted at any FAL, depending on the requirements of the use case.

## Reaching Different FALs in PIV Federation

The FAL classification of a PIV federation transaction primarily depends on several aspects of the federation process, including the establishment of the trust agreement, as discussed in [Sec. 3](trust.md#s-3). [[SP800-63C]](references.md#ref-SP-800-63C) defines general requirements for FALs, and this section defines requirements specific to PIV federation.

### FAL1

FAL1 allows federation in a wide variety of situations, particularly where the results of a risk assessment show that the value of making the federated connection outweighs the complexities of implementing higher FALs. The establishment of the trust agreement and the determination of the PIV IdP **MAY** happen dynamically. The PIV IdP **SHOULD** be the home IdP for the agency if known by the RP. The RP **SHOULD** audit and review all accepted PIV IdPs.

As defined in [[SP800-63C]](references.md#ref-SP-800-63C), at FAL1, the IdP **MAY** use front-channel presentation of the assertion. However, if the assertion contains private or sensitive information and is presented over the front-channel, an encrypted assertion **SHALL** be used.

### FAL2

All of the requirements for FAL1 apply at FAL2 except where overridden by more specific or stringent requirements in this section.

As defined in [[SP800-63C]](references.md#ref-SP-800-63C), FAL2 requires the assertion presentation to be protected against injection by an attacker at the RP. To accomplish this, PIV federation at FAL2 **SHALL** use back-channel presentation methods.

The establishment of the trust agreement and determination of the PIV IdP at FAL2 **SHALL** be done through a trusted process whereby the RP ensures that the PIV IdP is the official home IdP that represents the population of accounts in question. This process **MAY** be augmented by automated processes, including dynamic discovery and registration of the identifiers and key material for the IdP and RP in the federation protocol.

### FAL3 {#fal3}

All of the requirements for FAL1 and FAL2 apply at FAL3 except where overridden by more specific or stringent requirements in this section.

Trust establishment of the PIV IdP at FAL3 **SHALL** be done through a trusted process whereby the RP ensures that the PIV IdP is the official home IdP that represents the agencies and accounts in question. The establishment of identifiers and key material for the IdP and RP in the federation protocol **SHALL** occur through a static process between the IdP and RP.

As defined in [[SP800-63C]](references.md#ref-SP-800-63C), FAL3 requires the establishment of a _bound authenticator_, which the subscriber presents directly to the RP alongside the federation assertion from the IdP. Though most PIV credentials can be used as bound authenticators at FAL3, the nature of the binding depends on the type of authenticator, its use, and its phishing resistance qualities.

PKI-based credentials, such as the PIV authentication certificate on the PIV Card, **MAY** be used as an IdP-managed bound authenticator, as shown in [Figure 2](federation.md#fig-2). When a certificate is used in this fashion, the assertion **SHALL** contain the Distinguished Name of the certificate as an attribute in the assertion to identify the specific certificate used as an authenticator. If the RP uses a just-in-time provisioning method for the RP subscriber account (as defined in [[SP800-63C]](references.md#ref-SP-800-63C)), the RP **SHALL** compare the attributes of the certificate's Distinguished Name with other attributes from the federation transaction when first associating a Distinguished Name with a federated identifier. For example, if the certificate includes one email address and the federation transaction gives the RP a different email address, the RP needs to decide if the transaction should be rejected or if this specific discrepancy is expected for its use case and security profile.

[Figure 2. IdP-Managed Bound Authenticators](federation.md#fig-2){:name="fig-2"}
{:latex-ignore="true"}

![Diagram of a PIV Card being used as an IdP-managed bound authenticator]({{site.baseurl}}/{{page.collection}}/images/IdP-Managed-Bound-Auth.png "IdP-Managed Bound Authenticators"){:latex-src="IdP-Managed-Bound-Auth.pdf" latex-fig="2" latex-place="pt"}


Non-PKI-based derived PIV credentials and authenticators other than PIV credentials **MAY** be used as RP-managed bound authenticators, as shown in [Figure 3](federation.md#fig-3), provided the authenticators meet the phishing resistance requirements in [[SP800-63C]](references.md#ref-SP-800-63C). Note that with RP-managed bound authenticators, the IdP does not see the authenticator directly. The RP **SHALL** conduct an appropriate binding ceremony, as defined in [[SP800-63C]](references.md#ref-SP-800-63C).

[Figure 3. RP-Managed Bound Authenticators](federation.md#fig-3){:name="fig-3"}
{:latex-ignore="true"}

![Diagram of a non-PKI-based authenticator being used as an RP-managed bound authenticator]({{site.baseurl}}/{{page.collection}}/images/IdP-Managed-Bound-Auth.png "RP-Managed Bound Authenticators"){:latex-src="RP-Managed-Bound-Auth.pdf" latex-fig="3" latex-place="pb"}

In their use as bound authenticators at FAL3, authenticators from PIV credentials do not function as PIV credentials at the RP. However, the same authenticator **MAY** be used as both a derived PIV authenticator at the IdP and a bound authenticator at the RP in a single transaction provided that both the IdP and RP separately verify the authenticator.

In the case of a lost bound authenticator, the RP **SHALL** provide mechanisms for unbinding old authenticators and binding a new authenticator at FAL3.

## Selecting FAL

Agencies **SHALL** select the FAL appropriate for a given RP using the digital identity risk management process 
specified in [[SP800-63]](references.md#ref-SP-800-63). Notwithstanding the results of that process specifying a higher assurance level, agencies **SHOULD** use federation protocols, architectures, and processes compliant with FAL2 or higher to maximize the assurance provided by the management of the PIV identity accounts.

When not practical to deploy federation at FAL2 in low-impact use cases, agencies **MAY** elect to use FAL1 technologies and processes, in accordance with their digital identity risk management process. In such cases, the risk assessment **SHALL** consider the potential impact of risks associated with the FAL1 mechanisms that will be used.  This could include assertion injection attacks associated with front-channel presentation mechanisms or acceptance of outdated attributes associated with use of PIV IdPs that are not the subjects' home IdPs.
