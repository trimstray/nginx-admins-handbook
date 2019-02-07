<div align="center">
  <h1>Nginx Quick Reference</h1>
</div>

<div align="center">
  <h6><code>My notes about Nginx...</code></h6>
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

# Table of Contents

- **[Introduction](#introduction)**
  * [General disclaimer](#general-disclaimer)
  * [SSL Report: blkcipher.info](#ssl-report-blkcipherinfo)
- **[External Resources](#external-resources)**
  * [About Nginx](#about-nginx)
  * [References](#references)
  * [Cheatsheets](#cheatsheets)
  * [Performance & Hardening](#performance--hardening)
  * [Config generators](#config-generators)
  * [Static Analyzers](#static-analyzers)
  * [Log Analyzers](#log-analyzers)
  * [Performance Analyzers](#performance-analyzers)
  * [Benchmarking tools](#benchmarking-tools)
  * [Online tools](#online-tools)
  * [Other stuff](#other-stuff)
- **[Helpers](#helpers)**
  * [Shell aliases](#shell-aliases)
- **[Base rules](#base-rules)**
  * [Organising Nginx configuration](#beginner-organising-nginx-configuration)
  * [Separate listen directives for 80 and 443](#beginner-separate-listen-directives-for-80-and-443)
  * [Use `default_server` directive at the beginning](#beginner-use-default_server-directive-at-the-beginning)
  * [Force all connections over TLS](#beginner-force-all-connections-over-tls)
  * [Use geo/map modules instead allow/deny](#beginner-use-geomap-modules-instead-allowdeny)
  * [Map all the things...](#beginner-map-all-the-things)
  * [Drop the same root inside location block](#beginner-drop-the-same-root-inside-location-block)
  * [Use debug mode for debugging](#beginner-use-debug-mode-for-debugging)
- **[Performance](#performance)**
  * [Set manually worker processes](#beginner-set-manually-worker-processes)
  * [Use HTTP/2](#beginner-use-http2)
  * [Maintaining SSL Sessions](#beginner-maintaining-ssl-sessions)
- **[Hardening](#hardening)**
  * [Run as an unprivileged user](#beginner-run-as-an-unprivileged-user)
  * [Disable unnecessary modules](#beginner-disable-unnecessary-modules)
  * [Protect sensitive resources](#beginner-protect-sensitive-resources)
  * [Hide Nginx version number](#beginner-hide-nginx-version-number)
  * [Hide Nginx server signature](#beginner-hide-nginx-server-signature)
  * [Hide upstream proxy headers](#beginner-hide-upstream-proxy-headers)
  * [Use only 4096-bit private keys](#beginner-use-only-4096-bit-private-keys)
  * [Keep only TLS 1.2 (+ TLS 1.3)](#beginner-keep-only-tls-12--tls-13)
  * [Use only strong ciphers](#beginner-use-only-strong-ciphers)
  * [Use more secure ECDH Curve](#beginner-use-more-secure-ecdh-curve)
  * [Use strong Key Exchange](#beginner-use-strong-key-exchange)
  * [Defend against the BEAST attack](#beginner-defend-against-the-beast-attack)
  * [Disable compression (mitigation of CRIME attack)](#beginner-disable-compression-mitigation-of-crime-attack)
  * [HTTP Strict Transport Security](#beginner-http-strict-transport-security)
  * [Reduce XSS risks (Content-Security-Policy)](#beginner-reduce-xss-risks-content-security-policy)
  * [Control the behavior of the Referer header (Referrer-Policy)](#beginner-control-the-behavior-of-the-referer-header-referrer-policy)
  * [Provide clickjacking protection (X-Frame-Options)](#beginner-provide-clickjacking-protection-x-frame-options)
  * [Prevent some categories of XSS attacks (X-XSS-Protection)](#beginner-prevent-some-categories-of-xss-attacks-x-xss-protection)
  * [Prevent Sniff Mimetype middleware (X-Content-Type-Options)](#beginner-prevent-sniff-mimetype-middleware-x-content-type-options)
  * [Deny the use of browser features (Feature-Policy)](#beginner-deny-the-use-of-browser-features-feature-policy)
  * [Reject unsafe HTTP methods](#beginner-reject-unsafe-http-methods)
  * [Control Buffer Overflow attacks](#beginner-control-buffer-overflow-attacks)
  * [Mitigating Slow HTTP DoS attack (Closing Slow Connections)](#beginner-mitigating-slow-http-dos-attack-closing-slow-connections)

# Introduction

<img src="https://github.com/trimstray/nginx-quick-reference/blob/master/doc/img/nginx_logo.png" align="right">

  > Before using the **Nginx** please read **[Beginner’s Guide](http://nginx.org/en/docs/beginners_guide.html)**.

<p align="justify"><b>Nginx</b> (<i>/ˌɛndʒɪnˈɛks/ EN-jin-EKS</i>) is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev. For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler.</p>

To increase your knowledge, read **[Nginx Documentation](https://nginx.org/en/docs/)**.

## General disclaimer

This is not an official handbook. Many of these rules refer to another resources. It is rather a quick collection of some rules used by me in production environments (not only).

The most important thing:

  > Do not follow guides just to get 100% of something. Think about what you actually do at your server!

And remember:

  > These guidelines provides recommendations for very restrictive setup.

## SSL Report: blkcipher.info

Many of these recipes have been applied to the configuration of my private website. I finally got all 100%'s on my scores:

<p align="center">
    <img src="https://github.com/trimstray/nginx-quick-reference/blob/master/doc/img/blkcipher_ssllabs_preview.png"
        alt="Master">
</p>

# External Resources

##### About Nginx

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.nginx.com/"><b>Nginx Project</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nginx/nginx"><b>Nginx official read-only mirror</b></a><br>
</p>

##### References

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/h5bp/server-configs-nginx"><b>Nginx boilerplate configs</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nginx-boilerplate/nginx-boilerplate"><b>Awesome Nginx configuration template</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/fcambus/nginx-resources"><b>A collection of resources covering Nginx and more</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://calomel.org/nginx.html"><b>Nginx Secure Web Server</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.evanmiller.org/nginx-modules-guide.html"><b>Emiller’s Guide To Nginx Module Development</b></a><br>
</p>

##### Cheatsheets

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://gist.github.com/carlessanagustin/9509d0d31414804da03b"><b>Nginx Cheatsheet</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/SimulatedGREG/nginx-cheatsheet"><b>Nginx Quick Reference</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://mijndertstuij.nl/writing/posts/nginx-cheatsheet/"><b>Nginx Cheatsheet by Mijdert Stuij</b></a><br>
</p>

##### Performance & Hardening

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/projects/best-practices/"><b>SSL/TLS Deployment Best Practices</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/projects/rating-guide/index.html"><b>SSL Server Rating Guide</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.upguard.com/blog/how-to-build-a-tough-nginx-server-in-15-steps"><b>How to Build a Tough NGINX Server in 15 Steps</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html"><b>Top 25 Nginx Web Server Best Security Practices</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html"><b>Strong SSL Security on Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/denji/nginx-tuning"><b>Nginx Tuning For Best Performance by Denji</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://enable-cors.org/index.html"><b>Enable cross-origin resource sharing (CORS)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://istlsfastyet.com/"><b>TLS has exactly one performance problem: it is not used widely enough</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nbs-system/naxsi"><b>WAF for Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://geekflare.com/install-modsecurity-on-nginx/"><b>ModSecurity for Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.owasp.org/index.php/Transport_Layer_Protection_Cheat_Sheet"><b>Transport Layer Protection Cheat Sheet</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://wiki.mozilla.org/Security/Server_Side_TLS"><b>Security/Server Side TLS</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices"><b>SSL and TLS Deployment Best Practices</b></a><br>
</p>

##### Config generators

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://nginxconfig.io/"><b>Nginx config generator on steroids.</b></a><br>
</p>

##### Static Analyzers

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/yandex/gixy"><b>Nginx static analyzer</b></a><br>
</p>

##### Log Analyzers

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://goaccess.io/"><b>GoAccess</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.graylog.org/"><b>Graylog</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.elastic.co/products/logstash"><b>Logstash</b></a><br>
</p>

##### Performance Analyzers

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/lebinh/ngxtop"><b>ngxtop</b></a><br>
</p>

##### Benchmarking tools

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.joedog.org/siege-home/"><b>siege</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/wg/wrk"><b>wrk</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/codesenberg/bombardier"><b>bombardier</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/cmpxchg16/gobench"><b>gobench</b></a><br>
</p>

##### Online tools

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/ssltest/"><b>SSL Server Test</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/ssltest/viewMyClient.html"><b>SSL/TLS Capabilities of Your Browser</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://cipherli.st/"><b>Strong ciphers for Apache, Nginx, Lighttpd and more</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://securityheaders.com/"><b>Analyse the HTTP response headers by Security Headers</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://observatory.mozilla.org/"><b>Analyze your website by Mozilla Observatory</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://regexr.com/"><b>Online tool to learn, build, & test Regular Expressions</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.regextester.com/"><b>Online Regex Tester & Debugger</b></a><br>
</p>

##### Other stuff

<p>
&nbsp;&nbsp;:black_small_square: <a href="http://www.bbc.co.uk/blogs/internet/entries/17d22fb8-cea2-49d5-be14-86e7a1dcde04"><b>BBC Digital Media Distribution: How we improved throughput by 4x</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/jiangwenyuan/nuster/wiki/Web-cache-server-performance-benchmark:-nuster-vs-nginx-vs-varnish-vs-squid"><b>Web cache server performance benchmark: nuster vs nginx vs varnish vs squid</b></a><br>
</p>

# Helpers

#### Shell aliases

```bash
alias ng.test='nginx -t -c /etc/nginx/nginx.conf'
alias ng.stop='ng.test && systemctl stop nginx'
alias ng.reload='ng.test && systemctl reload nginx'
```

# Base rules

#### :beginner: Organising Nginx configuration

###### Rationale

  > When your configuration grow, the need for organising your code will also grow. Well organised code is:

  > - easier to understand
  > - easier to maintain
  > - easier to work with

  > Use `include` directive to attach your nginx specific code to global config, contexts and other.

###### Example

```bash
# Store this configuration in https-ssl-common.conf
listen 10.240.20.2:443 ssl;

root /etc/nginx/error-pages/other;

ssl_certificate /etc/nginx/domain.com/certs/nginx_domain.com_bundle.crt;
ssl_certificate_key /etc/nginx/domain.com/certs/domain.com.key;

# And include this file in server section:
server {

  include /etc/nginx/domain.com/commons/https-ssl-common.conf;

  server_name domain.com www.domain.com;
  ...
```

###### External resources

- [Organize your data and code](https://kbroman.org/steps2rr/pages/organize.html)

#### :beginner: Separate listen directives for 80 and 443

###### Rationale

...

###### Example

```bash
# For http:
server {

  listen 10.240.20.2:80;
  ...

}

# For https:
server {

  listen 10.240.20.2:443 ssl;
  ...

}
```

###### External resources

- [Understanding the Nginx Configuration File Structure and Configuration Contexts](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)

#### :beginner: Use `default_server` directive at the beginning

###### Rationale

  > Nginx should prevent processing requests with undefined server names - also traffic on ip address. It also protects against configuration errors and providing incorrect backends.

###### Example

```bash
server {

  listen 10.240.20.2:443 ssl;

  # Place it at the beginning of the configuration file.
  server_name default_server;

  location / {
    # serve static file (error page):
    root /etc/nginx/error-pages/404;
    # or redirect:
    # return 301 https://badssl.com;
  }

}

server {

  listen 10.240.20.2:443 ssl;

  server_name domain.com;
  ...

}

server {

  listen 10.240.20.2:443 ssl;

  server_name app.domain.com;
  ...

}
```

###### External resources

- [How nginx processes a request](https://nginx.org/en/docs/http/request_processing.html)

#### :beginner: Force all connections over TLS

###### Rationale

  > You should always use HTTPS instead of HTTP to protect your website, even if it doesn’t handle sensitive communications.

###### Example

```bash
server {

  listen 10.240.20.2:80;

  server_name domain.com;
  return 301 https://$host$request_uri;

}

server {

  listen 10.240.20.2:443 ssl;

  server_name domain.com;
  ...

}
```

###### External resources

- [Should we force user to HTTPS on website?](https://security.stackexchange.com/questions/23646/should-we-force-user-to-https-on-website)

#### :beginner: Use geo/map modules instead allow/deny

###### Rationale

  > Creates variables with values depending on the client IP address. Use map or geo modules (one of them) to prevent users abusing your servers.

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

#### :beginner: Map all the things...

###### Rationale

  > Map module provides a more elegant solution for clearly parsing a big list of regexes, e.g. User-Agents. Manage a large number of redirects with Nginx maps.

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

#### :beginner: Drop the same root inside location block

###### Rationale

  > If you add a root to every location block then a location block that isn’t matched will have no root. Set global `root` inside server directive.

###### Example

```bash
server {

  server_name domain.com;

  root /var/www/domain.com/public;

  location / {
    ...
  }

  location /api {
    ...
  }

  location /static {
    root /var/www/domain.com/static;
    ...
  }

}
```

###### External resources

- [Nginx Pitfalls: Root inside location block](http://wiki.nginx.org/Pitfalls#Root_inside_Location_Block)

#### :beginner: Use debug mode for debugging

###### Rationale

  > There's probably more detail than you want, but that can sometimes be a lifesaver (but log file growing rapidly).

###### Example

```bash
rewrite_log on;
error_log /var/log/nginx/error-debug.log debug;
```

###### External resources

- [A debugging log](https://nginx.org/en/docs/debugging_log.html)

# Performance

#### :beginner: Set manually worker processes

###### Rationale

  > The `worker_processes` directive is the sturdy spine of life for Nginx. This directive is responsible for letting our virtual server know many workers to spawn once it has become bound to the proper IP and port(s).

  > Official Nginx documentation say: "When one is in doubt, setting it to the number of available CPU cores would be a good start (the value "auto" will try to autodetect it)."

  > I think for high load proxy servers (also standalone servers) the best value is ALL_CORES - 1 (please test it before used).

###### Example

```bash
# VCPU = 4 , expr $(nproc --all) - 1
worker_processes 3;
```

###### External resources

- [Nginx Core Module - worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes)

#### :beginner: Use HTTP/2

###### Rationale

  > All requests are downloaded in parallel, not in a queue, HTTP headers are compressed, pages transfer as a binary, not as a text file, which is more efficient and more.

###### Example

```bash
# For https:
server {

  listen 10.240.20.2:443 ssl http2;
  ...
```

###### External resources

- [What is HTTP/2 - The Ultimate Guide](https://kinsta.com/learn/what-is-http2/)

#### :beginner: Maintaining SSL Sessions

###### Rationale

  > This improves performance from the clients’ perspective, because it eliminates the need for a new (and time-consuming) SSL handshake to be conducted each time a request is made.

  > Most servers do not purge sessions or ticket keys, thus increasing the risk that a server compromise would leak data from previous (and future) connections.

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

#### :beginner: Run as an unprivileged user

###### Rationale

  > There is no real difference in security just by changing the process owner name. On the other hand in security, the principle of least privilege states that an entity should be given no more permission than necessary to accomplish its goals within a given system. This way only master process runs as root.

###### Example

```bash
# Edit nginx.conf:
user www-data;

# Set owner and group:
chown -R www-data:www-data /var/www/domain.com
```

###### External resources

- [Why does nginx starts process as root?](https://unix.stackexchange.com/questions/134301/why-does-nginx-starts-process-as-root)

#### :beginner: Disable unnecessary modules

###### Rationale

  > It is recommended to disable any modules which are not required as this will minimize the risk of any potential attacks by limiting the operations allowed by the web server.

###### Example

```bash
# During installation:
./configure --without-http_autoindex_module

# Comment modules in the configuration file:
# load_module /usr/share/nginx/modules/ndk_http_module.so;
# load_module /usr/share/nginx/modules/ngx_http_auth_pam_module.so;
```

###### External resources

- [nginx-modules](https://github.com/nginx-modules)

#### :beginner: Protect sensitive resources

###### Rationale

  > Hidden directories and files should never be web accessible.

###### Example

```bash
if ( $request_uri ~ "/\.git" ) {

  return 403;

}

# or
location ~ /\.git {

  deny all;

}

# or all . directories/files in general
location ~ /\. {

  deny all;

}
```

###### External resources

- [Hidden directories and files as a source of sensitive information about web application](https://medium.com/@_bl4de/hidden-directories-and-files-as-a-source-of-sensitive-information-about-web-application-84e5c534e5ad)

#### :beginner: Hide Nginx version number

###### Rationale

  > Disclosing the version of nginx running can be undesirable, particularly in environments sensitive to information disclosure.

###### Example

```bash
server_tokens off;
```

###### External resources

- [Remove Version from Server Header Banner in nginx](https://geekflare.com/remove-server-header-banner-nginx/)

#### :beginner: Hide Nginx server signature

###### Rationale

  > You should compile Nginx from sources with `ngx_headers_more` to used `more_set_headers` directive.

###### Example

```bash
more_set_headers "Server: Unknown";
```

###### External resources

- [How to change (hide) the Nginx Server Signature?](https://stackoverflow.com/questions/24594971/how-to-changehide-the-nginx-server-signature)

#### :beginner: Hide upstream proxy headers

###### Rationale

  > When nginx is used to proxy requests from an upstream server (such as a PHP-FPM instance), it can be beneficial to hide certain headers sent in the upstream response (for example, the version of PHP running).

###### Example

```bash
proxy_hide_header X-Powered-By;
proxy_hide_header X-AspNetMvc-Version;
proxy_hide_header X-AspNet-Version;
proxy_hide_header X-Drupal-Cache;
```

###### External resources

- [Remove insecure http headers](https://veggiespam.com/headers/)

#### :beginner: Use only 4096-bit private keys

###### Rationale

  > Advisories recommend 2048 for now. Security experts are projecting that 2048 bits will be sufficient for commercial use until around the year 2030.

  > I always generate 4096 bit keys since the downside is minimal (slightly lower performance) and security is slightly higher (although not as high as one would like).

  > Use of alternative solution: ECC Certificate Signing Request (CSR).

###### Example

```bash
### Example (RSA):
( _fd="domain.com.key" ; _len="4096" ; openssl genrsa -out ${_fd} ${_len} )

# Let's Encrypt:
certbot certonly -d domain.com -d www.domain.com --rsa-key-size 4096

### Example (ECC):
( _fd="domain.com.key" ; _fd_csr="domain.com.csr" ; _curve="prime256v1" ; openssl ecparam -out ${_fd} -name ${_curve} -genkey ; openssl req -new -key ${_fd} -out ${_fd_csr} -sha256)

# Let's Encrypt:
certbot --csr domain.com.csr -[other-args]
```

&nbsp;&nbsp;<sub>ssllabs score: **100**</sub>

```bash
( _fd="domain.com.key" ; _len="2048" ; openssl genrsa -out ${_fd} ${_len} )

# Let's Encrypt:
certbot certonly -d domain.com -d www.domain.com
```

&nbsp;&nbsp;<sub>ssllabs score: **90**</sub>

###### External resources

- [So you're making an RSA key for an HTTPS certificate. What key size do you use?](https://certsimple.com/blog/measuring-ssl-rsa-keys)

#### :beginner: Keep only TLS 1.2 (+ TLS 1.3)

###### Rationale

  > TLS 1.1 and 1.2 are both without security issues - but only v1.2 provides modern cryptographic algorithms. TLS 1.0 and TLS 1.1 protocols will be removed from browsers at the beginning of 2020.

  > If you use TLS 1.2 or TLS 1.1/1.2 older clients will not able to load your site.

###### Example

```bash
ssl_protocols TLSv1.2;
```

&nbsp;&nbsp;<sub>ssllabs score: **100**</sub>

```bash
ssl_protocols TLSv1.2 TLSv1.1;
```

&nbsp;&nbsp;<sub>ssllabs score: **95**</sub>

###### External resources

- [TLS/SSL Explained – Examples of a TLS Vulnerability and Attack, Final Part](https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/)
- [How to enable TLS 1.3 on Nginx](https://ma.ttias.be/enable-tls-1-3-nginx/)

#### :beginner: Use only strong ciphers

###### Rationale

  > This parameter changes quite often, the recommended configuration for today may be out of date tomorrow. For more security use only strong and not vulnerable ciphersuite (but if you use http/2 you can get `Server sent fatal alert: handshake_failure` error).

  > For backward compatibility software components you should use less restrictive ciphers.

  > You should definitely disable weak ciphers like those with DSS, DSA, DES/3DES, RC4, MD5, SHA1, null, anon in the name.

###### Example

```bash
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384";
```

&nbsp;&nbsp;<sub>ssllabs score: **100**</sub>

```bash
ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256";
```

&nbsp;&nbsp;<sub>ssllabs score: **90**</sub>

###### External resources

- [SSL/TLS: How to choose your cipher suite](https://technology.amis.nl/2017/07/04/ssltls-choose-cipher-suite/)
- [HTTP/2 and ECDSA Cipher Suites](https://sparanoid.com/note/http2-and-ecdsa-cipher-suites/)
- [Which SSL/TLS Protocol Versions and Cipher Suites Should I Use?](https://www.securityevaluators.com/ssl-tls-protocol-versions-cipher-suites-use/)

#### :beginner: Use more secure ECDH Curve

###### Rationale

  > X25519 is a more secure but slightly less compatible option. To maximise interoperability with existing browsers and servers, stick to P-256 prime256v1 and P-384 secp384r1 curves.

  > If web browser support X25519 curves -> use X25519 otherwise try the next curve listed.

  > Do not use the secp112r1, secp112r2, secp128r1, secp128r2, secp160k1, secp160r1, secp160r2, secp192k1 curves. They have a too small size for security application according to NIST recommendation.

###### Example

```bash
ssl_ecdh_curve X25519;

# Alternative (this one doesn’t affect compatibility, by the way; it’s just a question of the preferred order)
ssl_ecdh_curve X25519:prime256v1:secp521r1:secp384r1;
```

&nbsp;&nbsp;<sub>ssllabs score: **100**</sub>

###### External resources

- [SafeCurves: choosing safe curves for elliptic-curve cryptography](https://safecurves.cr.yp.to/)
- [Safe ECC curves for HTTPS are coming sooner than you think](https://certsimple.com/blog/safe-curves-and-openssl)
- [Cryptographic Key Length Recommendations](https://www.keylength.com/)
- [Testing for Weak SSL/TLS Ciphers, Insufficient Transport Layer Protection (OTG-CRYPST-001)](https://www.owasp.org/index.php/Testing_for_Weak_SSL/TLS_Ciphers,_Insufficient_Transport_Layer_Protection_(OTG-CRYPST-001))

#### :beginner: Use strong Key Exchange

###### Rationale

  > Default key size in OpenSSL is `1024 bits` - it's vurnelable and breakable. For the best security configuration use `4096 bit` DH Group or pre-configured DH groups from [mozilla](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096).

###### Example

```bash
# Generating DH parameters:
openssl dhparam -dsaparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

# Nginx configuration:
ssl_dhparam /etc/nginx/ssl/dhparams_4096.pem;
```

&nbsp;&nbsp;<sub>ssllabs score: **100**</sub>

###### External resources

- [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
- [Pre-defined DHE groups](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096)
- [Instructs OpenSSL to produce "DSA-like" DH parameters](https://security.stackexchange.com/questions/95178/diffie-hellman-parameters-still-calculating-after-24-hours/95184#95184)

#### :beginner: Defend against the BEAST attack

###### Rationale

  > Enables server-side protection from BEAST attacks.

###### Example

```bash
ssl_prefer_server_ciphers on;
```

###### External resources

- [Is BEAST still a threat?](https://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html)

#### :beginner: Disable compression (mitigation of CRIME attack)

###### Rationale

  > Disabling SSL/TLS compression stops the attack very effectively.

###### Example

```bash
gzip off;
```

###### External resources

- [SSL/TLS attacks: Part 2 – CRIME Attack](http://niiconsulting.com/checkmate/2013/12/ssltls-attacks-part-2-crime-attack/)

#### :beginner: HTTP Strict Transport Security

###### Rationale

  > The header indicates for how long a browser should unconditionally refuse to take part in unsecured HTTP connection for a specific domain.

###### Example

```bash
add_header Strict-Transport-Security "max-age=63072000; includeSubdomains" always;
```

&nbsp;&nbsp;<sub>ssllabs score: **A+**</sub>

###### External resources

- [HTTP Strict Transport Security Cheat Sheet](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)

#### :beginner: Reduce XSS risks (Content-Security-Policy)

###### Rationale

  > CSP reduce the risk and impact of XSS attacks in modern browsers.

###### Example

```bash
# This policy allows images, scripts, AJAX, and CSS from the same origin, and does not allow any other resources to load.
add_header Content-Security-Policy "default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self';" always;
```

###### External resources

- [Content Security Policy (CSP) Quick Reference Guide](https://content-security-policy.com/)
- [Content Security Policy – OWASP](https://www.owasp.org/index.php/Content_Security_Policy)

#### :beginner: Control the behavior of the Referer header (Referrer-Policy)

###### Rationale

  > Determine what information is sent along with the requests.

###### Example

```bash
add_header Referrer-Policy "no-referrer";
```

###### External resources

- [A new security header: Referrer Policy](https://scotthelme.co.uk/a-new-security-header-referrer-policy/)

#### :beginner: Provide clickjacking protection (X-Frame-Options)

###### Rationale

  > Helps to protect your visitors against clickjacking attacks. It is recommended that you use the x-frame-options header on pages which should not be allowed to render a page in a frame.

###### Example

```bash
add_header X-Frame-Options "SAMEORIGIN" always;
```

###### External resources

- [Clickjacking Defense Cheat Sheet](https://www.owasp.org/index.php/Clickjacking_Defense_Cheat_Sheet)

#### :beginner: Prevent some categories of XSS attacks (X-XSS-Protection)

###### Rationale

  > Enable the cross-site scripting (XSS) filter built into modern web browsers.

###### Example

```bash
add_header X-XSS-Protection "1; mode=block" always
```

###### External resources

- [X-XSS-Protection HTTP Header](https://www.tunetheweb.com/security/http-security-headers/x-xss-protection/)

#### :beginner: Prevent Sniff Mimetype middleware (X-Content-Type-Options)

###### Rationale

  > It prevents the browser from doing MIME-type sniffing (prevents "mime" based attacks).

###### Example

```bash
add_header X-Content-Type-Options "nosniff" always;
```

###### External resources

- [X-Content-Type-Options HTTP Header](https://www.keycdn.com/support/x-content-type-options)

#### :beginner: Deny the use of browser features (Feature-Policy)

###### Rationale

  > This header protect your site from third parties using APIs that have security and privacy implications, and also from your own team adding outdated APIs or poorly optimized images.

###### Example

```bash
add_header Feature-Policy "geolocation none; midi none; notifications none; push none; sync-xhr none; microphone none; camera none; magnetometer none; gyroscope none; speaker none; vibrate none; fullscreen self; payment none; usb none;";
```

###### External resources

- [Feature Policy Explainer](https://docs.google.com/document/d/1k0Ua-ZWlM_PsFCFdLMa8kaVTo32PeNZ4G7FFHqpFx4E/edit)
- [Policy Controlled Features](https://github.com/w3c/webappsec-feature-policy/blob/master/features.md)

#### :beginner: Reject unsafe HTTP methods

###### Rationale

  > Set of methods support by a resource. An ordinary web server supports the HEAD, GET and POST methods to retrieve static and dynamic content. Other (e.g. OPTIONS, TRACE) methods should not be supported on public web servers, as they increase the attack surface.

###### Example

```bash
add_header Allow "GET, POST, HEAD" always;

if ( $request_method !~ ^(GET|POST|HEAD)$ ) {

  return 405;

}
```

###### External resources

- [Vulnerability name: Unsafe HTTP methods](https://www.onwebsecurity.com/security/unsafe-http-methods.html)

#### :beginner: Control Buffer Overflow attacks

###### Rationale

  > Buffer overflow attacks are made possible by writing data to a buffer and exceeding that buffers’ boundary and overwriting memory fragments of a process. To prevent this in nginx we can set buffer size limitations for all clients.

###### Example

```bash
client_body_buffer_size 100k;
client_header_buffer_size 1k;
client_max_body_size 100k;
large_client_header_buffers 2 1k;
```

###### External resources

- [SCG WS nginx](https://www.owasp.org/index.php/SCG_WS_nginx)

#### :beginner: Mitigating Slow HTTP DoS attack (Closing Slow Connections)

###### Rationale

  > Close connections that are writing data too infrequently, which can represent an attempt to keep connections open as long as possible.

###### Example

```bash
client_body_timeout 10s;
client_header_timeout 10s;
keepalive_timeout 5 5;
send_timeout 10;
```

###### External resources

- [Mitigating DDoS Attacks with NGINX and NGINX Plus](https://www.nginx.com/blog/mitigating-ddos-attacks-with-nginx-and-nginx-plus/)
- [SCG WS nginx](https://www.owasp.org/index.php/SCG_WS_nginx)
