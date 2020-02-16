# SSL/TLS Basics

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

- **[≡ SSL/TLS Basics](#ssltls-basics)**
  * [Introduction](#introduction)
  * [TLS versions](#tls-versions)
  * [TLS handshake](#tls-handshake)
    * [In which layer is TLS situated within the TCP/IP stack?](#in-which-layer-is-tls-situated-within-the-tcpip-stack)
  * [RSA and ECC keys/certificates](#rsa-and-ecc-keyscertificates)
  * [Cipher suites](#cipher-suites)
    * [Authenticated encryption (AEAD) cipher suites](#authenticated-encryption-aead-cipher-suites)
    * [Why cipher suites are important?](#why-cipher-suites-are-important)
    * [What does insecure, weak, secure and recommended mean?](#what-does-insecure-weak-secure-and-recommended-mean)
    * [NGINX and TLS 1.3 Cipher Suites](#nginx-and-tls-13-cipher-suites)
  * [Diffie-Hellman key exchange](#diffie-hellman-key-exchange)
    * [What exactly is the purpose of these DH Parameters?](#what-exactly-is-the-purpose-of-these-dh-parameters)
  * [Certificates](#certificates)
    * [Chain of Trust](#chain-of-trust)
    * [Single-domain](#single-domain)
    * [Multi-domain](#multi-domain)
    * [Wildcard](#wildcard)
    * [Wildcard SSL doesn't handle root domain?](#wildcard-ssl-doesnt-handle-root-domain)
    * [HTTPS with self-signed certificate vs HTTP](#https-with-self-signed-certificate-vs-http)
  * [TLS Server Name Indication](#tls-server-name-indication)
  * [Verify your SSL, TLS & Ciphers implementation](#verify-your-ssl-tls--ciphers-implementation)
  * [Useful video resources](#useful-video-resources)

#### Introduction

TLS stands for _Transport Layer Security_. It is a protocol that provides privacy and data integrity between two communicating applications. It’s the most widely deployed security protocol used today replacing _Secure Socket Layer_ (SSL), and is used for web browsers and other applications that require data to be securely exchanged over a network.

TLS ensures that a connection to a remote endpoint is the intended endpoint through encryption and endpoint identity verification. The versions of TLS, to date, are TLS 1.3, 1.2, 1.1, and 1.0.

I will not describe the SSL/TLS protocols meticulously so you have to look at this as an introduction. I will discuss only the most important things because we have some great documents which describe this protocol in a great deal of detail:

- [Bulletproof SSL and TLS](https://www.feistyduck.com/books/bulletproof-ssl-and-tls/)
- [Cryptology ePrint Archive](https://eprint.iacr.org/)
- [Practical Cryptography for Developers](https://cryptobook.nakov.com/)
- [SSL/TLS for dummies](https://www.wst.space/tag/https/)
- [Every byte of a TLS connection explained and reproduced - TLS 1.2](https://tls.ulfheim.net/)
- [Every byte of a TLS connection explained and reproduced - TLS 1.3](https://tls13.ulfheim.net/)
- [Transport Layer Security (TLS) - High Performance Browser Networking](https://hpbn.co/transport-layer-security-tls/)
- [The Sorry State Of SSL](https://hynek.me/talks/tls/)
- [How does SSL/TLS work?](https://security.stackexchange.com/questions/20803/how-does-ssl-tls-work)
- [What is TLS and how does it work?](https://www.comparitech.com/blog/information-security/tls-encryption/)
- [A study of the TLS ecosystem](https://pdfs.semanticscholar.org/12fb/86fcbf0564ab11552c516539c91c6c8ff4d6.pdf) <sup>[pdf]</sup>
- [Inspecting TLS/SSL](https://www.java2depth.com/2019/04/transport-layer-security-tls-and-secure.html)
- [TLS in HTTP/2](https://daniel.haxx.se/blog/2015/03/06/tls-in-http2/)
- [Keyless SSL: The Nitty Gritty Technical Details](https://blog.cloudflare.com/keyless-ssl-the-nitty-gritty-technical-details/)
- [Nuts and Bolts of Transport Layer Security (TLS)](https://medium.facilelogin.com/nuts-and-bolts-of-transport-layer-security-tls-2c5af298c4be)
- [SSL and TLS Deployment Best Practices](https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices)
- [TLS Security 1: What Is SSL/TLS (set of articles by Acunetix)](https://www.acunetix.com/blog/articles/tls-security-what-is-tls-ssl-part-1/)
- [How to deploy modern TLS in 2019?](https://blog.probely.com/how-to-deploy-modern-tls-in-2018-1b9a9cafc454?gi=7e9d841a4d9d)
- [SSL Labs Grading 2018](https://discussions.qualys.com/docs/DOC-6321-ssl-labs-grading-2018)
- [SSL/TLS Threat Model](https://blog.ivanristic.com/SSL_Threat_Model.png)

If you have any objections to your SSL configuration put your site into [SSL Labs](https://www.ssllabs.com/). It is one of the best (if not the best) tools to verify the SSL/TLS configuration of the HTTP server. I also recommend [ImmuniWeb SSL Security Test](https://www.immuniweb.com/ssl/) and [CryptCheck](https://tls.imirhil.fr/). Each of them will tell you if you need to fix or update your config.

For testing clients against (bad) SSL configs and to learn what real world TLS clients were capable of, I always use [sslClientInfo](https://suche.org/sslClientInfo), [How's My SSL](https://www.howsmyssl.com/), and [badssl.com](https://badssl.com/). For monitoring of SSL/TLS quality I recommend [SSL Pulse](https://www.ssllabs.com/ssl-pulse/). It's a continuously updated dashboard that is designed to show the state of the SSL ecosystem and supports over time across 150,000 SSL- and TLS-enabled websites, based on Alexa’s list of the most popular sites in the world.

Look also at the [useful video resources](#useful-video-resources) section of this chapter.

Finally, see [this](https://jve.linuxwall.info/blog/index.php?post/TLS_Survey) fantastic answer by [Julien Vehent](https://jve.linuxwall.info/blog/). It tell you why is the correct TLS configuration so important:

  > _What can we do about it? Education is key: TLS is a complex subject, and most administrators and website owners don't have the time and knowledge to dig through dozens of mailing lists and blog posts to find the best configuration choices._

  > _It is the primary motivation for documents such as Server Side TLS and Better Crypto. Some of us are working on improving these documents. But we need an army to broadcast the message, teach administrators in conferences, mailing lists and user groups, and push websites owners to apply more secure configuration to their websites._

  > _We could use some help: go out there and teach TLS!_

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

##### In which layer is TLS situated within the TCP/IP stack?

See this diagram:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/tls/tcp_tls_http.png" alt="tcp_tls_http">
</p>

The SSL protocol works between the `TCP/IP` protocols and higher-level protocols such as `HTTP`. Its design allows you to launch any website on the basis of public key cryptography, thus enabling secure data transmission on the network.

See also [What Happens in a TLS Handshake?](https://www.cloudflare.com/learning/ssl/what-happens-in-a-tls-handshake/).

#### RSA and ECC keys/certificates

An `RSA` key pair includes a private and a public key. It is a well-established method of public-key cryptography and is based on the use of two large prime numbers. The `RSA` private key is used to generate digital signatures, and the `RSA` public key is used to verify digital signatures. `RSA` requires much bigger key lengths to implement encryption (min. 2048-bit at this moment). This type of encryption is really great when we have two physically or geographically different end-points.

`ECC` is the latest encryption method. The main selling point of `ECC` is that this security level is achieved using very short system parameters (requires much shorter key lengths compared to `RSA`) and hence speeds. Elliptic curve based algorithms use significantly smaller key sizes than the non-elliptic curve equivalents. An `ECC` key pair also includes a private and public key. The `ECC` private key is used to generate digital signatures, and the `ECC` public key is used to verify digital signatures.

According to most recommendations the key lengths can be taken about twelve times shorter than their counterparts in `RSA` or in classical discrete logarithm based cryptography; concretely `Curve25519` works with keys consisting of about 256 bits, while an equivalent `RSA` instantiation would need key sizes of 3072 bits long.

By default `ECC` key pairs using the Elliptic Curve Digital Signature Algorithm (see [ECDSA: The digital signature algorithm of a better internet](https://blog.cloudflare.com/ecdsa-the-digital-signature-algorithm-of-a-better-internet/)). This algorithm uses elliptic curve cryptography (an encryption system based on the properties of elliptic curves) to provide a variant of the Digital Signature Algorithm (`DSA`) and is applied to `ECC` to make it appropriate for security encryption.

For more information please see this amazing presentation: [ECC vs RSA: Battle of the Crypto-Ninjas](https://www.slideshare.net/JamesMcGivern/ecc-vs-rsa-battle-of-the-cryptoninjas). See also [Diffie-Hellman, RSA, DSA, ECC and ECDSA – Asymmetric Key Algorithms](https://www.ssl2buy.com/wiki/diffie-hellman-rsa-dsa-ecc-and-ecdsa-asymmetric-key-algorithms).

Look at this key-length comparison:

```
+===+=================+========================+=================+
|   |    Symmetric    | RSA and Diffie-Hellman | Elliptic Curve  |
|   | Key Size (bits) |    Key Size (bits)     | Key Size (bits) |
+===+=================+========================+=================+
| 1 |       80        |          1024          |       160       |
+---+-----------------+------------------------+-----------------+
| 2 |      112        |         [2048]         |       224       |
+---+-----------------+------------------------+-----------------+
| 3 |      128        |          3072          |      [256]      |
+---+-----------------+------------------------+-----------------+
| 4 |      192        |          7680          |       384       |
+---+-----------------+------------------------+-----------------+
| 5 |      256        |         15360          |       521       |
+---+-----------------+------------------------+-----------------+
```

Finally, I recommend to read [this](https://crypto.stackexchange.com/questions/61248/aes-and-ecdh-key) answer by [Maarten Bodewes](https://crypto.stackexchange.com/users/1172/maarten-bodewes):

  > _RSA - an asymmetric algorithm - requires a larger key size because the number calculations are on large numbers. For RSA an attacker can try and refactor the modulus to try and find the private key components. It is therefore much easier to attack RSA than to try $2^X$ values for an $X$-bit key. In the table you can see that it will take about $2^{128}$ tests to break a 3072 bit key. So an AES key of 128 bit and a RSA key of 3072 bits both have a strength of 128 bits._

  > _Elliptic Curve cryptography allows for smaller key sizes than RSA to deliver the same strength asymmetric key pair. Generally the effective key size of the key pair needs to be double the size to achieve the same strength as a symmetric key. So we see the value 256 for ECC in that same row. The curve sizes listed are of the named curves first created by Certicom and later standardized by NIST as P-160, P-224, P-256, P-384 and P-521 (that's not a typo, it's not 512)._

#### Cipher suites

  > **:bookmark: [Use only strong ciphers - Hardening - P1](RULES.md#beginner-use-only-strong-ciphers)**<br>
  > **:bookmark: [Use more secure ECDH Curve - Hardening - P1](RULES.md#beginner-use-more-secure-ecdh-curve)**

To secure the transfer of data, TLS/SSL uses one or more cipher suites. A cipher suite is a combination of authentication, encryption, and message authentication code (MAC) algorithms. They are used during the negotiation of security settings for a TLS/SSL connection as well as for the transfer of data.

  > TLS 1.1 uses the same ciphers as TLS 1.0, therefore OpenSSL does not make a distinction between the two. When it supports a cipher suite for TLS 1.1, it also supports it for TLS 1.0, and vice versa. TLS 1.2 and TLS 1.3 have its own set of cipher suites. In TLS 1.3 they are configured in OpenSSL, are enabled by default, and selected automatically (not need to be set in the configuration).

In the SSL handshake, the client begins by informing the server what ciphers it supports. The cipher suites are usually arranged in order of security. The server then compares those cipher suites with the cipher suites that are enabled on its side. As soon as it finds a match, it then informs the client, and the chosen cipher suite's algorithms are called into play.

  > Note: The client suggests the Cipher Suite but the server chooses. The Cipher Suite decision is in the hands of the server. The server then negotiates and selects a specific cipher suite to use in the communication. If the server is not prepared to use any of the cipher suites advertised by the client, then it will not allow the session

Various cryptographic algorithms are used during establishing and later during the TLS connection. There are essentially 4 different parts of a TLS 1.2 cipher suite:

- **Key exchange** - what asymmetric crypto is used to exchange keys?<br>
  Examples: `RSA`, `DH`, `ECDH`, `DHE`, `ECDHE`
- **Authentication/Digital Signature Algorithm** - what crypto is used to verify the authenticity of the server?<br>
  Examples: `RSA`, `DSA`, `ECDSA`
- **Cipher/Bulk Encryption Algorithms** - what symmetric crypto is used to encrypt the data?<br>
  Examples: `AES`, `3DES`, `CHACHA20`, `Camellia`, `ARIA`
- **MAC** - what hash function is used to ensure message integrity?<br>
  Examples: `MD5`, `SHA-256`, `POLY1305`

These four types of algorithms are combined into so-called cipher suites/sets, for example, the `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256` uses ephemeral elliptic curve Diffie-Hellman (`ECDHE`) to exchange keys, providing forward secrecy. Because the parameters are ephemeral, they are discarded after use and the key that was exchanged cannot be recovered from the traffic stream without them. `RSA_WITH_AES_128_CBC_SHA256` - this means that an RSA key exchange is used in conjunction with `AES-128-CBC` (the symmetric cipher) and `SHA256` hashing is used for message authentication. `P256` is a type of elliptic curve (TLS cipher suites and elliptical curves are sometimes configure by using a single string like this).

  > To use `ECDSA` cipher suites, you need an `ECDSA` certificate and key. To use `RSA` cipher suites, you need an `RSA` certificate and key. `ECDSA `certificates are recommended over `RSA` certificates. I think, the minimum configuration is `ECDSA` (`P-256`), or `RSA` (2048 bits).

Look at the following explanation for `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`:

| <b>PROTOCOL</b> | <b>KEY EXCHANGE</b> | <b>AUTHENTICATION</b> | <b>ENCRYPTION</b> | <b>HASHING</b> |
| :---:        | :---:        | :---:        | :---:        | :---:        |
| `TLS` | `ECDHE` | `ECDSA` | `AES_128_GCM` | `SHA256` |

`TLS` is the protocol. Starting with `ECDHE` we can see that during the handshake the keys will be exchanged via ephemeral Elliptic Curve Diffie Hellman (`ECDHE`). `ECDSA` is the authentication algorithm. `AES_128_GCM` is the bulk encryption algorithm: `AES` running Galois Counter Mode with `128-bit` key size. Finally, `SHA-256` is the hashing algorithm.

The client and the server negotiate which cipher suite to use at the beginning of the TLS connection (the client sends the list of cipher suites that it supports, and the server picks one and lets the client know which one). The choice of elliptic curve for `ECDH` is not part of the cipher suite encoding. The curve is negotiated separately (here too, the client proposes and the server decides).

  > If you want to get a lot of useful information about available ciphers, see [TLS Cipher Suite Search](https://ciphersuite.info/) engine. For more, look also at [cipher suite definitions](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zos.v2r3.gska100/csdcwh.htm) for SSL and TLS protocols.

I recommend to read [Cipher Suites: Ciphers, Algorithms and Negotiating Security Settings](https://www.thesslstore.com/blog/cipher-suites-algorithms-security-settings/) and great answer about [Role of the chosen ciphersuite in an SSL/TLS connection](https://security.stackexchange.com/questions/160429/role-of-the-chosen-ciphersuite-in-an-ssl-tls-connection/160445#160445) (by [dave_thompson_085](https://security.stackexchange.com/users/39571/dave-thompson-085)).

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

##### Why cipher suites are important?

The security level of your HTTPS traffic (the safety of your data and the data of your users) depends on which cipher suites your web server uses. Having an extensive list of highly secure Cipher Suites is important for high security SSL/TLS interception. The compatibility of your HTTPS traffic (who will see errors, warnings or experience other issues) depends on the cipher suites your web server uses. The performance of your HTTPS traffic (how fast users see your pages) depends also on the cipher suites your web server uses.

##### What does insecure, weak, secure and recommended mean?

- **insecure** - these ciphers are very old and shouldn't be used under any circumstances. Their protection can be broken with minimal effort nowadays

- **weak** - these ciphers are old and should be disabled if you are setting up a new server for example. Make sure to only enable them if you have a special use case where support for older operating systems, browsers or applications is required

- **secure** - secure ciphers are considered state-of-the-art and if you want to secure your web server you should certainly choose from this set. Only very old operating systems, browsers or applications are unable to handle them

- **recommended** - all 'recommended' ciphers are 'secure' ciphers by definition. Recommended means that these ciphers also support PFS (Perfect Forward Secrecy) and should be your first choice if you want the highest level of security. However, you might run into some compatibility issues with older clients that do not support PFS ciphers

<sup><i>This explanation comes from [TLS Cipher Suite Search](https://ciphersuite.info/page/faq/).</i></sup>

##### NGINX and TLS 1.3 Cipher Suites

We currently don't have the ability to control TLS 1.3 cipher suites without support from the NGINX to use new API (that is why today, you cannot specify the TLSv1.3 cipher suites, applications still have to adapt). NGINX isn't able to influence that so at this moment all available ciphers are always on (also if you disable potentially weak cipher from NGINX). On the other hand, the ciphers in TLSv1.3 have been restricted to only a handful of completely secure ciphers by leading crypto experts.

If you want to use `TLS_AES_128_CCM_SHA256` and `TLS_AES_128_CCM_8_SHA256` ciphers (for example on constrained systems which are usually constrained for everything) see [TLSv1.3 and `CCM` ciphers](HELPERS.md#tlsv13-and-ccm-ciphers). But remember: `GCM` should be considered superior to `CCM` for most applications that require authenticated encryption.

#### Diffie-Hellman key exchange

  > **:bookmark: [Use strong Key Exchange with Perfect Forward Secrecy - Hardening - P1](RULES.md#beginner-use-strong-key-exchange-with-perfect-forward-secrecy)**

The goal in Diffie-Hellman key exchange (DHKE) is for two users to obtain a shared secret key, without any other users knowing that key. The exchange is performed over a public network, i.e. all messages sent between the two users can be intercepted and read by any other user.

The protocol makes use of modular arithmetic and especially exponentials. The security of the protocol relies on the fact that solving a discrete logarithm (the inverse of an exponential) is practically impossible when large enough values are used.

`DHE` (according to [RFC 5246 - The Cipher Suite](https://tools.ietf.org/html/rfc5246#appendix-A.5) <sup>[IETF]</sup>) and `EDH` are the same (`EDH` in OpenSSL-speak, `DHE` elsewhere). `EDH` isn't a standard way to state it, but it doesn't have another usual meaning. `ECC` can stand for "Elliptic Curve Certificates" or "Elliptic Curve Cryptography". Elliptic curve certificates are commonly called `ECDSA`. Elliptic curve key exchange is called `ECDH`. If you add another 'E' to the latter (`ECDHE`), you get ephemeral.

| <b>TYPE</b> | <b>ELLIPTIC CURVE</b> | <b>EPHERMAL</b> | <b>KEY ROTATION</b> | <b>PFS</b> | <b>DHPARAM FILE</b> |
| :---:        | :---:        | :---:        | :---:        | :---:        | :---:        |
| `DHE` | no | yes | yes | yes | yes |
| `ECDH` | yes | no | no | no | no |
| `ECDHE` | yes | yes | yes | yes | no |

Using `DHE` means even the `g` and `p` parameters may be randomly generated, but as this is a very expensive process (because you need to find a safe prime), computationally seen, you usually don't do this.

However, when you're doing a DH (without the "E") key exchange, the server has a certificate, which embeds a static, public Diffie-Hellman key, i.e. `gxmodp` as well as `g` and `p` allowing you to save an additional signature (e.g. using `RSA` or `ECDSA`) to verify the authenticity of the DH parameter. So, while the server's DH value is static, the client still usually chooses a random value for security and storage-reduction reasons. Obviously fixing the parameters in the certificate implies they can't be changed at run-time.

Ephermal Diffie-Hellman (`ECDHE/DHE`) generates a new key for every exchange (on-the-fly), which enables Perfect Forward Secrecy (PFS). Next, it signs the public key with its `RSA` or `DSA` or `ECDSA` private key, and sends that to the client. The DH key is ephemeral, meaning that the server never stores it on its disk; it keeps it in RAM during the session, and discarded after use. Being never stored, it cannot be stolen afterwards, and that's what PFS comes from.

Forward Secrecy is the prime feature of the ephemeral version of Diffie-Hellman which means if the private key of the server gets leaked, his past communications are secure. Ephemeral Diffie-Hellman doesn't provide authentication on its own, because the key is different every time. So neither party can be sure that the key is from the intended party.

The `ECDHE` is a variant of the Diffie-Hellman protocol which uses elliptic curve cryptography to lower computational, storage and memory requirements. The perfect forward secrecy offered by `DHE` comes at a price: more computation. The `ECDHE` variants uses elliptic curve cryptography to reduce this computational cost.

Fixed Diffie-Hellman (`ECDH` and `DH`) on the other hand uses the same Diffie-Hellman key every time. Without any DH exchange, you can only use `RSA` in encryption mode.

These parameters aren't secret and can be reused; plus they take several seconds to generate. The `openssl dhparam ...` step generates the DH params (mostly just a single large prime number) ahead of time, which you then store for the server to use.

##### What exactly is the purpose of these DH Parameters?

I will quote some [great answers](https://security.stackexchange.com/questions/94390/whats-the-purpose-of-dh-parameters):

  > _These parameters define how OpenSSL performs the Diffie-Hellman (DH) key-exchange. As you stated correctly they include a field prime p and a generator g. The purpose of the availability to customize these parameter is to allow everyone to use his/her own parameters for this. This can be used to prevent being affected from the Logjam attack (which doesn't really apply to 4096 bit field primes)._

  > _The parameters `p` and `g` define the security of this key-exchange. A larger `p` will make finding the shared secret `K` a lot harder, defending against passive attackers._

  > _Finding such primes is really computational intense and can't be afforded on each connection, so they're pre-computed._

  > _It's no risk publishing them. In fact they're sent out for every key-exchange that involves some Diffie-Hellman (DH) key exchange. There are even a few such parameters standardized for example in [RFC 5114 - Additional Diffie-Hellman Groups for Use with IETF Standards](https://tools.ietf.org/html/rfc5114) <sup>[IETF]</sup>._

#### Certificates

A SSL certificate contains the public key and information about its owner, authenticates the identity of a website and allows secure connections from a web server to a browser by encrypting information and protect the sensitive data (login details, signups, addresses and payment) transmitted from and to your website.

The authenticity and integrity of the certificate can be checked by cryptographic methods. The digital certificate contains the data required to verify it.

  > Without an SSL certificate, any data collected through your website is vulnerable to be intercepted by third party.

Certificates lets you secure your main domain and all its subdomains (like `example.com` and `api.example.com`) with one single SSL certificate.

See also [What is an SSL Certificate?](https://www.cloudflare.com/learning/ssl/what-is-an-ssl-certificate/) and [EV Certificates Make The Web Slow and Unreliable](https://www.aaronpeters.nl/blog/ev-certificates-make-the-web-slow-and-unreliable/).

##### Chain of Trust

  > **:bookmark: [Set the certificate chain correctly - Others - P2](RULES.md#set-the-certificate-chain-correctly)**

Validation of the certificate chain is a critical part within any certificate-based authentication process. If a system does not follow the chain of trust of a certificate to a root server, the certificate loses all usefulness as a metric of trust.

A certificate chain consists of all the certificates needed to certify the subject identified by the end certificate. In practice this includes the end certificate, the certificates of intermediate CAs, and the certificate of a root CA trusted by all parties in the chain. Every intermediate CA in the chain holds a certificate issued by the CA one level above it in the trust hierarchy.

If certificate is signed directly by the trusted root CA, there is no need to add any extra/intermediate to the certificate chain. The root CA issues a certificate for itself.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/tls/chain_of_trust.png" alt="chain_of_trust">
</p>

<sup><i>This infographic comes from [Wikipedia](https://en.wikipedia.org/wiki/Chain_of_trust).</i></sup>

With the chain broken, there is no verification that the server that's hosting the data is the correct (expected) server - there is no way to be sure the server is what the server says it is (you lose the ability to validate the security of the connection or to trust it).

The connections is still secure but the main concern would be to fix that certificate chain. You should solve the incomplete certificate chain issue manually by concatenating all certificates from the certificate to the trusted root certificate (exclusive, in this order), to prevent such issues. However, traffic will be still encrypted.

There are several ways in which the chain of trust might be broken, including but not limited to:

- any certificate in the chain is self-signed, unless it the root
- not every intermediate certificate is checked, starting from the original certificate all the way up to the root certificate
- an intermediate, CA-signed certificate does not have the expected basic constraints or other important extensions
- the root certificate has been compromised or authorized to the wrong party

Take a look at [this](https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices#21-use-complete-certificate-chains) great explanation:

  > _In most deployments, the server certificate alone is insufficient; two or more certificates are needed to build a complete chain of trust. A common configuration problem occurs when deploying a server with a valid certificate, but without all the necessary intermediate certificates. To avoid this situation, simply use all the certificates provided to you by your CA in the same sequence._
  >
  > _An invalid certificate chain effectively renders the server certificate invalid and results in browser warnings. In practice, this problem is sometimes difficult to diagnose because some browsers can reconstruct incomplete chains and some can’t. All browsers tend to cache and reuse intermediate certificates._

To test validation of your certificate chain use one of the following tools:

- [SSL Checker by sslshopper](https://www.sslshopper.com/ssl-checker.html)
- [SSL Checker by namecheap](https://decoder.link/sslchecker/)
- [SSL Server Test by Qualys](https://www.ssllabs.com/ssltest/analyze.html)

For more information please see [What is the SSL Certificate Chain?](https://support.dnsimple.com/articles/what-is-ssl-certificate-chain/) and [Get your certificate chain right](https://medium.com/@superseb/get-your-certificate-chain-right-4b117a9c0fce). Look also at [What happens to code sign certificates when when root CA expires?](https://serverfault.com/questions/878919/what-happens-to-code-sign-certificates-when-when-root-ca-expires).

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

The canonical answer should be in [RFC 2818 - Server Identity](https://tools.ietf.org/html/rfc2818#section-3.1) <sup>[IETF]</sup>:

  > _Matching is performed using the matching rules specified by
    RFC 2459. If more than one identity of a given type is present in
    the certificate (e.g., more than one dNSName name, a match in any one
    of the set is considered acceptable.) Names may contain the wildcard
    character `*` which is considered to match any single domain name
    component or component fragment. E.g., `*.a.com` matches `foo.a.com` but
    not `bar.foo.a.com`. `f*.com` matches `foo.com` but not `bar.com`._

[RFC 2459 - Server Identity Check](https://tools.ietf.org/html/rfc2595#section-2.4) <sup>[IETF]</sup> says:

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

##### HTTPS with self-signed certificate vs HTTP

| <b>FEATURE</b> | <b>HTTP</b> | <b>HTTPS WITH SELF-SIGNED CERTIFICATE</b> |
| :---         | :---         | :---         |
| encryption | no | **yes** |
| authorization | no | no |
| privacy | no | no (or **yes** if you trust the issuer of that certificate implicitly) |
| performance | **fast** | **faster than HTTP** |

Look at [this](https://stackoverflow.com/a/20578199) great explanation by [Kevin Cox](https://stackoverflow.com/users/1166181/kevin-cox):

  > _Self signed certificates are not strictly worse than certificates signed by a reputable CA, and in all technical ways they are better than plain HTTP. From the signing and encryption perspective they are identical. Both can sign and encrypt traffic so that it is not feasible for others to snoop or make modifications._

  > _The difference is the way that the certificate is designated as trusted. With a CA signed certificate the user is trusting the set of trusted CAs that they have installed in their browser/OS. If they see a certificate signed by one of these they accept it and everything is fine. If it isn't (such as when self-signed) you get a big scary warning._

  > _The reason this warning is displayed for self-signed certificates is that the browser has no idea who controls the certificate. The CAs that the browser trusts are known for verifying that they only sign the certificates of the web site owner. Therefore the browser, through extension trusts that the certificate's corresponding private key is controlled by the web site operator (and hopefully it is). With a self-signed certificate the browser has no way of knowing if the certificate was generated by the web site owner, or some man in the middle that wants to read your traffic. To be on the safe side, the browser rejects the certificate unless it is proven valid...and you get a big red warning._

  > _If you don't verify the certificate you are gaining nothing over unencrypted HTTP as anyone between you and the server could just generate their own certificate and you would be none the wiser. This could be considered worse than plain HTTP as us humans with our feeble emotions might be mislead into thinking that our connection is secure, but the only technical downside over HTTP is some wasted CPU cycles._

- **Security**

For me, a self-signed certificates are good to go for testing purposes and for internal services, on condition that you can trust the issuer of the certificate (but you are still implicitly authorizing the issuer by verifying manually certificate authority server is secure; no way of knowing who signed the certificate or if it should be trusted). Otherwise, they create the illusion of security (only provide encryption and an HTTPS connection), nothing more, so in principle, self-signed certificates should always raise doubts and be used only under controlled environments.

- **Performance**

So the important thing to keep in mind is performance. In my opinion, HTTP is slower than HTTPS with HTTP/2 (e.g one TCP connection, multiplexing, HPACK headers compression), HSTS, OCSP Stapling and several other improvements, except the initial TLS handshake which requires two extra roundtrips (but I think TLS performance impact is not as important as it used to be). See also [HTTP vs HTTPS Test](http://www.httpvshttps.com/).

#### TLS Server Name Indication

SNI is an extension of the SSL/TLS protocol that allows the client (for example, the browser) to provide the exact host name trying to connect at the beginning of the TLS handshaking process (it indicates which hostname is being contacted by the browser at the beginning of the handshake process). On the HTTP server side, it allows for multiple connection use the same IP address and port number, without having to use multiple IP addresses.

See the following diagram with example of communication with SNI extension:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/tls/with_sni.png" alt="with_sni">
</p>

<sup><i>This infographic comes from [Supporting virtual servers with Server Name Indication](https://nnc3.com/mags/LM10/Magazine/Archive/2008/92/072-074_SNI/article.html).</i></sup>

From NGINX documentation:

  > _This is caused by SSL protocol behaviour. The SSL connection is established before the browser sends an HTTP request and nginx does not know the name of the requested server. Therefore, it may only offer the default server’s certificate._

Take a look at this:

  > _A more generic solution for running several HTTPS servers on a single IP address is TLS Server Name Indication extension (SNI, [RFC 6066](https://tools.ietf.org/html/rfc6066) <sup>[IETF]</sup>), which allows a browser to pass a requested server name during the SSL handshake and, therefore, the server will know which certificate it should use for the connection._

For more information please see [What Is SNI? How TLS Server Name Indication Works](https://www.cloudflare.com/learning/ssl/what-is-sni/) and [Supporting virtual servers with Server Name Indication](https://nnc3.com/mags/LM10/Magazine/Archive/2008/92/072-074_SNI/article.html).

#### Verify your SSL, TLS & Ciphers implementation

| <b>TOOL</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| **[SSL Labs by Qualys](https://www.ssllabs.com/ssltest/)** | Check all latest vulnerability & misconfiguration |
| **[ImmuniWeb SSL Security Test](https://www.immuniweb.com/ssl/)** | Verify configuration with PCI DSS, HIPAA & NIST |

#### Useful video resources

- [Transport Layer Security, TLS 1.2 and 1.3 (Explained by Example)](https://youtu.be/AlE5X1NlHgg)
- [35C3 - The Rocky Road to TLS 1.3 and better Internet Encryption](https://youtu.be/i6mGfZrypP4)
- [SSL/TLS in action with Wireshark](https://youtu.be/u4ht-E-Kihk)
- [SF18US - 35: Examining SSL encryption/decryption using Wireshark (Ross Bagurdes)](https://youtu.be/0X2BVwNX4ks)
- [Breaking Down the TLS Handshake](https://youtu.be/cuR05y_2Gxc)
- [SSL/TLS handshake Protocol](https://youtu.be/sEkw8ZcxtFk)
- [What is a TLS Cipher Suite?](https://youtu.be/ZM3tXhPV8v0)
- [Strong vs. Weak TLS Ciphers](https://youtu.be/k_C2HcJbgMc)
- [Perfect Forward Secrecy](https://youtu.be/IkM3R-KDu44)
- [How SSL certificate works?](https://youtu.be/33VYnE7Bzpk)
- [Intro to Digital Certificates](https://youtu.be/qXLD2UHq2vk)
- [Digital Certificates: Chain of Trust](https://youtu.be/heacxYUnFHA)
- [Elliptic Curves - Computerphile](https://youtu.be/NF1pwjL9-DE)
- [Elliptic Curve Cryptography Overview](https://youtu.be/dCvB-mhkT0w)
- [Secret Key Exchange (Diffie-Hellman) - Computerphile](https://youtu.be/NmM9HA2MQGI)
