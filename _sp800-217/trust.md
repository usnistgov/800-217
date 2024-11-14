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

In any PIV federation, the RP **SHALL** establish a single, specific IdP as the PIV IdP for a population of PIV identity accounts, as described in [Sec. 2.2.1](architecture.md#s-piv-idp). The RP trusts this IdP to provide valid assertions for accounts within that population.

In many cases, the population is defined by the home agency of the PIV identity accounts, and the trust agreement defines a single PIV IdP for each home agency's accounts. It is possible &mdash; though uncommon &mdash; for an RP to have a distinct trust agreement established with an IdP for a single PIV identity account.

An RP in a PIV federation **SHALL** only accept assertions from PIV IdPs identified by its trust agreements. An RP **SHALL** reject assertions that do not comply with these trust agreements.

In addition to the requirements for trust agreements defined in [[SP800-63C]](references.md#ref-SP-800-63C), trust agreements in PIV federation **SHALL** contain the following:

- A population of PIV identity accounts, including agency identifiers;
- A list of PIV IdPs or a process by which a PIV IdP is established by the home agency;
- The means for mapping a specific PIV identity account to a specific PIV IdP;
- The location of home agency IdP records for all agencies covered by the trust agreement, if applicable;
- The interoperable technical profile of the federation protocol in use; and
- The list of shared signals agreed to by all parties and the actions to be taken in response to receiving those signals.

When establishing a trust agreement, the RP **SHALL** disclose:

- The list of attributes requested and the purpose of use for each attribute,
- The population of PIV identity accounts associated with the IdP, and
- The possible range of AAL and FAL required to access the RP.

~~~
\clearpage
~~~
{:latex-literal="true"}

When establishing a trust agreement, the IdP **SHALL** disclose:

- The list of attributes that can be provided to an RP,
- The possible range of AAL and FAL supported by the IdP,
- Whether the IdP is the home agency IdP for the population PIV identity accounts (see [Sec. 3.5](trust.md#home-idp-reqs)), and
- The sources of attributes for the PIV identity accounts.

> Since all PIV accounts are IAL3, this attribute does not need to be otherwise disclosed.

Trust agreements between an RP and an IdP do not preclude different agreements being established with other parties. For example, an RP can have an agreement to accept IdP A as the PIV IdP for Agency X but have a separate agreement to accept IdP B as the PIV IdP for Agency Y. Both of these IdPs can likewise have trust agreements with many other RPs with potentially different parameters.

The trust agreement **SHALL** establish a deterministic process by which the RP can determine whether a given PIV identity account is included in the population of PIV identity accounts covered by a trust agreement and, therefore, whether the RP should accept an assertion from the IdP for that PIV identity account. The means for this determination are out of scope for these guidelines, but common mapping policies include mapping a single PIV IdP to PIV identity accounts that have the following attributes:

- All accounts from a single home agency, regardless of other attributes
- All accounts with a set of organizational affiliations
- All accounts with a particular job classification, such as full-time employees or contractors
- A specific set of accounts with known human-facing account identifiers, such as email addresses or phone numbers

The trust framework **MAY** stipulate that this mapping be made available through a queryable interface. For example, a federation authority can provide an interface that allows an RP to look up which IdP within the trust agreement to contact given a subscriber's input to the RP.

The result of this process is a clear indication of which PIV identity accounts are served by which PIV IdP within the trust agreement. For example, an RP has established a trust agreement with IdP A as the PIV IdP for all subscribers from Agency X. If the RP then receives an assertion from IdP A for a subscriber from Agency Y, the RP would reject the assertion because the IdP is not trusted as the PIV IdP for Agency Y. Likewise, if the same RP also has an established trust agreement with IdP B for a different agency, and the RP receives an assertion from IdP B for a subscriber from Agency X, the RP would reject that assertion because it has determined that IdP A is the PIV IdP for Agency X.

Any changes to the parameters of the trust agreement **SHALL** be documented and disclosed to affected parties. If the identified PIV IdP changes for one or more PIV identity accounts, the RP **SHALL** document any mappings made between federated identifiers for affected PIV identity accounts.

The trust agreement **SHALL** be established in either a bilateral fashion (see [Sec. 3.1](#bilateral)) directly between the parties or a multilateral fashion (see [Sec. 3.2](#multilateral)) through a federation authority, as described in the following sections.

## Bilateral Agreements {#bilateral}

An RP **MAY** enter a trust agreement directly with the PIV IdP in a bilateral fashion, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C).

When the PIV IdP is the home agency IdP for an agency, the home agency IdMS **SHALL** make its home agency IdP record available to the connected RP, as described in [Sec. 3.5](trust.md#home-idp-reqs). The RP operator **SHALL** make the information in the home agency IdP record available to authenticated subscribers from that IdP upon request.

The IdP **SHOULD** make its discovery and registration available in a machine-readable format to facilitate configuration of the RP, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C).

## Multilateral Agreements {#multilateral}

Establishment of the trust agreement **MAY** be facilitated through the use of a trusted third party known as a federation authority, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C).
This creates a multilateral trust agreement between different PIV IdPs and RPs under the PIV federation authority. In such systems, the federation authority decides which PIV IdPs and RPs are allowed to participate based on the trust agreement provided by the authority. The federation authority **SHALL** declare which IdP is the PIV IdP for any given population of PIV identity accounts within the trust agreement. For all agencies covered by the federation authority's trust agreements, the federation authority **SHALL** indicate the agency's declared home agency IdP, if one exists.

The federation authority **SHALL** evaluate all PIV IdPs and RPs that sign on to a multilateral trust agreement with the federation authority to ensure that all parties adhere to the requirements of the trust agreement. The federation authority **SHALL** periodically reevaluate all members of the trust agreement. The schedule of evaluations **SHALL** be stipulated in the trust agreement.

The federation authority **SHALL** disclose to all connected RPs whether a particular IdP is the home agency IdP for a subscriber population. Federation authorities **SHALL** make all home agency IdP records (defined in [Sec. 3.5](trust.md#home-idp-reqs)) available to participants within the federation using a machine-readable format that is appropriate for the federation protocol standards in use. The federation authority **MAY** provide the home agency IdP records directly or through a pointer to a resource hosted by the home agency. As part of the trust agreement, the home agency **SHALL** document that its home agency IdP record is available through the federation authority in question.

The federation authority **SHALL** make lists of all member IdPs and RPs available to other members within the scope of the federation agreement. IdPs within a federation authority **SHOULD** enable dynamic registration of new RPs, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C), subject to the rules of the federation authority, the desired federation assurance level, and the capabilities of the federation protocol in use.

The federation authority **SHALL** document the full set of attributes that can be provided by each IdP and allowed to be requested by RPs within the federation. The federation authority **SHALL** collect the attributes requested by RPs joining the federation and **SHALL** document the RP's justification and use for these attributes.

## Identity Proxies and Brokers {#proxy-trust}

An identity proxy (also known as an identity broker) takes federated authentications from one domain and asserts them outbound to another domain, as discussed in [[SP800-63C]](references.md#ref-SP-800-63C). All requirements for proxies enumerated therein apply to identity proxies in a PIV federation.

Federation proxies can be used in both bilateral and multilateral trust agreements. While a federation authority facilitates the establishment of a trust agreement, it is not involved in the federation transaction. In contrast, an identity proxy facilitates the transaction itself by acting as a broker between the upstream IdP and downstream RP. In some cases, the same entity may operate both an identity proxy and a federation authority for all connected parties due to the proxy's nature as a common connection point between IdPs and RPs. Bilateral agreements are also possible through a proxy, with each IdP and RP making a pairwise trust agreement to the proxy itself.

For each federated transaction with an RP, the proxy **SHALL** determine the appropriate upstream PIV IdP that is appropriate for each PIV identity account it proxies to a downstream RP.

In addition to its other requirements as part of a trust agreement, an identity proxy in a PIV federation context **SHALL** disclose to other parties in the trust agreement that it is acting as a proxy. In its role as an IdP in a trust agreement, the proxy **SHALL** disclose to the RP the proxy's list of upstream PIV IdPs that the proxy uses as accounts for that RP within the trust agreement.

Assertions created by a proxy **SHALL** include the identifier of the upstream IdP. This is separate from the required issuer field, which identifies the proxy itself. Since the proxy is the issuer of federated assertions to its downstream RPs, these downstream RPs **SHALL** view the proxy as the PIV IdP for accounts asserted through the proxy.

## Shared Signaling {#shared-signaling}

In addition to sharing account information for the purposes of federated login, additional signals can be shared between the IdP and RP for the specific uses described in [[SP800-63C]](references.md#ref-SP-800-63C).

The IdP **SHOULD** inform the RP of significant status changes in a PIV identity account that has been used at an RP, including:

- A suspected breach of the PIV identity account,
- The termination of the PIV identity account, or
- Changes to any part of the federated identifier.

When the RP receives such status changes, the RP **SHALL** update its RP subscriber account as specified by the trust agreement.

The IdP **MAY** additionally inform the RP of significant changes to the PIV identity account's information, including:

- A change in contact information attributes (email address, phone number),
- A change in primary authenticator status, or
- The addition or removal of secondary authenticator.

The RP **SHOULD** inform the IdP of significant status changes in the RP subscriber account, including:

- A suspected breach of the RP subscriber account or its data,
- Suspicious behavior of the RP subscriber account (e.g., repeated attempts to access unauthorized functions), or
- The addition or removal of RP-managed bound authenticators at FAL3.

When the IdP receives such a signal, the IdP **SHALL** update the account as specified by the trust agreement.

~~~
\clearpage
~~~
{:latex-literal="true"}

## Home Agency IdPs {#home-idp-reqs}

Only the home agency responsible for issuing PIV identity accounts **SHALL** declare the home agency IdP for those accounts. Operation of the home agency IdP **MAY** be outsourced to a third party, if the IdP meets the requirements in this section.

A home agency IdP **SHALL** have access to the PIV identity accounts that it represents through the home agency IdMS. Current access **SHALL** be available throughout the lifecycle of the PIV identity account while the home agency IdP is in operation. The access includes the following:

- All attributes available for federation,
- All PIV credentials bound to the account, and
- The current status of the PIV identity account (i.e., active/terminated).

The effect of these requirements is that the home agency IdP needs to be coupled to the home agency IdMS. This can be accomplished through a variety of technological means, such as direct attachment to the home agency IdMS or the use of a provisioning protocol to synchronize account state with the IdP system. In all cases, a home agency IdP is expected to have current, accurate, and authoritative information for all of the PIV identity accounts that it represents. Additionally, the IdP **SHALL** inform the home agency IdMS of any results of processing shared signals, as discussed in [Sec. 3.4](trust.md#shared-signaling).

When declaring a home agency IdP, the home agency **SHALL** publish its home agency IdP record in a publicly available location that is securely associated with the home agency, such as on an HTTPS URL on the agency's domain or in a trusted directory service. The publication of the home agency IdP record **SHALL** include all of the following:

- A canonical issuer identifier for the IdP (generally a URI in federation protocols),
- A list of agency identifiers and organizational affiliations covered by the IdP,
- A list of federation protocols supported by the IdP along with any profiles of those protocols,
- The location of a machine-readable discovery document for each federation protocol supported by the IdP, and
- Technical contact information for the IdP.

The format for this record and the means by which it is published are out of scope for this specification and subject to technical profiles and federation trust agreements.

### Home Agencies and Subscriber-Controlled Wallet {#home-idp-subscribers}

Subscriber-controlled wallets can be a trusted mechanism for PIV federation, even if they are not controlled by the home agency. The home agency can declare that subscriber-controlled wallets are sufficient to fulfill the role of a home agency IdP if the following are true:

- The home agency is able to validate the IdP software.
- The subscriber-controlled wallet can be deprovisioned by the home agency independent of IdP action.

To declare subscriber-controlled wallets as fulfilling a home agency IdP role, the home agency **SHALL** publish a record that indicates:

- A canonical identifier for the home agency onboarding subscriber-controlled wallets
- A list of public signing keys or the location of a machine-readable document that lists the public signing keys used to issue attribute bundles
- A list of agency identifiers and organizational affiliations covered by subscriber-controlled IdPs
- Technical contact information for the home agency

The keys listed in this record used for signing attribute bundles **SHALL NOT** be used for other purposes.
