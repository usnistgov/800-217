---
layout: default
title: Trust Frameworks
navOrder: 3
navTitle: Trust
permalink: /trust/
anchor: s-3
section: 3
---

# Trust Agreements {#s-3}

_This section is normative._

The federation process defined in [[SP800-63C]](references.md#ref-SP-800-63C) requires the establishment of a trust agreement between the RP and the IdP for the purpose of federated login, wherein the RP agrees to accept assertions from the IdP, and the IdP agrees to provide assertions and attributes to the RP.

In any PIV federation, the RP **SHALL** establish a specific IdP as the PIV IdP for a population of PIV identity accounts, as described in [Sec. 2.2.2](architecture.md#s-piv-idp). The RP **SHALL** trust this IdP to provide valid assertions for accounts within that population. In many cases, the population is defined by the issuing agency of the PIV identity accounts, and the trust agreement defines a single PIV IdP for each issuing agency's accounts. It is possible&mdash;though uncommon&mdash;for an RP to have a distinct trust agreement established with an IdP for a single PIV identity account.

An RP in a PIV federation **SHALL** accept assertions only from PIV IdPs identified by its trust agreements. An RP **SHALL** accept assertions only within the bounds of its established trust agreements. An RP **SHALL** reject assertions that do not comply with these trust agreements.

Trust agreements in PIV federation **SHALL** consist of the following:

- A population of PIV identity accounts under consideration, including agency identifiers;
- A list of PIV IdPs and the PIV identity accounts they represent;
- A list of RPs capable of receiving assertions from the PIV IdPs;
- The authorized party, as defined in [[SP800-63C]](references.md#ref-SP-800-63C); and
- The interoperable technical profile of the federation protocol in use.

When establishing a trust agreement, the RP **SHALL** disclose to the PIV IdP or federation authority:

- The list of attributes requested and the purpose of use for each attribute;
- The possible range of IAL, AAL, and FAL required to access the RP; and
- The means for mapping any relevant PIV identity account to a specific PIV IdP.

When establishing a trust agreement, the IdP **SHALL** disclose to the RP or federation authority:

- The list of attributes provided;
- The possible range of IAL, AAL, and FAL supported by the IdP;
- Whether the IdP is the home IdP for the population PIV identity accounts (see [Sec. 3.5](trust.md#home-idp-reqs)); and
- The sources of attributes for the PIV identity accounts.

For example, an RP has established a trust agreement with IdP A as the PIV IdP for all subscribers from Agency X. If the RP then receives an assertion from IdP A for a subscriber from Agency Y, the RP would reject the assertion because the IdP is not trusted as the PIV IdP for Agency Y. Likewise, if the same RP also has an established trust agreement with IdP B, and the RP receives an assertion from IdP B for a subscriber from Agency X, the RP would reject that assertion because it has established IdP A as the PIV IdP for this agency.

Trust agreements between an RP and an IdP do not preclude different agreements being established with other parties. For example, an RP can have an agreement to accept IdP A as the PIV IdP for Agency X but have a separate agreement to accept IdP B as the PIV IdP for Agency Y. Both of these IdPs can likewise have trust agreements with many other RPs with potentially different parameters.

Any changes to the parameters of the trust agreement **SHALL** be documented and disclosed to affected parties. If the PIV IdP changes for one or more PIV identity accounts, the RP **SHALL** document any mappings made between federated identifiers for affected PIV identity accounts.

The trust agreement **SHALL** be established in either a bilateral fashion (See [Sec. 3.1](#bilateral)) directly between the parties or a multilateral fashion (See [Sec. 3.2](#multilateral)) through a federation authority, as described in the sections below.

## Bilateral Agreements {#bilateral}

An RP **MAY** establish the PIV IdP directly with the IdP in a bilateral fashion, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C).

When the PIV IdP is the home IdP for an agency, the PIV IdP operator **SHALL** make available its home IdP record to the connected RP, as described in [Sec. 3.5](trust.md#s-home-idp-reqs). The RP operator **SHALL** make the home IdP record available to authenticated subscribers from that IdP, upon request.

The IdP **SHOULD** make its discovery and registration available in a machine-readable format to facilitate configuration of the RP, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C).

## Multilateral Agreements {#multilateral}

An RP **MAY** establish the PIV IdP through the use of a trusted third party known as a federation authority, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C).
This creates a multilateral agreement between different PIV IdPs and RPs under the PIV federation authority. In such systems, the federation authority decides which PIV IdPs and RPs are allowed to participate based on the trust agreement provided by the authority. The federation authority **SHALL** declare which IdP is the PIV IdP for any given population of PIV identity accounts within the trust agreement. The federation authority **SHALL** establish and declare whether each PIV IdP is the home IdP for any given PIV identity account within the trust agreement.

The federation authority **SHALL** vet all PIV IdPs and RPs within the federation to ensure that all parties are acting within the terms of the agreements.

The federation authority **SHALL** disclose to all connected RPs whether a particular IdP is the home IdP for an agency in question. Federation authorities **SHALL** make all home IdP records (defined in [Sec. 3.5](trust.md#s-home-idp-reqs)) available to participants within the federation using a machine-readable format appropriate for the federation protocol standards in use.

The federation authority **SHALL** make lists of all member IdPs and RPs available to other members within the scope of the federation agreement. IdPs within a federation authority **SHOULD** enable dynamic registration of new RPs, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C), subject to the rules of the federation authority, the desired federation assurance level, and the capabilities of the federation protocol in use.

The federation authority **SHALL** document the full set of attributes to be provided by each IdP and allowed to be requested by RPs within the federation. The federation authority **SHALL** collect the attributes requested by RPs joining the federation and **SHALL** document the RP's justification and use for these attributes.

## Identity Proxies and Brokers {#proxy-trust}

An identity proxy (also known as an identity broker) takes in federated authentications from one domain and asserts them outbound to another domain. Identity proxies are discussed in [[SP800-63C]](references.md#ref-SP-800-63C), and all requirements for proxies enumerated therein apply to identity proxies in a PIV federation.

In many cases, it is natural for a proxy to act as a federation authority for all connected parties due to the proxy's nature as a common connection point between IdPs and RPs. However, bilateral agreements are still possible and allowable through a proxy, with each IdP and RP making a pairwise agreement to the proxy itself.

For each federated transaction with an RP, the proxy **SHALL** determine the appropriate upstream PIV IdP that is appropriate for each PIV identity account it proxies to a downstream RP.

~~~
\clearpage
~~~
{:latex-literal="true"}

In addition to its other requirements as part of a trust agreement, an identity proxy in a PIV federation context acting as an IdP **SHALL** disclose to the RP or federation authority:

- The proxy's nature as a proxy and
- The list of PIV IdPs that the proxy connects to for accounts that the RP is able to access.

Assertions created by a proxy **SHALL** include the identifier of the upstream IdP. Note that this is separate from the required issuer field, which identifies the proxy itself. Since the proxy is the issuer of federated assertions to its downstream RPs, these downstream RPs **SHALL** view the proxy as the PIV IdP for accounts asserted through the proxy.

## Shared Signaling {#shared-signaling}

In addition to sharing account information for the purposes of federated login, additional signals can be shared between the IdP and RP for the specific uses described in [[SP800-63C]](references.md#ref-SP-800-63C).

The IdP **SHOULD** inform the RP of significant status changes in a PIV identity account that has been used at an RP, including:

- A suspected breach of the PIV identity account,
- The termination of the PIV identity account, or
- Changes to any part of the federated identifier.

When the RP receives such status changes, the RP **SHOULD** update its RP subscriber account, as appropriate for the nature of the signal.

The IdP **MAY** additionally inform the RP of significant changes to the PIV identity account's information, including:

- A change in contact information attributes (email address, phone number),
- A change in primary authenticator status, or
- The addition or removal of secondary authenticator.

The RP **SHOULD** inform the IdP of significant status changes in the RP subscriber account, including:

- A suspected breach of the RP subscriber account or its data,
- Suspicious behavior of the RP subscriber account (such as repeated attempts to access unauthorized functions), or
- The addition or removal of RP-managed bound authenticators at FAL3.

When the IdP receives such status changes, the IdP **SHOULD** terminate, disable, or update the PIV identity account or the RP's access to the account as appropriate to the nature of the signal.

## Home IdPs {#home-idp-reqs}

Only the agency responsible for issuing PIV identity accounts **SHALL** declare the home IdP for those accounts. Operation of the home IdP **MAY** be outsourced to a third party.

A home IdP **SHALL** have access to relevant information for the PIV identity accounts that it asserts, including the following:

- All attributes available for federation,
- All PIV credentials bound to the account, and
- The current status of the PIV identity account (active/terminated).

The effect of these requirements is that the home IdP needs to be coupled to the management of the PIV identity accounts that it represents. This can be accomplished with a variety of technological means, such as attachment to the issuing agency's enterprise identity and access management system or the use of a provisioning protocol to synchronize account state with the IdP system.

The issuing agency responsible for declaring its home IdP **SHALL** publish its home IdP information in a publicly available location to allow for discovery and configuration by RPs. The home IdP publication record **SHALL** include all of the following:

- A canonical issuer identifier for the IdP (this is generally a URI in federation protocols),
- A list of agency identifiers covered by the IdP,
- A list of federation protocols supported by the IdP along with any profiles of those protocols,
- The location of a machine-readable discovery document for each federation protocol supported by the IdP, and
- Technical contact information for the IdP.

The format for this record and the means by which it is published are out of scope for this specification and subject to technical profiles and federation trust agreements.
