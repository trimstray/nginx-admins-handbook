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

- [ ] **Separate listen directives for 80 and 443**

    ###### Rationale

    ...

    ###### Example

    ```bash
    # For http:
    server {
      listen 10.240.20.2:80;
      ...

    # For https:
    server {
      listen 10.240.20.2:443 ssl;
      ...
    ```

    ###### External resources

    - [Understanding the Nginx Configuration File Structure and Configuration Contexts](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)

- [ ] **Use default_server directive**

    ###### Rationale

    Nginx should prevent processing requests with undefined server names - also traffic on ip address. It also protects against configuration errors and providing incorrect backends.

    ###### Example

    ```bash
    # Place it at the beginning of the configuration file.
    server_name default_server;

    location / {
      # serve static file (error page):
      root /etc/nginx/error-pages/404;
      # or redirect:
      # return 301 https://badssl.com;
    }
    ```

    ###### External resources

    - [How nginx processes a request](https://nginx.org/en/docs/http/request_processing.html)

- [ ] **Forcing HTTPS**

    ###### Rationale

    You should always use HTTPS instead of HTTP to protect your website, even if it doesn’t handle sensitive communications.

    ###### Example

    ```bash
    server {

      ...

      server_name domain.com;
      return 301 https://$host$request_uri;

    }
    ```

    ###### External resources

    - [Should we force user to HTTPS on website?](https://security.stackexchange.com/questions/23646/should-we-force-user-to-https-on-website)

- [ ] **Use geo/map modules instead allow/deny**

    ###### Rationale

    Creates variables with values depending on the client IP address. Use map or geo modules (one of them) to prevent users abusing your servers.

    ###### Example

    ```bash
    # Map module:
    map $remote_addr $globals_internal_map_acl {

      # Status code:
      #  - 0 = false
      #  - 1 = true
      default 0;

      ### INTERNAL ###
      10.255.10.0/24 1;
      10.255.20.0/24 1;
      10.255.30.0/24 1;
      192.168.0.0/16 1;

    }

    # Geo module:
    geo $globals_internal_geo_acl {

      # Status code:
      #  - 0 = false
      #  - 1 = true
      default 0;

      ### INTERNAL ###
      10.255.10.0/24 1;
      10.255.20.0/24 1;
      10.255.30.0/24 1;
      192.168.0.0/16 1;

    }
    ```

    ###### External resources

    - [Nginx Basic Configuration (Geo Ban)](https://www.axivo.com/resources/nginx-basic-configuration.3/update?update=27)

- [ ] **Map all the things...**

    ###### Rationale

    Map module provides a more elegant solution for clearly parsing a big list of regexes, e.g. User-Agents.

    ###### Example

    ```bash
    map $http_user_agent $device_redirect {
      default "desktop";
      ~(?i)ip(hone|od) "mobile";
      ~(?i)android.*(mobile|mini) "mobile";
      ~Mobile.+Firefox "mobile";
      ~^HTC "mobile";
      ~Fennec "mobile";
      ~IEMobile "mobile";
      ~BB10 "mobile";
      ~SymbianOS.*AppleWebKit "mobile";
      ~Opera\sMobi "mobile";
    }

    if ($device_redirect = "mobile") {
      return 301 https://m.domain.com$request_uri;
    }
    ```

    ###### External resources

    - [Cool Nginx feature of the week](https://www.ignoredbydinosaurs.com/posts/236-cool-nginx-feature-of-the-week)

# Performance

- [ ] **Use HTTP/2**

    ###### Rationale

    All requests are downloaded in parallel, not in a queue, HTTP headers are compressed, pages transfer as a binary, not as a text file, which is more efficient and more.

    ###### Example

    ```bash
    # For https:
    server {
      listen 10.240.20.2:443 ssl http2;
      ...
    ```

    ###### External resources

    - [What is HTTP/2 - The Ultimate Guide](https://kinsta.com/learn/what-is-http2/)

- [ ] **Maintaining SSL Sessions**

    ###### Rationale

    This improves performance from the clients’ perspective, because it eliminates the need for a new (and time-consuming) SSL handshake to be conducted each time a request is made.

    Most servers do not purge sessions or ticket keys, thus increasing the risk that a server compromise would leak data from previous (and future) connections.

    ###### Example

    ```bash
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
    ssl_session_tickets off;
    ssl_buffer_size 1400;
    ```

    ###### External resources

    - [SSL Session (cache)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache)
    - [Speeding up TLS: enabling session reuse](https://vincent.bernat.ch/en/blog/2011-ssl-session-reuse-rfc5077)

# Hardening

- [ ] **Run as an unprivileged user**

    ###### Rationale

    There is no real difference in security just by changing the process owner name. On the other hand in security, the principle of least privilege states that an entity should be given no more permission than necessary to accomplish its goals within a given system. This way only master process runs as root.

    ###### Example

    ```bash
    user www-data;
    chown -R www-data:www-data /var/www/domain.com
    ```

    ###### External resources

    - [Why does nginx starts process as root?](https://unix.stackexchange.com/questions/134301/why-does-nginx-starts-process-as-root)

- [ ] **Hide Nginx version number**

    ###### Rationale

    Disclosing the version of nginx running can be undesirable, particularly in environments sensitive to information disclosure.

    ###### Example

    ```bash
    server_tokens off;
    ```

    ###### External resources

    - [Remove Version from Server Header Banner in nginx](https://geekflare.com/remove-server-header-banner-nginx/)

- [ ] **Hide Nginx server signature**

    ###### Rationale

    You should compile Nginx from sources with `ngx_headers_more` to used `more_set_headers` directive.

    ###### Example

    ```bash
    more_set_headers "Server: Unknown";
    ```

    ###### External resources

    - [How to change (hide) the Nginx Server Signature?](https://stackoverflow.com/questions/24594971/how-to-changehide-the-nginx-server-signature)

- [ ] **Hide upstream proxy headers**

    ###### Rationale

    When nginx is used to proxy requests from an upstream server (such as a PHP-FPM instance), it can be beneficial to hide certain headers sent in the upstream response (for example, the version of PHP running).

    ###### Example

    ```bash
    proxy_hide_header Server;
    proxy_hide_header X-Powered-By;
    proxy_hide_header X-AspNetMvc-Version;
    proxy_hide_header X-AspNet-Version;
    proxy_hide_header X-Drupal-Cache;
    proxy_hide_header Via;
    proxy_hide_header Link;
    proxy_hide_header X-Generator;
    proxy_hide_header X-Host;
    proxy_hide_header X-Url;
    proxy_hide_header Purge-Cache-Tags;
    ```

    ###### External resources

    - [Remove insecure http headers](https://veggiespam.com/headers/)

- [ ] **Keep only TLS 1.2 (+ TLS 1.3)**

    ###### Rationale

    TLS 1.1 and 1.2 are both without security issues - but only v1.2 provides modern cryptographic algorithms. TLS 1.0 and TLS 1.1 protocols will be removed from browsers at the beginning of 2020.

    ###### Example

    ```bash
    ssl_protocols TLSv1.2;
    ```

    ###### External resources

    - [TLS/SSL Explained – Examples of a TLS Vulnerability and Attack, Final Part](https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/)
    - [How to enable TLS 1.3 on Nginx](https://ma.ttias.be/enable-tls-1-3-nginx/)

- [ ] **Use only strong ciphers**

    ###### Rationale

    This parameter changes quite often, the recommended configuration for today may be out of date tomorrow but remember - drop backward compatibility software components. Use only strong and not vulnerable ciphersuite.

    ###### Example

    ```bash
    ssl_ciphers "AES256+EECDH:AES256+EDH:!aNULL";
    ```

    ###### External resources

    - [SSL/TLS: How to choose your cipher suite](https://technology.amis.nl/2017/07/04/ssltls-choose-cipher-suite/)

- [ ] **Use strong Key Exchange**

    ###### Rationale

    Default key size in OpenSSL is `1024 bits` - it's vurnelable and breakable. For the best security configuration use `4096 bit` DH Group or pre-configured DH groups from [mozilla](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096).

    ###### Example

    ```bash
    # Generate DH Key:
    openssl dhparam -dsaparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

    # Nginx configuration:
    ssl_dhparam /etc/nginx/ssl/dhparams_4096.pem;
    ```

    ###### External resources

    - [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
    - [Pre-defined DHE groups](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096)
    - [Instructs OpenSSL to produce "DSA-like" DH parameters](https://security.stackexchange.com/questions/95178/diffie-hellman-parameters-still-calculating-after-24-hours/95184#95184)

- [ ] **Use more secure ECDH Curve**

    ###### Rationale

    x25519 is a more secure but slightly less compatible option. The NIST curves (prime256v1, secp384r1, secp521r1) are known to be weak and potentially vulnerable.

    ###### Example

    ```bash
    ssl_ecdh_curve x25519;
    ```

    ###### External resources

    - [SafeCurves: choosing safe curves for elliptic-curve cryptography](https://safecurves.cr.yp.to/)

- [ ] **Defend against the BEAST attack**

    ###### Rationale

    Enables server-side protection from BEAST attacks.

    ###### Example

    ```bash
    ssl_prefer_server_ciphers on;
    ```

    ###### External resources

    - [Is BEAST still a threat?](https://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html)

- [ ] **Disable compression (mitigation of CRIME attack)**

    ###### Rationale

    Disabling SSL/TLS compression stops the attack very effectively.

    ###### Example

    ```bash
    gzip off;
    ```

    ###### External resources

    - [SSL/TLS attacks: Part 2 – CRIME Attack](http://niiconsulting.com/checkmate/2013/12/ssltls-attacks-part-2-crime-attack/)

- [ ] **HTTP Strict Transport Security**

    ###### Rationale

    The header indicates for how long a browser should unconditionally refuse to take part in unsecured HTTP connection for a specific domain.

    ###### Example

    ```bash
    add_header Strict-Transport-Security "max-age=15768000; includeSubdomains" always;
    ```

    ###### External resources

    - [HTTP Strict Transport Security Cheat Sheet](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)

- [ ] **Reduce XSS risks (Content-Security-Policy)**

    ###### Rationale

    CSP reduce the risk and impact of XSS attacks in modern browsers.

    ###### Example

    ```bash
    # This policy allows images, scripts, AJAX, and CSS from the same origin, and does not allow any other resources to load.
    add_header Content-Security-Policy "default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self';" always;
    ```

    ###### External resources

    - [Content Security Policy (CSP) Quick Reference Guide](https://content-security-policy.com/)
    - [Content Security Policy – OWASP](https://www.owasp.org/index.php/Content_Security_Policy)

- [ ] **Control the behavior of the Referer header (Referrer-Policy)**

    ###### Rationale

    Determine what information is sent along with the requests.

    ###### Example

    ```bash
    add_header Referrer-Policy "no-referrer";
    ```

    ###### External resources

    - [A new security header: Referrer Policy](https://scotthelme.co.uk/a-new-security-header-referrer-policy/)

- [ ] **Provide clickjacking protection (X-Frame-Options)**

    ###### Rationale

    Helps to protect your visitors against clickjacking attacks. It is recommended that you use the x-frame-options header on pages which should not be allowed to render a page in a frame.

    ###### Example

    ```bash
    add_header X-Frame-Options "SAMEORIGIN" always;
    ```

    ###### External resources

    - [Clickjacking Defense Cheat Sheet](https://www.owasp.org/index.php/Clickjacking_Defense_Cheat_Sheet)

- [ ] **Prevent some categories of XSS attacks (X-XSS-Protection)**

    ###### Rationale

    Enable the cross-site scripting (XSS) filter built into modern web browsers.

    ###### Example

    ```bash
    add_header X-XSS-Protection "1; mode=block" always
    ```

    ###### External resources

    - [X-XSS-Protection HTTP Header](https://www.tunetheweb.com/security/http-security-headers/x-xss-protection/)

- [ ] **Prevent Sniff Mimetype middleware (X-Content-Type-Options)**

    ###### Rationale

    It prevents the browser from doing MIME-type sniffing (prevents "mime" based attacks).

    ###### Example

    ```bash
    add_header X-Content-Type-Options "nosniff" always;
    ```

    ###### External resources

    - [X-Content-Type-Options HTTP Header](https://www.keycdn.com/support/x-content-type-options)

- [ ] **Reject unsafe HTTP methods**

    ###### Rationale

    Set of methods support by a resource. An ordinary web server supports the HEAD, GET and POST methods to retrieve static and dynamic content. Other (e.g. OPTIONS, TRACE) methods should not be supported on public web servers, as they increase the attack surface.

    ###### Example

    ```bash
    add_header Allow "GET, POST, HEAD" always;

    if ( $request_method !~ ^(GET|POST|HEAD)$ ) {

      return 405;

    }
    ```

    ###### External resources

    - [Vulnerability name: Unsafe HTTP methods](https://www.onwebsecurity.com/security/unsafe-http-methods.html)
