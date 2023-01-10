---
layout: default
title: Protocol Requirements
navOrder: 6
navTitle: Protocol
permalink: /protocol/
anchor: s-6
section: 6
---

# Protocol Requirements {#s-6}

_This section is normative._

A federation protocol connects the IdP and RP together with a series of messages. These messages include assertions, which are passed between the IdP and RP to represent the federated authentication event, and the contents of identity APIs, which convey additional attribute information about the subscriber. This section enumerates requirements for these common components but is not intended to provide sufficient detail for any specific federation protocol.

## Required Attributes {#required-attributes}

A PIV IdP **SHALL** make the following mandatory attributes available to all RPs for each PIV identity account, as required by the trust agreement:

* Subject Identifier: A unique identifier for the PIV identity account that is assigned by the IdP to the account for use by the RP; the subject identifier is part of the federated identifier, see [Sec. 6.2.1](protocol.md#federated-identifier) for additional requirements.
* Issuing Agency: A global identifier for the issuing agency associated with the PIV identity account (e.g., an agency's domain name or a FASCN agency code from [[SP800-87]](references.md#ref-SP-800-87)).
* Organizational Affiliation: The organization or list of organizations that the PIV identity account is affiliated with.
* Last Updated: A timestamp that indicates when the available attributes in the PIV identity account were last updated at the IdP.

A PIV IdP **SHALL** make the following core identity attributes available to RPs, subject to the trust agreement:

* Email address: The current email address for the subscriber as known by or issued by the IdP.
* Full Name: The full name of the subscriber that is suitable for display or addressing the subscriber at the RP; the individual portions of the name, such as a given name and family name, **MAY** also be made available separately.

A PIV IdP **SHOULD** make the following optional identity attributes available to RPs, subject to the trust agreement:

* Physical Address: The physical address of the subscriber, most typically an office address
* Phone Number: The current telephone number for the subscriber as known by or issued by the IdP
* Certificate Subject Distinguished Name Field: The Subject Distinguished Name field of the subscriber's current PIV authentication certificate

Any given RP does not necessarily have access to all attributes made available by an IdP. The subject identifier (and therefore the federated identifier), issuing agency, organizational affiliations, and last updated timestamp **SHALL** be disclosed as part of all trust agreements in PIV federations. All other subscriber account attributes are subject to the trust agreement in place between the IdP and RP, including disclosures of use between the parties.

Except as otherwise stated in [Sec. 6.2](protocol.md#assertion-contents), the IdP **SHOULD** disclose attributes through an identity API rather than through the assertion itself. For example, in OpenID Connect, while it is possible to include subscriber attributes such as `name` and `email` within the ID token (the assertion), it is preferable to make such attributes available from the UserInfo Endpoint (an identity API). When attributes are available for a given account through more than one method at an IdP, the attribute values **SHALL** match.

A PIV IdP **SHOULD** allow for selective disclosure of attributes to different RPs, as determined by the authorized party listed in the trust agreement.

## Assertion Contents {#assertion-contents}

As specified in [[SP800-63C]](references.md#ref-SP-800-63C), the successful validation of a federated assertion is required to begin an authenticated session at the RP. The assertion contains a combination of attributes about the subscriber as well as attributes about the authentication event that the assertion represents.

At minimum, the assertion in PIV federation **SHALL** contain the following attributes of the PIV identity account:

* Flag indicating that this assertion represents a PIV federation transaction
* Last updated timestamp for the PIV identity account
* Identifier for the issuing agency of the PIV identity account
* IAL for the PIV identity account (which is IAL3)
* Federated identifier for the PIV identity account at this IdP, as defined in [Sec. 6.2.1](protocol.md#federated-identifier)

As an assertion is a short-lived message from the IdP to the RP, the assertion itself **SHOULD** contain only the minimum attributes required for its processing. To preserve privacy and minimize the information sent with each request, the assertion **SHOULD NOT** contain non-required or stable attributes from the PIV identity account, such as email address or display name. Additional attributes **SHOULD** be available to the RP through a standard identity API.

At minimum, the assertion in PIV federation **SHALL** contain the following attributes of the authentication event:

* AAL for the latest successful authentication event for the subscriber's current session at the IdP
* Timestamp of the latest successful authentication event for the subscriber's current session at the IdP
* Flag indicating whether the PIV Card or a derived PIV credential was used at the authentication event for the subscriber's current session at the IdP
* Intended FAL for the current transaction

For FAL3 assertions in PIV federation, the assertion **SHALL** contain either:

* A reference to an IdP-managed bound authenticator to be verified by the RP (such as the Subject Distinguished Name of the PIV Card authentication certificate), or
* A flag indicating that an RP-managed bound authenticator is required at the RP.

The mapping of these required attributes to specific fields within a given federation protocol is out of scope for this specification.

### Federated Identifier {#federated-identifier}

The assertion created by a PIV IdP includes a _federated identifier_ for the PIV identity account, as defined in [[SP800-63C]](references.md#ref-SP-800-63C). The federated identifier consists of the logical combination of both a local _subject identifier_ for the PIV identity account and a global _issuer identifier_ for the IdP.

The subject identifier **SHALL** be unique to the PIV identity account at the IdP such that no identifier is the same for any two PIV identity accounts at an IdP. The subject identifier **MAY** be generated by the IdP in a pairwise fashion for a specific RP, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C). If such a pairwise identifier is used, it **SHALL** be used consistently with a given RP and **SHALL NOT** be used for multiple RPs except as allowed by [[SP800-63C]](references.md#ref-SP-800-63C).

The issuer identifier **SHALL** be globally unique for the IdP. This identifier is usually the URL of the IdP, but it can be a unique key identifier or other globally unique value that can be verified by the RP as part of the assertion.

The federated identifier **SHALL NOT** include any personally identifiable or private information, such as username, identifier, the distinguished name of the PIV authentication certificate, email addresses, or UUIDs for the PIV Card or cardholder. 

The RP **SHALL** use this federated identifier to uniquely associate the PIV identity account with the RP subscriber account, as defined in [[SP800-63C]](references.md#ref-SP-800-63C). The RP **SHALL NOT** use other attributes alone for this purpose, including email addresses, certificate subject names, or PIV cardholder UUIDs.

### Authorization and Access Rights

The assertion **MAY** contain indicators for the authorizations and access rights that the subscriber has at the RP, such as a set of roles within an organization. The RP **SHALL** trust these only as subject to the details of the trust agreements between the IdP and RP.

As the point of enforcement, the RP **MAY** override these authorizations by additionally restricting access as necessary.

## Discovery and Registration

The IdP **SHALL** publish its configuration information in a standard machine-readable format and location appropriate to the federation protocol in use. The information in the configuration document **SHALL** be sufficient to allow for the automated configuration of an RP contacting the IdP even when the RP is statically registered.

IdPs operating at FAL2 and below **SHOULD** allow RPs to register dynamically, as described in [[SP800-63C]](references.md#ref-SP-800-63C). Assertions issued to dynamically registered RPs **SHALL** contain pairwise subject identifiers.

## Assertion Presentation

The IdP **SHALL** support back-channel assertion presentation, if possible within the federation protocol. All back-channel presentation methods **SHALL** require authentication of the RP.

At all FALs, RPs **SHOULD** use back-channel presentation to fetch the assertion directly from the IdP, where available.

If front-channel presentation is used, the contents of the assertion **SHALL** be encrypted to a key specific to the RP, as described in [[SP800-63C]](references.md#ref-SP-800-63C).

## Attribute APIs {#identity-apis}

The IdP **SHALL** make identity attributes for the subscriber available through a standard identity API, if possible within the federation protocol in use. The identity API **SHALL** require protected access from the RP.

The IdP **SHALL** allow limited disclosure of attributes through this API, such that federation agreements that connect the IdP and RP (including runtime decisions by an authorized party) can dictate which attributes are disclosed to the RP for a given request.

The RP **SHALL** use the account update timestamp to manage its cache of attribute information in the RP subscriber account, particularly when using a just-in-time provisioning model. That is, if the account update timestamp in the assertion is later than the last cache update value, the RP knows that it should fetch updated information from the identity API. If the timestamp is not later than the cache time, the RP can determine that an additional call to the identity API would be redundant.

The IdP **MAY** provide a provisioning API to the RP, subject to a trust agreement. When a provisioning API is used, the trust agreement **SHALL** include a justification for the intended use of all attributes provided to the RP by the provisioning API.

## Identity Proxies and Brokers

An identity proxy acting in a PIV federation context **SHALL** disclose the IdPs used as sources of attributes to the downstream RP. For example, if an assertion contains attributes for a PIV identity account from IdP A and IdP B, the proxy will list both IdPs as sources within the assertion. Note that the proxy, in its role as an IdP to downstream RPs, is still the issuer of the assertion and will identify itself as such.

See [Sec. 3.3](trust.md#proxy-trust) for more information about the trust agreement requirements of identity proxies.