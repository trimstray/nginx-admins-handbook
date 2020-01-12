# SSL/TLS Basics

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

- **[≡ SSL/TLS Basics](#ssltls-basics)**
  * [TLS versions](#tls-versions)
  * [TLS handshake](#tls-handshake)
  * [Cipher suites](#cipher-suites)
    * [Authenticated encryption (AEAD) cipher suites](#authenticated-encryption-aead-cipher-suites)
  * [Diffie-Hellman key exchange](#diffie-hellman-key-exchange)
  * [Certificates](#certificates)
    * [Single-domain](#single-domain)
    * [Multi-domain](#multi-domain)
    * [Wildcard](#wildcard)
    * [Wildcard SSL doesn't handle root domain?](#wildcard-ssl-doesnt-handle-root-domain)
  * [Verify your SSL, TLS & Ciphers implementation](#verify-your-ssl-tls--ciphers-implementation)

TLS stands for _Transport Layer Security_. It is a protocol that provides privacy and data integrity between two communicating applications. It’s the most widely deployed security protocol used today replacing _Secure Socket Layer_ (SSL), and is used for web browsers and other applications that require data to be securely exchanged over a network.

TLS ensures that a connection to a remote endpoint is the intended endpoint through encryption and endpoint identity verification. The versions of TLS, to date, are TLS 1.3, 1.2, 1.1, and 1.0.

I will not describe the SSL/TLS protocols meticulously so you have to look at this as an introduction. I will discuss only the most important things because we have some great documents which describe this protocol in a great deal of detail:

- [Bulletproof SSL and TLS](https://www.feistyduck.com/books/bulletproof-ssl-and-tls/)
- [Cryptology ePrint Archive](https://eprint.iacr.org/)
- [Every byte of a TLS connection explained and reproduced - TLS 1.2](https://tls.ulfheim.net/)
- [Every byte of a TLS connection explained and reproduced - TLS 1.3](https://tls13.ulfheim.net/)
- [SSL/TLS for dummies](https://www.wst.space/tag/https/)
- [Transport Layer Security (TLS) - High Performance Browser Networking](https://hpbn.co/transport-layer-security-tls/)
- [The Sorry State Of SSL](https://hynek.me/talks/tls/)
- [Keyless SSL: The Nitty Gritty Technical Details](https://blog.cloudflare.com/keyless-ssl-the-nitty-gritty-technical-details/)
- [How to deploy modern TLS in 2019?](https://blog.probely.com/how-to-deploy-modern-tls-in-2018-1b9a9cafc454?gi=7e9d841a4d9d)
- [SSL Labs Grading 2018](https://discussions.qualys.com/docs/DOC-6321-ssl-labs-grading-2018)

If you have any objections to your SSL configuration put your site into [SSL Labs](https://www.ssllabs.com/). It is one of the best (if not the best) tools to verify the SSL/TLS configuration of the HTTP server. I also recommend [ImmuniWeb SSL Security Test](https://www.immuniweb.com/ssl/). Both will tell you if you need to fix or update your config. For testing clients against bad SSL configs I always use [badssl.com](https://badssl.com/).

#### TLS versions

  > **:bookmark: [Keep only TLS 1.3 and TLS 1.2 - Hardening - P1](RULES.md#beginner-keep-only-tls-13-and-tls-12)**

| <b>PROTOCOL</b> | <b>RFC</b> | <b>PUBLISHED</b> | <b>STATUS</b> |
| :---:        | :---:        | :---:        | :---         |
| SSL 1.0 | | Unpublished | Unpublished |
| SSL 2.0 | | 1995 | Depracated in 2011 ([RFC 6176](https://tools.ietf.org/html/rfc6176)) <sup>[IETF]</sup> |
| SSL 3.0 | | 1996 | Depracated in 2015 ([RFC 7568](https://tools.ietf.org/html/rfc7568)) <sup>[IETF]</sup> |
| TLS 1.0 | [RFC 2246](https://tools.ietf.org/html/rfc2246) <sup>[IETF]</sup> | 1999 | Deprecation in 2020 |
| TLS 1.1 | [RFC 4346](https://tools.ietf.org/html/rfc4346) <sup>[IETF]</sup> | 2006 | Deprecation in 2020 |
| TLS 1.2 | [RFC 5246](https://tools.ietf.org/html/rfc5246) <sup>[IETF]</sup> | 2008 | Still secure |
| TLS 1.3 | [RFC 8446](https://tools.ietf.org/html/rfc8446) <sup>[IETF]</sup> | 2018 | Still secure |

Useful resources:

- [OpenSSL 1.1.1 (command) and SNI](https://github.com/drwetter/testssl.sh/issues/772)

#### TLS handshake

The differences between TLS 1.2 and TLS 1.3 are presented in the following illustrations (every byte explained and reproduced - marvelous work!):

- [The New Illustrated TLS Connection TLS 1.2](https://tls.ulfheim.net/)
- [The New Illustrated TLS Connection TLS 1.3](https://tls13.ulfheim.net/)

The full TLS 1.2 handshake looks like this:

<p align="center">
  <a href="https://ldapwiki.com/wiki/How%20SSL-TLS%20Works">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/tls/tls-handshake.png" alt="tls-handshake">
  </a>
</p>

<sup><i>This infographic comes from [ldapwiki - How SSL-TLS Works](https://ldapwiki.com/wiki/How%20SSL-TLS%20Works).</i></sup>

For TLS 1.3 is different:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/tls/tls-1.3-handshake.png" alt="tls-1.3-handshake">
</p>

By the way, the [How SSL-TLS Works](https://ldapwiki.com/wiki/How%20SSL-TLS%20Works) from ldapwiki is an amazing explanation.

#### Cipher suites

  > **:bookmark: [Use only strong ciphers - Hardening - P1](RULES.md#beginner-use-only-strong-ciphers)**<br>
  > **:bookmark: [Use more secure ECDH Curve - Hardening - P1](RULES.md#beginner-use-more-secure-ecdh-curve)**

To secure the transfer of data, TLS/SSL uses one or more cipher suites. A cipher suite is a combination of authentication, encryption, and message authentication code (MAC) algorithms. They are used during the negotiation of security settings for a TLS/SSL connection as well as for the transfer of data.

Various cryptographic algorithms are used during establishing and later during the TLS connection. There are essentially 4 different parts of a TLS 1.2 cipher suite:

- **Key exchange** - what asymmetric crypto is used to exchange keys?<br>
  Examples: `RSA`, `DH`, `ECDH`, `DHE`, `ECDHE`, `PSK`
- **Authentication/Digital Signature Algorithm** - what crypto is used to verify the authenticity of the server?<br>
  Examples: `RSA`, `ECDSA`, `DSA`
- **Cipher/Bulk Encryption Algorithms** - what symmetric crypto is used to encrypt the data?<br>
  Examples: `AES`, `CHACHA20`, `Camellia`, `ARIA`
- **MAC** - what hash function is used to ensure message integrity?<br>
  Examples: `SHA-256`, `POLY1305`

These four types of algorithms are combined into so-called cipher sets, for example, the `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256` uses ephemeral elliptic curve Diffie-Hellman (`ECDHE`) to exchange keys, providing forward secrecy. Because the parameters are ephemeral, they are discarded after use and the key that was exchanged cannot be recovered from the traffic stream without them. `RSA_WITH_AES_128_CBC_SHA256` - this means that an RSA key exchange is used in conjunction with `AES-128-CBC` (the symmetric cipher) and `SHA256` hashing is used for message authentication. `P256` is an type of elliptic curve.

  > To use `ECDSA` cipher suites, you need an `ECDSA` certificate. To use `RSA` cipher suites, you need an `RSA` certificate. `ECDSA `certificates are recommended over `RSA` certificates. I think, the minimum configuration is `ECDSA` (`P-256`) (recommended), or `RSA` (2048 bits).

Look at the following explanation for `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`:

| <b>PROTOCOL</b> | <b>KEY EXCHANGE</b> | <b>AUTHENTICATION</b> | <b>CIPHER</b> | <b>HASHING</b> |
| :---:        | :---:        | :---:        | :---:        | :---:        |
| `TLS` | `ECDHE` | `ECDSA` | `AES_128_GCM` | `SHA256` |

`TLS` is the protocol. Starting with `ECDHE` we can see that during the handshake the keys will be exchanged via ephemeral Elliptic Curve Diffie Hellman (`ECDHE`). `ECDSA` is the authentication algorithm. `AES_128_GCM` is the bulk encryption algorithm: `AES` running Galois Counter Mode with `128-bit` key size. Finally, `SHA-256` is the hashing algorithm.

The client and the server negotiate which cipher suite to use at the beginning of the TLS connection (the client sends the list of cipher suites that it supports, and the server picks one and lets the client know which one). The choice of elliptic curve for `ECDH` is not part of the cipher suite encoding. The curve is negotiated separately (here too, the client proposes and the server decides).

Look also at [cipher suite definitions](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zos.v2r3.gska100/csdcwh.htm) for SSL and TLS versions.

##### Authenticated encryption (AEAD) cipher suites

AEAD algorithms generally come with a security proof. These security proofs are of course dependent on the underlying primitives, but it gives more confidence in the full scheme none-the-less. The AEAD ciphers - regardless of the internal structure - should be immune to the problems caused by authenticate-then-encrypt.

Advantages of AEAD ciphers:

- trust only one algorithm, not two
- perform only one pass (an ideal in the world of AEAD, not a consequence of it)
- save on code and sometimes on computation as well

Any with `GCM`, `CCM`, or `POLY1305` are AEAD cipher suites, for example:

```
TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
TLS_ECDHE_ECDSA_WITH_AES_128_CCM
TLS_ECDHE_ECDSA_WITH_AES_256_CCM
TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8
TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8
TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_GCM_SHA256
TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_GCM_SHA384
TLS_ECDHE_ECDSA_WITH_ARIA_128_GCM_SHA256
TLS_ECDHE_ECDSA_WITH_ARIA_256_GCM_SHA384
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
TLS_ECDHE_RSA_WITH_CAMELLIA_128_GCM_SHA256
TLS_ECDHE_RSA_WITH_CAMELLIA_256_GCM_SHA384
TLS_ECDHE_RSA_WITH_ARIA_128_GCM_SHA256
TLS_ECDHE_RSA_WITH_ARIA_256_GCM_SHA384
TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256
TLS_DHE_RSA_WITH_AES_128_CCM
TLS_DHE_RSA_WITH_AES_256_CCM
TLS_DHE_RSA_WITH_AES_128_CCM_8
TLS_DHE_RSA_WITH_AES_256_CCM_8
TLS_DHE_RSA_WITH_CAMELLIA_128_GCM_SHA256
TLS_DHE_RSA_WITH_CAMELLIA_256_GCM_SHA384
TLS_DHE_RSA_WITH_ARIA_128_GCM_SHA256
TLS_DHE_RSA_WITH_ARIA_256_GCM_SHA384
```

These are the current AEAD ciphers which don't trigger the [ROBOT](https://robotattack.org/) warning.

#### Diffie-Hellman key exchange

  > **:bookmark: [Use strong Key Exchange with Perfect Forward Secrecy - Hardening - P1](RULES.md#beginner-use-strong-key-exchange-with-perfect-forward-secrecy)**

The goal in Diffie-Hellman key exchange (DHKE) is for two users to obtain a shared secret key, without any other users knowing that key. The exchange is performed over a public network, i.e. all messages sent between the two users can be intercepted and read by any other user.

The protocol makes use of modular arithmetic and especially exponentials. The security of the protocol relies on the fact that solving a discrete logarithm (the inverse of an exponential) is practically impossible when large enough values are used.

`DHE` (according to [RFC 5246](https://tools.ietf.org/html/rfc5246#appendix-A.5) <sup>[IETF]</sup>) and `EDH` are the same (`EDH` in OpenSSL-speak, `DHE` elsewhere). `EDH` isn't a standard way to state it, but it doesn't have another usual meaning. `ECC` can stand for "Elliptic Curve Certificates" or "Elliptic Curve Cryptography". Elliptic curve certificates are commonly called `ECDSA`. Elliptic curve key exchange is called `ECDH`. If you add another 'E' to the latter (`ECDHE`), you get ephemeral.

| <b>TYPE</b> | <b>ELLIPTIC CURVE</b> | <b>EPHERMAL</b> | <b>KEY ROTATION</b> | <b>PFS</b> | <b>DHPARAM FILE</b> |
| :---:        | :---:        | :---:        | :---:        | :---:        | :---:        |
| `DHE` | no | yes | yes | yes | yes |
| `ECDH` | yes | no | no | no | no |
| `ECDHE` | yes | yes | yes | yes | no |

Using `DHE` means even the `g` and `p` parameters may be randomly generated, but as this is a very expensive process (because you need to find a safe prime), computationally seen, you usually don't do this.

However, when you're doing a DH (without the "E") key exchange, the server has a certificate, which embeds a static, public Diffie-Hellman key, i.e. `gxmodp` as well as `g` and `p` allowing you to save an additional signature (e.g. using `RSA` or `ECDSA`) to verify the authenticity of the DH parameter. So while the server's DH value is static, the client still usually chooses a random value for security and storage-reduction reasons. Obviously fixing the parameters in the certificate implies they can't be changed at run-time.

Ephermal Diffie-Hellman (`ECDHE/DHE`) generates a new key for every exchange (on-the-fly), which enables Perfect Forward Secrecy (PFS). Next, it signs the public key with its `RSA` or `DSA` or `ECDSA` private key, and sends that to the client. The DH key is ephemeral, meaning that the server never stores it on its disk; it keeps it in RAM during the session, and discarded after use. Being never stored, it cannot be stolen afterwards, and that's what PFS comes from.

Forward Secrecy is the prime feature of the ephemeral version of Diffie-Hellman which means if the private key of the server gets leaked, his past communications are secure. Ephemeral Diffie-Hellman doesn't provide authentication on its own, because the key is different every time. So neither party can be sure that the key is from the intended party.

The `ECDHE` is a variant of the Diffie-Hellman protocol which uses elliptic curve cryptography to lower computational, storage and memory requirements. The perfect forward secrecy offered by `DHE` comes at a price: more computation. The `ECDHE` variants uses elliptic curve cryptography to reduce this computational cost.

Fixed Diffie-Hellman (`ECDH` and `DH`) on the other hand uses the same Diffie-Hellman key every time. Without any DH exchange, you can only use `RSA` in encryption mode.

These parameters aren't secret and can be reused; plus they take several seconds to generate. The `openssl dhparam ...` step generates the DH params (mostly just a single large prime number) ahead of time, which you then store for the server to use.

#### Certificates

##### Single-domain

When a certificate only has one SAN field and it contains a reference to a single subdomain/hostname, then it’s a single-domain certificate (it cannot secure any other domains).

##### Multi-domain

The multi-domain certificate is also commonly referred to as a SAN certificate (using the SAN feature of an SSL certificate) and that can be used on more than one domain.

When a user tries to access a website protected by a multi-domain/SAN certificate, the browser will check the certificate to see if the URL matches one of the SAN names contained within. If it does, a secure connection to the server will be established.

Multi-domain certificate sometimes have 100 or more SAN fields, and some or all of these fields may contain wildcards, creating a hybrid "multi-domain wildcard" certificate.

##### Wildcard

Wildcard certificates are used when you want to secure an unlimited number of subdomains on a single certificate.

In this brief the author explain [Why you probably shouldn't use a wildcard certificate](https://gist.github.com/joepie91/7e5cad8c0726fd6a5e90360a754fc568), as it will put your security at risk.

##### Wildcard SSL doesn't handle root domain?

No, it is not possible. By default, the wildcard cert is valid only for `*.example.com`, not `example.com`. A wildcard inside a name only reflects a single label and the wildcard can only be leftmost. Thus `*.*.example.org` or `www.*.example.org` are not possible. And `*.example.org` will neither match `example.org` nor `www.subdomain.example.org`, only `sub.example.org.`

  > In order to secure the domain name itself and hosts within the domain, you need to get certificate with names in SAN extension.

Technically, wildcard certs are issued based on the unknown children of a subdomain. Most wildcard certs are issued for 3-part domains (`*.domain.com`), but it's also very common to see them for 4-part domains (e.g. `*.domain.co.uk`).

The canonical answer should be in [RFC2818 (3.1. Server Identity)](https://tools.ietf.org/html/rfc2818#section-3.1) <sup>[IETF]</sup>:

  > _Matching is performed using the matching rules specified by
    RFC2459. If more than one identity of a given type is present in
    the certificate (e.g., more than one dNSName name, a match in any one
    of the set is considered acceptable.) Names may contain the wildcard
    character `*` which is considered to match any single domain name
    component or component fragment. E.g., `*.a.com` matches `foo.a.com` but
    not `bar.foo.a.com`. `f*.com` matches `foo.com` but not `bar.com`._

[RFC2459 (2.4. Server Identity Check)](https://tools.ietf.org/html/rfc2595#section-2.4) <sup>[IETF]</sup> says:

  > _A "`*`" wildcard character MAY be used as **the left-most name
    component** in the certificate.  For example, `*.example.com` would
    match `a.example.com`, `foo.example.com`, etc. but **would not match**
    `example.com`._

Essentially, the standards say that the `*` should match 1 or more non-dot characters. So the root domain needs to be an alternate name for it to validate.

For a `*.example.com` cert:

- `a.example.com` should pass
- `www.example.com` should pass
- `example.com` shouldn't pass
- `a.b.example.com` shouldn't pass

Sometimes, some SSL providers will automatically add the root domain as a Subject Alternative Name to a wildcard SSL certificate, e.g.:

```bash
issuer: RapidSSL RSA CA 2018 (DigiCert Inc)
cn: example.com
san: *.example.com example.com
```

Another interesting thing is that you can have multiple wildcard names inside the same certificate, that is you can have `*.example.org` and `*.subdomain.example.org` inside the same certificate. You should have little trouble finding a Certificate Authority that will issue such a certificate, and most clients should accept it.

#### Verify your SSL, TLS & Ciphers implementation

| <b>TOOL</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| **[SSL Labs by Qualys](https://www.ssllabs.com/ssltest/)** | Check all latest vulnerability & misconfiguration |
| **[ImmuniWeb SSL Security Test](https://www.immuniweb.com/ssl/)** | Verify configuration with PCI DSS, HIPAA & NIST |
