---
layout: default
title: Architecture
navOrder: 2
navTitle: Architecture
permalink: /architecture/
anchor: s-2
section: 2
---

# Architecture {#s-2}

_This section is informative._

PIV federation is the process by which a subscriber uses their PIV identity account to access an RP using an IdP for that account. As shown in [Figure 1](architecture.md#fig-1), the subscriber uses their PIV credentials (either a PIV Card or a derived PIV credential) to authenticate to the IdP and access the PIV identity account. The authentication event is then conveyed to the RP using an assertion that contains a set of attributes about the authentication event and the PIV identity account.

[Figure 1. PIV federation](federation.md#fig-1){:name="fig-1"}
{:latex-ignore="true"}

![Diagram of a PIV federation showing the PIV identity account authenticating to the IdP and being asserted to the RP.]({{site.baseurl}}/{{page.collection}}/images/federation.png "PIV Federation"){:latex-src="federation.pdf" latex-fig="1" latex-place="h"}

For PIV federation to occur, all of the following conditions apply:

- The account being asserted is a valid and active PIV identity account (see [Sec. 2.1](#s-piv-account)).
- The RP has established the IdP as the PIV IdP for the account through a valid and current trust agreement (see [Sec. 2.2.1](#s-piv-idp)).
- The subscriber authenticates to the IdP using a PIV credential (see [Sec. 2.1.1](#s-piv-credential)) or has provisioned the subscriber-controlled wallet by authenticating with a PIV credential (see [Sec 2.2.3](#subscriber-idp)).

If any of these items are not true, such as the use of a non-PIV identity account at a PIV-enabled IdP or the authentication of a PIV identity account through an IdP that is not the PIV IdP for the account, then the transaction does not meet the requirements of PIV federation, and therefore the definitions and requirements in this document do not apply.

A successful PIV federation transaction is, roughly, as follows:

1. The subscriber starts in an unauthenticated state at the RP.
2. The RP requests a federated login at the IdP.
3. The subscriber authenticates to the IdP using a PIV credential (i.e., a PIV Card or derived PIV credential).
4. The IdP generates an assertion that represents the subscriber's PIV identity account to the RP.
5. The RP receives the assertion and processes it.
6. The RP creates an authenticated session for the subscriber. At the establishment of this session, the subscriber is logged in to the RP.

## PIV Identity Account {#s-piv-account}

A PIV identity account, as established in [[FIPS201]](references.md#ref-FIPS201), is the digital account of a PIV cardholder, a party also known as the subject or subscriber in [[SP800-63]](references.md#ref-SP-800-63). This account contains a set of identity attributes for the subscriber, bindings to all PIV credentials for the account, metadata about the account's creation, and identification of the home agency for the account.

The PIV identity account is the definitive source of PIV cardholder information in the context of PIV federation transactions, whether this information is communicated directly from that source to an RP (see _home agency IdP_ in [Sec. 2.2.2](architecture.md#s-home-idp)) or from another entity trusted by an RP to have accurate and timely information aligned with the PIV identity account records (see _PIV IdP_ in [Sec. 2.2.1](architecture.md#s-piv-idp)). The strong identity proofing used in establishing this account, along with the processes used to manage the attributes and authenticators bound to this account, provide the foundation for trust in PIV identity assertions.

While the systems involved in PIV federation may also manage non-PIV accounts, the use of these accounts is outside the scope of this specification.

### PIV Credentials {#s-piv-credential}

Authentication to a PIV identity account is accomplished using one or more PIV credentials that are bound to the account. PIV credentials can take the form of different kinds of authenticators that are each suitable for different purposes and use cases. The primary credential for a PIV identity account is the PIV Card, which is issued to the subscriber, as defined in [[FIPS201]](references.md#ref-FIPS201). A PIV identity account can also have multiple derived PIV credentials bound to it, as described in [[SP800-157]](references.md#ref-SP-800-157). For the purposes of PIV federation, the PIV credential is presented to the PIV IdP to authenticate the cardholder to the PIV IdP.

### Home Agency Identity Management System {#s-piv-home-idms}

The canonical record for a PIV identity account is stored in the identity management system (IdMS) of the home agency of the PIV identity account, known in this document as the home agency IdMS. This system stores and manages the attributes, statuses, and set of PIV credentials that are bound to the PIV identity account. In the terms of [[SP800-63]](references.md#ref-SP-800-63), the PIV identity account is the subscriber account, and the CSP acts on behalf of the home agency to establish the PIV identity account.

Some systems can have a direct view into the current state of a PIV identity account at the home agency IdMS, such as through a provisioning API at a federated RP. Such systems allow for a proactive propagation of information from the authoritative source, informing downstream systems of account changes as they happen.

Other systems have an indirect view of the status of the PIV identity account, such as by checking the status of the authentication certificate from a PIV Card. If the certificate is not revoked, it can be assumed that the PIV identity account it represents is still valid. However, the inverse is not true, as a revoked certificate could have been replaced for a still-valid PIV identity account during its normal lifecycle process.

In both of these systems, information from the home agency IdMS to the other systems may bye delayed or interrupted. For example, the certificates from a PIV Card can be revoked hours after the PIV identity account has been terminated. Even after the revocation occurs, the processes for updating the certificate revocation list or OCSP status listing are susceptible to latency as that information traverses the certificate issuer and validation systems. While such systems are designed to reach eventual consistency, the potential delays and failures need to be accounted for when designing a system.

## Identity Providers

As described in [[SP800-63C]](references.md#ref-SP-800-63C), the IdP provides a bridge between the PIV identity account (established in the home agency IdMS) and the RP using a federation protocol. In a federation transaction, the IdP acts as the verifier for the authenticator held by the subscriber. In the case of PIV federation, this means that the IdP verifies the PIV credential bound to the PIV identity account, as discussed in [Sec. 2.1.1](#s-piv-credential).

The IdP sends a cryptographically verifiable message called an _assertion_ to the RP that identifies the PIV identity account being authenticated. The assertion contains attributes associated with that PIV identity account and details about the authentication event, as discussed in [Sec. 6.2](protocol.md#assertion-contents). The IdP can also make PIV identity account attributes available through a protected identity API alongside the assertion, as discussed in [Sec. 6.5](protocol.md#identity-apis).

A _PIV IdP_ is the IdP trusted by an RP to issue assertions for a given PIV identity account. From the perspective of the RP, all PIV federation transactions involve a PIV IdP. A PIV IdP is trusted by the RP to issue accurate and timely assertions regarding a PIV identity account. The means by which the PIV IdP obtains this information is outside of the scope of these guidelines, but many IdMSs integrate with federation services to provide an IdP capability. When the PIV IdP is not directly integrated, the account status can be ascertained by other means, such as querying the PIV identity account issuer through an API or inferring the account status from the status of the PKI-based PIV credential used to authenticate to the PIV IdP.

The _home agency IdP_ (see [Sec. 2.2.2](architecture.md#s-home-idp)) is the officially designated PIV IdP established by the home agency, which is the agency employing a federal employee or contractor. As a consequence, the home agency IdP is expected to have a direct view of the PIV identity account and PIV credentials associated with the account, including PKI-based and non-PKI-based authenticators. Because there may be multiple PIV IdPs capable of issuing assertions for a PIV cardholder, each home agency will need to identify the home agency IdP for the cardholders they serve, as discussed in [Sec 3.5](trust.md#home-idp-reqs). The designation and use of a home agency IdP is required for all transactions at FAL2 and above.

The Federation Assurance Level (FAL) of a federation transaction places requirements on the parties of the transaction, as defined in [[SP800-63C]](references.md#ref-SP-800-63C). At FAL2 and FAL3, the PIV IdP trusted by the RP has to be the home agency IdP for the PIV identity account in question, as discussed in [Sec. 4](federation.md#s-4). Additional requirements for the home agency IdP are discussed in [Sec. 3.5](trust.md#home-idp-reqs). At FAL1, the IdP could be operated or controlled by an entity other than the agency responsible for the PIV identity account. Some forms of PIV credential (such as PKI-based authenticators) can support such third-party operation of an IdP by allowing the authenticator to be verified across domains, which enables a PIV IdP to exist apart from the home agency's identity management systems.

### PIV IdP {#s-piv-idp}

The PIV IdP is the PIV IdP identified in a trust agreement to provide federated assertions for a population of PIV identity accounts for an RP. Establishment of the PIV IdP in the trust agreement is discussed in greater detail in [Sec. 3](trust.md#s-3).

The population of PIV identity accounts served by a given PIV IdP can be determined based on a variety of factors but is usually based on the home agency of the PIV identity account. That is to say, an trust agreement will indicate that an agency's PIV identity accounts will be served by one specific IdP. Within any trust agreement, the RP needs to know which IdP to accept assertions about a particular PIV identity account from.

Different trust agreements can indicate different PIV IdPs for the same population of PIV identity accounts. For example, one RP could point to an integration service that acts as a proxy, while a different RP could connect directly to the IdP. Alternatively, one RP's trust agreement could require that it use the home agency IdP, while another RP's trust agreement could allow for a secondary integration, such as a PKI federation gateway.

These decisions can also change over time. For example, an agency could deploy a new IdP service and transfer all existing accounts to it, or a trust agreement could point to different IdPs as new federation protocols are adopted and integrated.

### Home Agency IdP {#s-home-idp}

When a home agency officially endorses a specific PIV IdP for the PIV identity accounts that the agency issues, that IdP is known as the home agency IdP for that population of PIV identity accounts. The home agency IdP is often run by the home agency, but operations can be outsourced to a third party through a variety of technical means.

As discussed in [Sec. 3.5](trust.md#home-idp-reqs), a home agency IdP has direct access to the home agency IdMS. This tight coupling allows the home agency IdP to be a highly trusted authority for the PIV identity account in question, including its current status and attributes. 
Not all use cases require a home agency IdP, but RPs can discover the home agency IdP for a given agency through the published home agency IdP record, as discussed in [Sec. 3.5](trust.md#home-idp-reqs).

A particularly important application of the home agency IdP stems from non-PKI-based derived PIV credentials. These credentials can only be verified by the home agency, as discussed in [[SP800-157]](references.md#ref-SP-800-157). However, if the home agency provides an IdP that can verify such credentials, the cardholder can authenticate to RPs outside of the home agency while using the non-PKI-based derived PIV credential as their primary authenticator.

~~~
\clearpage
~~~
{:latex-literal="true"}

### Subscriber-Controlled wallets {#subscriber-idp}

The PIV IdP can be a subscriber-controlled wallet, as defined in [[SP800-63C]](references.md#ref-SP-800-63C). In this architecture, the IdP is issued a signed attribute bundle that represents the PIV identity account. This is done while the subscriber is authenticated using a PIV credential. The RP in turn trusts the assertions from the subscriber-controlled wallet thanks to the inclusion of the signed attribute bundle from a trusted source.

## Relying Parties

In the context of a PIV federation, a subscriber logs into the RP using the federation protocol to use the RP’s services and functionality. The nature of the services provided by the RP and the nature of the RP's deployment are outside the scope of this document. General requirements for the RP in a PIV federation are discussed in [Sec. 5.3](participants.md#rp-requirements), and general requirements for RPs in all federation contexts are discussed in [[SP800-63C]](references.md#ref-SP-800-63C).

In PIV federation, the RP does not directly verify the authentication of the PIV credential, nor does the RP manage the PIV identity account. The RP's only view into the contents and status of the PIV identity account comes through its interactions with the IdP. The RP can manage its own local reference to the PIV identity account along with information that is local to the RP. This record is known as the RP subscriber account and is defined by [[SP800-63C]](references.md#ref-SP-800-63C) and discussed in [Sec. 5.3.2](participants.md#rp-subscriber-account).

At FAL3, the RP is also responsible for verifying the presentation of the bound authenticator, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C). The bound authenticator could also be a PIV credential, but it is not necessary for it to be one (see [Sec. 4.1.3](federation.md#fal3) for more information about bound authenticators).
