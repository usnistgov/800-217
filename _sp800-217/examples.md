---
layout: default
title: Examples
navOrder: 9
navTitle: Examples
permalink: /examples/
anchor: examples
section: B
---

# Examples {#examples}

_This appendix is informative._

This appendix contains several example scenarios of PIV federation in various environments and applications to show different kinds of trust establishment, account management, and authenticator usage. The details of the federation transactions within each scenario all follow the common patterns discussed in [[SP800-63C]](references.md#ref-SP800-63C) and adhere to the requirements in this document.

The scenarios in this section are for illustrative purposes and do not convey additional requirements beyond those imposed by this specification.

## Direct Connection to the Home IdP

Agency A, which issues and manages PIV identity accounts, sets up an OpenID Connect IdP in order to make its PIV identity accounts available online through a federation process. The agency publishes its home IdP record from its publicly available website with all required information for RPs to consume.

The RP enters into a pairwise trust agreement with the IdP to accept assertions for Agency A. The RP declares the set of attributes that it needs from the IdP as part of this agreement. The RP uses a just-in-time provisioning system to establish an RP subscriber account only once the subscriber logs in for the first time. The RP has other pairwise agreements with other IdPs to accept assertions for different agencies but will reject any assertions for accounts at Agency A that come from any other IdP.

The IdP generates a pairwise federated identifier for the PIV identity account for each RP that it is in contact with by hashing the identifier for the RP along with a randomly generated value stored with the PIV identity account at the IdP. This way, each new RP that signs on to the IdP gets a different federated identifier for a single account, but a consistent federated identifier is used for each RP with that account.

Per the terms of the trust agreement, the subscriber is prompted by the IdP the first time they log on to the RP. The IdP asks for the subscriber's consent at runtime to share attributes with the RP. The IdP also prompts the subscriber to allow the IdP to remember this consent decision. This stored decision causes the IdP to act on the stored consent in a future request and not prompt the subscriber if the same RP requests the same attributes.

## Multilateral Federation Network

Agencies A, B, and C each have a home IdP running OpenID Connect for their PIV identity accounts. All three agencies join a multilateral federation in which the federation authority independently verifies that each home IdP represents the agency in question. The federation authority publishes the home IdP records for all agencies that are part of the multilateral federation. This publication allows RPs within the federation to discover which IdP is to be used to access accounts for a given agency under the rules of the federation agreement.

RPs X and Y wish to allow logins from agencies A, B, and C, and the RPs declare their intent and a list of required attributes to the federation authority. The federation authority assesses both RP requests and adds them to the multilateral federation. This allows both RPs to register at each of the three separate IdPs as needed for each agency.

Both RPs interface directly with each of the three IdPs and not through a federation proxy. When a new IdP or RP is added to the multilateral federation agreement, the existing IdPs and RPs are notified of the new component and its parameters.

The IdPs and RPs establish a shared signaling channel under the auspices of the federation authority. This allows any IdP and any RP to report suspicious or malicious behavior that involves a specific account to the rest of the members under the federation authority.

## Enterprise Application

The home IdP establishes a pairwise agreement with an RP to provide an enterprise-class service to the subjects of the agency's PIV identity accounts. As part of this trust agreement, the home IdP allows access to a provisioning API for the RP. The provisioning API pushes a set of federated identifiers and associated attributes to the RP that allow the RP to pre-provision RP subscriber accounts for every PIV identity account at the IdP.

The existence of these RP subscriber accounts allows the RP to offer things like access rights, sharing, and messaging to all accounts on the system, whether or not the specific account has logged in to the RP yet.

Under the terms of the trust agreement, the RP is placed on an allowlist. Consequently, subscribers are not prompted for consent at runtime because the agency consented to use the service on behalf of all accounts at the time the RP was onboarded. This gives subscribers a seamless single sign-on experience, even though a federation protocol is being used across security domain boundaries.

The RP subscriber accounts are synchronized using the provisioning API. When a new PIV identity account is created, modified, or deleted at the IdP, the IdP updates the status of the RP subscriber account using the provisioning API. This allows the RP to always have an up-to-date status for each PIV identity account. For example, when the RP subscriber account is terminated at the IdP, the provisioning API signals to the RP that the RP subscriber account is to be terminated immediately. The RP removes all locally cached attributes for the account in question, except for the identifiers and references in audit and access logs.

## PKI-Based Federation Gateway

A service provider that does not issue any PIV identity account of its own sets up a SAML IdP that accepts PKI-based PIV credentials as its only authentication method. These accounts are provisioned at the IdP using the attributes in the certificates when the subscriber first presents the certificate. The IdP collects no additional attributes from the subscriber in the process. 

The IdP generates federated identifiers for the accounts by computing a hash of the authentication certificate and encoding that hash in Base64. This process fulfills the requirements of this document for federated identifiers, but it is specific to this IdP and need not be known or understood by any RP connecting through the IdP. Note that if the subscriber changes any attributes in the certificate, such as their name, then a new federated identifier will be created as a result. As a result, this IdP does not necessarily provide a stable subject identifier across authenticator updates.

The RP enters into a pairwise trust agreement with the IdP to accept assertions for any agency with PIV credentials. The RP does not have any other IdPs that it speaks to directly, and so the only way to log in to the RP is through this gateway. Since the IdP accepts a broad range of PKI-based credentials, this allows the RP access to any account based on those credentials.

This setup does not allow the PIV identity accounts to use non-PKI-based derived PIV credentials since the IdP portion of the gateway is not the home IdP for any of the accounts in question. The RP is also not able to receive any attributes other than those available directly to the IdP through subscriber certificates. To ensure account continuity, an RP would need to have an out-of-band process to bind their new federated identifier to the existing RP subscriber account if the certificate and attributes change over time.

The IdP is not acting as a federation proxy because the inbound credential is not a federated assertion but rather a PKI-based credential that the gateway processes directly as a verifier.

## PIV Federation Proxy as a Federation Authority

A federation proxy is set up within a multilateral federation. The proxy is run by the federation authority. All IdPs under the multilateral agreement register the proxy as an RP. The RPs within the federation authority connect to the proxy as their only IdP. All federation transactions within the multilateral federation flow through the proxy.

The federation authority discloses the nature of the proxy to all parties, so the IdPs know that this particular RP is a proxy, and the RPs know that their IdP is a proxy. Furthermore, the proxy lists all of the upstream IdPs and their associated populations of PIV identity accounts to all RPs connecting through the proxy.

The proxy discloses to the RPs which upstream IdPs participated in the authentication of the PIV identity account to the proxy, allowing the downstream RPs to validate that the source of the federation transaction through the proxy is appropriate for the PIV identity account in question.

The proxy is not regarded as a home IdP for any RP in the system, even if the IdPs connecting in to the proxy are themselves home IdPs.

## FAL3 With a PIV Card

The PIV Card and certain PKI-based derived PIV credentials can be used as IdP-managed bound authenticators for use at FAL3. The home IdP authenticates the PIV identity account using an authenticator bound to the account and then creates an assertion that is flagged as FAL3. The assertion also contains the certificate common name (CN) and thumbprint of the certificate to be used as a bound authenticator.

When the RP receives the assertion, it processes it as usual and sees the FAL3 flag and the certificate attributes. The RP matches the CN against attributes in the RP Subscriber Account to ensure that the certificate being identified is appropriate for the PIV identity account being represented. The RP then prompts the subscriber to authenticate using a certificate and compares that certificate against the provided CN and thumbprint, ensuring that they match. When the certificate has been validated, the RP creates a secure session at FAL3. From this point forward in the session, the RP no longer requires presentation of the certificate in order to access the RP's services.

## FAL3 With an RP-Bound Authenticator

The home IdP authenticates the PIV identity account using an authenticator bound to the account, and then creates an assertion that is flagged as FAL3 and using an RP-bound authenticator.

When the RP receives the assertion, it processes it as usual and sees the FAL3 flag. The RP looks up the bound authenticator associated with the RP Subscriber Account and prompts the subscriber for this authenticator. When the authenticator has been verified, the RP creates a secure session at FAL3.
