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

As discussed in [[SP800-63C]](references.md#ref-SP-800-63C), federation provides a means of conveying the proofing and authentication processes associated with the life cycle of the subscriber account. For PIV federation, the PIV identity account is proofed at IAL3, and all PIV credentials are either AAL2 or AAL3, depending on the type of credential. PIV federation **MAY** be conducted at any FAL, depending on the requirements of the use case.

## Reaching Different FALs in PIV Federation

The FAL classification of a PIV federation transaction primarily depends on several aspects of the federation process, including the establishment of the trust agreement, as discussed in [Sec. 3](trust.md#s-3). [[SP800-63C]](references.md#ref-SP-800-63C) defines general requirements for FALs, and this section defines requirements specific to PIV federation.

### FAL1

FAL1 allows federation in a wide variety of situations, particularly when the results of a risk assessment show that the risk is low, and the value of making the federated connection outweighs the complexities of implementing higher FALs. The establishment of the trust agreement and the determination of the PIV IdP **MAY** be established at the behest of the subscriber. The PIV IdP **SHOULD** be the home agency IdP for the agency if the home agency IdP is known for the target agency by the RP. The RP **SHOULD** audit and review all accepted PIV IdPs.

As defined in [[SP800-63C]](references.md#ref-SP-800-63C), at FAL1, the IdP **MAY** use front-channel presentation of the assertion. However, if the assertion contains private or sensitive information and is presented over the front-channel, an encrypted assertion **SHALL** be used.

### FAL2

All of the requirements for FAL1 apply at FAL2 except when more specific or stringent requirements in this section override them.

As defined in [[SP800-63C]](references.md#ref-SP-800-63C), FAL2 requires the assertion presentation to be protected against injection by an attacker at the RP. To accomplish this, PIV federation at FAL2 **SHALL** use back-channel presentation methods.

The establishment of the trust agreement and determination of the PIV IdP at FAL2 **SHALL** be performed prior to the start of the federation transaction. In this establishment, the RP **SHALL** ensure that the PIV IdP is the home agency IdP that represents the population of accounts in question. This process **MAY** be augmented by automated processes (e.g., key exchange) and facilitated by trusted parties (e.g., federation authority).

### FAL3 {#fal3}

All of the requirements for FAL1 and FAL2 apply at FAL3 except when more specific or stringent requirements in this section override them.

The PIV IdP at FAL3 **SHALL** establish identifiers and key material for RP such that the IdP can identify and trust the RP prior to the federation transaction.

As defined in [[SP800-63C]](references.md#ref-SP-800-63C), FAL3 requires the establishment of a _bound authenticator_, which the subscriber presents directly to the RP alongside the federation assertion from the IdP. The bound authenticator does not need to be a PIV credential, though most PIV credentials can be used as bound authenticators at FAL3. When used as a bound authenticator, a PIV credential must be verified separately from the PIV identity account and the assertion with which it is associated. The nature of the binding depends on the type of authenticator, its use, and its phishing resistance qualities.
The same authenticator **MAY** be used as both a derived PIV authenticator at the IdP and a bound authenticator at the RP in a single transaction provided that both the IdP and RP separately verify the authenticator.

PKI-based credentials, such as the PIV authentication certificate on the PIV Card, **MAY** be used as an IdP-managed bound authenticator, as shown in [Fig. 2](federation.md#fig-2). When a certificate is used in this fashion, the assertion **SHALL** contain an identifier of the certificate (as discussed in [Sec 6.2.3](protocol.md#certificate-id)) as an attribute in the assertion to identify the specific certificate used as an authenticator. If the RP uses a just-in-time provisioning method for the RP subscriber account (as defined in [[SP800-63C]](references.md#ref-SP-800-63C)), the RP **SHALL** compare the attributes of the certificate with other attributes from the federation transaction when first associating the bound authenticator with a federated identifier. For example, if the certificate includes one email address, and the federation transaction gives the RP a different email address, the RP needs to decide whether the transaction should be rejected or if this specific discrepancy is expected for its use case and security profile.

[Fig 2. IdP-managed bound authenticators](federation.md#fig-2){:name="fig-2"}
{:latex-ignore="true"}

![Diagram of a PIV Card being used as an IdP-managed bound authenticator]({{site.baseurl}}/{{page.collection}}/images/IdP-Managed-Bound-Auth.png "IdP-managed bound authenticators"){:latex-src="IdP-Managed-Bound-Auth.pdf" latex-fig="2" latex-place="pt"}


Non-PKI-based derived PIV credentials and authenticators other than PIV credentials **MAY** be used as RP-managed bound authenticators, as shown in [Fig. 3](federation.md#fig-3), provided the authenticators meet the phishing resistance requirements in [[SP800-63C]](references.md#ref-SP-800-63C). With RP-managed bound authenticators, the IdP does not see the authenticator directly. The RP **SHALL** conduct an appropriate binding ceremony, as defined in [[SP800-63C]](references.md#ref-SP-800-63C).

[Fig. 3. RP-managed bound authenticators](federation.md#fig-3){:name="fig-3"}
{:latex-ignore="true"}

![Diagram of a non-PKI-based authenticator being used as an RP-managed bound authenticator]({{site.baseurl}}/{{page.collection}}/images/IdP-Managed-Bound-Auth.png "RP-managed nound authenticators"){:latex-src="RP-Managed-Bound-Auth.pdf" latex-fig="3" latex-place="pb"}

When a PIV credential is used as a bound authenticator at the RP, the RP **SHALL** verify the authenticator in the context of a valid assertion. In this way, the authenticator functions separately from its use as a PIV credential.

In the case of a lost bound authenticator, the RP **SHALL** provide mechanisms for unbinding old authenticators and binding a new authenticator at FAL3.

## Selecting FAL

Agencies **SHALL** select the FAL appropriate for a given RP using the digital identity risk management process 
specified in [[SP800-63]](references.md#ref-SP-800-63). Notwithstanding the results of that process specifying a higher assurance level, agencies **SHOULD** use federation protocols, architectures, and processes that are compliant with FAL2 or higher to maximize the assurance provided by the management of the PIV identity accounts.

When not practical to deploy federation at FAL2 in low-impact use cases, agencies **MAY** elect to use FAL1 technologies and processes, in accordance with their digital identity risk management process. In such cases, the risk assessment **SHALL** consider the potential impact of risks associated with the FAL1 mechanisms that will be used.  This could include assertion injection attacks associated with front-channel presentation mechanisms or acceptance of outdated attributes associated with use of PIV IdPs that are not the subjects' home agency IdPs.
