---
layout: default
title: Introduction
navOrder: 1
navTitle: Introduction
permalink: /introduction/
anchor: s-1
section: 1
---

# Introduction {#s-1}

_This section is informative._

PIV Cards and derived PIV credentials allow for a very high level of trust in a PIV identity account because of the requirements and processes used in the issuance of the PIV identity account, the features of the associated PIV Card, and the binding of derived PIV credentials to the PIV identity account.
This document seeks to make the benefits of the PIV identity account available to federated relying parties (RPs) through the use of identity providers (IdPs) that verify PIV credentials and provide federated assertions representing the PIV identity account.
Federation technologies can facilitate the connection of these PIV identity accounts across different security domains, allowing a subscriber to leverage the trust and strength of their PIV identity account at agencies other than the agency that issued the credentials.

## Background

This document is a companion document to [[FIPS201]](references.md#ref-FIPS201), providing specific details for implementing PIV federation for PIV identity accounts.  [[FIPS201]](references.md#ref-FIPS201) defines standards for the use of PIV credentials, including the establishment of the PIV identity account, the issuance of the PIV Card, authentication using the PIV Card, management of derived PIV credentials, and other aspects of the PIV identity account. FIPS 201 provides basic requirements for the use of federation and defers to the guidelines provided in this publication to define details of what a PIV-based federation system would entail.


[[SP800-63C]](references.md#ref-SP-800-63C) and its companion document suite of [[SP800-63]](references.md#ref-SP-800-63) provide general guidelines for the use of federation technologies and assertions within Federal Government use cases. These guidelines are intended to be used across a wide variety of account types, authenticators, and deployment patterns. The SP 800-63 suite is not specific to PIV identity accounts.


This document, SP 800-217, specifically applies the guidelines of [[SP800-63C]](references.md#ref-SP-800-63C) to the PIV identity account defined in [[FIPS201]](references.md#ref-FIPS201) to outline the details of _PIV federation_. This document provides a set of processes and technical guidelines for deployers of PIV federation with Federal Government use cases in both IdP and RP roles.

## Purpose and Scope

This document focuses on the use of federation technologies with PIV identity accounts for federal employees and contractors. This document does not discuss citizen-facing use cases covered in [[SP800-63C]](references.md#ref-SP-800-63C).
This document does not address creation or life cycle of PIV identity accounts as covered in [[FIPS201]](references.md#ref-FIPS201), nor does this document account for the issuance and management of derived PIV credentials in PIV identity accounts as covered in [[SP800-157]](references.md#ref-SP-800-157).
While the guidelines within this document could be generally useful in other circumstances, application to any additional use cases are outside the scope of this document.

### Creating Technical Interoperability Profiles of This Guideline

The guidelines in this document alone are not intended to provide full technical interoperability profiles. In addition to this document and its prerequisites ([[FIPS201]](references.md#ref-FIPS201), [[SP800-63C]](references.md#ref-SP-800-63C), and [[SP800-157]](references.md#ref-SP-800-157)), PIV federation deployments will need technical interoperability profiles that are suitable for the federation protocol being used. The details of such profiles are out of scope for this document, but all technical interoperability profiles will need to consider the following points.

Target Protocols:
: Different federation protocols can be used to fulfill the requirements in the guidelines of this document in different and often incompatible ways. A technical interoperability profile ought to target each specific federation protocol in order to allow for more stringent definitions.

Attribute Naming:
: Each attribute that occurs within an assertion or the response from an identity API will need to have a name (or other means of address) defined. To ease interoperability, this name ought to reflect the value being asserted, such as `exp` for an expiration timestamp or `sub` for the subject identifier. Each entity of the federation has to use the same naming convention for interoperable attributes.

Attribute Contents:
: Each attribute that occurs within an assertion or the response from an identity API will need to have its type, format, structure, or other content restrictions sufficiently defined such that the value can be unambiguously understood between sender and receiver. For example, a timestamp format could be encoded as an integer number of seconds since the UNIX Epoch GMT or in an ISO 8601 date string.

Conformance Criteria:
: As PIV federation systems are likely to be built on top of existing federation software, a technical interoperability profile will need to define what additional options are allowed or forbidden by conformant implementations. For example, a profile of OpenID Connect could restrict use of the Implicit Grant Type for requests and responses.

Home Agency IdP Records:
: Agencies need to have a means of publishing verifiable home agency IdP records in a known location that is easily reached and machine-readable by other parties. This could take the form of a centralized directory service with a query function or a lookup pattern based on domain names.

All technical interoperability profiles also need to consider existing profiles and industry best practices for the target technology in question.

## Federation Use Cases

In a *direct authentication*, the claimant presents their authenticator to a verifier, which is tightly coupled with the RP and, usually, the home agency IdMS described in [Sec 2.1.2](architecture.md#s-piv-home-idms). The verifier conducts an authentication process of a PIV credential. This process sometimes uses an external service, such as when public key infrastructure is used to validate a certificate.

PIV credentials are intended for use with direct authentication via the mechanisms listed in [[FIPS201]](references.md#ref-FIPS201) and [[SP800-157]](references.md#ref-SP-800-157). However, there are many situations in which direct authentication is not viable or desirable.

For example, non-PKI-based derived PIV credentials are bound and validated at the home agency. Federation allows these credentials to be used for accessing systems outside of the home agency by having the subscriber present the derived credential to the IdP, which can validate the credential and assert to the RP that the validation has taken place.

In a *federated authentication*, the verifier is not tightly associated with RP and is instead operated by a separate but trusted entity, the IdP. The PIV Card or derived PIV credential is used to authenticate the PIV cardholder to the IdP of a federation system. The IdP creates an *assertion* that represents the authentication event of the subscriber. The IdP sends this assertion to the RP using a federation protocol, and the RP verifies the assertion upon receipt.

In order to authenticate the subscriber, the IdP needs to perform the role of verifier for one or more PIV credentials in the PIV identity account. In some cases, the IdP is a service directly tied to the home agency IdMS. This tight coupling allows the IdP a direct view of the status of the PIV identity account and all associated PIV credentials. However, there are several mechanisms for a PIV IdP to be run by a party other than the home agency. For example, the home agency could outsource the IdP functionality and synchronize the state of its PIV identity accounts using a provisioning protocol or similar system. Alternatively, PKI-based PIV credentials can be verified by an IdP that is run by a party other than the home agency. In this scenario, the validity of the PIV identity account is inferred from the validity of the credential presented to the third-party IdP, and there is no connection to the home agency IdMS.

### Federation Considerations

The use of a federation protocol allows RPs to be shielded from the complexities and requirements of managing individual authenticators. When a new authentication technology is adopted, only the IdP needs to be updated in order for the entire network to benefit. The home agency has the option to bind and manage any number of valid PIV credentials to the PIV identity account. The lifecycle of adding and removing authenticators to the PIV identity account does not affect the RP, which implements only the federation protocol.

Federation allows an RP to access PIV identity accounts that originate from different agencies on different networks. This connection allows an agency to leverage the identity infrastructure of another agency without needing to replicate the PIV identity account management process. The federation process allows the cardholder to use their established PIV credentials to authenticate to a variety of services through the PIV IdP without having to establish separate credentials at those RPs.

The subject identifier asserted by the IdP to the RP is stable to the PIV identity account over time and across different authenticators, including different certificates and attribute changes such as email address or name changes. The subject identifier can also be generated in a pairwise fashion for use cases that require a higher degree of privacy between multiple RPs while still providing a smooth user experience for the subscriber.

Many RPs need access to attributes about the subscriber, such as a display name or contact information. The fixed set of attributes included in a PIV certificate are presented as a whole to all RPs at which the certificate is presented, and some derived PIV credentials carry no attributes at all. In contrast, the attributes released during a federation transaction can vary depending on a variety of factors, including the nature of access required and the parameters of the RP. These attributes can include information in the PIV identity account that is not carried in any specific authenticator. In fact, these attributes are made available to the RP separate from the subscriber's use of any particular authenticator.

An RP may want to verify that the PIV identity account is still active and has not been terminated, but in many circumstances, the RP will not have direct access to the PIV identity account. With federated protocols, the IdP is the authority for the accounts it asserts, allowing RPs to trust that these accounts are in good and current standing according to the IdP. When a PIV identity account is terminated, that account cannot be used to authenticate to the IdP and therefore can no longer be used at any connected RPs.

In advanced circumstances, the IdP and RP can engage in shared signaling about security events concerning accounts, agencies, and applications. These signals can inform a party about suspicious behavior with a given account or proactively indicate significant changes in an account's status, such as termination, without the need for action on the subscriber's part.

The RPs in a federation relationship transitively benefit from the security practices of the IdP. Instead of relying on all RPs to manage authenticators and accounts for many users over time, the IdP can act as a dedicated identity management device within the network.

This also means that an IdP would be aware of the usage of a given PIV identity account under its control at different RPs within its trust networks. While this has positive benefits for security, it does pose a privacy tradeoff wherein the IdP needs to be trusted with this usage information. 

## Audience

This document is intended for stakeholders who are responsible for procuring, designing, implementing, and managing deployments of PIV federation in both the IdP and RP roles.

## Notations

This guideline uses the following typographical conventions in text:

- Specific terms in **CAPITALS** represent normative requirements. When these same terms are not in **CAPITALS**, the term does not represent a normative requirement. 
    - The terms "**SHALL**" and "**SHALL NOT**" indicate requirements to be followed strictly in order to conform to the publication and from which no deviation is permitted.
    - The terms "**SHOULD**" and "**SHOULD NOT**" indicate that among several possibilities, one is recommended as particularly suitable without mentioning or excluding others, that a certain course of action is preferred but not necessarily required, or that (in the negative form) a certain possibility or course of action is discouraged but not prohibited.
    - The terms "**MAY**" and "**NEED NOT**" indicate a course of action permissible within the limits of the publication.
    - The terms "**CAN**" and "**CANNOT**" indicate a possibility and capability&mdash;whether material, physical, or causal&mdash;or, in the negative, the absence of that possibility or capability.

## Document Structure

This document is organized as follows. Each section is labeled as either normative (i.e., mandatory for compliance) or informative (i.e., not mandatory).

- Section 2 describes a general architecture for PIV federation. This section is _informative_.
- Section 3 describes the trust agreements in a PIV federation. This section is _normative_.
- Section 4 describes the Federation Assurance Levels as applied to PIV federation. This section is _normative_.
- Section 5 describes the requirements for IdPs and RPs in a PIV federation. This section is _normative_.
- Section 6 describes the requirements for protocol elements in a PIV federation, including assertion contents. This section is _normative_.
- References contains a list of publications referred to from this document. This section is _informative_.
- Appendix A contains a glossary of selected terms used in this document. This appendix is _informative_.
- Appendix B contains a selected list of abbreviations used in this document. This appendix is _informative_.
