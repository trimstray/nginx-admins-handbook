<div align="center">
  <h1><code>Nginx Quick Reference</code></h1>
</div>

<br>

<p align="center">
  <a href="https://github.com/trimstray/nginx-quick-reference/tree/master">
    <img src="https://img.shields.io/badge/Branch-master-green.svg?longCache=true"
        alt="Branch">
  </a>
  <a href="https://github.com/trimstray/nginx-quick-reference/pulls">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?longCache=true"
        alt="Pull Requests">
  </a>
  <a href="http://www.gnu.org/licenses/">
    <img src="https://img.shields.io/badge/License-GNU-blue.svg?longCache=true"
        alt="License">
  </a>
</p>

<div align="center">
  <sub>Created by
  <a href="https://twitter.com/trimstray">trimstray</a> and
  <a href="https://github.com/trimstray/nginx-quick-reference/graphs/contributors">
    contributors
  </a>
</div>

<br>

****

# Main context

- **Separate listen directives for 80 and 443**

    **Rationale:**

    ...

    **Example:**

    ```bash
    # For http:
    server {
      listen                    10.240.20.2:80;
      ...

    # For https:
    server {
      listen                    10.240.20.2:443 ssl;
      ...
    ```

    **External resources:**

    - [Understanding the Nginx Configuration File Structure and Configuration Contexts](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)

- **Use default_server directive**

    **Rationale:**

    Nginx should prevent processing requests with undefined server names - also traffic on ip address. It also protects against configuration errors and providing incorrect backends.

    **Example:**

    ```bash
    # Place it at the beginning of the configuration file.
    server_name                 default_server;

    location / {
      # server static file (error page):
      root                      /etc/nginx/error-pages/sites/404;
      # or redirect:
      # return                  301 https://badssl.com;
    }
    ```

    **External resources:**

    - [How nginx processes a request](https://nginx.org/en/docs/http/request_processing.html)

# Performance

- **Use HTTP2**

    **Rationale:**

    All requests are downloaded in parallel, not in a queue, HTTP headers are compressed, pages transfer as a binary, not as a text file, which is more efficient and more.

    **Example:**

    ```bash
    # For https:
    server {
      listen                    10.240.20.2:443 ssl http2;
      ...
    ```

    **External resources:**

    - [What is HTTP/2 - The Ultimate Guide](https://kinsta.com/learn/what-is-http2/)

# Hardening

## Response Headers

- **HTTP Strict Transport Security**

    **Rationale:**

    Default key size in OpenSSL is `1024 bits` - it's vurnelable and breakable. For the best security configuration use `4096 bit` DH Group.

    **Example:**

    ```bash
    add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";
    ```

    **External resources:**

    - [HTTP Strict Transport Security Cheat Sheet](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)

## SSL/TLS

- **Keep only TLS 1.2**

    **Rationale:**

    TLS 1.1 and 1.2 are both without security issues - but only v1.2 provides modern cryptographic algorithms. TLS 1.0 and TLS 1.1 protocols will be removed from browsers at the beginning of 2020.

    **Example:**

    ```bash
    ssl_protocols               TLSv1.2;
    ```

    **External resources:**

    - [TLS/SSL Explained – Examples of a TLS Vulnerability and Attack, Final Part](https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/)
    - [How to enable TLS 1.3 on Nginx](https://ma.ttias.be/enable-tls-1-3-nginx/)

- **Use only strong ciphers**

    **Rationale:**

    This parameter changes quite often, the recommended configuration for today may be out of date tomorrow but remember - drop backward compatibility software components. Use only strong and not vulnerable ciphersuite.

    **Example:**

    ```bash
    ssl_ciphers                 "AES256+EECDH:AES256+EDH:!aNULL";
    ```

    **External resources:**

    - [SSL/TLS: How to choose your cipher suite](https://technology.amis.nl/2017/07/04/ssltls-choose-cipher-suite/)

- **Use strong Diffie-Hellman group**

    **Rationale:**

    Default key size in OpenSSL is `1024 bits` - it's vurnelable and breakable. For the best security configuration use `4096 bit` DH Group or pre-configured DH groups from [mozilla](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096).

    **Example:**

    ```bash
    # Generate DH Key:
    openssl dhparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

    # Nginx configuration:
    ssl_dhparam                 /etc/nginx/ssl/dhparams_4096.pem;
    ```

    **External resources:**

    - [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
    - [Pre-defined DHE groups](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096)

- **Enables server-side protection from BEAST attacks**

    **Rationale:**

    Default key size in OpenSSL is `1024 bits` - it's vurnelable and breakable. For the best security configuration use `4096 bit` DH Group.

    **Example:**

    ```bash
    # Generate DH Key:
    openssl dhparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

    # Nginx configuration:
    ssl_dhparam                 /etc/nginx/ssl/dhparams_4096.pem;
    ```

    **External resources:**

    - [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
