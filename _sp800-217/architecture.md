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

[Figure 1. PIV Federation](federation.md#fig-1){:name="fig-1"}
{:latex-ignore="true"}

![Diagram of a PIV Federation showing the PIV identity account authenticating to the IdP and being asserted to the RP.]({{site.baseurl}}/{{page.collection}}/images/federation.png "PIV Federation"){:latex-src="federation.pdf" latex-fig="1" latex-place="h"}

For PIV federation to occur, all of the following conditions apply:

- The account being asserted is a valid and active PIV identity account (See [Sec. 2.1](#s-piv-account)).
- The RP has established the IdP as the PIV IdP for the account through a valid and current trust agreement (See [Sec. 2.2.2](#s-piv-idp)).
- The subscriber authenticates to the IdP using a PIV credential (See [Sec. 2.3](#s-piv-credential)).

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

The PIV identity account is the definitive source of PIV cardholder information in the context of PIV federation transactions, whether this information is communicated directly from that source to an RP (see _home IdP_ in [Sec. 2.2.1](architecture.md#s-home-idp)) or from another entity trusted by an RP to have accurate and timely information aligned with the PIV identity account records (see _PIV IdP_ in [Sec. 2.2.2](architecture.md#s-piv-idp)). The strong identity proofing used in establishing this account, along with the processes used to manage the attributes and authenticators bound to this account, provide the foundation for trust in PIV identity assertions.

While the systems involved in PIV federation may also manage non-PIV accounts, the use of these accounts is outside the scope of this specification.

## Identity Providers

As described in [[SP800-63C]](references.md#ref-SP-800-63C), the IdP is a service of the Credential Service Provider (CSP) that issues and maintains the PIV identity account. In a federation transaction, the IdP acts as the verifier for the authenticator held by the subscriber. In the case of PIV federation, this means that the IdP verifies the PIV credential bound to the PIV identity account, as discussed in [Sec. 2.3](#s-piv-credential).

The IdP sends a cryptographically verifiable message called an _assertion_ to the RP that identifies the PIV identity account being authenticated. The assertion contains attributes associated with that PIV identity account and details about the authentication event, as discussed in [Sec. 6.2](protocol.md#assertion-contents). The IdP can also make PIV identity account attributes available through a protected identity API alongside the assertion, as discussed in [Sec. 6.5](protocol.md#identity-apis).

The _home IdP_ (see [Sec. 2.2.1](architecture.md#s-home-idp)) is the IdP operated by or on behalf of the issuer of a PIV identity account, which is typically expected to be the agency employing a federal employee or contractor. As a consequence, the home IdP has a direct view of the management of the PIV identity account and PIV credentials associated with the account, including PKI-based and non-PKI-based authenticators. Because there may be multiple IdPs capable of issuing assertions for a PIV cardholder, some of whom may not be directly linked to the PIV identity account, each issuer will need to identify the home IdP for the cardholders they serve, as discussed in [Sec 3.5](trust.md#home-idp-reqs).

A _PIV IdP_ is the IdP trusted by an RP to issue assertions for a given PIV identity account. From the perspective of the RP, all PIV federation transactions involve a PIV IdP. A PIV IdP is trusted by the RP to issue accurate and timely assertions regarding a PIV identity account. When the PIV IdP is not the home IdP, the account status can be ascertained by other means, such as querying the PIV identity account issuer or inferring account status from the status of the PKI-based PIV credential used to authenticate to the PIV IdP.

The Federation Assurance Level (FAL) of a federation transaction places requirements on the parties of the transaction, as defined in [[SP800-63C]](references.md#ref-SP-800-63C). At FAL2 and FAL3, the PIV IdP trusted by the RP has to be the home IdP for the PIV identity account in question, as discussed in [Sec. 4](federation.md#s-4). Additional requirements for the home IdP are discussed in [Sec. 3.5](trust.md#home-idp-reqs). At FAL1, the IdP could be operated or controlled by an entity other than the agency responsible for the PIV identity account. Some forms of PIV credential (such as PKI-based authenticators) can support such third-party operation of an IdP by allowing the authenticator to be verified across domains, which enables a PIV IdP to exist apart from the issuing agency's identity management systems.

### Home IdP {#s-home-idp}

When an issuing agency officially endorses a specific PIV IdP for the PIV identity accounts that the agency issues, that IdP is known as the home IdP for that population of PIV identity accounts. The home IdP is often run by the issuing agency, but operations can be outsourced to a third party through a variety of technical means.

As discussed in [Sec. 3.5](trust.md#home-idp-reqs), a home IdP has direct access to the PIV identity account. This tight coupling allows the home IdP be a highly trusted authority for the PIV identity account in question.

Not all use cases require a home IdP, but RPs can discover the home IdP for a given agency through the published home IdP record, as discussed in [Sec. 3.5](trust.md#home-idp-reqs).

Note that the use of a home IdP is the only means of making non-PKI-based derived PIV credentials available across security domain boundaries due to the nature of the authenticators, as discussed in [[SP800-157]](references.md#ref-SP-800-157).

### PIV IdP {#s-piv-idp}

The PIV IdP is the PIV IdP identified in a trust agreement to provide federated assertions for a population of PIV identity accounts for an RP. Establishment of the PIV IdP is discussed in greater detail in [Sec. 3](trust.md#s-3).

In most cases, the RP's determination of the PIV IdP depends on the agency that issues the PIV identity account. Therefore, an RP will only accept assertions of PIV identity accounts of a particular agency from a specific IdP. However, it is possible for the RP to be more specific and determine the PIV IdP on a per-account basis, subject to the trust agreements in place.

It is possible for an RP's definition of the PIV IdP for a given PIV identity account to change over time as the federation relationship changes for a variety of reasons, including reorganization of the PIV identity account's issuing agency or redeployment of the IdP.

## PIV Credentials {#s-piv-credential}

PIV identity accounts are protected using one or more PIV credentials that are bound to the account. PIV credentials can take the form of different kinds of authenticators, each kind suitable for different purposes and use cases.

The primary credential for a PIV identity account is the PIV Card, which is issued to the subscriber, as defined in [[FIPS201]](references.md#ref-FIPS201).

A PIV identity account can also have multiple derived PIV credentials associated with it, as described in [[SP800-157]](references.md#ref-SP-800-157).

## Relying Parties

In the context of a PIV federation, a subscriber logs into the RP using the federation protocol to use the RP’s services and functionality. The nature of the services provided by the RP and the nature of the RP's deployment are outside the scope of this document. General requirements for the RP in a PIV federation are discussed in [Sec. 5.2](participants.md#rp-requirements), and general requirements for RPs in all federation contexts are discussed in [[SP800-63C]](references.md#SP-800-63C).

In PIV federation, the RP does not directly verify the authentication of the PIV credential, nor does the RP manage the PIV identity account. The RP's only view into the contents and status of the PIV identity account comes through its interactions with the IdP. The RP can manage its own local reference to the PIV identity account, known as the RP subscriber account, as discussed in [Sec. 5.2.2](participants.md#rp-subscriber-account).

At FAL3, the RP is responsible for verifying the presentation of the bound authenticator, as discussed in [[SP800-63C]](references.md#SP-800-63C). Note that the bound authenticator could also be a PIV credential, but it is not necessary for it to be one (see [Sec. 4.1.3](federation.md#fal3) for more information about bound authenticators).
