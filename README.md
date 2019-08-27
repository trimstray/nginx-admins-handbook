<div align="center">
  <h1>Nginx Admin's Handbook</h1>
</div>

<div align="center">
  <b><code>My notes on NGINX administration basics, tips & tricks, caveats, and gotchas.</code></b>
</div>

<br>

<p align="center">
  <a href="https://www.hostingadvice.com/how-to/nginx-vs-apache/">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx_meme.png" alt="Meme">
  </a>
</p>

<br>

<p align="center">
  <sup>
    <i>
      Hi-diddle-diddle, he played on his<br>
      fiddle and danced with lady pigs.<br>
      Number three said, "Nicks on tricks!<br>
      I'll build my house with <b>EN-jin-EKS</b>!".<br>
      <a href="https://g.co/kgs/HCcQVz">The Three Little Pigs: Who's Afraid of the Big Bad Wolf?</a>
    </i>
  </sup>
</p>

<br>

<p align="center">
  <a href="https://github.com/trimstray/nginx-admins-handbook/pulls">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?longCache=true" alt="Pull Requests">
  </a>
  <a href="http://www.gnu.org/licenses/">
    <img src="https://img.shields.io/badge/License-GNU-blue.svg?longCache=true" alt="License">
  </a>
</p>

<div align="center">
  <sub>Created by
  <a href="https://twitter.com/trimstray">trimstray</a> and
  <a href="https://github.com/trimstray/nginx-admins-handbook/graphs/contributors">contributors</a>
</div>

<br>

****

# Table of Contents

- **[Introduction](#introduction)**
  * [Prologue](#prologue)
  * [Why I Create This Book](#why-i-create-this-book)
  * [Who This Book is For](#who-this-book-is-for)
  * [Before You Start](#before-you-start)
  * [Contributing & Support](#contributing--support)
  * [ToDo list](#todo-list)
- **[Extras](#extras)**
  * [Reports: blkcipher.info](#reports-blkcipherinfo)
    * [SSL Labs](#ssl-labs)
    * [Mozilla Observatory](#mozilla-observatory)
  * [Checklist to rule them all](#checklist-to-rule-them-all)
  * [Printable hardening cheatsheets](#printable-hardening-cheatsheets)
  * [Fully automatic installation](#fully-automatic-installation)
- **[Books](#books)**
  * [Nginx Essentials](#nginx-essentials)
  * [Nginx Cookbook](#nginx-cookbook)
  * [Nginx HTTP Server](#nginx-http-server)
  * [Nginx High Performance](#nginx-high-performance)
  * [Mastering Nginx](#mastering-nginx)
  * [ModSecurity 3.0 and NGINX: Quick Start Guide](#modsecurity-30-and-nginx-quick-start-guide)
  * [Cisco ACE to NGINX: Migration Guide](#cisco-ace-to-nginx-migration-guide)
- **[External Resources](#external-resources)**
  * [Nginx official](#nginx-official)
  * [Nginx distributions](#nginx-distributions)
  * [Comparison reviews](#comparison-reviews)
  * [Cheatsheets & References](#cheatsheets--references)
  * [Performance & Hardening](#performance--hardening)
  * [Presentations & Videos](#presentations--videos)
  * [Playgrounds](#playgrounds)
  * [Config generators](#config-generators)
  * [Static analyzers](#static-analyzers)
  * [Log analyzers](#log-analyzers)
  * [Performance analyzers](#performance-analyzers)
  * [Benchmarking tools](#benchmarking-tools)
  * [Debugging tools](#debugging-tools)
  * [Development](#development)
  * [Online tools](#online-tools)
  * [Other stuff](#other-stuff)
- **[HTTP Basics](#http-basics)**
  * [Features and architecture](#features-and-architecture)
  * [URI vs URL](#uri-vs-url)
  * [Request](#request)
    * [Request line](#request-line)
      * [Methods](#methods)
      * [Request URI](#request-uri)
      * [HTTP version](#http-version)
    * [Request header fields](#request-header-fields)
    * [Message body](#message-body)
    * [Generate requests](#generate-requests)
  * [Response](#response)
    * [Status line](#status-line)
      * [HTTP version](#http-version-1)
      * [Status codes and reason phrase](#status-codes-and-reason-phrase)
    * [Response header fields](#response-header-fields)
    * [Message body](#message-body-1)
- **[NGINX Basics](#nginx-basics)**
  * [Directories and files](#directories-and-files)
  * [Commands](#commands)
  * [Processes](#processes)
  * [Configuration syntax](#configuration-syntax)
    * [Comments](#comments)
    * [End of lines](#end-of-lines)
    * [Variables, Strings, and Quotes](#variables-strings-and-quotes)
    * [Directives, Blocks, and Contexts](#directives-blocks-and-contexts)
    * [External files](#external-files)
    * [Measurement units](#measurement-units)
    * [Enable syntax highlighting](#enable-syntax-highlighting)
  * [Connection processing](#connection-processing)
    * [Event-Driven architecture](#event-driven-architecture)
    * [Multiple processes](#multiple-processes)
    * [Simultaneous connections](#simultaneous-connections)
    * [HTTP Keep-Alive connections](#http-keep-alive-connections)
  * [Request processing stages](#request-processing-stages)
  * [Server blocks logic](#server-blocks-logic)
    * [Handle incoming connections](#handle-incoming-connections)
    * [Matching location](#matching-location)
    * [rewrite vs return](#rewrite-vs-return)
    * [try_files directive](#try_files-directive)
    * [if, break, and set](#if-break-and-set)
  * [Log files](#log-files)
    * [Conditional logging](#conditional-logging)
    * [Manually log rotation](#manually-log-rotation)
    * [Error log severity levels](#error-log-severity-levels)
  * [Reverse proxy](#reverse-proxy)
    * [Passing requests](#passing-requests)
    * [Trailing slashes](#trailing-slashes)
    * [Processing headers](#processing-headers)
    * [Passing headers](#passing-headers)
      * [Importance of the Host header](#importance-of-the-host-header)
      * [Redirects and X-Forwarded-Proto](#redirects-and-x-forwarded-proto)
      * [A warning about the X-Forwarded-For](#a-warning-about-the-x-forwarded-for)
      * [Improve extensibility with Forwarded](#improve-extensibility-with-forwarded)
  * [Load balancing algorithms](#load-balancing-algorithms)
    * [Backend parameters](#backend-parameters)
    * [Round Robin](#round-robin)
    * [Weighted Round Robin](#weighted-round-robin)
    * [Least Connections](#least-connections)
    * [Weighted Least Connections](#weighted-least-connections)
    * [IP Hash](#ip-hash)
    * [Generic Hash](#generic-hash)
    * [Other methods](#other-methods)
  * [Rate limiting](#rate-limiting)
    * [Variables](#variables)
    * [Directives, keys, and zones](#directives-keys-and-zones)
    * [Burst and nodelay parameters](#burst-and-nodelay-parameters)
- **[Helpers](#helpers)**
  * [Installing from prebuilt packages](#installing-from-prebuilt-packages)
    * [RHEL7 or CentOS 7](#rhel7-or-centos-7)
    * [Debian or Ubuntu](#debian-or-ubuntu)
  * [Installing from source](#installing-from-source)
    * [Automatic installation](#automatic-installation)
    * [Nginx package](#nginx-package)
    * [Dependencies](#dependencies)
    * [3rd party modules](#3rd-party-modules)
    * [Compiler and linker](#compiler-and-linker)
      * [Debugging Symbols](#debugging-symbols)
    * [SystemTap](#systemtap)
      * [stapxx](#stapxx)
    * [Installation Nginx on CentOS 7](#installation-nginx-on-centos-7)
      * [Pre installation tasks](#pre-installation-tasks)
      * [Dependencies](#dependencies)
      * [Get Nginx sources](#get-nginx-sources)
      * [Download 3rd party modules](#download-3rd-party-modules)
      * [Build Nginx](#build-nginx)
      * [Post installation tasks](#post-installation-tasks)
    * [Installation OpenResty on CentOS 7](#installation-openresty-on-centos-7)
    * [Installation Tengine on Ubuntu 18.04](#installation-tengine-on-ubuntu-1804)
  * [Analyse configuration](#analyse-configuration)
  * [Monitoring](#monitoring)
    * [GoAccess](#goaccess)
      * [Build and install](#build-and-install)
      * [Analyse log file and enable all recorded statistics](#analyse-log-file-and-enable-all-recorded-statistics)
      * [Analyse compressed log file](#analyse-compressed-log-file)
      * [Analyse log file remotely](#analyse-log-file-remotely)
      * [Analyse log file and generate html report](#analyse-log-file-and-generate-html-report)
    * [Ngxtop](#ngxtop)
      * [Analyse log file](#analyse-log-file)
      * [Analyse log file and print requests with 4xx and 5xx](#analyse-log-file-and-print-requests-with-4xx-and-5xx)
      * [Analyse log file remotely](#analyse-log-file-remotely-1)
  * [Testing](#testing)
    * [Send request and show response headers](#send-request-and-show-response-headers)
    * [Send request with http method, user-agent, follow redirects and show response headers](#send-request-with-http-method-user-agent-follow-redirects-and-show-response-headers)
    * [Send multiple requests](#send-multiple-requests)
    * [Testing SSL connection](#testing-ssl-connection)
    * [Testing SSL connection with SNI support](#testing-ssl-connection-with-sni-support)
    * [Testing SSL connection with specific SSL version](#testing-ssl-connection-with-specific-ssl-version)
    * [Testing SSL connection with specific cipher](#testing-ssl-connection-with-specific-cipher)
    * [Verify 0-RTT](#verify-0-rtt)
    * [Load testing with ApacheBench (ab)](#load-testing-with-apachebench-ab)
      * [Standard test](#standard-test)
      * [Test with Keep-Alive header](#test-with-keep-alive-header)
    * [Load testing with wrk2](#load-testing-with-wrk2)
      * [Standard scenarios](#standard-scenarios)
      * [POST call (with Lua)](#post-call-with-lua)
      * [Random paths (with Lua)](#random-paths-with-lua)
      * [Multiple paths (with Lua)](#multiple-paths-with-lua)
      * [Random server address to each thread (with Lua)](#random-server-address-to-each-thread-with-lua)
      * [Multiple json requests (with Lua)](#multiple-json-requests-with-lua)
      * [Debug mode (with Lua)](#debug-mode-with-lua)
      * [Analyse data pass to and from the threads](#analyse-data-pass-to-and-from-the-threads)
      * [Parsing wrk result and generate report](#parsing-wrk-result-and-generate-report)
    * [Load testing with locust](#load-testing-with-locust)
      * [Multiple paths](#multiple-paths)
      * [Multiple paths with different user sessions](#multiple-paths-with-different-user-sessions)
    * [TCP SYN flood Denial of Service attack](#tcp-syn-flood-denial-of-service-attack)
    * [HTTP Denial of Service attack](#tcp-syn-flood-denial-of-service-attack)
  * [Debugging](#debugging)
    * [Show information about processes](#show-information-about-nginx-processes)
    * [Check memory usage](#check-memoryusage)
    * [Show open files](#show-open-files)
    * [Dump configuration](#dump-configuration)
    * [Get the list of configure arguments](#get-the-list-of-configure-arguments)
    * [Check if the module has been compiled](#check-if-the-module-has-been-compiled)
    * [Show the most accessed IP addresses](#show-the-most-accessed-ip-addresses)
    * [Show the top 5 visitors (IP addresses)](#show-the-top-5-visitors-ip-addresses)
    * [Show the most requested urls](#show-the-most-requested-urls)
    * [Show the most requested urls containing 'string'](#show-the-most-requested-urls-containing-string)
    * [Show the most requested urls with http methods](#show-the-most-requested-urls-with-http-methods)
    * [Show the most accessed response codes](#show-the-most-accessed-response-codes)
    * [Analyse web server log and show only 2xx http codes](#analyse-web-server-log-and-show-only-2xx-http-codes)
    * [Analyse web server log and show only 5xx http codes](#analyse-web-server-log-and-show-only-5xx-http-codes)
    * [Show requests which result 502 and sort them by number per requests by url](#show-requests-which-result-502-and-sort-them-by-number-per-requests-by-url)
    * [Show requests which result 404 for php files and sort them by number per requests by url](#show-requests-which-result-404-for-php-files-and-sort-them-by-number-per-requests-by-url)
    * [Calculating amount of http response codes](#calculating-amount-of-http-response-codes)
    * [Calculating requests per second](#calculating-requests-per-second)
    * [Calculating requests per second with IP addresses](#calculating-requests-per-second-with-ip-addresses)
    * [Calculating requests per second with IP addresses and urls](#calculating-requests-per-second-with-ip-addresses-and-urls)
    * [Get entries within last n hours](#get-entries-within-last-n-hours)
    * [Get entries between two timestamps (range of dates)](#get-entries-between-two-timestamps-range-of-dates)
    * [Get line rates from web server log](#get-line-rates-from-web-server-log)
    * [Trace network traffic for all processes](#trace-network-traffic-for-all-nginx-processes)
    * [List all files accessed by a NGINX](#list-all-files-accessed-by-a-nginx)
    * [Check that the gzip_static module is working](#check-that-the-gzip_static-module-is-working)
    * [Which worker processing current request](#which-worker-processing-current-request)
    * [Capture only http packets](#capture-only-http-packets)
    * [Extract User Agent from the http packets](#extract-user-agent-from-the-http-packets)
    * [Capture only http GET and POST packets](#capture-only-http-get-and-post-packets)
    * [Capture requests and filter by source ip and destination port](#capture-requests-and-filter-by-source-ip-and-destination-port)
    * [Dump a process's memory](#dump-a-processs-memory)
    * [GNU Debugger (gdb)](#gnu-debugger-gdb)
      * [Dump configuration from a running process](#dump-configuration-from-a-running-process)
      * [Show debug log in memory](#show-debug-log-in-memory)
      * [Core dump backtrace](#core-dump-backtrace)
  * [Shell aliases](#shell-aliases)
  * [Configuration snippets](#configuration-snippets)
    * [Custom log formats](#custom-log-formats)
    * [Restricting access with basic authentication](#restricting-access-with-basic-authentication)
    * [Blocking/allowing IP addresses](#blockingallowing-ip-addresses)
    * [Blocking referrer spam](#blocking-referrer-spam)
    * [Limiting referrer spam](#limiting-referrer-spam)
    * [Limiting the rate of requests with burst mode](#limiting-the-rate-of-requests-with-burst-mode)
    * [Limiting the rate of requests with burst mode and nodelay](#limiting-the-rate-of-requests-with-burst-mode-and-nodelay)
    * [Limiting the number of connections](#limiting-the-number-of-connections)
    * [Adding and removing the www prefix](#adding-and-removing-the-www-prefix)
    * [Redirect POST request with payload to external endpoint](#redirect-post-request-with-payload-to-external-endpoint)
    * [Allow multiple cross-domains using the CORS headers](#allow-multiple-cross-domains-using-the-cors-headers)
    * [Set correct scheme passed in X-Forwarded-Proto](#set-correct-scheme-passed-in-x-forwarded-proto)
  * [Other snippets](#other-snippets)
    * [Create a temporary static backend](#create-a-temporary-static-backend)
    * [Create a temporary static backend with SSL support](#create-a-temporary-static-backend-with-ssl-support)
    * [Generate private key without passphrase](#generate-private-key-without-passphrase)
    * [Generate CSR](#generate-csr)
    * [Generate CSR (metadata from existing certificate)](#generate-csr-metadata-from-existing-certificate)
    * [Generate CSR with -config param](#generate-csr-with--config-param)
    * [Generate private key and CSR](#generate-private-key-and-csr)
    * [Generate ECDSA private key](#generate-ecdsa-private-key)
    * [Generate private key with CSR (ECC)](#generate-private-key-with-csr-ecc)
    * [Generate self-signed certificate](#generate-self-signed-certificate)
    * [Generate self-signed certificate from existing private key](#generate-self-signed-certificate-from-existing-private-key)
    * [Generate self-signed certificate from existing private key and csr](#generate-self-signed-certificate-from-existing-private-key-and-csr)
    * [Generate multidomain certificate](#generate-multidomain-certificate)
    * [Generate wildcard certificate](#generate-wildcard-certificate)
    * [Generate certificate with 4096 bit private key](#generate-certificate-with-4096-bit-private-key)
    * [Generate DH Param key](#generate-dh-param-key)
    * [Convert DER to PEM](#convert-der-to-pem)
    * [Convert PEM to DER](#convert-pem-to-der)
    * [Verification of the private key](#verification-of-the-private-key)
    * [Verification of the public key](#verification-of-the-public-key)
    * [Verification of the certificate](#verification-of-the-certificate)
    * [Verification of the CSR](#verification-of-the-csr)
    * [Check whether the private key and the certificate match](#check-whether-the-private-key-and-the-certificate-match)
- **[Base Rules (14)](#base-rules)**
  * [Organising Nginx configuration](#beginner-organising-nginx-configuration)
  * [Format, prettify and indent your Nginx code](#beginner-format-prettify-and-indent-your-nginx-code)
  * [Use reload option to change configurations on the fly](#beginner-use-reload-option-to-change-configurations-on-the-fly)
  * [Separate listen directives for 80 and 443](#beginner-separate-listen-directives-for-80-and-443)
  * [Define the listen directives explicitly with address:port pair](#beginner-define-the-listen-directives-explicitly-with-addressport-pair)
  * [Prevent processing requests with undefined server names](#beginner-prevent-processing-requests-with-undefined-server-names)
  * [Never use a hostname in a listen or upstream directives](#beginner-never-use-a-hostname-in-a-listen-or-upstream-directives)
  * [Use only one SSL config for the listen directive](#beginner-use-only-one-ssl-config-for-the-listen-directive)
  * [Use geo/map modules instead of allow/deny](#beginner-use-geomap-modules-instead-of-allowdeny)
  * [Map all the things...](#beginner-map-all-the-things)
  * [Set global root directory for unmatched locations](#beginner-set-global-root-directory-for-unmatched-locations)
  * [Use return directive for URL redirection (301, 302)](#beginner-use-return-directive-for-url-redirection-301-302)
  * [Configure log rotation policy](#beginner-configure-log-rotation-policy)
  * [Don't duplicate index directive, use it only in the http block](#beginner-dont-duplicate-index-directive-use-it-only-in-the-http-block)
- **[Debugging (4)](#debugging-1)**
  * [Use custom log formats](#beginner-use-custom-log-formats)
  * [Use debug mode to track down unexpected behaviour](#beginner-use-debug-mode-to-track-down-unexpected-behaviour)
  * [Disable daemon, master process, and all workers except one](#beginner-disable-daemon-master-process-and-all-workers-except-one)
  * [Use core dumps to figure out why NGINX keep crashing](#beginner-use-core-dumps-to-figure-out-why-nginx-keep-crashing)
- **[Performance (11)](#performance)**
  * [Adjust worker processes](#beginner-adjust-worker-processes)
  * [Use HTTP/2](#beginner-use-http2)
  * [Maintaining SSL sessions](#beginner-maintaining-ssl-sessions)
  * [Use exact names in a server_name directive where possible](#beginner-use-exact-names-in-a-server_name-directive-where-possible)
  * [Avoid checks server_name with if directive](#beginner-avoid-checks-server_name-with-if-directive)
  * [Use $request_uri to avoid using regular expressions](#beginner-use-request_uri-to-avoid-using-regular-expressions)
  * [Use try_files directive to ensure a file exists](#beginner-use-try_files-directive-to-ensure-a-file-exists)
  * [Use return directive instead of rewrite for redirects](#beginner-use-return-directive-instead-of-rewrite-for-redirects)
  * [Enable PCRE JIT to speed up processing of regular expressions](#beginner-enable-pcre-jit-to-speed-up-processing-of-regular-expressions)
  * [Make an exact location match to speed up the selection process](#beginner-make-an-exact-location-match-to-speed-up-the-selection-process)
  * [Use limit_conn to improve limiting the download speed](#beginner-use-limit_conn-to-improve-limiting-the-download-speed)
- **[Hardening (28)](#hardening)**
  * [Always keep NGINX up-to-date](#beginner-always-keep-nginx-up-to-date)
  * [Run as an unprivileged user](#beginner-run-as-an-unprivileged-user)
  * [Disable unnecessary modules](#beginner-disable-unnecessary-modules)
  * [Protect sensitive resources](#beginner-protect-sensitive-resources)
  * [Hide Nginx version number](#beginner-hide-nginx-version-number)
  * [Hide Nginx server signature](#beginner-hide-nginx-server-signature)
  * [Hide upstream proxy headers](#beginner-hide-upstream-proxy-headers)
  * [Force all connections over TLS](#beginner-force-all-connections-over-tls)
  * [Use only the latest supported OpenSSL version](#beginner-use-only-the-latest-supported-openssl-version)
  * [Use min. 2048-bit private keys](#beginner-use-min-2048-bit-private-keys)
  * [Keep only TLS 1.3 and TLS 1.2](#beginner-keep-only-tls-13-and-tls-12)
  * [Use only strong ciphers](#beginner-use-only-strong-ciphers)
  * [Use more secure ECDH Curve](#beginner-use-more-secure-ecdh-curve)
  * [Use strong Key Exchange](#beginner-use-strong-key-exchange)
  * [Prevent Replay Attacks on Zero Round-Trip Time](#beginner-prevent-replay-attacks-on-zero-round-trip-time)
  * [Defend against the BEAST attack](#beginner-defend-against-the-beast-attack)
  * [Mitigation of CRIME/BREACH attacks](#beginner-mitigation-of-crimebreach-attacks)
  * [HTTP Strict Transport Security](#beginner-http-strict-transport-security)
  * [Reduce XSS risks (Content-Security-Policy)](#beginner-reduce-xss-risks-content-security-policy)
  * [Control the behaviour of the Referer header (Referrer-Policy)](#beginner-control-the-behaviour-of-the-referer-header-referrer-policy)
  * [Provide clickjacking protection (X-Frame-Options)](#beginner-provide-clickjacking-protection-x-frame-options)
  * [Prevent some categories of XSS attacks (X-XSS-Protection)](#beginner-prevent-some-categories-of-xss-attacks-x-xss-protection)
  * [Prevent Sniff Mimetype middleware (X-Content-Type-Options)](#beginner-prevent-sniff-mimetype-middleware-x-content-type-options)
  * [Deny the use of browser features (Feature-Policy)](#beginner-deny-the-use-of-browser-features-feature-policy)
  * [Reject unsafe HTTP methods](#beginner-reject-unsafe-http-methods)
  * [Prevent caching of sensitive data](#beginner-prevent-caching-of-sensitive-data)
  * [Control Buffer Overflow attacks](#beginner-control-buffer-overflow-attacks)
  * [Mitigating Slow HTTP DoS attacks (Closing Slow Connections)](#beginner-mitigating-slow-http-dos-attacks-closing-slow-connections)
- **[Reverse Proxy (7)](#reverse-proxy-1)**
  * [Use pass directive compatible with backend protocol](#beginner-use-pass-directive-compatible-with-backend-protocol)
  * [Be careful with trailing slashes in proxy_pass directive](#beginner-be-careful-with-trailing-slashes-in-proxy_pass-directive)
  * [Set and pass Host header only with $host variable](#beginner-set-and-pass-host-header-only-with-host-variable)
  * [Set properly values of the X-Forwarded-For header](#beginner-set-properly-values-of-the-x-forwarded-for-header)
  * [Don't use X-Forwarded-Proto with $scheme behind reverse proxy](#beginner-dont-use-x-forwarded-proto-with-scheme-behind-reverse-proxy)
  * [Always pass Host, X-Real-IP, and X-Forwarded stack headers to the backend](#beginner-always-pass-host-x-real-ip-and-x-forwarded-stack-headers-to-the-backend)
  * [Use custom headers without X- prefix](#beginner-use-custom-headers-without-x--prefix)
- **[Load Balancing (2)](#load-balancing)**
  * [Tweak passive health checks](#beginner-tweak-passive-health-checks)
  * [Don't disable backends by comments, use down parameter](#beginner-dont-disable-backends-by-comments-use-down-parameter)
- **[Others (2)](#others)**
  * [Enable DNS CAA Policy](#beginner-enable-dns-caa-policy)
  * [Define security policies with security.txt](#beginner-define-security-policies-with-securitytxt)
- **[Configuration Examples](#configuration-examples)**
  * [Reverse Proxy](#reverse-proxy)
    * [Installation](#installation)
    * [Configuration](#configuration)
    * [Import configuration](#import-configuration)
    * [Set bind IP address](#set-bind-ip-address)
    * [Set your domain name](#set-your-domain-name)
    * [Regenerate private keys and certs](#regenerate-private-keys-and-certs)
    * [Update modules list](#update-modules-list)
    * [Generating the necessary error pages](#generating-the-necessary-error-pages)
    * [Add new domain](#add-new-domain)
    * [Test your configuration](#test-your-configuration)

# Introduction

<br>

<p align="center">
  <a href="https://www.nginx.com/">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx_admins_handbook_logo.png">
  </a>
</p>

<br>

  > Before you start playing with NGINX please read an official **[Beginner’s Guide](http://nginx.org/en/docs/beginners_guide.html)**. It's a great introduction for everyone.

**Nginx** (_/ˌɛndʒɪnˈɛks/ EN-jin-EKS_, stylized as NGINX or nginx) is an open source HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server. It is originally written by [Igor Sysoev](http://sysoev.ru/en/). For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. In the April 2019 NGINX was the most commonly used HTTP server (see [Netcraft survey](https://news.netcraft.com/archives/category/web-server-survey/)).

NGINX is a fast, light-weight and powerful web server that can also be used as a:

- fast HTTP reverse proxy
- reliable load balancer
- high performance caching server
- full-fledged web platform

Generally, it provides the core of complete web stacks and is designed to help build scalable web applications. When it comes to performance, NGINX can easily handle a huge amount of traffic. The other main advantage of the NGINX is that allows you to do the same thing in different ways.

For me, it is a one of the best and most important service that I used in my SysAdmin career.

----

These essential documents should be the main source of knowledge for you:

- **[Getting Started](https://www.nginx.com/resources/wiki/start/)**
- **[NGINX Documentation](https://nginx.org/en/docs/)**
- **[Development guide](http://nginx.org/en/docs/dev/development_guide.html)**

In addition, I would like to recommend two great docs focuses on the concept of the HTTP protocol:

- **[HTTP Made Really Easy](https://www.jmarshall.com/easy/http/)**
- **[Hypertext Transfer Protocol Specification](https://www.w3.org/Protocols/)**

If you love security keep your eye on this one: [Cryptology ePrint Archive](https://eprint.iacr.org/). It provides access to recent research in cryptology and explores many subjects of security (e.g. Ciphers, Algorithms, SSL/TLS protocols).

## Prologue

When I was studying architecture of HTTP servers I became interested in NGINX. I found a lot of information about it but I've never found one guide that covers the most important things in a suitable form. I was a little disappointed.

I was interested in everything: NGINX internals, functions, security best practices, performance optimisations, tips & tricks, hacks and rules, but for me all documents treated the subject lightly.

Of course, [Official Documentation](https://nginx.org/en/docs/) is the best place but I know that we also have other great resources:

- [agentzh's Nginx Tutorials](https://openresty.org/download/agentzh-nginx-tutorials-en.html)
- [Nginx Guts](http://www.nginxguts.com/)
- [Nginx discovery journey](http://www.nginx-discovery.com/)
- [Emiller’s Guide To Nginx Module Development](https://www.evanmiller.org/nginx-modules-guide.html)
- [Emiller’s Advanced Topics In Nginx Module Development](https://www.evanmiller.org/nginx-modules-guide-advanced.html)

These are definitely the best assets for us and in the first place you should seek help there.

## Why I Create This Book

For me, however, there hasn't been a truly in-depth and reasonably simple cheatsheet which describe a variety of configurations and important cross-cutting topics for HTTP servers. I think, the configuration you provided should work without any talisman. That's why I created this repository.

  > This handbook is a collection of rules, helpers, notes, papers, best practices, and recommendations gathered and used by me (also in production environments). Many of them refer to external resources.

There are a lot of things you can do to improve NGINX server and this guide will attempt to cover as many of them as possible.

Throughout this handbook you will explore the many features and capabilities of the NGINX. You'll find out, for example, how to testing the performance or how to resolve debugging problems. You will learn configuration guidelines, security design patterns, ways to handle common issues and how to stay out of them. I explained here are few best tips to avoid pitfails and configuration mistakes.

In this handbook I added set of guidelines and examples has also been produced to help you administer of the NGINX. They give us insight into NGINX internals also.

Mostly, I apply the rules presented here on the NGINX working as a reverse proxy. However, does not to prevent them being implemented for NGINX as a standalone server.

## Who This Book is For

If you do not have the time to read hundreds of articles (just like me) this multipurpose handbook may be useful. I created it in the hope that it will be useful especially for System Administrators and Experts of web-based applications. I think it can also be a good complement to official documentation.

I did my best to make this handbook a single and consistent. Is organized in an order that makes logical sense to me. Of course, I still have a lot [to improve and to do](#todo-list). I hope you enjoy it, and fun with it.

## Before You Start

Remember about the following most important things:

  > **`Do not follow guides just to get 100% of something. Think about what you actually do at your server!`**

  > **`There are no settings that are perfect for everyone.`**

  > **`The only correct approach is to understand your exposure, measure and tune.`**

  > **`These guidelines provides (in some places) recommendations for very restrictive setup.`**

## Contributing & Support

  > _A real community, however, exists only when its members interact in a meaningful way that deepens their understanding of each other and leads to learning._

If you find something which doesn't make sense, or something doesn't seem right, please make a pull request and please add valid and well-reasoned explanations about your changes or comments.

Before adding a pull request, please see the **[contributing guidelines](CONTRIBUTING.md)**.

If this project is useful and important for you, you can bring **positive energy** by giving some **good words** or **supporting this project**. Thank you!

## ToDo list

New chapters:

- [x] **Extras**
- [x] **Reverse Proxy**
- [ ] **Caching**
- [ ] **3rd party modules**
- [ ] **Web Application Firewall**
- [ ] **ModSecurity**
- [x] **Debugging**

Existing chapters:

<details>
<summary><b>Introduction</b></summary><br>

  - [x] _Prologue_
  - [x] _Why I Create This Book_
  - [x] _Who This Book is For_
  - [x] _Before You Start_
  - [x] _ToDo list_

</details>

<details>
<summary><b>Extras</b></summary><br>

  - [x] _Checklist to rule them all_
  - [x] _Fully automatic installation_

</details>

<details>
<summary><b>Books</b></summary><br>

  - [x] _ModSecurity 3.0 and NGINX: Quick Start Guide_
  - [x] _Cisco ACE to NGINX: Migration Guide_

</details>

<details>
<summary><b>External Resources</b></summary><br>

  - _Nginx official_
    - [x] _Nginx Forum_
    - [x] _Nginx Mailing List_
    - [x] _NGINX-Demos_
  - _Presentations & Videos_
    - [x] _NGINX: Basics and Best Practices_
    - [x] _NGINX Installation and Tuning_
    - [x] _Nginx Internals (by Joshua Zhu)_
    - [x] _Nginx internals (by Liqiang Xu)_
    - [x] _How to secure your web applications with NGINX_
    - [x] _Tuning TCP and NGINX on EC2_
    - [x] _Extending functionality in nginx, with modules!_
    - [x] _Nginx - Tips and Tricks._
    - [x] _Nginx Scripting - Extending Nginx Functionalities with Lua_
    - [x] _How to handle over 1,200,000 HTTPS Reqs/Min_
    - [x] _Using ngx_lua / lua-nginx-module in pixiv_
  - _Static analyzers_
    - [x] _nginx-minify-conf_
  - _Comparison reviews_
    - [x] _NGINX vs. Apache (Pro/Con Review, Uses, & Hosting for Each)_
    - [x] _Web cache server performance benchmark: nuster vs nginx vs varnish vs squid_
  - _Benchmarking tools_
    - [x] _wrk2_
    - [x] _httperf_
    - [x] _slowloris_
    - [x] _slowhttptest_
    - [x] _GoldenEye_
  - _Debugging tools_
    - [x] _strace_
    - [x] _GDB_
    - [x] _SystemTap_
    - [x] _stapxx_
    - [x] _htrace.sh_
  - _Other stuff_
    - [x] _OWASP Cheat Sheet Series_
    - [x] _Mozilla Web Security_
    - [x] _Application Security Wiki_
    - [x] _OWASP ASVS 4.0_

</details>

<details>
<summary><b>HTTP Basics</b></summary><br>

  - [x] _Features and architecture_
  - [x] _URI vs URL_
  - [x] _Request_
    - [x] _Request line_
      - [x] _Methods_
      - [x] _Request URI_
      - [x] _HTTP version_
    - [x] _Request header fields_
    - [x] _Message body_
    - [x] _Generate requests_
  - [x] _Response_
    - [x] _Status line_
      - [x] _HTTP version_
      - [x] _Status codes and reason phrase_
    - [x] _Response header fields_
    - [x] _Message body_

</details>

<details>
<summary><b>NGINX Basics</b></summary><br>

  - _Server blocks logic_
    - [x] _rewrite vs return_
    - [x] _try_files directive_
    - [x] _if, break and set_
  - _Log files_
    - [x] _Conditional logging_
    - [x] _Manually log rotation_
  - _Configuration syntax_
    - [x] _Comments_
    - [x] _End of lines_
    - [x] _Variables, Strings, and Quotes_
    - [x] _Directives, Blocks, and Contexts_
    - [x] _External files_
    - [x] _Measurement units_
    - [x] _Enable syntax highlighting_
  - _Connection processing_
    - [x] _Event-Driven architecture_
    - [x] _Multiple processes_
    - [x] _Simultaneous connections_
    - [x] _HTTP Keep-Alive connections_
  - _Reverse proxy_
    - [x] _Passing requests_
    - [x] _Trailing slashes_
    - [x] _Processing headers_
    - [x] _Passing headers_
      - [x] _Importance of the Host header_
      - [x] _Redirects and X-Forwarded-Proto_
      - [x] _A warning about the X-Forwarded-For_
      - [x] _Improve extensibility with Forwarded_
  - _Load balancing algorithms_
    - [x] _Backend parameters_
    - [x] _Round Robin_
    - [x] _Weighted Round Robin_
    - [x] _Least Connections_
    - [x] _Weighted Least Connections_
    - [x] _IP Hash_
    - [x] _Generic Hash_
    - [ ] _Fair module_
    - [x] _Other methods_
  - _Rate Limiting_
    - [x] _Variables_
    - [x] _Directives, keys, and zones_
    - [x] _Burst and nodelay parameters_

</details>

<details>
<summary><b>Helpers</b></summary><br>

  - _Installing from source_
    - [x] _Add autoinstaller for RHEL/Debian like distributions_
    - [x] _Add compiler and linker options_
      - [x] _Debugging Symbols_
    - [x] _Add SystemTap - Real-time analysis and diagnoistcs tools_
    - [x] _Separation and improvement of installation methods_
    - [x] _Add installation process on CentOS 7 for NGINX_
    - [x] _Add installation process on CentOS 7 for OpenResty_
    - [ ] _Add installation process on FreeBSD 11.2_
  - _Monitoring_
    - [ ] _CollectD, Prometheus, and Grafana_
      - [ ] _nginx-vts-exporter_
    - [ ] _CollectD, InfluxDB, and Grafana_
    - [ ] _Telegraf, InfluxDB, and Grafana_
  - _Testing_
    - [x] _Send request and show response headers_
    - [x] _Send request with http method, user-agent, follow redirects and show response headers_
    - [x] _Send multiple requests_
    - [x] _Testing SSL connection_
    - [x] _Testing SSL connection with SNI support_
    - [x] _Testing SSL connection with specific SSL version_
    - [x] _Testing SSL connection with specific cipher_
    - [x] _Verify 0-RTT_
    - _Load testing with ApacheBench (ab)_
      - [x] _Standard test_
      - [x] _Test with Keep-Alive header_
    - _Load testing with wrk2_
      - [x] _Standard scenarios_
      - [x] _POST call (with Lua)_
      - [x] _Random paths (with Lua)_
      - [x] _Multiple paths (with Lua)_
      - [x] _Random server address to each thread (with Lua)_
      - [x] _Multiple json requests (with Lua)_
      - [x] _Debug mode (with Lua)_
      - [x] _Analyse data pass to and from the threads_
      - [x] _Parsing wrk result and generate report_
    - _Load testing with locust_
      - [x] _Multiple paths_
      - [x] _Multiple paths with different user sessions_
    - [x] _TCP SYN flood Denial of Service attack_
    - [x] _HTTP Denial of Service attack_
  - _Debugging_
    - [x] _Show information about processes_
    - [x] _Check memory usage_
    - [x] _Show open files_
    - [x] _Dump configuration_
    - [x] _Get the list of configure arguments_
    - [x] _Check if the module has been compiled_
    - [x] _Show the most requested urls with http methods_
    - [x] _Show the most accessed response codes_
    - [x] _Calculating requests per second with IP addresses and urls_
    - [x] _Check that the gzip_static module is working_
    - [x] _Which worker processing current request_
    - [x] _Capture only http packets_
    - [x] _Extract User Agent from the http packets_
    - [x] _Capture only http GET and POST packets_
    - [x] _Capture requests and filter by source ip and destination port_
    - [x] _Dump a process's memory_
    - _GNU Debugger (gdb)_
      - [x] _Dump configuration from a running process_
      - [x] _Show debug log in memory_
      - [x] _Core dump backtrace_
    - _SystemTap cheatsheet_
      - [x] _stapxx_
  - _Errors & Issues_
    - [ ] _Common errors_
  - _Configuration snippets_
    - [x] _Custom log formats_
    - [ ] _Custom error pages_
    - [x] _Adding and removing the www prefix_
    - [x] _Redirect POST request with payload to external endpoint_
    - [x] _Allow multiple cross-domains using the CORS headers_
    - [x] _Set correct scheme passed in X-Forwarded-Proto_
    - [ ] _Tips and methods for high load traffic testing (cheatsheet)_
    - [ ] _Location matching examples_
    - [ ] _Passing requests to the backend_
      - [ ] _The HTTP backend server_
      - [ ] _The uWSGI backend server_
      - [ ] _The FastCGI backend server_
      - [ ] _The memcached backend server_
      - [ ] _The Redis backend server_
    - [ ] _Lua snippets_
    - [ ] _nginscripts snippets_
  - _Other snippets_
    - [x] _Create a temporary static backend_
    - [x] _Create a temporary static backend with SSL support_
    - [x] _Generate private key without passphrase_
    - [x] _Generate CSR_
    - [x] _Generate CSR (metadata from existing certificate)_
    - [x] _Generate CSR with -config param_
    - [x] _Generate private key and CSR_
    - [x] _Generate ECDSA private key_
    - [x] _Generate private key with CSR (ECC)_
    - [x] _Generate self-signed certificate_
    - [x] _Generate self-signed certificate from existing private key_
    - [x] _Generate self-signed certificate from existing private key and csr_
    - [x] _Generate multidomain certificate_
    - [x] _Generate wildcard certificate_
    - [x] _Generate certificate with 4096 bit private key_
    - [x] _Generate DH Param key_
    - [x] _Convert DER to PEM_
    - [x] _Convert PEM to DER_
    - [x] _Verification of the private key_
    - [x] _Verification of the public key_
    - [x] _Verification of the certificate_
    - [x] _Verification of the CSR_
    - [x] _Check whether the private key and the certificate match_

</details>

<details>
<summary><b>Base Rules</b></summary><br>

  - [x] _Format, prettify and indent your Nginx code_
  - [x] _Never use a hostname in a listen or upstream directives_
  - [ ] _Making a rewrite absolute (with scheme)_
  - [x] _Use return directive for URL redirection (301, 302)_
  - [x] _Configure log rotation policy_
  - [x] _Don't duplicate index directive, use it only in the http block_

</details>

<details>
<summary><b>Debugging</b></summary><br>

  - [x] _Disable daemon, master process, and all workers except one_
  - [x] _Use core dumps to figure out why NGINX keep crashing_
  - [ ] _Use mirror module to copy requests to another backend_
  - [ ] _Dynamic debugging with echo module_

</details>

<details>
<summary><b>Performance</b></summary><br>

  - [ ] _Avoid multiple index directives_
  - [x] _Use $request_uri to avoid using regular expressions_
  - [x] _Use try_files directive to ensure a file exists_
  - [ ] _Don't pass all requests to the backend - use try_files_
  - [x] _Use return directive instead of rewrite for redirects_
  - [x] _Enable PCRE JIT to speed up processing of regular expressions_
  - [ ] _Set proxy timeouts for normal load and under heavy load_
  - [ ] _Configure kernel parameters for high load traffic_

</details>

<details>
<summary><b>Hardening</b></summary><br>

  - [x] _Keep NGINX up-to-date_
  - [x] _Use only the latest supported OpenSSL version_
  - [x] _Prevent Replay Attacks on Zero Round-Trip Time_
  - [ ] _Enable OCSP Stapling_
  - [x] _Prevent caching of sensitive data_
  - [ ] _Set properly files and directories permissions (also with acls) on a paths_
  - [ ] _Implement HTTPOnly and secure attributes on cookies_

</details>

<details>
<summary><b>Reverse Proxy</b></summary><br>

  - [x] _Use pass directive compatible with backend protocol_
  - [x] _Be careful with trailing slashes in proxy_pass directive_
  - [x] _Set and pass Host header only with $host variable_
  - [x] _Set properly values of the X-Forwarded-For header_
  - [x] _Don't use X-Forwarded-Proto with $scheme behind reverse proxy_
  - [x] _Always pass Host, X-Real-IP, and X-Forwarded stack headers to the backend_
  - [x] _Use custom headers without X- prefix_
  - [ ] _Set proxy buffers and timeouts_

</details>

<details>
<summary><b>Others</b></summary><br>

  - [x] _Define security policies with security.txt_

</details>

Other stuff:

  - [x] _Add static error pages generator to the NGINX snippets directory_

# Extras

## Reports: blkcipher.info

Many of these recipes have been applied to the configuration of my private website.

  > An example configuration is in [configuration examples](#configuration-examples) chapter. It's also based on [this](https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/cheatsheets/nginx-hardening-cheatsheet-tls13.png) version of printable high-res hardening cheatsheets.

### SSL Labs

  > Read about SSL Labs grading [here](https://community.qualys.com/docs/DOC-6321-ssl-labs-grading-2018) (SSL Labs Grading 2018).

Short SSL Labs grades explanation:

  > _A+ is clearly the desired grade, both A and B grades are acceptable and result in adequate commercial security. The B grade, in particular, may be applied to configurations designed to support very wide audiences (for old clients)_.

I finally got **A+** grade and following scores:

- Certificate = **100%**
- Protocol Support = **100%**
- Key Exchange = **90%**
- Cipher Strength = **90%**

<p align="center">
  <a href="https://www.ssllabs.com/ssltest/analyze.html?d=blkcipher.info&hideResults=on">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/blkcipher_ssllabs_preview.png" alt="blkcipher_ssllabs_preview">
  </a>
</p>

### Mozilla Observatory

  > Read about Mozilla Observatory [here](https://observatory.mozilla.org/faq/).

I also got the highest note on the Observatory:

<p align="center">
  <a href="https://observatory.mozilla.org/analyze/blkcipher.info?third-party=false">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/blkcipher_mozilla_observatory_preview.png" alt="blkcipher_mozilla_observatory_preview">
  </a>
</p>

## Checklist to rule them all

  > This checklist contains all rules (68) from this handbook.

Generally, I think that each of these principles is important and should be considered. I tried, however, to separate them into four levels of priority which I hope will help guide your decision.

| <b>PRIORITY</b> | <b>NAME</b> | <b>AMOUNT</b> | <b>DESCRIPTION</b> |
| :---:        | :---         | :---:        | :---         |
| ![high](static/img/priorities/high.png) | <i>critical</i> | 28 | definitely use this rule, otherwise it will introduce high risks of your NGINX security, performance, and other |
| ![medium](static/img/priorities/medium.png) | <i>major</i> | 21 | it's also very important but not critical, and should still be addressed at the earliest possible opportunity |
| ![low](static/img/priorities/low.png) | <i>normal</i> | 12 | there is no need to implement but it is worth considering because it can improve the NGINX working and functions |
| ![info](static/img/priorities/info.png) | <i>minor</i> | 6 | as an option to implement or use (not required) |

Remember, these are only guidelines. My point of view may be different from yours so if you feel these priority levels do not reflect your configurations commitment to security, performance or whatever else, you should adjust them as you see fit.

| <b>RULE</b> | <b>CHAPTER</b> | <b>PRIORITY</b> |
| :---         | :---         | :---:        |
| [Define the listen directives explicitly with address:port pair](#beginner-define-the-listen-directives-explicitly-with-addressport-pair)<br><sup>Prevents soft mistakes which may be difficult to debug.</sup> | Base Rules | ![high](static/img/priorities/high.png) |
| [Prevent processing requests with undefined server names](#beginner-prevent-processing-requests-with-undefined-server-names)<br><sup>It protects against configuration errors, e.g. traffic forwarding to incorrect backends.</sup> | Base Rules | ![high](static/img/priorities/high.png) |
| [Never use a hostname in a listen or upstream directives](#beginner-never-use-a-hostname-in-a-listen-or-upstream-directives)<br><sup>While this may work, it will come with a large number of issues.</sup> | Base Rules | ![high](static/img/priorities/high.png) |
| [Configure log rotation policy](#beginner-configure-log-rotation-policy)<br><sup>Save yourself trouble with your web server: configure appropriate logging policy.</sup> | Base Rules | ![high](static/img/priorities/high.png) |
| [Use HTTP/2](#beginner-use-http2)<br><sup>HTTP/2 will make our applications faster, simpler, and more robust.</sup> | Performance | ![high](static/img/priorities/high.png) |
| [Enable PCRE JIT to speed up processing of regular expressions](#beginner-enable-pcre-jit-to-speed-up-processing-of-regular-expressions)<br><sup>NGINX with PCRE JIT is much faster than without it.</sup> | Performance | ![high](static/img/priorities/high.png) |
| [Always keep NGINX up-to-date](#always-keep-nginx-up-to-date)<br><sup>Use newest NGINX package to fix vulnerabilities, bugs, and to use new features.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Run as an unprivileged user](#beginner-run-as-an-unprivileged-user)<br><sup>Use the principle of least privilege. This way only master process runs as root.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Protect sensitive resources](#beginner-protect-sensitive-resources)<br><sup>Hidden directories and files should never be web accessible.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Hide upstream proxy headers](#beginner-hide-upstream-proxy-headers)<br><sup>Don't expose what version of software is running on the server.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Force all connections over TLS](#beginner-force-all-connections-over-tls)<br><sup>Protects your website especially for handle sensitive communications.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Use min. 2048-bit private keys](#beginner-use-min-2048-bit-private-keys)<br><sup>2048 bits private keys are sufficient for commercial use.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Keep only TLS 1.3 and TLS 1.2](#beginner-keep-only-tls-13-and-tls-12)<br><sup>Use TLS with modern cryptographic algorithms and without protocol weaknesses.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Use only strong ciphers](#beginner-use-only-strong-ciphers)<br><sup>Use only strong and not vulnerable cipher suites.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Use more secure ECDH Curve](#beginner-use-more-secure-ecdh-curve)<br><sup>Use ECDH Curves with according to NIST recommendations.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Use strong Key Exchange](#beginner-use-strong-key-exchange)<br><sup>Establishes a shared secret between two parties that can be used for secret communication.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Defend against the BEAST attack](#beginner-defend-against-the-beast-attack)<br><sup>The server ciphers should be preferred over the client ciphers.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [HTTP Strict Transport Security](#beginner-http-strict-transport-security)<br><sup>Tells browsers that it should only be accessed using HTTPS, instead of using HTTP.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Reduce XSS risks (Content-Security-Policy)](#beginner-reduce-xss-risks-content-security-policy)<br><sup>CSP is best used as defence-in-depth. It reduces the harm that a malicious injection can cause.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Control the behaviour of the Referer header (Referrer-Policy)](#beginner-control-the-behaviour-of-the-referer-header-referrer-policy)<br><sup>The default behaviour of referrer leaking puts websites at risk of privacy and security breaches.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Provide clickjacking protection (X-Frame-Options)](#beginner-provide-clickjacking-protection-x-frame-options)<br><sup>Defends against clickjacking attack.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Prevent some categories of XSS attacks (X-XSS-Protection)](#beginner-prevent-some-categories-of-xss-attacks-x-xss-protection)<br><sup>Prevents to render pages if a potential XSS reflection attack is detected.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Prevent Sniff Mimetype middleware (X-Content-Type-Options)](#beginner-prevent-sniff-mimetype-middleware-x-content-type-options)<br><sup>Tells browsers not to sniff MIME types.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Reject unsafe HTTP methods](#beginner-reject-unsafe-http-methods)<br><sup>Only allow the HTTP methods for which you, in fact, provide services.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Prevent caching of sensitive data](#beginner-prevent-caching-of-sensitive-data)<br><sup>It helps to prevent critical data (e.g. credit card details, or username) leaked.</sup> | Hardening | ![high](static/img/priorities/high.png) |
| [Use pass directive compatible with backend protocol](#beginner-use-pass-directive-compatible-with-backend-protocol)<br><sup>Set pass directive only to working with compatible backend layer protocol.</sup> | Reverse Proxy | ![high](static/img/priorities/high.png) |
| [Set properly values of the X-Forwarded-For header](#beginner-set-properly-values-of-the-x-forwarded-for-header)<br><sup>Identify clients communicating with servers located behind the proxy.</sup> | Reverse Proxy | ![high](static/img/priorities/high.png) |
| [Don't use X-Forwarded-Proto with $scheme behind reverse proxy](#beginner-dont-use-x-forwarded-proto-with-scheme-behind-reverse-proxy)<br><sup>Prevent pass incorrect value of this header.</sup> | Reverse Proxy | ![high](static/img/priorities/high.png) |
| [Organising Nginx configuration](#beginner-organising-nginx-configuration)<br><sup>Well organised code is easier to understand and maintain.</sup> | Base Rules | ![medium](static/img/priorities/medium.png) |
| [Format, prettify and indent your Nginx code](#beginner-format-prettify-and-indent-your-nginx-code)<br><sup>Formatted code is easier to maintain, debug, and can be read and understood in a short amount of time.</sup> | Base Rules | ![medium](static/img/priorities/medium.png) |
| [Use reload option to change configurations on the fly](#beginner-use-reload-option-to-change-configurations-on-the-fly)<br><sup>Graceful reload of the configuration without stopping the server and dropping any packets.</sup> | Base Rules | ![medium](static/img/priorities/medium.png) |
| [Use return directive for URL redirection (301, 302)](#beginner-use-return-directive-for-url-redirection-301-302)<br><sup>The by far simplest and fastest because there is no regexp that has to be evaluated.</sup> | Base Rules | ![medium](static/img/priorities/medium.png) |
| [Maintaining SSL sessions](#beginner-maintaining-ssl-sessions)<br><sup>Improves performance from the clients’ perspective.</sup> | Performance | ![medium](static/img/priorities/medium.png) |
| [Use exact names in a server_name directive where possible](#beginner-use-exact-names-in-a-server_name-directive-where-possible)<br><sup>Helps speed up searching using exact names.</sup> | Performance | ![medium](static/img/priorities/medium.png) |
| [Avoid checks server_name with if directive](#beginner-avoid-checks-server_name-with-if-directive)<br><sup>It decreases NGINX processing requirements.</sup> | Performance | ![medium](static/img/priorities/medium.png) |
| [Use $request_uri to avoid using regular expressions](#beginner-use-request_uri-to-avoid-using-regular-expressions)<br><sup>By default, the regex is costly and will slow down the performance.</sup> | Performance | ![medium](static/img/priorities/medium.png) |
| [Use try_files directive to ensure a file exists](#beginner-use-try_files-directive-to-ensure-a-file-exists)<br><sup>Use it if you need to search for a file, it saving duplication of code also.</sup> | Performance | ![medium](static/img/priorities/medium.png) |
| [Use return directive instead of rewrite for redirects](#beginner-use-return-directive-instead-of-rewrite-for-redirects)<br><sup>Use return directive to more speedy response than rewrite.</sup> | Performance | ![medium](static/img/priorities/medium.png) |
| [Disable unnecessary modules](#beginner-disable-unnecessary-modules)<br><sup>Limits vulnerabilities, improve performance and memory efficiency.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Hide Nginx version number](#beginner-hide-nginx-version-number)<br><sup>Don't disclose sensitive information about NGINX.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Hide Nginx server signature](#beginner-hide-nginx-server-signature)<br><sup>Don't disclose sensitive information about NGINX.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Use only the latest supported OpenSSL version](#beginner-use-only-the-latest-supported-openssl-version)<br><sup>Stay protected from SSL security threats and don't miss out new features.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Prevent Replay Attacks on Zero Round-Trip Time](#beginner-prevent-replay-attacks-on-zero-round-trip-time)<br><sup>0-RTT is disabled by default but you should know that enabling this option creates a significant security risks.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Mitigation of CRIME/BREACH attacks](#beginner-mitigation-of-crimebreach-attacks)<br><sup>Disable HTTP compression or compress only zero sensitive content.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Deny the use of browser features (Feature-Policy)](#beginner-deny-the-use-of-browser-features-feature-policy)<br><sup>A mechanism to allow and deny the use of browser features.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Control Buffer Overflow attacks](#beginner-control-buffer-overflow-attacks)<br><sup>Prevents errors are characterised by the overwriting of memory fragments of the NGINX process.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Mitigating Slow HTTP DoS attacks (Closing Slow Connections)](#beginner-mitigating-slow-http-dos-attack-closing-slow-connections)<br><sup>Prevents attacks in which the attacker sends HTTP requests in pieces slowly.</sup> | Hardening | ![medium](static/img/priorities/medium.png) |
| [Set and pass Host header only with $host variable](#beginner-set-and-pass-host-header-only-with-host-variable)<br><sup>Use of the $host is the only one guaranteed to have something sensible.</sup> | Reverse Proxy | ![medium](static/img/priorities/medium.png) |
| [Always pass Host, X-Real-IP, and X-Forwarded stack headers to the backend](beginner-always-pass-host-x-real-ip-and-x-forwarded-stack-headers-to-the-backend)<br><sup>It gives you more control of forwarded headers.</sup> | Reverse Proxy | ![medium](static/img/priorities/medium.png) |
| [Enable DNS CAA Policy](#beginner-enable-dns-caa-policy)<br><sup>Allows domain name holders to indicate to CA whether they are authorized to issue digital certificates.</sup> | Others | ![medium](static/img/priorities/medium.png) |
| [Separate listen directives for 80 and 443](#beginner-separate-listen-directives-for-80-and-443)<br><sup>Help you maintain and modify your configuration.</sup> | Base Rules | ![low](static/img/priorities/low.png) |
| [Use only one SSL config for the listen directive](#beginner-use-only-one-ssl-config-for-the-listen-directive)<br><sup>The most of the SSL changes will affect only the default server.</sup> | Base Rules | ![low](static/img/priorities/low.png) |
| [Use geo/map modules instead of allow/deny](#beginner-use-geomap-modules-instead-of-allowdeny)<br><sup>Provides the perfect way to block invalid visitors.</sup> | Base Rules | ![low](static/img/priorities/low.png) |
| [Set global root directory for unmatched locations](#beginner-set-global-root-directory-for-unmatched-locations)<br><sup>Specifies the root directory for an undefined locations.</sup> | Base Rules | ![low](static/img/priorities/low.png) |
| [Don't duplicate index directive, use it only in the http block](#beginner-dont-duplicate-index-directive-use-it-only-in-the-http-block)<br><sup>Watch out for duplicating the same rules.</sup> | Base Rules | ![low](static/img/priorities/low.png) |
| [Adjust worker processes](#beginner-adjust-worker-processes)<br><sup>You can adjust this value to maximum throughput under high concurrency.</sup> | Performance | ![low](static/img/priorities/low.png) |
| [Make an exact location match to speed up the selection process](#beginner-make-an-exact-location-match-to-speed-up-the-selection-process)<br><sup>Exact location matches are often used to speed up the selection process.</sup> | Performance | ![low](static/img/priorities/low.png) |
| [Use limit_conn to improve limiting the download speed](#beginner-use-limit_conn-to-improve-limiting-the-download-speed) | Performance | ![low](static/img/priorities/low.png) |
| [Be careful with trailing slashes in proxy_pass directive](#beginner-be-careful-with-trailing-slashes-in-proxy_pass-directive)<br><sup>Incorrect setting could end up with some strange url.</sup> | Reverse Proxy | ![low](static/img/priorities/low.png) |
| [Use custom headers without X- prefix](#beginner-use-custom-headers-without-x--prefix)<br><sup>The use of custom headers with X- prefix is discouraged.</sup> | Reverse Proxy | ![low](static/img/priorities/low.png) |
| [Tweak passive health checks](#beginner-tweak-passive-health-checks)<br><sup>Improve behaviour of the passive health checks.</sup> | Load Balancing | ![low](static/img/priorities/low.png) |
| [Define security policies with security.txt](#beginner-define-security-policies-with-securitytxt)<br><sup>Helps make things easier for companies and security researchers.</sup> | Others | ![low](static/img/priorities/low.png) |
| [Map all the things...](#beginner-map-all-the-things)<br><sup>Map module provides a more elegant solution for clearly parsing a big list of regexes.</sup> | Base Rules | ![info](static/img/priorities/info.png) |
| [Use custom log formats](#beginner-use-custom-log-formats)<br><sup>This is extremely helpful for debugging specific location directives.</sup> | Debugging | ![info](static/img/priorities/info.png) |
| [Use debug mode to track down unexpected behaviour](#beginner-use-debug-mode-to-track-down-unexpected-behaviour)<br><sup>There's probably more detail than you want, but that can sometimes be a lifesaver.</sup> | Debugging | ![info](static/img/priorities/info.png) |
| [Disable daemon, master process, and all workers except one](#beginner-disable-daemon-master-process-and-all-workers-except-one)<br><sup>This simplifies the debugging and lets test configurations rapidly.</sup> | Debugging | ![info](static/img/priorities/info.png) |
| [Use core dumps to figure out why NGINX keep crashing](#beginner-use-core-dumps-to-figure-out-why-nginx-keep-crashing)<br><sup>Enable core dumps when your NGINX instance receive an unexpected error or when it crashed.</sup> | Debugging | ![info](static/img/priorities/info.png) |
| [Don't disable backends by comments, use down parameter](#beginner-dont-disable-backends-by-comments-use-down-parameter) | Load Balancing | ![info](static/img/priorities/info.png) |

## Printable hardening cheatsheets

I created two versions of printable posters with hardening cheatsheets (High-Res 5000x8200) based on recipes from this handbook:

  > For `*.xcf` and `*.pdf` formats please see [this](https://github.com/trimstray/nginx-admins-handbook/tree/master/static/img) directory.

- **A+** with all **100%’s** on @ssllabs and **120/100** on @mozilla observatory:

  > It provides the highest scores of the SSL Labs test. Setup is very restrictive with 4096-bit private key, only TLS 1.2, and also modern strict TLS cipher suites (non 128-bits).

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/cheatsheets/nginx-hardening-cheatsheet-tls12-100p.png" alt="nginx-hardening-cheatsheet-100p" width="92%" height="92%">
</p>

- **A+** on @ssllabs and **120/100** on @mozilla observatory with TLS 1.3 support:

  > It provides less restrictive setup with 2048-bit private key, TLS 1.3 and 1.2, and also modern strict TLS cipher suites (128/256-bits). The final grade is also in line with the industry standards. Recommend using this configuration.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/cheatsheets/nginx-hardening-cheatsheet-tls13.png" alt="nginx-hardening-cheatsheet-tls13" width="92%" height="92%">
</p>

## Fully automatic installation

I created a set of scripts for unattended installation of NGINX from the raw, uncompiled code. It allows you to easily install, create a setup for dependencies (like `zlib` or `openssl`), and customized with installation parameters.

For more information please see [Installing from source - Automatic installation](#automatic-installation) chapter.

# Books

#### [Nginx Essentials](https://www.amazon.com/Nginx-Essentials-Valery-Kholodkov/dp/1785289535)

Authors: **Valery Kholodkov**

_Excel in Nginx quickly by learning to use its most essential features in real-life applications._

- _Learn how to set up, configure, and operate an Nginx installation for day-to-day use_
- _Explore the vast features of Nginx to manage it like a pro, and use them successfully to run your website_
- _Example-based guide to get the best out of Nginx to reduce resource usage footprint_

<sup><i>This short review comes from this book or the store.</i></sup>

#### [Nginx Cookbook](https://www.oreilly.com/library/view/nginx-cookbook/9781492049098/)

Authors: **Derek DeJonghe**

_You’ll find recipes for:_

- _Traffic management and A/B testing_
- _Managing programmability and automation with dynamic templating and the NGINX Plus API_
- _Securing access through encrypted traffic, secure links, HTTP authentication subrequests, and more_
- _Deploying NGINX to AWS, Azure, and Google cloud-computing services_
- _Using Docker to deploy containers and microservices_
- _Debugging and troubleshooting, performance tuning, and practical ops tips_

<sup><i>This short review comes from this book or the store.</i></sup>

#### [Nginx HTTP Server](https://www.amazon.com/Nginx-HTTP-Server-Harness-infrastructure/dp/178862355X)

Authors: **Martin Fjordvald**, **Clement Nedelcu**

_Harness the power of Nginx to make the most of your infrastructure and serve pages faster than ever._

- _Discover possible interactions between Nginx and Apache to get the best of both worlds_
- _Learn to exploit the features offered by Nginx for your web applications_
- _Get your hands on the most updated version of Nginx (1.13.2) to support all your web administration requirements_

<sup><i>This short review comes from this book or the store.</i></sup>

#### [Nginx High Performance](https://www.amazon.com/Nginx-High-Performance-Rahul-Sharma/dp/1785281836)

Authors: **Rahul Sharma**

_Optimize NGINX for high-performance, scalable web applications._

- _Configure Nginx for best performance, with configuration examples and explanations_
- _Step-by-step tutorials for performance testing using open source software_
- _Tune the TCP stack to make the most of the available infrastructure_

<sup><i>This short review comes from this book or the store.</i></sup>

#### [Mastering Nginx](https://www.amazon.com/Mastering-Nginx-Dimitri-Aivaliotis/dp/1849517444)

Authors: **Dimitri Aivaliotis**

_Written for experienced systems administrators and engineers, this book teaches you from scratch how to configure Nginx for any situation. Step-by-step instructions and real-world code snippets clarify even the most complex areas._

<sup><i>This short review comes from this book or the store.</i></sup>

#### [ModSecurity 3.0 and NGINX: Quick Start Guide](https://www.nginx.com/resources/library/modsecurity-3-nginx-quick-start-guide/)

Authors: **Faisal Memon**, **Owen Garrett**, **Michael Pleshakov**

_Learn in this ebook how to get started with ModSecurity, the world’s most widely deployed web application firewall (WAF), now available for NGINX and NGINX Plus._

<sup><i>This short review comes from this book or the store.</i></sup>

#### [Cisco ACE to NGINX: Migration Guide](https://www.nginx.com/resources/library/cisco-ace-nginx-migration-guide/)

Authors: **Faisal Memon**

_This ebook provides step-by-step instructions on replacing Cisco ACE with NGINX and off-the-shelf servers. NGINX helps you cut costs and modernize._

_In this ebook you will learn:_

- _How to migrate Cisco ACE configuration to NGINX, with detailed examples_
- _Why you should go with a software load balancer, and not hardware_

<sup><i>This short review comes from this book or the store.</i></sup>

# External Resources

##### Nginx official

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.nginx.com/"><b>Nginx Project</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://nginx.org/en/docs/"><b>Nginx Documentation</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.nginx.com/resources/wiki/"><b>Nginx Wiki</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://docs.nginx.com/nginx/admin-guide/"><b>Nginx Admin's Guide</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/"><b>Nginx Pitfalls and Common Mistakes</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://nginx.org/en/docs/dev/development_guide.html"><b>Development guide</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://forum.nginx.org/"><b>Nginx Forum</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://mailman.nginx.org/mailman/listinfo/nginx"><b>Nginx Mailing List</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nginx/nginx"><b>Nginx Read-only Mirror</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nginxinc/NGINX-Demos"><b>NGINX-Demos
</b></a><br>
</p>

##### Nginx distributions

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://openresty.org/"><b>OpenResty</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://tengine.taobao.org/"><b>The Tengine Web Server</b></a><br>
</p>

##### Comparison reviews

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.hostingadvice.com/how-to/nginx-vs-apache/"><b>NGINX vs. Apache (Pro/Con Review, Uses, & Hosting for Each)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/jiangwenyuan/nuster/wiki/Web-cache-server-performance-benchmark:-nuster-vs-nginx-vs-varnish-vs-squid"><b>Web cache server performance benchmark: nuster vs nginx vs varnish vs squid</b></a><br>
</p>

##### Cheatsheets & References

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://openresty.org/download/agentzh-nginx-tutorials-en.html"><b>agentzh's Nginx Tutorials</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://agentzh.org/misc/slides/nginx-conf-scripting/nginx-conf-scripting.html#1"><b>Introduction to nginx.conf scripting</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.nginx-discovery.com/"><b>Nginx discovery journey</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.nginxguts.com/"><b>Nginx Guts</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://gist.github.com/carlessanagustin/9509d0d31414804da03b"><b>Nginx Cheatsheet</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.scalescale.com/tips/nginx/"><b>Nginx Tutorials, Linux Sysadmin Configuration & Optimizing Tips and Tricks</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/h5bp/server-configs-nginx"><b>Nginx boilerplate configs</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nginx-boilerplate/nginx-boilerplate"><b>Awesome Nginx configuration template</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/SimulatedGREG/nginx-cheatsheet"><b>Nginx Quick Reference</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/fcambus/nginx-resources"><b>A collection of resources covering Nginx and more</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/lebinh/nginx-conf"><b>A collection of useful Nginx configuration snippets</b></a><br>
</p>

##### Performance & Hardening

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/denji/nginx-tuning"><b>Nginx Tuning For Best Performance by Denji</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://istlsfastyet.com/"><b>TLS has exactly one performance problem: it is not used widely enough</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/projects/best-practices/"><b>SSL/TLS Deployment Best Practices</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/projects/rating-guide/index.html"><b>SSL Server Rating Guide</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.upguard.com/blog/how-to-build-a-tough-nginx-server-in-15-steps"><b>How to Build a Tough NGINX Server in 15 Steps</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html"><b>Top 25 Nginx Web Server Best Security Practices</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://calomel.org/nginx.html"><b>Nginx Secure Web Server</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://cipherli.st/"><b>Strong ciphers for Apache, Nginx, Lighttpd and more</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html"><b>Strong SSL Security on Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://enable-cors.org/index.html"><b>Enable cross-origin resource sharing (CORS)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nbs-system/naxsi"><b>NAXSI - WAF for Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://geekflare.com/install-modsecurity-on-nginx/"><b>ModSecurity for Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.owasp.org/index.php/Transport_Layer_Protection_Cheat_Sheet"><b>Transport Layer Protection Cheat Sheet</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://wiki.mozilla.org/Security/Server_Side_TLS"><b>Security/Server Side TLS</b></a><br>
</p>

##### Presentations & Videos

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/Nginx/nginx-basics-and-best-practices"><b>NGINX: Basics and Best Practices</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/Nginx/nginx-installation-and-tuning"><b>NGINX Installation and Tuning</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/joshzhu/nginx-internals"><b>Nginx Internals (by Joshua Zhu)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/feifengxlq/nginx-internals-10514355"><b>Nginx internals (by Liqiang Xu)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/wallarm/how-to-secure-your-web-applications-with-nginx"><b>How to secure your web applications with NGINX</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/chartbeat/tuning-tcp-and-nginx-on-ec2"><b>Tuning TCP and NGINX on EC2</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/trygvevea/extending-functionality-in-nginx-with-modules"><b>Extending functionality in nginx, with modules!</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/tuxtoti/nginx-tips-and-tricks-13087831"><b>Nginx - Tips and Tricks.</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/TonyFabeen/nginx-scripting-extending-nginx-functionalities-with-lua"><b>Nginx Scripting - Extending Nginx Functionalities with Lua</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/kazeburo/advanced-nginx-in-mercari-how-to-handle-over-1200000-https-reqsmin"><b>How to handle over 1,200,000 HTTPS Reqs/Min</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.slideshare.net/harukayon/ngx-lua-public"><b>Using ngx_lua / lua-nginx-module in pixiv</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.youtube.com/playlist?list=PLGz_X9w9raXewvc6tjIGGFZ6DBKHEld3k"><b>NGINX Conf 2014</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.youtube.com/playlist?list=PLGz_X9w9raXdED9BR6GQ61A6d3fBzjpbn"><b>NGINX Conf 2015</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.youtube.com/playlist?list=PLGz_X9w9raXcOsB_dT26iu0BvbSxWYG1g"><b>NGINX Conf 2016</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.youtube.com/playlist?list=PLGz_X9w9raXeT-z_rcZ9yF0kV5SENZ-yt"><b>NGINX Conf 2017</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.youtube.com/playlist?list=PLGz_X9w9raXeHhKRX6ZS7vmFKN12iYOw9"><b>NGINX Conf 2018 | Deep Dive Track</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.youtube.com/playlist?list=PLGz_X9w9raXe_Vc708VKvr5KJ4gnf1WxS"><b>NGINX Conf 2018 | Keynotes and Sessions</b></a><br>
</p>

##### Playgrounds

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/sportebois/nginx-rate-limit-sandbox"><b>NGINX Rate Limit, Burst and nodelay sandbox</b></a><br>
</p>

##### Config generators

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://nginxconfig.io/"><b>Nginx config generator on steroids</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://mozilla.github.io/server-side-tls/ssl-config-generator/"><b>Mozilla SSL Configuration Generator</b></a><br>
</p>

##### Static analyzers

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/yandex/gixy"><b>gixy</b></a> - is a tool to analyze Nginx configuration to prevent security misconfiguration and automate flaw detection.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/1connect/nginx-config-formatter"><b>nginx-config-formatter</b></a> - Nginx config file formatter/beautifier written in Python.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/vasilevich/nginxbeautifier"><b>nginxbeautifier</b></a> - format and beautify Nginx config files.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/lovette/nginx-tools/tree/master/nginx-minify-conf"><b>nginx-minify-conf</b></a> - creates a minified version of a Nginx configuration.<br>
</p>

##### Log analyzers

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://goaccess.io/"><b>GoAccess</b></a> - is a fast, terminal-based log analyzer (quickly analyze and view web server statistics in real time).<br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.graylog.org/"><b>Graylog</b></a> - is a leading centralized log management for capturing, storing, and enabling real-time analysis.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.elastic.co/products/logstash"><b>Logstash</b></a> - is an open source, server-side data processing pipeline.<br>
</p>

##### Performance analyzers

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/lebinh/ngxtop"><b>ngxtop</b></a> - parses your Nginx access log and outputs useful, top-like, metrics of your Nginx server.<br>
</p>

##### Benchmarking tools

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://httpd.apache.org/docs/2.4/programs/ab.html"><b>ab</b></a> - is a single-threaded command line tool for measuring the performance of HTTP web servers.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.joedog.org/siege-home/"><b>siege</b></a> - is an http load testing and benchmarking utility.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/wg/wrk"><b>wrk</b></a> - is a modern HTTP benchmarking tool capable of generating significant load.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/giltene/wrk2"><b>wrk2</b></a> - is a constant throughput, correct latency recording variant of wrk.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/codesenberg/bombardier"><b>bombardier</b></a> - is a HTTP(S) benchmarking tool.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/cmpxchg16/gobench"><b>gobench</b></a> - is a HTTP/HTTPS load testing and benchmarking tool.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/rakyll/hey"><b>hey</b></a> - is a HTTP load generator, ApacheBench (ab) replacement, formerly known as rakyll/boom.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/tarekziade/boom"><b>boom</b></a> - is a script you can use to quickly smoke-test your web app deployment.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/tarekziade/httperf"><b>httperf</b></a> - the httperf HTTP load generator.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://jmeter.apache.org/"><b>JMeter™</b></a> - is designed to load test functional behavior and measure performance.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://gatling.io/"><b>Gatling</b></a> - is a powerful open-source load and performance testing tool for web applications.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/locustio/locust"><b>locust</b></a> - is an easy-to-use, distributed, user load testing tool.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/gkbrk/slowloris"><b>slowloris</b></a> - low bandwidth DoS tool. Slowloris rewrite in Python.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/shekyan/slowhttptest"><b>slowhttptest</b></a> - application layer DoS attack simulator.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/jseidl/GoldenEye"><b>GoldenEye</b></a> - GoldenEye Layer 7 (KeepAlive+NoCache) DoS test tool.<br>
</p>

##### Debugging tools

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://strace.io/"><b>strace</b></a> - is a diagnostic, debugging and instructional userspace utility (linux syscall tracer) for Linux.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.gnu.org/software/gdb/"><b>GDB</b></a> - allows you to see what is going on `inside' another program while it executes.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://sourceware.org/systemtap/"><b>SystemTap</b></a> - provides infrastructure to simplify the gathering of information about the running Linux system.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/openresty/stapxx"><b>stapxx</b></a> - simple macro language extentions to SystemTap.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/trimstray/htrace.sh"><b>htrace.sh</b></a> - is a simple Swiss Army knife for http/https troubleshooting and profiling.<br>
</p>

##### Development

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.lua.org/pil/contents.html"><b>Programming in Lua (first edition)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.londonlua.org/scripting_nginx_with_lua/"><b>Scripting Nginx with Lua</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.evanmiller.org/nginx-modules-guide.html"><b>Emiller’s Guide To Nginx Module Development</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.evanmiller.org/nginx-modules-guide-advanced.html"><b>Emiller’s Advanced Topics In Nginx Module Development</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.airpair.com/nginx/extending-nginx-tutorial"><b>NGINX Tutorial: Developing Modules</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.openmymind.net/An-Introduction-To-OpenResty-Nginx-Lua/"><b>An Introduction To OpenResty (nginx + lua) - Part 1</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.openmymind.net/An-Introduction-To-OpenResty-Part-2/"><b>An Introduction To OpenResty - Part 2 - Concepts</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.openmymind.net/An-Introduction-To-OpenResty-Part-3/"><b>An Introduction To OpenResty - Part 3</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://blog.dutchcoders.io/openresty-with-dynamic-generated-certificates/"><b>OpenResty (Nginx) with dynamically generated certificates</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/openresty/programming-openresty"><b>Programming OpenResty</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.lua.org/pil/contents.html"><b>Programming in Lua (first edition)</b></a><br>
</p>

##### Online tools

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/ssltest/"><b>SSL Server Test by SSL Labs</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/ssltest/viewMyClient.html"><b>SSL/TLS Capabilities of Your Browser</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.htbridge.com/ssl/"><b>Test SSL/TLS (PCI DSS, HIPAA and NIST)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://sslanalyzer.comodoca.com/"><b>SSL analyzer and certificate checker</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://cryptcheck.fr/"><b>Test your TLS server configuration (e.g. ciphers)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.jitbit.com/sslcheck/"><b>Scan your website for non-secure content</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://2ton.com.au/dhtool/"><b>Public Diffie-Hellman Parameter Service/Tool</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://securityheaders.com/"><b>Analyse the HTTP response headers by Security Headers</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://observatory.mozilla.org/"><b>Analyze your website by Mozilla Observatory</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://sslmate.com/caa/"><b>CAA Record Helper</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://webhint.io/"><b>Linting tool that will help you with your site's accessibility, speed, security and more</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://urlscan.io/"><b>Service to scan and analyse websites</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.url-encode-decode.com/"><b>Tool from above to either encode or decode a string of text</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://uncoder.io/"><b>Online translator for search queries on log data</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://regex101.com/"><b>Online regex tester and debugger: PHP, PCRE, Python, Golang and JavaScript</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://regexr.com/"><b>Online tool to learn, build, & test Regular Expressions</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.regextester.com/"><b>Online Regex Tester & Debugger</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nginxinc/NGINX-Demos/tree/master/nginx-regex-tester"><b>nginx-regex-tester</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://gchq.github.io/CyberChef/"><b>A web app for encryption, encoding, compression and data analysis</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://nginx.viraptor.info/"><b>Nginx location match tester</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://detailyang.github.io/nginx-location-match-visible/"><b>Nginx location match visible</b></a><br>
</p>

##### Other stuff

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://cheatsheetseries.owasp.org/"><b>OWASP Cheat Sheet Series</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://infosec.mozilla.org/guidelines/web_security.html"><b>Mozilla Web Security</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://appsecwiki.com/#/"><b>Application Security Wiki</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/OWASP/ASVS/tree/master/4.0"><b>OWASP ASVS 4.0</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml"><b>Transport Layer Security (TLS) Parameters</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://wiki.mozilla.org/Security/Server_Side_TLS"><b>Security/Server Side TLS by Mozilla</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/GrrrDog/TLS-Redirection#technical-details"><b>TLS Redirection (and Virtual Host Confusion)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/"><b>TLS Security 6: Examples of TLS Vulnerabilities and Attacks</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.veracode.com/blog/2014/03/guidelines-for-setting-security-headers"><b>Guidelines for Setting Security Headers</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://medium.freecodecamp.org/secure-your-web-application-with-these-http-headers-fd66e0367628"><b>Secure your web application with these HTTP headers</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://zinoui.com/blog/security-http-headers"><b>Security HTTP Headers</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/GrrrDog/weird_proxies/wiki"><b>Analysis of various reverse proxies, cache proxies, load balancers, etc.</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.regular-expressions.info/"><b>Regular-Expressions</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://nickcraver.com/blog/2017/05/22/https-on-stack-overflow/#the-beginning"><b>HTTPS on Stack Overflow: The End of a Long Road</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.aosabook.org/en/nginx.html"><b>The Architecture of Open Source Applications - Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.bbc.co.uk/blogs/internet/entries/17d22fb8-cea2-49d5-be14-86e7a1dcde04"><b>BBC Digital Media Distribution: How we improved throughput by 4x</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.kegel.com/c10k.html"><b>The C10K problem by Dan Kegel</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://highscalability.com/blog/2013/5/13/the-secret-to-10-million-concurrent-connections-the-kernel-i.html"><b>The Secret To 10 Million Concurrent Connections</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://hpbn.co/"><b>High Performance Browser Networking</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/leandromoreira/linux-network-performance-parameters"><b>Learn where some of the network sysctl variables fit into the Linux/Kernel network flow</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://suniphrase.wordpress.com/2015/10/27/jemalloc-vs-tcmalloc-vs-dlmalloc/"><b>jemalloc vs tcmalloc vs dlmalloc</b></a><br>
</p>

# HTTP Basics

HTTP stands for hypertext transfer protocol and is used for transmitting data (web pages) over the Internet.

Some important information about HTTP:

- all requests originate at the client (e.g. browser)
- the server responds to a request
- the requests and responses are in readable text
- the requests are independent of each other and the server doesn’t need to track the requests

I will not describe the HTTP protocol in detail, but I will discuss only the most important things because we have some great documents which describe it meticulously:

- [RFC 2616 - Hypertext Transfer Protocol - HTTP/1.1](https://tools.ietf.org/html/rfc2616)
- [HTTP Made Really Easy](https://www.jmarshall.com/easy/http/)
- [MDN web docs - An overview of HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
- [LWP in Action - Chapter 2. Web Basics](http://lwp.interglacial.com/ch02_01.htm)
- [HTTP and everything you need to know about it](https://medium.com/faun/http-and-everything-you-need-to-know-about-it-8273bc224491)

We have also some interesting books:

- [HTTP: The Definitive Guide](https://www.amazon.com/HTTP-Definitive-Guide-Guides-ebook/dp/B0043D2EKO)
- [RESTful Web Services](https://www.crummy.com/writing/RESTful-Web-Services/)

#### Features and architecture

The HTTP protocol is a request/response protocol based on the client/server based architecture where web browsers, robots and search engines, etc. act like HTTP clients, and the Web server acts as a server.

Here is a brief explanation:

- the HTTP client, i.e., a browser initiates an HTTP request and after a request is made, the client waits for the response

- the HTTP server handles and processing requests from clients, after that it sends a response to the client

- any type of data can be sent by HTTP as long as both the client and the server know how to handle the data content

- the server and client are aware of each other only during a current request. Afterwards, both of them forget about each other

The HTTP protocol allows clients and servers to communicate. Clients send requests using an HTTP method request and servers listen for requests on a host and port. The following is a comparison:

- **client** - the HTTP client sends a request to the server in the form of a request method, URI, and protocol version, followed by a MIME-like message containing request modifiers, client information, and possible body content over a TCP/IP connection

- **server** - the HTTP server responds with a status line, including the message's protocol version and a success or error code, followed by a MIME-like message containing server information, entity meta information, and possible entity-body content

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/HTTP_steps.png" alt="HTTP_steps">
</p>

<sup><i>This infographic comes from [www.ntu.edu.sg - HTTP (HyperText Transfer Protocol)](https://www.ntu.edu.sg/home/ehchua/programming/webprogramming/HTTP_Basics.html).</i></sup>

#### URI vs URL

Uniform Resource Identifier (URI) is a string of characters used to identify a name or a resource on the Internet. A URI identifies a resource either by location, or a name, or both. A URI has two specializations known as URL and URN.

I think, the best explanation is here: [The Difference Between URLs, URIs, and URNs](https://danielmiessler.com/study/url-uri/) by [Daniel Miessler](https://danielmiessler.com/about/).

For me, this short and clear explanation is also interesting:

  > URIs **identify** and URLs **identify** and **locate**; however, **locators are also identifiers**, so every URL is also a URI, but there are URIs which are not URLs.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/url_urn_uri.png" alt="url_urn_uri">
</p>

Look at the following examples to get your mind out of confusion and take it simple:

| <b>TYPE</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| **URL** | `https://www.google.com/folder/page.html` |
| **URL** | `http://example.com/resource?foo=bar#fragment` |
| **URL** | `ftp://example.com/download.zip` |
| **URL** | `mailto:user@example.com` |
| **URL** | `file:///home/user/file.txt` |
| **URL** | `/other/link.html` (a relative URL) |
| **URN** | `www.pierobon.org/iis/review1.htm#one` |
| **URN** | `urn:ietf:rfc:2648` |
| **URN** | `urn:isbn:0451450523` |
| **URI** | `http://www.pierobon.org/iis/review1.htm.html#one` |

The graphic below explains the URL format:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/url_format.png" alt="url_format">
</p>

If it is still unclear to you, I recommend you read: [What is the difference between a URI, a URL and a URN?](https://stackoverflow.com/questions/176264/what-is-the-difference-between-a-uri-a-url-and-a-urn/1984225). This is an amazing explanation.

#### Request

A request consists of: `(1) a command or request + (2) optional headers + (4) optional body content`

```
                      FIELDS OF HTTP REQUEST       PART OF RFC 2616
---------------------------------------------------------------------
  Request       = (1) : Request-line                ; Section 5.1
                  (2) : *(( general-header          ; Section 4.5
                          | request-header          ; Section 5.3
                          | entity-header ) CRLF)   ; Section 7.1
                  (3) : CRLF
                  (4) : [ message-body ]            ; Section 4.3
```

Example of form an HTTP request to fetch `/alerts/status` page from the web server running on `localhost:8000`:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/http_request.png" alt="http_request">
</p>

##### Request line

The Request-line begins with a method, followed by the Request-URI and the protocol version, and ending with CRLF. The elements are separated by space SP characters:

```
Request-Line = Method SP Request-URI SP HTTP-Version CRLF
```

###### Methods

| <b>METHOD</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| `GET` | is used to retreive data from a server at the specified resource |

For example, say you have an API with a `/api/v2/users` endpoint. Making a GET request to that endpoint should return a list of all available users.

  > Requests with GET method does not change any data.

At a basic level, these things should be validated:

- check that a valid `GET` request returns a 200 status code
- ensure that a GET request to a specific resource returns the correct data

| <b>METHOD</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| `POST` | is used to send data to the sever to modify and update a resource |

The simplest example is a contact form on a website. When you fill out the inputs in a form and hit Send, that data is put in the response body of the request and sent to the server.

  > Requests with POST method change data on the backend server (by modifying or updating a resource).

Here are some tips for testing POST requests:

- create a resource with a POST request and ensure a 200 status code is returned
- next, make a GET request for that resource, and ensure the data was saved correctly
- add tests that ensure POST requests fail with incorrect or ill-formatted data

Modify and update a resource:

```
POST /items/<existing_item> HTTP/1.1
Host: example.com
```

The following is an error:

```
POST /items/<new_item> HTTP/1.1
Host: example.com
```

| <b>METHOD</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| `PUT` | is used to send data to the sever to create or overwrite a resource |

The same PUT request multiple times will always produce the same result.

Check for these things when testing PUT requests:

- repeatedly cally a PUT request always returns the same result (idempotent)
- after updating a resource with a PUT request, a GET request for that resource should return the new data
- PUT requests should fail if invalid data is supplied in the request - nothing should be updated

For a new resource:

```
PUT /items/<new_item> HTTP/1.1
Host: example.com
```

To overwrite an existing resource:

```
PUT /items/<existing_item> HTTP/1.1
Host: example.com
```

###### Request URI

The Request-URI is a Uniform Resource Identifier and identifies the resource upon which to apply the request. The exact resource identified by an Internet request is determined by examining both the Request-URI and the Host header field.

The most common form of Request-URI is that used to identify a resource on an origin server or gateway. For example, a client wishing to retrieve a resource directly from the origin server would create a TCP connection to port 80 of the host `example.com` and send the following lines:

```
GET /pub/index.html HTTP/1.1
Host: example.com
```

The absoluteURI form is required when the request is being made to a proxy:

```
GET http://example.com/pub/index.html HTTP/1.1
```

  > Note that the absolute path cannot be empty; if none is present in the original URI, it MUST be given as `/` (the server root).

  > The asterisk `*` is used when an HTTP request does not apply to a particular resource, but to the server itself, and is only allowed when the method used does not necessarily apply to a resource.

###### HTTP version

The last part of the request indicating the client's supported HTTP version.

HTTP has four versions — HTTP/0.9, HTTP/1.0, HTTP/1.1, and HTTP/2.0. Today the versions in common use are HTTP/1.1 and HTTP/2.0.

Determining the appropriate version of the HTTP protocol is very important because it allows you to set specific HTTP method or required headers (e.g. `cache-control` for HTTP/1.1).

There is a nice explanation about [How does a HTTP 1.1 server respond to a HTTP 1.0 request?](https://stackoverflow.com/questions/35850518/how-does-a-http-1-1-server-respond-to-a-http-1-0-request).

##### Request header fields

There are three types of HTTP message headers for requests:

- **General-header** - applying to both requests and responses but with no relation to the data eventually transmitted in the body

- **Request-header** - containing more information about the resource to be fetched or about the client itself

- **Entity-header** - containing more information about the body of the entity, like its content length or its MIME-type

The Request-header fields allow the client to pass additional information about the request, and about the client itself, to the server.

##### Message body

Request (message) body is the part of the HTTP request where additional content can be sent to the server.

It is optional. Most of the HTTP requests are GET requests without bodies. However, simulating requests with bodies is important to properly stress the proxy code and to test various hooks working with such requests. Most HTTP requests with bodies use POST or PUT request method.

##### Generate requests

How to generate a requests?

- `telnet`

  ```
  telnet example.com 80
  GET /index.html HTTP/1.1
  Host: example.com
  ```

- `openssl`

  ```
  openssl s_client -servername example.com -connect example.com:443
  ...
  ---
  GET /index.html HTTP/1.1
  Host: example.com
  ```

#### Response

After receiving and interpreting a request message, a server responds with an HTTP response message.

```
                     FIELDS OF HTTP RESPONSE       PART OF RFC 2616
---------------------------------------------------------------------
  Request       = (1) : Status-line                 ; Section 6.1
                  (2) : *(( general-header          ; Section 4.5
                          | response-header         ; Section 6.2
                          | entity-header ) CRLF)   ; Section 7.1
                  (3) : CRLF
                  (4) : [ message-body ]            ; Section 4.3
```

Example of form an HTTP response for a request to fetch the `/alerts/status` page from the web server running on `localhost:8000`:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/http_response.png" alt="http_request">
</p>

##### Status line

The Status-line consisting of the protocol version followed by a numeric status code and its associated textual phrase.

```
Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```

###### HTTP version

  > When an HTTP/1.1 message is sent to an HTTP/1.0 recipient or a recipient whose version is unknown, the HTTP/1.1 message is constructed such that it can be interpreted as a valid HTTP/1.0 message if all of the newer features are ignored.

###### Status codes and reason phrase

For more information please see:

- [HTTP response status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
- [HTTP Status Codes](https://httpstatuses.com/)
- [RFC 2616 - Hypertext Transfer Protocol -- HTTP/1.1 - Status Code Definitions](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)

##### Response header fields

There are three types of HTTP message headers for responses:

- **General-header** - applying to both requests and responses but with no relation to the data eventually transmitted in the body

- **Response-header** - these header fields give information about the server and about further access to the resource identified by the Request-URI

- **Entity-header** - containing more information about the body of the entity, like its content length or its MIME-type

The response-header fields allow the server to pass additional information about the response.

##### Message body

Contains the resource data that was requested by the client.

# NGINX Basics

#### Directories and files

  > If you compile NGINX with default parameters all files and directories are available from `/usr/local/nginx` location.

For upstream NGINX packaging paths can be as follows (it depends on the type of system/distribution):

- `/etc/nginx` - is the default configuration root for the NGINX service
  * other locations: `/usr/local/etc/nginx`, `/usr/local/nginx/conf`

- `/etc/nginx/nginx.conf` - is the default configuration entry point used by the NGINX services, includes the top-level http block and all other configuration contexts and files
  * other locations: `/usr/local/etc/nginx/nginx.conf`, `/usr/local/nginx/conf/nginx.conf`

- `/usr/share/nginx` - is the default root directory for requests, contains `html` directory and basic static files
  * other locations: `html/` in root directory

- `/var/log/nginx` - is the default log (access and error log) location for NGINX
  * other locations: `logs/` in root directory

- `/var/cache/nginx` - is the default temporary files location for NGINX
  * other locations: `/var/lib/nginx`

- `/etc/nginx/conf` - contains custom/vhosts configuration files
  * other locations:  `/etc/nginx/conf.d`, `/etc/nginx/sites-enabled` (I can't stand this debian-like convention...)

- `/var/run/nginx` - contains information about NGINX process(es)
  * other locations: `/usr/local/nginx/logs`, `logs/` in root directory

#### Commands

- `nginx -h` - shows the help
- `nginx -v` - shows the NGINX version
- `nginx -V` - shows the extended information about NGINX: version, build parameters, and configuration arguments
- `nginx -t` - tests the NGINX configuration
- `nginx -c <filename>` - sets configuration file (default: `/etc/nginx/nginx.conf`)
- `nginx -p <directory>` - sets prefix path (default: `/etc/nginx/`)
- `nginx -T` - tests the NGINX configuration and prints the validated configuration on the screen
- `nginx -s <signal>` - sends a signal to the NGINX master process:
  - `stop` - discontinues the NGINX process immediately
  - `quit` - stops the NGINX process after it finishes processing
inflight requests
  - `reload` - reloads the configuration without stopping processes
  - `reopen` - instructs NGINX to reopen log files
- `nginx -g <directive>` - sets [global directives](https://nginx.org/en/docs/ngx_core_module.html) out of configuration file

Some useful snippets for management of the NGINX daemon:

- testing configuration:

  ```bash
  /usr/sbin/nginx -t -c /etc/nginx/nginx.conf
  /usr/sbin/nginx -t -q -g 'daemon on; master_process on;' # ; echo $?
  ```

- starting daemon:

  ```bash
  /usr/sbin/nginx -g 'daemon on; master_process on;'

  service nginx start
  systemctl start nginx

  # You can also start NGINX from start-stop-daemon script:
  /sbin/start-stop-daemon --quiet --start --exec /usr/sbin/nginx --background --retry QUIT/5 --pidfile /run/nginx.pid
  ```

- stopping daemon:

  ```bash
  /usr/sbin/nginx -s quit     # graceful shutdown (waiting for the worker processes to finish serving current requests)
  /usr/sbin/nginx -s stop     # fast shutdown (kill connections immediately)

  service nginx stop
  systemctl stop nginx

  # You can also stop NGINX from start-stop-daemon script:
  /sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
  ```

- reloading daemon:

  ```bash
  /usr/sbin/nginx -g 'daemon on; master_process on;' -s reload

  service nginx reload
  systemctl reload nginx

  kill -HUP $(cat /var/run/nginx.pid)
  kill -HUP $(pgrep -f "nginx: master")
  ```

#### Configuration syntax

NGINX uses a micro programming language in the configuration files. This language's design is heavily influenced by Perl and Bourne Shell. For me NGINX configuration has a simple and very transparent structure.

##### Comments

NGINX configuration files don't support comment blocks, they only accept `#` at the beginning of a line for a comment.

##### End of lines

Lines containing directives must end with a `;` or NGINX will fail to load the configuration and report an error.

##### Variables, Strings, and Quotes

Variables start with `$`. Some modules introduce variables can be used when setting directives.

  > There are some directives that do not support variables, e.g. `access_log` or `error_log`.

To assign value to the variable you should use a `set` directive:

```bash
set $var "value";
```

  > See [`if`, `break`, and `set`](#if-break-and-set) section to learn more about variables.

Some interesting things about variables:

  > Make sure to read the [agentzh's Nginx Tutorials](https://openresty.org/download/agentzh-nginx-tutorials-en.html) - it's about NGINX tips & tricks. This guy is a Guru and creator of the OpenResty. In these tutorials he describes, amongst other things, variables in great detail. I also recommend [nginx built-in variables](http://siwei.me/blog/posts/nginx-built-in-variables).

- the most variables in NGINX only exist at runtime, not during configuration time
- the scope of variables spreads out all over configuration
- variable assignment occurs when requests are actually being served
- variable have exactly the same lifetime as the corresponding request
- each request does have its own version of all those variables' containers (different containers values)
- requests do not interfere with each other even if they are referencing a variable with the same name
- the assignment operation is only performed in requests that access location

Strings may be inputted without quotes unless they include blank spaces, semicolons or curly braces, then they need to be escaped with backslashes or enclosed in single/double quotes.

Quotes are required for values which are containing space(s) and/or some other special characters, otherwise NGINX will not recognize them. You can either quote or `\`-escape some special characters like `" "` or `";"` in strings (characters that would make the meaning of a statement ambiguous). So the following instructions are the same:

```bash
# 1)
add_header X-Header "nginx web server;";

# 2)
add_header X-Header nginx\ web\ server\;;
```

Variables in quoted strings are expanded normally unless the `$` is escaped.

##### Directives, Blocks, and Contexts

  > Read this great article about [the NGINX configuration inheritance model](https://blog.martinfjordvald.com/2012/08/understanding-the-nginx-configuration-inheritance-model/) by [Martin Fjordvald](https://blog.martinfjordvald.com/about/).

Configuration options are called directives. We have four types of directives:

- standard directive - one value per context:

  ```bash
  worker_connections 512;
  ```

- array directive - multiple values per context:

  ```bash
  error_log /var/log/nginx/localhost/localhost-error.log warn;
  ```

- action directive - something which does not just configure:

  ```bash
  rewrite ^(.*)$ /msie/$1 break;
  ```

- `try_files` directive:

  ```bash
  try_files $uri $uri/ /test/index.html;
  ```

Directives are organised into groups known as **blocks** or **contexts**. Generally, context is a block directive that can have other directives inside braces. It appears to be organised in a tree-like structure, defined by sets of brackets - `{` and `}`.

As a general rule, if a directive is valid in multiple nested scopes, a declaration in a broader context will be passed on to any child contexts as default values. The children contexts can override these values at will.

  > Directives placed in the configuration file outside of any contexts are considered to be in the global/main context.

Directives can only be used in the contexts that they were designed for. NGINX will error out on reading a configuration file with directives that are declared in the wrong context.

  > If you want to review all directives see [alphabetical index of directives](https://nginx.org/en/docs/dirindex.html).

Contexts can be layered within one another (a level of inheritance). Their structure looks like this:

```
Global/Main Context
        |
        |
        +-----» Events Context
        |
        |
        +-----» HTTP Context
        |          |
        |          |
        |          +-----» Server Context
        |          |          |
        |          |          |
        |          |          +-----» Location Context
        |          |
        |          |
        |          +-----» Upstream Context
        |
        |
        +-----» Mail Context
```

NGINX also provides other contexts (mainly used for mapping) such as:

- `map` - is used to set the value of a variable depending on the value of another variable. It provides a mapping of one variable’s values to determine what the second variable should be set to

- `geo` - is used to specify a mapping. However, this mapping is specifically used to categorize client IP addresses. It sets the value of a variable depending on the connecting IP address

- `types` - is used to map MIME types to the file extensions that should be associated with them

- `if` - provide conditional processing of directives defined within, execute the instructions contained if a given test returns `true`

- `limit_except` - is used to restrict the use of certain HTTP methods within a location context

Also look at the graphic below. It presents the most important contexts with reference to the configuration:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx_contexts.png" alt="nginx-contexts">
</p>

NGINX lookup starts from the http block, then through one or more server blocks, followed by the location block(s).

##### External files

`include` directive may appear inside any contexts to perform conditional inclusion. It attaching another file, or files matching the specified mask:

```bash
include /etc/nginx/proxy.conf;
```

##### Measurement units

Sizes can be specified in:

- `k` or `K`: Kilobytes
- `m` or `M`: Megabytes
- `g` or `G`: Gigabytes

```bash
client_max_body_size 2M;
```

Time intervals can be specified in:

- `ms`: Milliseconds
- `s`: Seconds (default, without a suffix)
- `m`: Minutes
- `h`: Hours
- `d`: Days
- `w`: Weeks
- `M`: Months (30 days)
- `y`: Years (365 days)

```bash
proxy_read_timeout 20s;
```

##### Enable syntax highlighting

###### vi/vim

```bash
# 1) Download vim plugin for NGINX:

# Official NGINX vim plugin:
mkdir -p ~/.vim/syntax/

wget "http://www.vim.org/scripts/download_script.php?src_id=19394" -O ~/.vim/syntax/nginx.vim

# Improved NGINX vim plugin (incl. syntax highlighting) with Pathogen:
mkdir -p ~/.vim/{autoload,bundle}/

curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo -en "\nexecute pathogen#infect()\n" >> ~/.vimrc

git clone https://github.com/chr4/nginx.vim ~/.vim/bundle/nginx.vim

# 2) Set location of NGINX config files:
cat > ~/.vim/filetype.vim << __EOF__
au BufRead,BufNewFile /etc/nginx/*,/etc/nginx/conf.d/*,/usr/local/nginx/conf/*,*/conf/nginx.conf if &ft == '' | setfiletype nginx | endif
__EOF__
```

  > It may be interesting for you: [Highlight insecure SSL configuration in Vim](https://github.com/chr4/sslsecure.vim).

###### Sublime Text

Install `cabal` - system for building and packaging Haskell libraries and programs (on Ubuntu):

```bash
add-apt-repository -y ppa:hvr/ghc
apt-get update

apt-get install -y cabal-install-1.22 ghc-7.10.2

# Add this to the main configuration file of your shell:
export PATH=$HOME/.cabal/bin:/opt/cabal/1.22/bin:/opt/ghc/7.10.2/bin:$PATH
source $HOME/.<shellrc>

cabal update
```

- `nginx-lint`:

  ```bash
  git clone https://github.com/temoto/nginx-lint

  cd nginx-lint && cabal install --global
  ```

- `sublime-nginx` + `SublimeLinter-contrib-nginx-lint`:

  Bring up the _Command Palette_ and type `install`. Among the commands you should see _Package Control: Install Package_. Type `nginx` to install [sublime-nginx](https://github.com/brandonwamboldt/sublime-nginx) and after that do the above again for install [SublimeLinter-contrib-nginx-lint](https://github.com/irvinlim/SublimeLinter-contrib-nginx-lint): type `SublimeLinter-contrib-nginx-lint`.

#### Processes

NGINX has **one master process** and **one or more worker processes**.

The main purposes of the master process is to read and evaluate configuration files, as well as maintain the worker processes (respawn when a worker dies), handle signals, notify workers, opens log files, and, of course binding to ports.

Master process should be started as root user, because this will allow NGINX to open sockets below 1024 (it needs to be able to listen on port 80 for HTTP and 443 for HTTPS).

The worker processes do the actual processing of requests and get commands from master process. They runs in an event loop (registering events and responding when one occurs), handle network connections, read and write content to disk, and communicate with upstream servers. These are spawned by the master process, and the user and group will as specified (unprivileged).

  > NGINX has also cache loader and cache manager processes but only if you enable caching.

The following signals can be sent to the NGINX master process:

| <b>SIGNAL</b> | <b>NUM</b> | <b>DESCRIPTION</b> |
| :---         | :---:        | :---         |
| `TERM`, `INT` | **15**, **2** | quick shutdown |
| `QUIT` | **3** | graceful shutdown |
| `KILL` | **9** | halts a stubborn process |
| `HUP` | **1** | configuration reload, start new workers, gracefully shutdown the old worker processes |
| `USR1` | **10** | reopen the log files |
| `USR2` | **12** | upgrade executable on the fly |
| `WINCH` | **28** | gracefully shutdown the worker processes |

There’s no need to control the worker processes yourself. However, they support some signals too:

| <b>SIGNAL</b> | <b>NUM</b> | <b>DESCRIPTION</b> |
| :---         | :---:        | :---         |
| `TERM`, `INT` | **15**, **2** | quick shutdown |
| `QUIT` | **3** | graceful shutdown |
| `USR1` | **10** | reopen the log files |

#### Connection processing

NGINX supports a variety of [connection processing methods](https://nginx.org/en/docs/events.html) which depends on the platform used.

In general there are four types of event multiplexing:

- `select` - is anachronism and not recommended but installed on all platforms as a fallback
- `poll` - is anachronism and not recommended

And the most efficient implementations of non-blocking I/O:

- `epoll` - recommend if you're using GNU/Linux
- `kqueue` - recommend if you're using BSD (is technically superior to `epoll`)

There are also great resources (also makes comparisons) about them:

- [Kqueue: A generic and scalable event notification facility](https://people.freebsd.org/~jlemon/papers/kqueue.pdf)
- [poll vs select vs event-based](https://daniel.haxx.se/docs/poll-vs-select.html)
- [select/poll/epoll: practical difference for system architects](http://www.ulduzsoft.com/2014/01/select-poll-epoll-practical-difference-for-system-architects/)
- [Scalable Event Multiplexing: epoll vs. kqueue](https://people.eecs.berkeley.edu/~sangjin/2012/12/21/epoll-vs-kqueue.html)
- [Async IO on Linux: select, poll, and epoll](https://jvns.ca/blog/2017/06/03/async-io-on-linux--select--poll--and-epoll/)
- [A brief history of select(2)](https://idea.popcount.org/2016-11-01-a-brief-history-of-select2/)
- [Select is fundamentally broken](https://idea.popcount.org/2017-01-06-select-is-fundamentally-broken/)
- [Epoll is fundamentally broken](https://idea.popcount.org/2017-02-20-epoll-is-fundamentally-broken-12/)
- [I/O Multiplexing using epoll and kqueue System Calls](https://austingwalters.com/io-multiplexing/)
- [Benchmarking BSD and Linux](http://bulk.fefe.de/scalability/)
- [The C10K problem](http://www.kegel.com/c10k.html)

Look also at libevent benchmark (read about [libevent – an event notification library](http://libevent.org/)):

<p align="center">
  <a href="https://www.nginx.com/resources/library/infographic-inside-nginx/">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/libevent-benchmark.jpg" alt="libevent-benchmark">
  </a>
</p>

<sup><i>This infographic comes from [daemonforums - An interesting benchmark (kqueue vs. epoll)](http://daemonforums.org/showthread.php?t=2124).</i></sup>

You may also view why big players use NGINX on FreeBSD instead of on GNU/Linux:

- [FreeBSD NGINX Performance](https://devinteske.com/wp/freebsd-nginx-performance/)
- [Why did Netflix use NGINX and FreeBSD to build their own CDN?](https://www.youtube.com/watch?v=KP_bKvXkoC4)

##### Event-Driven architecture

  > [Thread Pools in NGINX Boost Performance 9x!](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) - this official article is an amazing explanation about thread pools and generally about handling connections. I also recommend [Inside NGINX: How We Designed for Performance & Scale](https://www.nginx.com/blog/inside-nginx-how-we-designed-for-performance-scale). Both are really great.

NGINX uses Event-Driven architecture which heavily relies on Non-Blocking I/O. One advantage of non-blocking/asynchronous operations is that you can maximize the usage of a single CPU as well as memory because is that your thread can continue it's work in parallel.

  > There is a perfectly good and brief [summary](https://stackoverflow.com/questions/8546273/is-non-blocking-i-o-really-faster-than-multi-threaded-blocking-i-o-how) about non-blocking I/O and multi-threaded blocking I/O by [Werner Henze](https://stackoverflow.com/users/1023911/werner-henze).

Look what the official documentation says about it:

  > _It’s well known that NGINX uses an asynchronous, event‑driven approach to handling connections. This means that instead of creating another dedicated process or thread for each request (like servers with a traditional architecture), it handles multiple connections and requests in one worker process. To achieve this, NGINX works with sockets in a non‑blocking mode and uses efficient methods such as epoll and kqueue._

  > _Because the number of full‑weight processes is small (usually only one per CPU core) and constant, much less memory is consumed and CPU cycles aren’t wasted on task switching. The advantages of such an approach are well‑known through the example of NGINX itself. It successfully handles millions of simultaneous requests and scales very well._

I must not forget to mention here about Non-Blocking and 3rd party modules (from official documentation):

  > Unfortunately, many third‑party modules use blocking calls, and users (and sometimes even the developers of the modules) aren’t aware of the drawbacks. Blocking operations can ruin NGINX performance and must be avoided at all costs.

To handle concurrent requests with a single worker process NGINX uses the [reactor design pattern](https://stackoverflow.com/questions/5566653/simple-explanation-for-the-reactor-pattern-with-its-applications). Basically, it's a single-threaded but it can fork several processes to utilize multiple cores.

However, NGINX is not a single threaded application. Each of worker processes is single-threaded and can handle thousands of concurrent connections. NGINX does not create a new process/thread for each connection/requests but it starts several worker threads during start. It does this asynchronously with one thread, rather than using multi-threaded programming (it uses an event loop with asynchronous I/O).

That way, the I/O and network operations are not a very big bottleneck (remember that your CPU would spend a lot of time waiting for your network interfaces, for example). This results from the fact that NGINX only use one thread to service all requests. When requests arrive at the server, they are serviced one at a time. However, when the code serviced needs other thing to do it sends the callback to the other queue and the main thread will continue running (it doesn't wait).

Now you see why NGINX can handle a large amount of requests perfectly well (and without any problems).

For more information take a look at following resources:

- [Asynchronous, Non-Blocking I/O](https://medium.com/@entzik/on-asynchronous-non-blocking-i-o-4a2ac0af5c50)
- [About High Concurrency, NGINX architecture and internals](http://www.aosabook.org/en/nginx.html)
- [A little holiday present: 10,000 reqs/sec with Nginx!](https://blog.webfaction.com/2008/12/a-little-holiday-present-10000-reqssec-with-nginx-2/)
- [Nginx vs Apache: Is it fast, if yes, why?](http://planetunknown.blogspot.com/2011/02/why-nginx-is-faster-than-apache.html)
- [How is Nginx handling its requests in terms of tasks or threading?](https://softwareengineering.stackexchange.com/questions/256510/how-is-nginx-handling-its-requests-in-terms-of-tasks-or-threading)
- [Why nginx is faster than Apache, and why you needn’t necessarily care](https://djangodeployment.com/2016/11/15/why-nginx-is-faster-than-apache-and-why-you-neednt-necessarily-care/)

##### Multiple processes

NGINX uses only asynchronous I/O, which makes blocking a non-issue. The only reason NGINX uses multiple processes is to make full use of multi-core, multi-CPU and hyper-threading systems. NGINX requires only enough worker processes to get the full benefit of symmetric multiprocessing (SMP).

From NGINX documentation:

  > _The NGINX configuration recommended in most cases – running one worker process per CPU core – makes the most efficient use of hardware resources._

NGINX uses a custom event loop which was designed specifically for NGINX - all connections are processed in a highly efficient run-loop in a limited number of single-threaded processes called workers.

Multiplexing works by using a loop to increment through a program chunk by chunk operating on one piece of data/new connection/whatever per connection/object per loop iteration. It is all based on events multiplexing like `epoll()`, `kqueue()`, or `select()`. Within each worker NGINX can handle many thousands of concurrent connections and requests per second.

  > See [Nginx Internals](https://www.slideshare.net/joshzhu/nginx-internals) presentation as a lot of great stuff about the internals of NGINX.

NGINX does not fork a process or thread per connection (like Apache) so memory usage is very conservative and extremely efficient in the vast majority of cases. NGINX is a faster and consumes less memory than Apache. It is also very friendly for CPU because there's no ongoing create-destroy pattern for processes or threads.

Finally and in summary:

- uses Non-Blocking "Event-Driven" architecture
- uses the single-threaded reactor pattern to handle concurrent requests
- uses highly efficient loop for connection processing
- is not a single threaded application because it starts multiple worker processes (to handle multiple connections and requests) during start

##### Simultaneous connections

Okay, so how many simultaneous connections can be processed by NGINX?

```bash
worker_processes * worker_connections = max connections
```

According to this: if you are running **4** worker processes with **4,096** worker connections per worker, you will be able to serve **16,384** connections. Of course, these are the NGINX settings limited by the kernel (number of connections, number of open files, or number of processes).

  > At this point, I would like to mention about [Understanding socket and port in TCP](https://medium.com/fantageek/understanding-socket-and-port-in-tcp-2213dc2e9b0c). It is a great and short explanation. I also recommend to read [Theoretical maximum number of open TCP connections that a modern Linux box can have](https://stackoverflow.com/questions/2332741/what-is-the-theoretical-maximum-number-of-open-tcp-connections-that-a-modern-lin).

I've seen some admins does directly translate the sum of `worker_processes` and `worker_connections` into the number of clients that can be served simultaneously. In my opinion, it is a mistake because certain of clients (e.g. browsers) **opens a number of parallel connections** (see [this](https://stackoverflow.com/questions/985431/max-parallel-http-connections-in-a-browser) to confirm my words). Clients typically establish 4-8 TCP connections so that they can download resources in parallel (to download various components that compose a web page, for example, images, scripts, and so on). This increases the effective bandwidth and reduces latency.

Additionally, you must know that the `worker_connections` directive **includes all connections** per worker (e.g. connection structures are used for listen sockets, internal control sockets between NGINX processes, connections with proxied servers, and for upstream connections), not only incoming connections from clients.

  > Be aware that every worker connection (in the sleeping state) needs 256 bytes of memory, so you can increase it easily.

The number of connections is especially limited by the maximum number of open files (`RLIMIT_NOFILE`) on your system. The reason is that the operating system needs memory to manage each open file, and memory is a limited resource. This limitation only affects the limits for the current process. The limits of the current process are bequeathed to children processes too, but each process has a separate count.

To change the limit of the maximum file descriptors (that can be opened by a single worker process) you can also edit the `worker_rlimit_nofile` directive. With this, NGINX provides very powerful dynamic configuration capabilities with no service restarts.

  > The number of file descriptors is not the only one limitation of the number of connections - remember also about the kernel network (TCP/IP stack) parameters and the maximum number of processes.

I don't like this piece of the NGINX documentation. It says the `worker_rlimit_nofile` is a limit on the maximum number of open files for worker processes. I believe it is associated to a single worker process.

If you set `RLIMIT_NOFILE` to 25,000 and `worker_rlimit_nofile` to 12,000, NGINX sets (only for workers) the maximum open files limit as a `worker_rlimit_nofile`. But the master process will have a set value of `RLIMIT_NOFILE`. Default value of `worker_rlimit_nofile` directive is `none` so by default NGINX sets the initial value of maximum open files from the system limits.

```bash
grep "LimitNOFILE" /lib/systemd/system/nginx.service
LimitNOFILE=5000

grep "worker_rlimit_nofile" /etc/nginx/nginx.conf
worker_rlimit_nofile 256;

   PID       SOFT HARD
 24430       5000 5000
 24431        256 256
 24432        256 256
 24433        256 256
 24434        256 256
```

This is also controlled by the OS because the worker is not the only process running on the machine. It would be very bad if your workers used up all of the file descriptors available to all processes, don't set your limits so that is possible.

In my opinion, relying on the `RLIMIT_NOFILE` than `worker_rlimit_nofile` value is more understandable and predictable. To be honest, it doesn't really matter which method is used to set, but you should keep a constant eye on the priority of the limits.

  > If you don't set the `worker_rlimit_nofile` directive manually, then the OS settings will determine how many file descriptors can be used by NGINX.

I think that the chance of running out of file descriptors is minimal, but it might be a big problem on a high traffic websites.

Ok, so how many fds are opens by NGINX?

- one file handler for the client's active connection
- one file handler for the proxied connection (that will open a socket handling these requests to remote or local host/process)
- one file handler for opening file (e.g. static file)
- other file handlers for internal connections, shared libraries, log files, and sockets

Also important is:

  > NGINX can use up to two file descriptors per full-fledged connection.

Look also at these diagrams:

- 1 file handler for connection with client and 1 file handler for static file being served by NGINX:

  ```
  # 1 connection, 2 file handlers

                       +-----------------+
  +----------+         |                 |
  |          |    1    |                 |
  |  CLIENT <---------------> NGINX      |
  |          |         |        ^        |
  +----------+         |        |        |
                       |      2 |        |
                       |        |        |
                       |        |        |
                       | +------v------+ |
                       | | STATIC FILE | |
                       | +-------------+ |
                       +-----------------+
  ```

- 1 file handler for connection with client and 1 file handler for a open socket to the remote or local host/process:

  ```
  # 2 connections, 2 file handlers

                       +-----------------+
  +----------+         |                 |         +-----------+
  |          |    1    |                 |    2    |           |
  |  CLIENT <---------------> NGINX <---------------> BACKEND  |
  |          |         |                 |         |           |
  +----------+         |                 |         +-----------+
                       +-----------------+
  ```

- 2 file handlers for two simultaneous connections from the same client (1, 4), 1 file handler for connection with other client (3), 2 file handlers for static files (2, 5), and 1 file handler for a open socket to the remote or local host/process (6), so in total it is 6 file descriptors:

  ```
  # 4 connections, 6 file handlers

                    4
        +-----------------------+
        |              +--------|--------+
  +-----v----+         |        |        |
  |          |    1    |        v        |  6
  |  CLIENT <-----+---------> NGINX <---------------+
  |          |    |    |        ^        |    +-----v-----+
  +----------+    |    |        |        |    |           |
                3 |    |      2 | 5      |    |  BACKEND  |
  +----------+    |    |        |        |    |           |
  |          |    |    |        |        |    +-----------+
  |  CLIENT  <----+    | +------v------+ |
  |          |         | | STATIC FILE | |
  +----------+         | +-------------+ |
                       +-----------------+
  ```

In the first two examples: we can take that NGINX needs 2 file handlers for full-fledged connection (but still uses 2 worker connections). In the third example NGINX can take still 2 file handlers for every full-fledged connection (also if client uses parallel connections).

So, to conclude, I think that the correct value of `worker_rlimit_nofile` per all connections of worker should be greater than `worker_connections`.

In my opinion, the safe value of `worker_rlimit_nofile` (and system limits) is:

```bash
# 1 file handler for 1 connection:
worker_connections + (shared libs, log files, event pool etc.) = worker_rlimit_nofile

# 2 file handlers for 1 connection:
(worker_connections * 2) + (shared libs, log files, event pool etc.) = worker_rlimit_nofile
```

That is probably how many files can be opened by each worker and should have a value greater than to the number of connections per worker (according to the above formula).

In the most articles and tutorials we can see that this parameter has a value similar to the maximum number (or even more) of all open files by the NGINX. If we assume that this parameter applies to each worker separately these values are altogether excessive.

However, after a deeper reflection they are rational because they allow one worker to use all the file descriptors so that they are not confined to other workers if something happens to them. Remember though that we are still limited by the connections per worker. May I remind you that any connection opens at least one file.

So, moving on, the maximum number of open files by the NGINX should be:

```bash
(worker_processes * worker_connections * 2) + (shared libs, log files, event pool) = max open files
```

  > To serve **16,384** connections by all workers (4,096 connections for each worker), and bearing in mind about the other handlers used by NGINX, a reasonably value of max files handlers in this case may be **35,000**. I think it's more than enough.

Given the above to change/improve the limitations you should:

1. Edit the maximum, total, global number of file descriptors the kernel will allocate before choking (this step is optional, I think you should change this only for a very very high traffic):

    ```bash
    # Find out the system-wide maximum number of file handles:
    sysctl fs.file-max

    # Shows the current number of all file descriptors in kernel memory:
    #   first value:  <allocated file handles>
    #  second value:  <unused-but-allocated file handles>
    #   third value:  <the system-wide maximum number of file handles> # fs.file-max
    sysctl fs.file-nr

    # Set it manually and temporarily:
    sysctl -w fs.file-max=150000

    # Set it permanently:
    echo "fs.file-max = 150000" > /etc/sysctl.d/99-fs.conf

    # And load new values of kernel parameters:
    sysctl -p       # for /etc/sysctl.conf
    sysctl --system # for /etc/sysctl.conf and all of the system configuration files
    ```

2. Edit the system-wide value of the maximum file descriptor number that can be opened by a single process:

    - for non-systemd systems:

      ```bash
      # Set the maximum number of file descriptors for the users logged in via PAM:
      #   /etc/security/limits.conf
      nginx       soft    nofile    35000
      nginx       hard    nofile    35000
      ```

    - for systemd systems:

      ```bash
      # Set the maximum number (hard limit) of file descriptors for the services started via systemd:
      #   /etc/systemd/system.conf          - global config (default values for all units)
      #   /etc/systemd/user.conf            - this specifies further per-user restrictions
      #   /lib/systemd/system/nginx.service - default unit for the NGINX service
      #   /etc/systemd/system/nginx.service - for your own instance of the NGINX service
      [Service]
      # ...
      LimitNOFILE=35000

      # Reload a unit file and restart the NGINX service:
      systemctl daemon-reload && systemct restart nginx
      ```

3.  Adjusts the system limit on number of open files for the NGINX worker. The maximum value can not be greater than LimitNOFILE (in this example: 35,000). You can change it at any time:

    ```bash
    # Set the limit for file descriptors for a single worker process (change it as needed):
    #   nginx.conf within the main context
    worker_rlimit_nofile          10000;

    # You need to reload the NGINX service:
    nginx -s reload
    ```

To show the current hard and soft limits applying to the NGINX processes (with `nofile`, `LimitNOFILE`, or `worker_rlimit_nofile`):

```bash
for _pid in $(pgrep -f "nginx: [master,worker]") ; do

  echo -en "$_pid "
  grep "Max open files" /proc/${_pid}/limits | awk '{print $4" "$5}'

done | xargs printf '%6s %10s\t%s\n%6s %10s\t%s\n' "PID" "SOFT" "HARD"
```

To list the current open file descriptors for each NGINX process:

```bash
for _pid in $(pgrep -f "nginx: [master,worker]") ; do

  _fds=$(find /proc/${_pid}/fd/*)
  _fds_num=$(echo "$_fds" | wc -l)

  echo -en "\n\n##### PID: $_pid ($_fds_num fds) #####\n\n"

  # List all files from the proc/{pid}/fd directory:
  echo -en "$_fds\n\n"

  # List all open files (log files, memory mapped files, libs):
  lsof -as -p $_pid | awk '{if(NR>1)print}'

done
```

You should also remember about the following rules:

- `worker_rlimit_nofile` serves to dynamically change the maximum file descriptors the NGINX worker processes can handle, which is typically defined with the system's soft limit (`ulimit -Sn`)

- `worker_rlimit_nofile` works only at the process level, it's limited to the system's hard limit (`ulimit -Hn`)

- if you have SELinux enabled, you will need to run `setsebool -P httpd_setrlimit 1` so that NGINX has permissions to set its rlimit. To diagnose SELinux denials and attempts you can use `sealert -a /var/log/audit/audit.log`

To sum up this example:

- each of the NGINX processes (master + workers) have the ability to create up to 35,000 files
- for all workers, the maximum number of file descriptors is 140,000 (`LimitNOFILE` per worker)
- for each worker, the initial/current number of file descriptors is 10,000 (`worker_rlimit_nofile`)

```
nginx: master process         = LimitNOFILE (35,000)
  \_ nginx: worker process    = LimitNOFILE (35,000), worker_rlimit_nofile (10,000)
  \_ nginx: worker process    = LimitNOFILE (35,000), worker_rlimit_nofile (10,000)
  \_ nginx: worker process    = LimitNOFILE (35,000), worker_rlimit_nofile (10,000)
  \_ nginx: worker process    = LimitNOFILE (35,000), worker_rlimit_nofile (10,000)

                              = master (35,000), all workers (140,000 or 40,000)
```

There is a great article about [Optimizing Nginx for High Traffic Loads](https://blog.martinfjordvald.com/2011/04/optimizing-nginx-for-high-traffic-loads/).

##### HTTP Keep-Alive connections

Before starting this section I recommend to read the following articles:

- [HTTP Keepalive Connections and Web Performance](https://www.nginx.com/blog/http-keepalives-and-web-performance/)
- [Optimizing HTTP: Keep-alive and Pipelining](https://www.igvita.com/2011/10/04/optimizing-http-keep-alive-and-pipelining/)
- [Evolution of HTTP — HTTP/0.9, HTTP/1.0, HTTP/1.1, Keep-Alive, Upgrade, and HTTPS](https://medium.com/platform-engineer/evolution-of-http-69cfe6531ba0)

The original model of HTTP, and the default one in HTTP/1.0, is short-lived connections. Each HTTP request is completed on its own connection; this means a TCP handshake happens before each HTTP request, and these are serialized. The client creates a new TCP connection for each transaction (and the connection is torn down after the transaction completes).

HTTP Keep-Alive connection or persistent connection is the idea of using a single TCP connection to send and receive multiple HTTP requests/responses (Keep Alive's work between requests), as opposed to opening a new connection for every single request/response pair.

This mechanism hold open the TCP connection between the client and the server after an HTTP transaction has completed. It's important because NGINX needs to close connections from time to time, even if you configure NGINX to allow infinite keep-alive-timeouts and a huge amount of acceptable requests per connection, to return results and as well errors and success messages.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/closed_vs_keepalive.png" alt="closed_vs_keepalive">
</p>

Persistent connection model keeps connections opened between successive requests, reducing the time needed to open new connections. The HTTP pipelining model goes one step further, by sending several successive requests without even waiting for an answer, reducing much of the latency in the network.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http_connections.png" alt="http_connections">
</p>

<sup><i>This infographic comes from [Mozilla MDN - Connection management in HTTP/1.x](https://developer.mozilla.org/en-US/docs/Web/HTTP/Connection_management_in_HTTP_1.x).</i></sup>

Look also at this example that shows how a Keep-Alive header could be used:

```
 Client                        Proxy                         Server
   |                             |                              |
   +- Keep-Alive: timeout=600 -->|                              |
   |  Connection: Keep-Alive     |                              |
   |                             +- Keep-Alive: timeout=1200 -->|
   |                             |  Connection: Keep-Alive      |
   |                             |                              |
   |                             |<-- Keep-Alive: timeout=300 --+
   |                             |    Connection: Keep-Alive    |
   |<- Keep-Alive: timeout=5000 -+                              |
   |    Connection: Keep-Alive   |                              |
   |                             |                              |
```

NGINX official documentation say:

  > _All connections are independently negotiated. The client indicates a timeout of 600 seconds (10 minutes), but the proxy is only prepared to retain the connection for at least 120 seconds (2 minutes). On the link between proxy and server, the proxy requests a timeout of 1200 seconds and the server reduces this to 300 seconds. As this example shows, the timeout policies maintained by the proxy are different for each connection. Each connection hop is independent._

Keepalive connections reduce overhead, especially when SSL/TLS is in use but they also have drawbacks; even when idling they consume server resources, and under heavy load, DoS attacks can be conducted. In such cases, using non-persistent connections, which are closed as soon as they are idle, can provide better performance.

  > NGINX closes keepalive connections when the `worker_connections` limit is reached.

To better understand how Keep-Alive works, I recommend a great [explanation](https://stackoverflow.com/a/38190172) by [Barry Pollard](https://stackoverflow.com/users/2144578/barry-pollard).

NGINX provides the two layers to enable Keep-Alive:

###### Client layer

- the maximum number of keepalive requests a client can make over a given connection, which means a client can make e.g. 256 successfull requests inside one keepalive connection:

  ```bash
  # Default: 100
  keepalive_requests  256;
  ```

- server will close connection after this time. A higher number may be required when there is a larger amount of traffic to ensure there is no frequent TCP connection re-initiated. If you set it lower, you are not utilizing keep-alives on most of your requests slowing down client:

  ```bash
  # Default: 75s
  keepalive_timeout   10s;
  ```

  > Increase this to allow the keepalive connection to stay open longer, resulting in faster subsequent requests. However, setting this too high will result in the waste of resources (mainly memory) as the connection will remain open even if there is no traffic, potentially: significantly affecting performance. I think this should be as close to your average response time as possible.

###### Upstream layer

- the number of idle keepalive connections that remain open for each worker process. The connections parameter sets the maximum number of idle keepalive connections to upstream servers that are preserved in the cache of each worker process (when this number is exceeded, the least recently used connections are closed):

  ```bash
  # Default: disable
  keepalive         32;
  ```

NGINX, by default, only talks HTTP/1.0 to the upstream servers. To keep TCP connection alive both upstream section and origin server should be configured to not finalise the connection.

  > Please keep in mind that keepalive is a feature of HTTP 1.1, NGINX uses HTTP 1.0 per default for upstreams.

Connection won't be reused by default because keepalive in the upstream section means no keepalive (each time you can see TCP stream number increases per every request to origin server).

HTTP keepalive enabled in NGINX upstream servers reduces latency thus improves performance and it reduces the possibility that the NGINX runs out of ephemeral ports.

  > The connections parameter should be set to a number small enough to let upstream servers process new incoming connections as well.

Update your upstream configuration to use keepalive:

```bash
upstream bk_x8080 {

  ...

  keepalive         16;

}
```

And enable the HTTP/1.1 protocol in all upstream requests:

```bash
server {

  ...

  location / {

    # Default is HTTP/1, keepalive is only enabled in HTTP/1.1:
    proxy_http_version  1.1;
    # Remove the Connection header if the client sends it,
    # it could be "close" to close a keepalive connection:
    proxy_set_header    Connection "";

    proxy_pass          http://bk_x8080;

  }

}

...

}
```

#### Request processing stages

There can be altogether 11 phases when NGINX handles (processes) a request:

- `NGX_HTTP_POST_READ_PHASE` - first phase, read the request header
  - example modules: [ngx_http_realip_module](https://nginx.org/en/docs/http/ngx_http_realip_module.html)

- `NGX_HTTP_SERVER_REWRITE_PHASE` - implementation of rewrite directives defined in a server block; to change request URI using PCRE regular expressions, return redirects, and conditionally select configurations
  - example modules: [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)

- `NGX_HTTP_FIND_CONFIG_PHASE` - replace the location according to URI (location lookup)

- `NGX_HTTP_REWRITE_PHASE` - URI transformation on location level
  - example modules: [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)

- `NGX_HTTP_POST_REWRITE_PHASE` - URI transformation post-processing (the request is redirected to a new location)
  - example modules: [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)

- `NGX_HTTP_PREACCESS_PHASE` - authentication preprocessing request limit, connection limit (access restriction)
  - example modules: [ngx_http_limit_req_module](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html), [ngx_http_limit_conn_module](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html), [ngx_http_realip_module](https://nginx.org/en/docs/http/ngx_http_realip_module.html)

- `NGX_HTTP_ACCESS_PHASE` - verification of the client (the authentication process, limiting access)
  - example modules: [ngx_http_access_module](https://nginx.org/en/docs/http/ngx_http_access_module.html), [ngx_http_auth_basic_module](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html)

- `NGX_HTTP_POST_ACCESS_PHASE` - access restrictions check post-processing phase, the certification process, processing `satisfy any` directive
  - example modules: [ngx_http_access_module](https://nginx.org/en/docs/http/ngx_http_access_module.html), [ngx_http_auth_basic_module](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html)

- `NGX_HTTP_PRECONTENT_PHASE` - generating content
  - example modules: [ngx_http_try_files_module](https://nginx.org/en/docs/http/ngx_http_core_module.html#try_files)

- `NGX_HTTP_CONTENT_PHASE` - content processing
  - example modules: [ngx_http_index_module](https://nginx.org/en/docs/http/ngx_http_index_module.html), [ngx_http_autoindex_module](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html), [ngx_http_gzip_module](https://nginx.org/en/docs/http/ngx_http_gzip_module.html)

- `NGX_HTTP_LOG_PHASE` - log processing
  - example modules: [ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html)

You may feel lost now (me too...) so I let myself put this great and simple preview:

<p align="center">
  <a href="https://www.nginx.com/resources/library/infographic-inside-nginx/">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/request-flow.png" alt="request-flow">
  </a>
</p>

<sup><i>This infographic comes from [Inside NGINX](https://www.nginx.com/resources/library/infographic-inside-nginx/) official library.</i></sup>

On every phase you can register any number of your handlers. Each phase has a list of handlers associated with it.

I recommend a great explanation about [HTTP request processing phases in Nginx](http://scm.zoomquiet.top/data/20120312173425/index.html) and, of course, official [Development guide](http://nginx.org/en/docs/dev/development_guide.html).

#### Server blocks logic

  > NGINX does have **server blocks** (like a virtual hosts in an Apache) that use `listen` and `server_name` directives to bind to TCP sockets.

Before start reading this chapter you should know what regular expressions are and how they works (they are not a black magic really). I recommend two great and short write-ups about regular expressions created by [Jonny Fox](https://medium.com/@jonny.fox):

- [Regex tutorial — A quick cheatsheet by examples](https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285)
- [Regex cookbook — Top 10 Most wanted regex](https://medium.com/factory-mind/regex-cookbook-most-wanted-regex-aa721558c3c1)

Why? Regular expressions can be used in both the `server_name` and `location` (also in other) directives, and sometimes you must have a great skills of reading them. I think you should create the most readable regular expressions that do not become spaghetti code - impossible to debug and maintain.

NGINX uses the [PCRE](https://www.pcre.org/) library to perform complex manipulations with your `location` blocks and use the powerful `rewrite` and `return` directives. Below is something interesting:

- [Learn PCRE in Y minutes](https://learnxinyminutes.com/docs/pcre/)
- [PCRE Regex Cheatsheet](https://www.debuggex.com/cheatsheet/regex/pcre)
- [Regular Expression Cheat Sheet - PCRE](https://github.com/niklongstone/regular-expression-cheat-sheet)
- [Regex cheatsheet](https://remram44.github.io/regex-cheatsheet/regex.html)
- [Regular expressions in Perl](http://jkorpela.fi/perl/regexp.html)
- [Regexp Security Cheatsheet](https://github.com/attackercan/regexp-security-cheatsheet)

You can also use external tools for testing regular expressions. For more please see [online tools](#online-tools) chapter.

If you're good at it, check these very nice and brainstorming regex challenges:

- [RegexGolf](https://alf.nu/RegexGolf)
- [Regex Crossword](https://regexcrossword.com/)

It's a short example of two server block contexts with several regular expressions:

```bash
http {

  index index.html;
  root /var/www/example.com/default;

  server {

    listen 10.10.250.10:80;
    server_name www.example.com;

    access_log logs/example.access.log main;

    root /var/www/example.com/public;

    location ~ ^/(static|media)/ { ... }

    location ~* /[0-9][0-9](-.*)(\.html)$ { ... }

    location ~* \.(jpe?g|png|gif|ico)$ { ... }

    location ~* (?<begin>.*app)/(?<end>.+\.php)$ { ... }

    ...

  }

  server {

    listen 10.10.250.11:80;
    server_name "~^(api.)?example\.com api.de.example.com";

    access_log logs/example.access.log main;

    location ~ ^(/[^/]+)/api(.*)$ { ... }

    location ~ ^/backend/id/([a-z]\.[a-z]*) { ... }

    ...

  }

}
```

##### Handle incoming connections

NGINX uses the following logic to determining which virtual server (server block) should be used:

1. Match the `address:port` pair to the `listen` directive - that can be multiple server blocks with `listen` directives of the same specificity that can handle the request

    > NGINX use the `address:port` combination for handle incoming connections. This pair is assigned to the `listen` directive.

    The `listen` directive can be set to:

      - an IP address/port combination (`127.0.0.1:80;`)

      - a lone IP address, if only address is given, the port `80` is used (`127.0.0.1;`) - becomes `127.0.0.1:80;`

      - a lone port which will listen to every interface on that port (`80;` or `*:80;`) - becomes `0.0.0.0:80;`

      - the path to a UNIX domain socket (`unix:/var/run/nginx.sock;`)

    If the `listen` directive is not present then either `*:80` is used (runs with the superuser privileges), or `*:8000` otherwise.

    To play with `listen` directive NGINX must follow the following steps:

      - NGINX translates all incomplete `listen` directives by substituting missing values with their default values (see above)

      - NGINX attempts to collect a list of the server blocks that match the request most specifically based on the `address:port`

      - If any block that is functionally using `0.0.0.0`, will not be selected if there are matching blocks that list a specific IP

      - If there is only one most specific match, that server block will be used to serve the request

      - If there are multiple server blocks with the same level of matching, NGINX then begins to evaluate the `server_name` directive of each server block

    Look at this short example:

    ```bash
    # From client side:
    GET / HTTP/1.0
    Host: api.random.com

    # From server side:
    server {

      # This block will be processed:
      listen 192.168.252.10;  # --> 192.168.252.10:80

      ...

    }

    server {

      listen 80;  # --> *:80 --> 0.0.0.0:80
      server_name api.random.com;

      ...

    }
    ```

2. Match the `Host` header field against the `server_name` directive as a string (the exact names hash table)

3. Match the `Host` header field against the `server_name` directive with a
wildcard at the beginning of the string (the hash table with wildcard names starting with an asterisk)

    > If one is found, that block will be used to serve the request. If multiple matches are found, the longest match will be used to serve the request.

4. Match the `Host` header field against the `server_name` directive with a
wildcard at the end of the string (the hash table with wildcard names ending with an asterisk)

    > If one is found, that block is used to serve the request. If multiple matches are found, the longest match will be used to serve the request.

5. Match the `Host` header field against the `server_name` directive as a regular expression

    > The first `server_name` with a regular expression that matches the `Host` header will be used to serve the request.

6. If all the `Host` headers doesn't match, then direct to the `listen` directive marked as `default_server` (makes the server block answer all the requests that doesn’t match any server block)

7. If all the `Host` headers doesn't match and there is no `default_server`,
direct to the first server with a `listen` directive that satisfies first step

8. Finally, NGINX goes to the `location` context

<sup><i>This list is based on [Mastering Nginx - The virtual server section](#mastering-nginx).</i></sup>

##### Matching location

  > For each request, NGINX goes through a process to choose the best location block that will be used to serve that request.

The location block enables you to handle several types of URIs/routes, within a server block. Syntax looks like:

```bash
location optional_modifier location_match { ... }
```

`location_match` in the above defines what NGINX should check the request URI against. The `optional_modifier` below will cause the associated location block to be interpreted as follows (the order doesn't matter at this moment):

- `(none)`: if no modifiers are present, the location is interpreted as a prefix match. To determine a match, the location will now be matched against the beginning of the URI

- `=`: is an exact match, without any wildcards, prefix matching or regular expressions; forces a literal match between the request URI and the location parameter

- `~`: if a tilde modifier is present, this location must be used for case sensitive matching (RE match)

- `~*`: if a tilde and asterisk modifier is used, the location must be used for case insensitive matching (RE match)

- `^~`: assuming this block is the best non-RE match, a carat followed by a tilde modifier means that RE matching will not take place

And now, a short introduction to determines location priority:

- the exact match is the best priority (processed first); ends search if match

- the prefix match is the second priority; there are two types of prefixes: `^~` and `(none)`, if this match used the `^~` prefix, searching stops

- the regular expression match has the lowest priority; there are two types of prefixes: `~` and `~*`; in the order they are defined in the configuration file

- if regular expression searching yielded a match, that result is used, otherwise, the match from prefix searching is used

So look at this example, it comes from the [Nginx documentation - ngx_http_core_module](https://nginx.org/en/docs/http/ngx_http_core_module.html#location):

```bash
location = / {
  # Matches the query / only.
  [ configuration A ]
}
location / {
  # Matches any query, since all queries begin with /, but regular
  # expressions and any longer conventional blocks will be
  # matched first.
  [ configuration B ]
}
location /documents/ {
  # Matches any query beginning with /documents/ and continues searching,
  # so regular expressions will be checked. This will be matched only if
  # regular expressions don't find a match.
  [ configuration C ]
}
location ^~ /images/ {
  # Matches any query beginning with /images/ and halts searching,
  # so regular expressions will not be checked.
  [ configuration D ]
}
location ~* \.(gif|jpg|jpeg)$ {
  # Matches any request ending in gif, jpg, or jpeg. However, all
  # requests to the /images/ directory will be handled by
  # Configuration D.
  [ configuration E ]
}
```

To help you understand how does location match works:

- [Nginx location match tester](https://nginx.viraptor.info/)
- [Nginx location match visible](https://detailyang.github.io/nginx-location-match-visible/)

The process of choosing NGINX location block is as follows (a detailed explanation):

1. NGINX searches for an exact match. If a `=` modifier exactly matches the request URI, this specific location block is chosen right away

2. Prefix-based NGINX location matches (no regular expression). Each location will be checked against the request URI. If no exact (meaning no `=` modifier) location block is found, NGINX will continue with non-exact prefixes. It starts with the longest matching prefix location for this URI, with the following approach:

    - In case the longest matching prefix location has the `^~` modifier, NGINX will stop its search right away and choose this location.

    - Assuming the longest matching prefix location doesn’t use the `^~` modifier, the match is temporarily stored and the process continues.

3. As soon as the longest matching prefix location is chosen and stored, NGINX continues to evaluate the case-sensitive and insensitive regular expression locations. The first regular expression location that fits the URI is selected right away to process the request

4. If no regular expression locations are found that match the request URI, the previously stored prefix location is selected to serve the request

In order to better understand how this process work please see this short cheatsheet that will allow you to design your location blocks in a predictable way:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx_location_cheatsheet.png" alt="nginx-location-cheatsheet">
</p>

  > I recommend to use external tools for testing regular expressions. For more please see [online tools](#online-tools) chapter.

Ok, so here's a more complicated configuration:

```bash
server {

 listen           80;
 server_name      xyz.com www.xyz.com;

 location ~ ^/(media|static)/ {
  root            /var/www/xyz.com/static;
  expires         10d;
 }

 location ~* ^/(media2|static2) {
  root            /var/www/xyz.com/static2;
  expires         20d;
 }

 location /static3 {
  root            /var/www/xyz.com/static3;
 }

 location ^~ /static4 {
  root            /var/www/xyz.com/static4;
 }

 location = /api {
  proxy_pass      http://127.0.0.1:8080;
 }

 location / {
  proxy_pass      http://127.0.0.1:8080;
 }

 location /backend {
  proxy_pass      http://127.0.0.1:8080;
 }

 location ~ logo.xcf$ {
  root            /var/www/logo;
  expires         48h;
 }

 location ~* .(png|ico|gif|xcf)$ {
  root            /var/www/img;
  expires         24h;
 }

 location ~ logo.ico$ {
  root            /var/www/logo;
  expires         96h;
 }

 location ~ logo.jpg$ {
  root            /var/www/logo;
  expires         48h;
 }

}
```

And here's the table with the results:

| <b>URL</b> | <b>LOCATIONS FOUND</b> | <b>FINAL MATCH</b> |
| :---         | :---         | :---         |
| `/` | <sup>1)</sup> prefix match for `/` | `/` |
| `/css` | <sup>1)</sup> prefix match for `/` | `/` |
| `/api` | <sup>1)</sup> exact match for `/api` | `/api` |
| `/api/` | <sup>1)</sup> prefix match for `/` | `/` |
| `/backend` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> prefix match for `/backend` | `/backend` |
| `/static` | <sup>1)</sup> prefix match for `/` | `/` |
| `/static/header.png` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `^/(media\|static)/` | `^/(media\|static)/` |
| `/static/logo.jpg` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `^/(media\|static)/` | `^/(media\|static)/` |
| `/media2` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `^/(media2\|static2)` | `^/(media2\|static2)` |
| `/media2/` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `^/(media2\|static2)` | `^/(media2\|static2)` |
| `/static2/logo.jpg` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `^/(media2\|static2)` | `^/(media2\|static2)` |
| `/static2/logo.png` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `^/(media2\|static2)` | `^/(media2\|static2)` |
| `/static3/logo.jpg` | <sup>1)</sup> prefix match for `/static3`<br><sup>2)</sup> prefix match for `/`<br><sup>3)</sup> case sensitive regex match for `logo.jpg$` | `logo.jpg$` |
| `/static3/logo.png` | <sup>1)</sup> prefix match for `/static3`<br><sup>2)</sup> prefix match for `/`<br><sup>3)</sup> case insensitive regex match for `.(png\|ico\|gif\|xcf)$` | `.(png\|ico\|gif\|xcf)$` |
| `/static4/logo.jpg` | <sup>1)</sup> priority prefix match for `/static4`<br><sup>2)</sup> prefix match for `/` | `/static4` |
| `/static4/logo.png` | <sup>1)</sup> priority prefix match for `/static4`<br><sup>2)</sup> prefix match for `/` | `/static4` |
| `/static5/logo.jpg` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `logo.jpg$` | `logo.jpg$` |
| `/static5/logo.png` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `.(png\|ico\|gif\|xcf)$` | `.(png\|ico\|gif\|xcf)$` |
| `/static5/logo.xcf` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `logo.xcf$` | `logo.xcf$` |
| `/static5/logo.ico` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `.(png\|ico\|gif\|xcf)$` | `.(png\|ico\|gif\|xcf)$` |

##### `rewrite` vs `return`

Generally there are two ways of implementing redirects in NGINX: with `rewrite` and `return`.

These directives (they come from the `ngx_http_rewrite_module`) are very useful but (from the NGINX documentation) the only 100% safe things which may be done inside if in a location context are:

- `return ...;`
- `rewrite ... last;`

Anything else may possibly cause unpredictable behaviour, including potential `SIGSEGV`.

###### `rewrite` directive

The `rewrite` directives are executed sequentially in order of their appearance in the configuration file. It's slower (but still extremely fast) than a `return` and returns HTTP 302 in all cases, irrespective of `permanent`.

Importantly only the part of the original url that matches the regex is rewritten. It can be used for temporary url changes.

I sometimes used `rewrite` to capture elementes in the original URL, change or add elements in the path, and in general when I do something more complex:

```bash
location / {

  ...

  rewrite   ^/users/(.*)$       /user.php?username=$1 last;

  # or:
  rewrite   ^/users/(.*)/items$ /user.php?username=$1&page=items last;

}
```

`rewrite` directive accept optional flags:

- `break` - basically completes processing of rewrite directives, stops processing, and breakes location lookup cycle by not doing any location lookup and internal jump at all

  - if you use `break` flag inside `location` block:

    - no more parsing of rewrite conditions
    - internal engine continues to parse the current `location` block

    _Inside a location block, with `break`, NGINX only stops processing anymore rewrite conditions._

  - if you use `break` flag outside `location` block:

    - no more parsing of rewrite conditions
    - internal engine goes to the next phase (searching for `location` match)

    _Outside a location block, with `break`, NGINX stops processing anymore rewrite conditions._

- `last` - basically completes processing of rewrite directives, stops processing, and starts a search for a new location matching the changed URI

  - if you use `last` flag inside `location` block:

    - no more parsing of rewrite conditions
    - internal engine **starts to look** for another location match based on the result of the rewrite result
    - no more parsing of rewrite conditions, even on the next location match

    _Inside a location block, with last, NGINX stops processing anymore rewrite conditions and then **starts to look** for a new matching of location block. NGINX also ignores any rewrites in the new location block._

  - if you use `last` flag outside `location` block:

    - no more parsing of rewrite conditions
    - internal engine goes to the next phase (searching for `location` match)

    _Outside a location block, with `last`, NGINX stops processing anymore rewrite conditions._

- `redirect` - returns a temporary redirect with the 302 HTTP response code
- `permanent` - returns a permanent redirect with the 301 HTTP response code

Note:

- that outside location blocks, `last` and `break` are effectively the same
- processing of rewrite directives at server level may be stopped via `break`, but the location lookup will follow anyway

<sup><i>This explanation is based on the awesome answer by [Pothi Kalimuthu](https://serverfault.com/users/102173/pothi-kalimuthu) to [nginx url rewriting: difference between break and last](https://serverfault.com/a/829148).</i></sup>

Official documentation has a great tutorials about [Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/) and [Converting rewrite rules](https://nginx.org/en/docs/http/converting_rewrite_rules.html).

###### `return` directive

The other way is a `return` directive. It's faster than rewrite because there is no regexp that has to be evaluated. It's stops processing and returns HTTP 301 (by default) to a client, and the entire url is rerouted to the url specified.

I use `return` directive in the following cases:

- force redirect from http to https:

  ```bash
  server {

    ...

    return  301 https://example.com$request_uri;

  }
  ```

- redirect from www to non-www and vice versa:

  ```bash
  server {

    ...

    if ($host = www.domain.com) {

      return  301 https://domain.com$request_uri;

    }

  }
  ```

- close the connection and log it internally:

  ```bash
  server {

    ...

    return 444;

  }
  ```

- send 4xx HTTP response for a client without any other actions:

  ```bash
  server {

    ...

    if ($request_method = POST) {

      return 405;

    }

    # or:
    if ($invalid_referer) {

      return 403;

    }

    # or:
    if ($request_uri ~ "^/app/(.+)$") {

      return 403;

    }

    # or:
    location ~ ^/(data|storage) {

      return 403;

    }

  }
  ```

- and sometimes for reply with HTTP code without serving a file:

  ```bash
  server {

    ...

    # NGINX will not allow a 200 with no response body (200's need to be with a resource in the response)
    return 204 "it's all okay";

    # Because default Content-Type is application/octet-stream, browser will offer to "save the file".
    # If you want to see reply in browser you should add properly Content-Type:
    # add_header Content-Type text/plain;

  }
  ```

##### `try_files` directive

We have one more very interesting and important directive: `try_files` (from the `ngx_http_core_module`). This directive tells NGINX to check for the existence of a named set of files or directories (checks files conditionally breaking on success).

I think the best explanation come from official documentation:

  > _`try_files` checks the existence of files in the specified order and uses the first found file for request processing; the processing is performed in the current context. The path to a file is constructed from the file parameter according to the root and alias directives. It is possible to check directory’s existence by specifying a slash at the end of a name, e.g. `$uri/`. If none of the files were found, an internal redirect to the uri specified in the last parameter is made._

Generally it may check files on disk, redirect to proxies or internal locations, and return error codes, all in one directive.

Take a look at the following example:

```bash
server {

  ...

  root /var/www/example.com;

  location / {

    try_files $uri $uri/ /frontend/index.html;

  }

  location ^~ /images {

    root /var/www/static;
    try_files $uri $uri/ =404;

  }

  ...
```

- default root directory for all locations is `/var/www/example.com`

- `location /` - matches all locations without more specific locations, e.g. exact names

  - `try_files $uri` - when you receive a URI that's matched by this block try `$uri` first

    > For example: `https://example.com/tools/en.js` - NGINX will try to check if there's a file inside `/tools` called `en.js`, if found it, serve it in the first place.

  - `try_files $uri $uri/` - if you didn't find the first condition try the URI as a directory

    > For example: `https://example.com/backend/` - NGINX will try first check if a file called `backend` exists, if can't find it then goes to second check `$uri/` and see if there's a directory called `backend` exists then it will try serving it.

  - `try_files $uri $uri/ /frontend/index.html` - if a file and directory not found, NGINX sends `/frontend/index.html`

- `location ^~ /images` - handle any query beginning with `/images` and halts searching

  - default root directory for this location is `/var/www/static`

  - `try_files $uri` - when you receive a URI that's matched by this block try `$uri` first

    > For example: `https://example.com/images/01.gif` - NGINX will try to check if there's a file inside `/images` called `01.gif`, if found it, serve it in the first place.

  - `try_files $uri $uri/` - if you didn't find the first condition try the URI as a directory

    > For example: `https://example.com/images/` - NGINX will try first check if a file called `images` exists, if can't find it then goes to second check `$uri/` and see if there's a directory called `images` exists then it will try serving it.

  - `try_files $uri $uri/ =404` - if a file and directory not found, NGINX sends `HTTP 404` (Not Found)

##### `if`, `break` and `set`

The `ngx_http_rewrite_module` also provides additional directives:

- `break` - stops processing, if is specified inside the `location`, further processing of the request continues in this location:

  ```bash
  # It's useful for:
  if ($slow_resp) {

    limit_rate 50k;
    break;

  }
  ```

- `if` - you can use `if` inside a `server` but not the other way around, also notice that you shouldn't use `if` inside `location` as it may not work as desired. The NGINX docs say:

  > _There are cases where you simply cannot avoid using an `if`, for example if you need to test a variable which has no equivalent directive._

  You should also remember about this:

  > _> The `if` context in NGINX is provided by the rewrite module and this is the primary intended use of this context. Since NGINX will test conditions of a request with many other purpose-made directives, `if` **should not** be used for most forms of conditional execution. This is such an important note that the NGINX community has created a page called [if is evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/)._

- `set` - sets a value for the specified variable. The value can contain text, variables, and their combination

Example of usage `if` and `set` directives:

```bash
# It comes from: https://gist.github.com/jrom/1760790:
if ($request_uri = /) {

  set $test  A;

}

if ($host ~* example.com) {

  set $test  "${test}B";

}

if ($http_cookie !~* "auth_token") {

  set $test  "${test}C";

}

if ($test = ABC) {

  proxy_pass http://cms.example.com;
  break;

}
```

#### Log files

Log files are a critical part of the NGINX management. It writes information about client requests in the access log right after the request is processed (in the last phase: `NGX_HTTP_LOG_PHASE`).

By default:

- the access log is located in `logs/access.log`, but I suggest you take it to `/var/log/nginx` directory
- data is written in the predefined `combined` format

##### Conditional logging

Sometimes certain entries are there just to fill up the logs or are cluttering them. I sometimes exclude requests - by client IP or whatever else - when I want to debug log files more effective.

So, in this example, if the `$error_codes` variable’s value is 0 - then log nothing (default action), but if 1 (e.g. `404` or `503` from backend) - to save this request to the log:

```bash
# Define map in the http context:
http {

  ...

  map $status $error_codes {

    default   1;
    ~^[23]    0;

  }

  ...

  # Add if condition to access log:
  access_log /var/log/nginx/example.com-access.log combined if=$error_codes;

}
```

##### Manually log rotation

NGINX will re-open its logs in response to the `USR1` signal:

```bash
cd /var/log/nginx

mv access.log access.log.0
kill -USR1 $(cat /var/run/nginx.pid) && sleep 1

# >= gzip-1.6:
gzip -k access.log.0
# With any version:
gzip < access.log.0 > access.log.0.gz

# Test integrity and remove if test passed:
gzip -t access.log.0 && rm -fr access.log.0
```

  > You can also read about how to [configure log rotation policy](#beginner-configure-log-rotation-policy).

##### Error log severity levels

The following is a list of all severity levels:

| <b>TYPE</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `debug` | information that can be useful to pinpoint where a problem is occurring |
| `info` | informational messages that aren’t necessary to read but may be good to know |
| `notice` | something normal happened that is worth noting |
| `warn` | something unexpected happened, however is not a cause for concern |
| `error` | something was unsuccessful, contains the action of limiting rules |
| `crit` | important problems that need to be addressed |
| `alert` | severe situation where action is needed promptly |
| `emerg` | the system is in an unusable state and requires immediate attention |

For example: if you set `crit` error log level, messages of `crit`, `alert`, and `emerg` levels are logged.

#### Reverse proxy

  > After reading this chapter, please see on the [Rules: Reverse Proxy)](#reverse-proxy-1).

This is one of the greatest feature of the NGINX. In simplest terms, a reverse proxy is a server that comes in-between internal applications and external clients, forwarding client requests to the appropriate server. It takes a client request, passes it on to one or more servers, and subsequently delivers the server’s response back to the client.

Official NGINX documentation say:

  > _Proxying is typically used to distribute the load among several servers, seamlessly show content from different websites, or pass requests for processing to application servers over protocols other than HTTP._

A reverse proxy can off load much of the infrastructure concerns of a high-volume distributed web application.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/reverse-proxy/reverse-proxy_preview.png" alt="reverse-proxy_preview">
</p>

<sup><i>This infographic comes from [Jenkins with NGINX - Reverse proxy with https](https://medium.com/@sportans300/nginx-reverse-proxy-with-https-466daa4da4fc).</i></sup>

This allow you to have NGINX reverse proxy requests to unicorns, mongrels, webricks, thins, or whatever you really want to have run your servers.

Reverse proxy gives you number of advanced features such as:

- load balancing, failover, and transparent maintenance of the backend servers
- increased security (e.g. SSL termination, hide upstream configuration)
- increased performance (e.g. caching, load balancing)
- simplifies the access control responsibilities (single point of access and maintenance)
- centralised logging and auditing (single point of maintenance)
- add/remove/modify HTTP headers

In my opinion, the two most important things related to the reverse proxy are:

- the way of requests forwarded to the backend
- the type of headers forwarded to the backend

##### Passing requests

When NGINX proxies a request, it sends the request to a specified proxied server, fetches the response, and sends it back to the client.

It is possible to proxy requests to:

- an HTTP servers (e.g. NGINX, Apache, or other) with `proxy_pass` directive:

  ```bash
  upstream bk_front {

    server 192.168.252.20:8080  weight=5;
    server 192.168.252.21:8080

  }

  server {

    location / {

      proxy_pass    http://bk_front;

    }

    location /api {

      proxy_pass    http://192.168.21.20:8080;

    }

    location /info {

      proxy_pass    http://localhost:3000;

    }

    location /ra-client {

      proxy_pass    http://10.0.11.12:8080/guacamole/;

    }

    location /foo/bar/ {

      proxy_pass    http://www.example.com/url/;

    }

    ...

  }
  ```

- a non-HTTP servers (e.g. PHP, Node.js, Python, Java, or other) with `proxy_pass` directive (as a fallback) or directives specially designed for this:

  - `fastcgi_pass` which passes a request to a FastCGI server ([PHP FastCGI Example](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)):

    ```bash
    server {

      ...

      location ~ ^/.+\.php(/|$) {

        fastcgi_pass    127.0.0.1:9000;
        include         /etc/nginx/fcgi_params;

      }

      ...

    }
    ```

  - `uwsgi_pass` which passes a request to a uWSGI server ([Nginx support uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/Nginx.html)):

    ```bash
    server {

      location / {

        root            html;
        uwsgi_pass      django_cluster;
        uwsgi_param     UWSGI_SCRIPT testapp;
        include         /etc/nginx/uwsgi_params;

      }

      ...

    }
    ```

  - `scgi_pass` which passes a request to an SCGI server:

    ```bash
    server {

      location / {

        scgi_pass       127.0.0.1:4000;
        include         /etc/nginx/scgi_params;

      }

      ...

    }
    ```

  - `memcached_pass` which passes a request to a Memcached server:

    ```bash
    server {

      location / {

        set            $memcached_key "$uri?$args";
        memcached_pass memc_instance:4004;

        error_page     404 502 504 = @memc_fallback;

      }

      location @memc_fallback {

        proxy_pass     http://backend;

      }

      ...

    }
    ```

  - `redis_pass` which passes a request to a Redis server ([HTTP Redis](https://www.nginx.com/resources/wiki/modules/redis/)):

    ```bash
    server {

      location / {

        set            $redis_key $uri;

        redis_pass     redis_instance:6379;
        default_type   text/html;
        error_page     404 = /fallback;

      }

      location @fallback {

        proxy_pass     http://backend;

      }

      ...

    }
    ```

The `proxy_pass` and other `*_pass` directives specifies that all requests which match the location block should be forwarded to the specific socket, where the backend app is running.

However, more complex apps may need additional directives:

  - `proxy_pass` - see [`ngx_http_proxy_module`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) directives explanation
  - `fastcgi_pass` - see [`ngx_http_fastcgi_module`](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html) directives explanation
  - `uwsgi_pass` - see [`ngx_http_uwsgi_module`](http://nginx.org/en/docs/http/ngx_http_uwsgi_module.html) directives explanation
  - `scgi_pass` - see [`ngx_http_scgi_module`](http://nginx.org/en/docs/http/ngx_http_scgi_module.html) directives explanation
  - `memcached_pass` - see [`ngx_http_memcached_module`](http://nginx.org/en/docs/http/ngx_http_memcached_module.html) directives explanation
  - `redis_pass` - see [`ngx_http_redis_module`](https://www.nginx.com/resources/wiki/modules/redis/) directives explanation

##### Trailing slashes

Look at this example:

```bash
location /foo/bar/ {

  proxy_pass    http://www.example.com/url/;

}
```

If the URI is specified along with the address, it replaces the part of the request URI that matches the location parameter. For example, here the request with the `/foo/bar/page.html` URI will be proxied to `http://www.example.com/url/page.html`.

If the address is specified without a URI, or it is not possible to determine the part of URI to be replaced, the full request URI is passed (possibly, modified).

Look also at this:

Here is an example with trailing slash in location, but no trailig slash in `proxy_pass`.

```bash
location /foo/ {

  proxy_pass  http://127.0.0.1:8080/bar;

}
```

If one go to address `http://yourserver.com/foo/path/id?param=1` NGINX will proxy request to `http://127.0.0.1/barpath/id?param=1`. See how `bar` and `path` concatenates.

##### Passing headers

By default, NGINX redefines two header fields in proxied requests:

- the `Host` header is re-written to the value defined by the `$proxy_host` variable. This will be the IP address or name and port number of the upstream, directly as defined by the `proxy_pass` directive

- the `Connection` header is changed to `close`. This header is used to signal information about the particular connection established between two parties. In this instance, NGINX sets this to `close` to indicate to the upstream server that this connection will be closed once the original request is responded to. The upstream should not expect this connection to be persistent

When NGINX proxies a request, it automatically makes some adjustments to the request headers it receives from the client:

- NGINX drop empty headers. There is no point of passing along empty values to another server; it would only serve to bloat the request

- NGINX, by default, will consider any header that contains underscores as invalid. It will remove these from the proxied request. If you wish to have NGINX interpret these as valid, you can set the `underscores_in_headers` directive to `on`, otherwise your headers will never make it to the backend server

It is important to pass more than just the URI if you expect the upstream server handle the request properly. The request coming from NGINX on behalf of a client will look different than a request coming directly from a client.

  > Please read [Managing request headers](https://www.nginx.com/resources/wiki/start/topics/examples/headers_management/) from the official wiki.

NGINX use the `proxy_set_header` directive to sets headers that sends to the backend servers.

  > HTTP headers are used to transmit additional information between client and server. `add_header` sends headers to the client (browser), `proxy_set_header` sends headers to the backend server.

It's also important to distinguish between request headers and response headers. Request headers are for traffic inbound to the webserver or backend app. Response headers are going the other way (in the HTTP response you get back using client, e.g. curl or browser).

Ok, so look at following short explanation about proxy directives (for more information about valid header values please see [this](#beginner-always-pass-host-x-real-ip-and-x-forwarded-stack-headers-to-the-backend) rule):

- `proxy_http_version` - defines the HTTP protocol version for proxying, by default it it set to 1.0. For Websockets and keepalive connections you need to use the version 1.1

  ```bash
  proxy_http_version  1.1;
  ```

- `proxy_cache_bypass` - sets conditions under which the response will not be taken from a cache

  ```bash
  proxy_cache_bypass  $http_upgrade;
  ```

- `proxy_intercept_errors` - means that any response with HTTP code 300 or greater is handled by the `error_page` directive and ensures that if the proxied backend returns an error status, NGINX will be the one showing the error page (overrides the error page on the backend side)

  ```bash
  proxy_intercept_errors on;
  error_page 500 503 504 @debug;  # go to the @debug location
  ```

- `proxy_set_header` - allows redefining or appending fields to the request header passed to the proxied server

  - `Upgrade` and `Connection` - these header fields are required if your application is using Websockets

    ```bash
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    ```

  - `Host` - the `$host` variable in the following order of precedence contains: host name from the request line, or host name from the Host request header field, or the server name matching a request

    ```bash
    proxy_set_header Host $host;
    ```

  - `X-Real-IP` - forwards the real visitor remote IP address to the proxied server

    ```bash
    proxy_set_header X-Real-IP $remote_addr;
    ```

  - `X-Forwarded-For` - is the conventional way of identifying the originating IP address of the user connecting to the web server coming from either a HTTP proxy, load balancer

    ```bash
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    ```

  - `X-Forwarded-Proto` - identifies the protocol (HTTP or HTTPS) that a client used to connect to your proxy or load balancer

    ```bash
    proxy_set_header X-Forwarded-Proto $scheme;
    ```

  - `X-Forwarded-Host` - defines the original host requested by the client

    ```bash
    proxy_set_header X-Forwarded-Host $host;
    ```

  - `X-Forwarded-Port` - defines the original port requested by the client

    ```bash
    proxy_set_header X-Forwarded-Port $server_port;
    ```

###### Importancy of the `Host` header

The host Header tells the webserver which virtual host to use (if set up). You can even have the same virtual host using several aliases (= domains and wildcard-domains). This why the host header exists. The host header specifies which website or web application should process an incoming HTTP request.

In NGINX, `$host` equals `$http_host`, lowercase and without the port number (if present), except when `HTTP_HOST` is absent or is an empty value. In that case, `$host` equals the value of the `server_name` directive of the server which processed the request

For example, if you set `Host: MASTER:8080`, `$host` will be "master" (while `$http_host` will be "MASTER:8080" as it just reflects the whole header).

###### Redirects and `X-Forwarded-Proto`

This header is very important because it prevent a redirect loop. When used inside HTTPS server block each HTTP response from the proxied server will be rewritten to HTTPS. Look at the following example:

1. Client sends the HTTP request to the Proxy
2. Proxy sends the HTTP request to the Server
3. Server sees that the URL is `http://`
4. Server sends back 3xx redirect response telling the Client to connect to `https://`
5. Client sends an HTTPS request to the Proxy
6. Proxy decrypts the HTTPS traffic and sets the `X-Forwarded-Proto: https`
7. Proxy sends the HTTP request to the Server
8. Server sees that the URL is `http://` but also sees that `X-Forwarded-Proto` is https and trusts that the request is HTTPS
9. Server sends back the requested web page or data

<sup><i>This explanation comes from [Purpose of the X-Forwarded-Proto HTTP Header](https://community.pivotal.io/s/article/Purpose-of-the-X-Forwarded-Proto-HTTP-Header).</i></sup>

In step 6 above, the Proxy is setting the HTTP header `X-Forwarded-Proto: https` to specify that the traffic it received is HTTPS. In step 8, the Server then uses the `X-Forwarded-Proto` to determine if the request was HTTP or HTTPS.

You can read about how to set it up correctly here: []()

###### A warning about the `X-Forwarded-For`

I think, we should just maybe stop for a second. `X-Forwarded-For` is a one of the most important header that has the security implications.

Where a connection passes through a chain of proxy servers, `X-Forwarded-For` can give a comma-separated list of IP addresses with the first being the furthest downstream (that is, the user).

`X-Forwarded-For` should not be used for any Access Control List (ACL) checks because it can be spoofed by attackers. Use the real IP address for this type of restrictions. HTTP request headers such as `X-Forwarded-For`, `True-Client-IP`, and `X-Real-IP` are not a robust foundation on which to build any security measures, such as access controls.

[Set properly values of the X-Forwarded-For header (from this handbook)](#beginner-set-properly-values-of-the-x-forwarded-for-header) - see this for more detailed information on how to set properly values of the `X-Forwarded-For` header.

But that's not all. Behind a reverse proxy, the user IP we get is often the reverse proxy IP itself. If you use other HTTP server working between proxy and app server you should also set the correct mechanism for interpreting values of this header.

I recommend to read [this](https://serverfault.com/questions/314574/nginx-real-ip-header-and-x-forwarded-for-seems-wrong/414166#414166) amazing explanation by [Nick M](https://serverfault.com/users/130923/nick-m).

1) Pass headers from proxy to the backend layer

    - [Always pass Host, X-Real-IP, and X-Forwarded stack headers to the backend](#beginner-always-pass-host-x-real-ip-and-x-forwarded-stack-headers-to-the-backend)
    - [Set properly values of the X-Forwarded-For header (from this handbook)](#beginner-set-properly-values-of-the-x-forwarded-for-header)

2) NGINX - modify the `set_real_ip_from` and `real_ip_header` directives:

    > For this, the `http_realip_module` must be installed (`--with-http_realip_module`).

    First of all, you should add the following lines to the configuration:

    ```bash
    # Add these to the set_real_ip.conf, there are the real IPs where your traffic is coming from (front proxy/lb):
    set_real_ip_from    192.168.20.10; # IP address of master
    set_real_ip_from    192.168.20.11; # IP address of slave

    # You can also add an entire subnet:
    set_real_ip_from    192.168.40.0/24;

    # Defines a request header field used to send the address for a replacement, in this case We use X-Forwarded-For:
    real_ip_header      X-Forwarded-For;

    # The real IP from your client address that matches one of the trusted addresses is replaced by the last non-trusted address sent in the request header field:
    real_ip_recursive   on;

    # Include it to the appropriate context:
    server {

      include /etc/nginx/set_real_ip.conf;

      ...

    }
    ```

3) NGINX - add/modify and set log format:

    ```bash
    log_format combined-1 '$remote_addr forwarded for $http_x_real_ip - $remote_user [$time_local]  '
                          '"$request" $status $body_bytes_sent '
                          '"$http_referer" "$http_user_agent"';

    # or:
    log_format combined-2 '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/example.com/access.log combined-1;
    ```

    This way, e.g. the `$_SERVER['REMOTE_ADDR']` will be correctly filled up in PHP fastcgi. You can test it with the following script:

    ```bash
    # tls_check.php
    <?php

    echo '<pre>';
    print_r($_SERVER);
    echo '</pre>';
    exit;

    ?>
    ```

    And send request to it:

    ```bash
    curl -H Cache-Control: no-cache -ks https://example.com/tls-check.php?${RANDOM} | grep "HTTP_X_FORWARDED_FOR\|HTTP_X_REAL_IP\|SERVER_ADDR\|REMOTE_ADDR"
    [HTTP_X_FORWARDED_FOR] => 172.217.20.206
    [HTTP_X_REAL_IP] => 172.217.20.206
    [SERVER_ADDR] => 192.168.10.100
    [REMOTE_ADDR] => 192.168.10.10
    ```

###### Improve extensibility with `Forwarded`

Since 2014, the IETF has approved a standard header definition for proxy, called `Forwarded`, documented [here](https://tools.ietf.org/html/rfc7239) and [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Forwarded) that should be use instead of `X-Forwarded` headers. This is the one you should use reliably to get originating IP in case your request is handled by a proxy. Official NGINX documentation also gives you how to [Using the Forwarded header](https://www.nginx.com/resources/wiki/start/topics/examples/forwarded/).

In general, the proxy headers (Forwarded or X-Forwarded-For) are the right way to get your client IP only when you are sure they come to you via a proxy. If there is no proxy header or no usable value in, you should default to the `REMOTE_ADDR` server variable.

#### Load balancing algorithms

Load Balancing is in principle a wonderful thing really. You can find out about it when you serve tens of thousands (or maybe more) of requests every second. Of course, load balancing is not the only reason - think also about maintenance tasks without downtime.

Generally load balancing is a technique used to distribute the workload across multiple computing resources and servers. I think you should always use this technique also if you have a simple app or whatever else what you're sharing with other.

The configuration is very simple. NGINX includes a `ngx_http_upstream_module` to define backends (groups of servers or multiple server instances). More specifically, the `upstream` directive is responsible for this.

  > `upstream` only provide a list of servers, some kind of weight, and other parameters related to the backend layer.

##### Backend parameters

Before we start talking about the load balancing techniques you should know something about `server` directive. It defines the address and other parameters of a backend servers.

This directive accepts the following options:

- `weight=<num>` - sets the weight of the origin server, e.g. `weight=10`

- `max_conns=<num>` - limits the maximum number of simultaneous active connections from the NGINX proxy server to an upstream server (default value: `0` = no limit), e.g. `max_conns=8`

  - if you set `max_conns=4` the 5th will be rejected
  - if the server group does not reside in the shared memory (`zone` directive), the limitation works per each worker process

- `max_fails=<num>` - the number of unsuccessful attempts to communicate with the backend (default value: `1`, `0` disables the accounting of attempts), e.g. `max_fails=3;`

- `fail_timeout=<time>` - the time during which the specified number of unsuccessful attempts to communicate with the server should happen to consider the server unavailable (default value: `10 seconds`), e.g. `fail_timeout=30s;`

- `zone <name> <size>` - defines shared memory zone that keeps the group’s configuration and run-time state that are shared between worker processes, e.g. `zone backend 32k;`

- `backup` - if server is marked as a backup server it does not receive requests unless both of the other servers are unavailable

- `down` - marks the server as permanently unavailable

##### Round Robin

It's the simpliest load balancing technique. Round Robin has the list of servers and forwards each request to each server from the list in order. Once it reaches the last server, the loop again jumps to the first server and start again.

```bash
upstream bck_testing_01 {

  # with default weight for all (weight=1)
  server 192.168.250.220:8080
  server 192.168.250.221:8080
  server 192.168.250.222:8080

}
```

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_round-robin.png" alt="round-robin">
</p>

##### Weighted Round Robin

In Weighted Round Robin load balancing algorithm, each server is allocated with a weight based on its configuration and ability to process the request.

This method is similar to the Round Robin in a sense that the manner by which requests are assigned to the nodes is still cyclical, albeit with a twist. The node with the higher specs will be apportioned a greater number of requests.

```bash
upstream bck_testing_01 {

  server 192.168.250.220:8080   weight=3
  server 192.168.250.221:8080              # default weight=1
  server 192.168.250.222:8080              # default weight=1

}
```

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_weighted-round-robin.png" alt="weighted-round-robin">
</p>

##### Least Connections

This method tells the load balancer to look at the connections going to each server and send the next connection to the server with the least amount of connections.

```bash
upstream bck_testing_01 {

  least_conn;

  # with default weight for all (weight=1)
  server 192.168.250.220:8080
  server 192.168.250.221:8080
  server 192.168.250.222:8080

}
```

For example: if clients D10, D11 and D12 attempts to connect after A4, C2 and C8 have already disconnected but A1, B3, B5, B6, C7 and A9 are still connected, the load balancer will assign client D10 to server 2 instead of server 1 and server 3. After that, client D11 will be assign to server 1 and client D12 will be assign to server 2.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_least-conn.png" alt="least-conn">
</p>

##### Weighted Least Connections

This is, in general, a very fair distribution method, as it uses the ratio of the number of connections and the weight of a server. The server in the cluster with the lowest ratio automatically receives the next request.

```bash
upstream bck_testing_01 {

  least_conn;

  server 192.168.250.220:8080   weight=3
  server 192.168.250.221:8080              # default weight=1
  server 192.168.250.222:8080              # default weight=1

}
```

For example: if clients D10, D11 and D12 attempts to connect after A4, C2 and C8 have already disconnected but A1, B3, B5, B6, C7 and A9 are still connected, the load balancer will assign client D10 to server 2 or 3 (because they have a least active connections) instead of server 1. After that, client D11 and D12 will be assign to server 1 because it has the biggest `weight` parameter.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_weighted-least-conn.png" alt="weighted-least-conn">
</p>

##### IP Hash

The IP Hash method uses the IP of the client to create a unique hash key and associates the hash with one of the servers. This ensures that a user is sent to the same server in future sessions (a basic kind of session persistence) except when this server is unavailable. If one of the servers needs to be temporarily removed, it should be marked with the `down` parameter in order to preserve the current hashing of client IP addresses.

This technique is especially helpful if actions between sessions has to be kept alive e.g. products put in the shopping cart or when the session state is of concern and not handled by shared memory of the application.

```bash
upstream bck_testing_01 {

  ip_hash;

  # with default weight for all (weight=1)
  server 192.168.250.220:8080
  server 192.168.250.221:8080
  server 192.168.250.222:8080

}
```

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_ip-hash.png" alt="ip-hash">
</p>

##### Generic Hash

This technique is very similar to the IP Hash but for each request the load balancer calculates a hash that is based on the combination of a text string, variable, or a combination you specify, and associates the hash with one of the servers.

```bash
upstream bck_testing_01 {

  hash $request_uri;

  # with default weight for all (weight=1)
  server 192.168.250.220:8080
  server 192.168.250.221:8080
  server 192.168.250.222:8080

}
```

For example: load balancer calculate hash from the full original request URI (with arguments). Clients A4, C7, C8 and A9 sends requests to the `/static` location and will be assign to server 1. Similarly clients A1, C2, B6 which get `/sitemap.xml` resource they will be assign to server 2. Clients B3 and B5 sends requests to the `/api/v4` and they will be assign to server 3.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_generic-hash.png" alt="generic-hash">
</p>

##### Other methods

It is similar to the Generic Hash method because you can also specify a unique hash identifier but the assignment to the appropriate server is under your control. I think it's a somewhat primitive method and I wouldn't say it is a full load balancing technique, but in some cases it is very useful.

  > Mainly this helps reducing the mess on the configuration made by a lot of `location` blocks with similar configurations.

First of all create a map:

```bash
map $request_uri $bck_testing_01 {

  default       "192.168.250.220:8080";

  /api/v4       "192.168.250.220:8080";
  /api/v3       "192.168.250.221:8080";
  /static       "192.168.250.222:8080";
  /sitemap.xml  "192.168.250.222:8080";

}
```

And add `proxy_pass` directive:

```bash
server {

  ...

  location / {

    proxy_pass    http://$bck_testing_01;

  }

  ...

}
```

#### Rate limiting

NGINX has a default module to setup rate limiting. For me, it's one of the most useful protect feature but sometimes really hard to understand.

I think, in case of doubt, you should read up on the following documents:

- [Rate Limiting with NGINX and NGINX Plus](https://www.nginx.com/blog/rate-limiting-nginx/)
- [NGINX rate-limiting in a nutshell](https://www.freecodecamp.org/news/nginx-rate-limiting-in-a-nutshell-128fe9e0126c/)
- [NGINX Rate Limiting](https://dzone.com/articles/nginx-rate-limiting)
- [How to protect your web site from HTTP request flood, DoS and brute-force attacks](https://www.ryadel.com/en/nginx-request-rate-limit-protect-web-site-http-request-flood-dos-brute-force/)

Rate limiting rules are useful for:

- traffic shaping
- traffic optimising
- slow down the rate of incoming requests
- protect http requests flood
- protect against slow http attacks
- prevent consume a lot of bandwidth
- mitigating ddos attacks
- protect brute-force attacks

##### Variables

NGINX has following variables (unique keys) that can be used in a rate limiting rules. For example:

| <b>VARIABLE</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `$remote_addr` | client address |
| `$binary_remote_addr`| client address in a binary form, it is smaller and saves space then `remote_addr` |
| `$server_name` | name of the server which accepted a request |
| `$request_uri` | full original request URI (with arguments) |
| `$query_string` | arguments in the request line |

<sup><i>Please see [official doc](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables) for more information about variables.</i></sup>

##### Directives, keys, and zones

NGINX also provides following keys:

| <b>KEY</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `limit_req_zone` | stores the current number of excessive requests |
| `limit_conn_zone` | stores the maximum allowed number of connections |

and directives:

| <b>DIRECTIVE</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `limit_req` | in combination with a `limit_conn_zone` sets the shared memory zone and the maximum burst size of requests |
| `limit_conn` | in combination with a `limit_req_zone` sets the shared memory zone and the maximum allowed number of (simultaneous) connections to the server per a client IP |

Keys are used to store the state of each IP address and how often it has accessed a limited object. This information are stored in shared memory available from all NGINX worker processes.

Both keys also provides response status parameters indicating too many requests or connections with specific http code (default **503**).

- `limit_req_status <value>`
- `limit_conn_status <value>`

For example, if you want to set the desired logging level for cases when the server limits the number of connections:

```bash
# Add this to http context:
limit_req_status 429;

# Set your own error page for 429 http code:
error_page 429 /rate_limit.html;
location = /rate_limit.html {

  root /usr/share/www/http-error-pages/sites/other;
  internal;

}

# And create this file:
cat > /usr/share/www/http-error-pages/sites/other/rate_limit.html << __EOF__
HTTP 429 Too Many Requests
__EOF__
```

Rate limiting rules also have zones that lets you define a shared space in which to count the incoming requests or connections.

  > All requests or connections coming into the same space will be counted in the same rate limit. This is what allows you to limit per URL, per IP, or anything else.

The zone has two required parts:

- `<name>` - is the zone identifier
- `<size>` - is the zone size

Example:

```bash
<key> <variable> zone=<name>:<size>;
```

  > State information for about **16,000** IP addresses takes **1 megabyte**. So **1 kilobyte** zone has **16** IP addresses.

The range of zones is as follows:

- **http context**

  ```bash
  http {

    ... zone=<name>;

  ```

- **server context**

  ```bash
  server {

    ... zone=<name>;

  ```

- **location directive**

  ```bash
  location /api {

    ... zone=<name>;

  ```

  > All rate limiting rules (definitions) should be added to the NGINX `http` context.

`limit_req_zone` key lets you set `rate` parameter (optional) - it defines the rate limited URL(s).

##### Burst and nodelay parameters

For enable queue you should use `limit_req` or `limit_conn` directives (see above). `limit_req` also provides optional parameters:

| <b>PARAMETER</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `burst=<num>` | sets the maximum number of excessive requests that await to be processed in a timely manner; maximum requests as `rate` * `burst` in `burst` seconds |
| `nodelay`| it imposes a rate limit without constraining the allowed spacing between requests; default NGINX would return 503 response and not handle excessive requests |

  > `nodelay` parameters are only useful when you also set a `burst`.

Without `nodelay` NGINX would wait (no 503 response) and handle excessive requests with some delay.

# Helpers

#### Installing from prebuilt packages

##### RHEL7 or CentOS 7

###### From EPEL

```bash
# Install epel repository:
yum install epel-release
# or alternative:
#   wget -c https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#   yum install epel-release-latest-7.noarch.rpm

# Install NGINX:
yum install nginx
```

###### From Software Collections

```bash
# Install and enable scl:
yum install centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms

# Install NGINX (rh-nginx14, rh-nginx16, rh-nginx18):
yum install rh-nginx16

# Enable NGINX from SCL:
scl enable rh-nginx16 bash
```

###### From Official Repository

```bash
# Where:
#   - <os_type> is: rhel or centos
cat > /etc/yum.repos.d/nginx.repo << __EOF__
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/<os_type>/$releasever/$basearch/
gpgcheck=0
enabled=1
__EOF__

# Install NGINX:
yum install nginx
```

##### Debian or Ubuntu

Check available flavours of NGINX before install. For more information please see [this](https://askubuntu.com/a/556382) great answer by [Thomas Ward](https://askubuntu.com/users/10616/thomas-ward).

###### From Debian/Ubuntu Repository

```bash
# Install NGINX:
apt-get install nginx
```

###### From Official Repository

```bash
# Where:
#   - <os_type> is: debian or ubuntu
#   - <os_release> is: xenial, bionic, jessie, stretch or other
cat > /etc/apt/sources.list.d/nginx.list << __EOF__
deb http://nginx.org/packages/<os_type>/ <os_release> nginx
deb-src http://nginx.org/packages/<os_type>/ <os_release> nginx
__EOF__

# Update packages list:
apt-get update

# Download the public key (or <pub_key> from your GPG error):
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <pub_key>

# Install NGINX:
apt-get update
apt-get install nginx
```

#### Installing from source

The build is configured using the `configure` command. The configure shell script attempts to guess correct values for various system-dependent variables used during compilation. It uses those values to create a `Makefile`. Of course you can adjust certain environment variables to make configure able to find the packages like a `zlib` or `openssl`, and of many other options (paths, modules).

Before the beginning installation process please read these important articles which describes exactly the entire installation process and the parameters using the `configure` command:

- [Installation and Compile-Time Options](https://www.nginx.com/resources/wiki/start/topics/tutorials/installoptions/)
- [Installing NGINX Open Source](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#configure)
- [Building nginx from Sources](https://nginx.org/en/docs/configure.html)

In this chapter I'll present three (very similar) methods of installation. They relate to:

- the [NGINX on CentOS 7](#installation-nginx-on-centos-7)
- the [OpenResty on CentOS 7](#installation-openresty-on-centos-7)
- the [Tengine on Ubuntu 18.04](#installation-tengine-on-ubuntu-1804)

Each of them is suited towards a high performance as well as high-concurrency applications. They work great as a high-end proxy servers too.

Look also on this short note about the system locations. That can be useful too:

- For booting the system, rescues and maintenance: `/`
  - `/bin` - user programs
  - `/sbin` - system programs
  - `/lib` - shared libraries

- Full running environment: `/usr`
  - `/usr/bin` - user programs
  - `/usr/sbin` - system programs
  - `/usr/lib` - shared libraries
  - `/usr/share` - manual pages, data

- Added packages: `/usr/local`
  - `/usr/local/bin` - user programs
  - `/usr/local/sbin` - system programs
  - `/usr/local/lib` - shared libraries
  - `/usr/local/share` - manual pages, data

##### Automatic installation

Installing from source consists of multiple steps. If you don't want to pass through all of them manually, you can run automated script. I created it to facilitate the whole installation process.

  > It supports Debian and RHEL like distributions.

This tool is located in `lib/ngx_installer.sh`. Configuration file is in `lib/ngx_installer.conf`. By default, it show prompt to confirm steps but you can disable it if you want:

```bash
cd lib/
export NGX_PROMPT=0 ; bash ngx_installer.sh
```

##### Nginx package

There are currently two versions of NGINX:

- **stable** - is recommended, doesn’t include all of the latest features, but has critical bug fixes from mainline release
- **mainline** - is typically quite stable as well, includes the latest features and bug fixes and is always up to date

You can download NGINX source code from an official read-only mirrors:

  > Detailed instructions about download and compile the NGINX sources can be found later in the handbook.

- [NGINX source code](https://nginx.org/download/)
- [NGINX GitHub repository](https://github.com/nginx/nginx)

##### Dependencies

Mandatory requirements:

  > Download, compile and install or install prebuilt packages from repository of your distribution.

- [OpenSSL](https://www.openssl.org/source/) library
- [Zlib](https://zlib.net/) or [Cloudflare Zlib](https://github.com/cloudflare/zlib) library
- [PCRE](https://ftp.pcre.org/pub/pcre/) library
- [LuaJIT v2.1](https://github.com/LuaJIT/LuaJIT) or [OpenResty's LuaJIT2](https://github.com/openresty/luajit2) library
- [jemalloc](https://github.com/jemalloc/jemalloc) library

OpenResty's LuaJIT uses its own branch of LuaJIT with various important bug fixes and optimizations for OpenResty's use cases.

I also use Cloudflare Zlib version due to performance. See below articles:

- [A comparison of Zlib implementations](http://www.htslib.org/benchmarks/zlib.html)
- [Improving Nginx Zlib Compression Performance](https://medium.com/@centminmod/improving-nginx-zlib-compression-performance-eb961f3ac0f4)

If you download and compile above sources the good point is to install additional packages (dependent on the system version) before building NGINX:

| <b>Debian Like</b> | <b>RedHat Like</b> | <b>Comment</b> |
| :---         | :---         | :---         |
| `gcc`<br>`make`<br>`build-essential`<br>`linux-headers*`<br>`bison` | `gcc`<br>`gcc-c++`<br>`kernel-devel`<br>`bison` | |
| `perl`<br>`libperl-dev`<br>`libphp-embed` | `perl`<br>`perl-devel`<br>`perl-ExtUtils-Embed` | |
| `libssl-dev`* | `openssl-devel`* | |
| `zlib1g-dev`* | `zlib-devel`* | |
| `libpcre2-dev`* | `pcre-devel`* | |
| `libluajit-5.1-dev`* | `luajit-devel`* | |
| `libxslt-dev` | `libxslt libxslt-devel` | |
| `libgd-dev` | `gd gd-devel` | |
| `libgeoip-dev` | `GeoIP-devel` | |
| `libxml2-dev` | `libxml2-devel` | |
| `libexpat-dev` | `expat-devel` | |
| `libgoogle-perftools-dev`<br>`libgoogle-perftools4` | `gperftools-devel` | |
| | `cpio` | |
| | `gettext-devel` | |
| `autoconf` | `autoconf` | for `jemalloc` from sources |
| `libjemalloc1`<br>`libjemalloc-dev`* | `jemalloc`<br>`jemalloc-devel`* | for `jemalloc` |
| `libpam0g-dev` | `pam-devel` | for `ngx_http_auth_pam_module` |
| `jq` | `jq` | for [http error pages](https://github.com/trimstray/nginx-admins-handbook/tree/master/lib/nginx/snippets/http-error-pages) generator |

<sup><i>* If you don't use from sources.</i></sup>

Shell one-liners example:

```bash
# Ubuntu/Debian
apt-get install gcc make build-essential bison perl libperl-dev libphp-embed libssl-dev zlib1g-dev libpcre2-dev libluajit-5.1-dev libxslt-dev libgd-dev libgeoip-dev libxml2-dev libexpat-dev libgoogle-perftools-dev libgoogle-perftools4 autoconf jq

# RedHat/CentOS
yum install gcc gcc-c++ kernel-devel bison perl perl-devel perl-ExtUtils-Embed openssl-devel zlib-devel pcre-devel luajit-devel libxslt libxslt-devel gd gd-devel GeoIP-devel libxml2-devel expat-devel gperftools-devel cpio gettext-devel autoconf jq
```

##### 3rd party modules

  > Not all external modules can work properly with your currently NGINX version. You should read the documentation of each module before adding it to the modules list. You should also to check what version of module is compatible with your NGINX release.

  > Before installing external modules please read [Event-Driven architecture](#event-driven-architecture) section to understand why poor quality 3rd party modules may reduce NGINX performance.

Modules can be compiled as a shared object (`*.so` file) and then dynamically loaded into NGINX at runtime (`--add-dynamic-module`). On the other hand you can also built them into NGINX at compile time and linked to the NGINX binary statically (`--add-module`).

I mixed both variants because some of the modules are built-in automatically even if I try them to be compiled as a dynamic modules (they are not support dynamic linking).

You can download external modules from:

- [NGINX 3rd Party Modules](https://www.nginx.com/resources/wiki/modules/)
- [OpenResty Components](https://openresty.org/en/components.html)
- [Tengine Modules](https://github.com/alibaba/tengine/tree/master/modules)

A short description of the modules that I used in this step-by-step tutorial:

- [`ngx_devel_kit`](https://github.com/simplresty/ngx_devel_kit)** - adds additional generic tools that module developers can use in their own modules

- [`lua-nginx-module`](https://github.com/openresty/lua-nginx-module) - embed the Power of Lua into NGINX

- [`set-misc-nginx-module`](https://github.com/openresty/set-misc-nginx-module) - various `set_xxx` directives added to NGINX rewrite module

- [`echo-nginx-module`](https://github.com/openresty/echo-nginx-module) - module for bringing the power of `echo`, `sleep`, `time` and more to NGINX config file

- [`headers-more-nginx-module`](https://github.com/openresty/headers-more-nginx-module) - set, add, and clear arbitrary output headers

- [`replace-filter-nginx-module`](https://github.com/openresty/replace-filter-nginx-module) - streaming regular expression replacement in response bodies

- [`array-var-nginx-module`](https://github.com/openresty/array-var-nginx-module) - add supports for array-typed variables to NGINX config files

- [`encrypted-session-nginx-module`](https://github.com/openresty/encrypted-session-nginx-module) - encrypt and decrypt NGINX variable values

- [`nginx-module-sysguard`](https://github.com/vozlt/nginx-module-sysguard) - module to protect servers when system load or memory use goes too high

- [`nginx-access-plus`](https://github.com/nginx-clojure/nginx-access-plus) - allows limiting access to certain http request methods and client addresses

- [`ngx_http_substitutions_filter_module`](https://github.com/yaoweibin/ngx_http_substitutions_filter_module) - can do both regular expression and fixed string substitutions

- [`nginx-sticky-module-ng`](https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/src) - module to add a sticky cookie to be always forwarded to the same

- [`nginx-module-vts`](https://github.com/vozlt/nginx-module-vts) - Nginx virtual host traffic status module

- [`ngx_brotli`](https://github.com/google/ngx_brotli) - module for Brotli compression

- [`ngx_http_naxsi_module`](https://github.com/nbs-system/naxsi) - is an open-source, high performance, low rules maintenance WAF for NGINX

- [`ngx_http_delay_module`](http://mdounin.ru/hg/ngx_http_delay_module) - allows to delay requests for a given time

- [`nginx-backtrace`](https://github.com/alibaba/nginx-backtrace)* - module to dump backtrace when a worker process exits abnormally

- [`ngx_debug_pool`](https://github.com/chobits/ngx_debug_pool)* - provides access to information of memory usage for NGINX memory pool

- [`ngx_debug_timer`](https://github.com/hongxiaolong/ngx_debug_timer)* - provides access to information of timer usage for NGINX

- [`nginx_upstream_check_module`](https://github.com/yaoweibin/nginx_upstream_check_module)* - health checks upstreams for NGINX

- [`nginx-http-footer-filter`](https://github.com/alibaba/nginx-http-footer-filter)* - module that prints some text in the footer of a request upstream server

- [`memc-nginx-module`](https://github.com/agentzh/memc-nginx-module) - extended version of the standard Memcached module

- [`nginx-rtmp-module`](https://github.com/arut/nginx-rtmp-module) - NGINX-based Media Streaming Server

- [`ngx-fancyindex`](https://github.com/aperezdc/ngx-fancyindex) - generates of file listings, like the built-in autoindex module does, but adding a touch of style

- [`ngx_log_if`](https://github.com/cfsego/ngx_log_if) - allows you to control when not to write down access log

- [`nginx-http-user-agent`](https://github.com/alibaba/nginx-http-user-agent) - module to match browsers and crawlers

- [`ngx_http_auth_pam_module`](https://github.com/sto/ngx_http_auth_pam_module) - module to use PAM for simple http authentication

- [`ngx_http_google_filter_module`](https://github.com/cuber/ngx_http_google_filter_module) - is a filter module which makes google mirror much easier to deploy

- [`nginx-push-stream-module`](https://github.com/wandenberg/nginx-push-stream-module) - a pure stream http push technology for your Nginx setup

- [`nginx_tcp_proxy_module`](https://github.com/yaoweibin/nginx_tcp_proxy_module) - add the feature of tcp proxy with nginx, with health check and status monitor

- [`ngx_http_custom_counters_module`](https://github.com/lyokha/nginx-custom-counters-module) - customizable counters shared by all worker processes and virtual servers

<sup><i>* Available in Tengine Web Server (but these modules may have been updated/patched by Tengine Team).</i></sup><br>
<sup><i>** Is already being used in quite a few third party modules.</i></sup>

##### Compiler and linker

Someting about compiler and linker options. Out of the box you probably do not need to provide any flags yourself, the configure script should detect automatically some reasonable defaults. However, in order to optimise for speed and/or security, you should probably provide a few compiler flags.

See [this](https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc/) recommendations by RedHat. You should also read [Compilation and Installation](https://wiki.openssl.org/index.php/Compilation_and_Installation) for OpenSSL.

There are examples:

```bash
# Example of use compiler options:
# 1)
--with-cc-opt="-I/usr/local/include -I${OPENSSL_INC} -I${LUAJIT_INC} -I${JEMALLOC_INC} -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC"
# 2)
--with-cc-opt="-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -O3 -g -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf"

# Example of use linker options:
# 1)
--with-ld-opt="-Wl,-E -L/usr/local/lib -ljemalloc -lpcre -Wl,-rpath,/usr/local/lib,-z,relro -Wl,-z,now -pie"
# 2)
--with-ld-opt="-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib"
```

###### Debugging Symbols

Debugging symbols helps obtain additional information for debugging, such as functions, variables, data structures, source file and line number information.

However, if you get the `No symbol table info available` error when you run a `(gdb) backtrace` you should to recompile NGINX with support of debugging symbols. For this it is essential to include debugging symbols with the `-g` flag and make the debugger output easier to understand by disabling compiler optimization with the `-O0` flag:

  > If you use `-O0` remember about disable `-D_FORTIFY_SOURCE=2`, if you don't do it you will get: `error: #warning _FORTIFY_SOURCE requires compiling with optimization (-O)`.

```bash
./configure --with-debug --with-cc-opt='-O0 -g' ...
```

Also if you get errors similar to one of them:

```bash
Missing separate debuginfo for /usr/lib64/libluajit-5.1.so.2 ...
Reading symbols from /lib64/libcrypt.so.1...(no debugging symbols found) ...
```

You should also recompile libraries with `-g` compiler option and optional with `-O0`. For more information please read [3.9 Options for Debugging Your Program](https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html).

##### SystemTap

SystemTap is a scripting language and tool for dynamically instrumenting running production Linux kernel-based operating systems. It's required for `openresty-systemtap-toolkit` for OpenResty.

  > It's good [all-in-one tutorial](https://gist.github.com/notsobad/b8f5ebb9b99f3a818f30) for install and configure SystemTap on CentOS 7/Ubuntu distributions. In case of problems please see this [SystemTap](https://github.com/shawfdong/hyades/wiki/SystemTap) document.

  > Hint: Do not specify `--with-debug` while profiling. It slows everything down
significantly.

```bash
cd /opt

git clone --depth 1 https://github.com/openresty/openresty-systemtap-toolkit

# RHEL/CentOS
yum install yum-utils
yum --enablerepo=base-debuginfo install kernel-devel-$(uname -r) kernel-headers-$(uname -r) kernel-debuginfo-$(uname -r) kernel-debuginfo-common-x86_64-$(uname -r)
yum --enablerepo=base-debuginfo install systemtap systemtap-debuginfo

reboot

# Run this commands for testing SystemTap:
stap -v -e 'probe vfs.read {printf("read performed\n"); exit()}'
stap -v -e 'probe begin { printf("Hello, World!\n"); exit() }'
```

For installation SystemTap on Ubuntu/Debian:

- [Ubuntu Wiki - Systemtap](https://wiki.ubuntu.com/Kernel/Systemtap)
- [Install SystemTap in Ubuntu 14.04](https://blog.jeffli.me/blog/2014/10/10/install-systemtap-in-ubuntu-14-dot-04/)

###### stapxx

The author of OpenResty created great and simple macro language extensions to the SystemTap: [stapxx](https://github.com/openresty/stapxx).

#### Installation Nginx on CentOS 7

###### Pre installation tasks

Set NGINX version (I use stable release):

```bash
export ngx_version="1.17.0"
```

Set temporary variables:

```bash
ngx_src="/usr/local/src"
ngx_base="${ngx_src}/nginx-${ngx_version}"
ngx_master="${ngx_base}/master"
ngx_modules="${ngx_base}/modules"
```

Create directories:

```bash
for i in "$ngx_base" "${ngx_master}" "$ngx_modules" ; do

  mkdir "$i"

done
```

###### Dependencies

  > In my configuration I used all prebuilt dependencies without `libssl-dev`, `zlib1g-dev`, `libluajit-5.1-dev` and `libpcre2-dev` because I compiled them manually - for TLS 1.3 support and with OpenResty recommendation for LuaJIT.

**Install prebuilt packages, export variables and set symbolic link:**

```bash
# It's important and required, regardless of chosen sources:
yum install gcc gcc-c++ kernel-devel bison perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel gd gd-devel GeoIP-devel libxml2-devel expat-devel gperftools-devel cpio gettext-devel autoconf jq

# In this example we use sources for all below packages so we do not install them:
yum install openssl-devel zlib-devel pcre-devel luajit-devel

# For LuaJIT (libluajit-5.1-dev):
export LUAJIT_LIB="/usr/local/x86_64-linux-gnu"
export LUAJIT_INC="/usr/include/luajit-2.1"

ln -s /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 /usr/local/lib/liblua.so
```

  > Remember to build [`sregex`](#sregex) also if you use above steps.

**Or download and compile them:**

PCRE:

```bash
cd "${ngx_src}"

export pcre_version="8.42"

export PCRE_SRC="${ngx_src}/pcre-${pcre_version}"
export PCRE_LIB="/usr/local/lib"
export PCRE_INC="/usr/local/include"

wget https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.tar.gz && tar xzvf pcre-${pcre_version}.tar.gz

cd "$PCRE_SRC"

# Add to compile with debugging symbols:
#   CFLAGS='-O0 -g' ./configure
./configure

make -j2 && make test
make install
```

Zlib:

```bash
# I recommend to use Cloudflare Zlib version (cloudflare/zlib) instead an original Zlib (zlib.net), but both installation methods are similar:
cd "${ngx_src}"

export ZLIB_SRC="${ngx_src}/zlib"
export ZLIB_LIB="/usr/local/lib"
export ZLIB_INC="/usr/local/include"

# For original Zlib:
#   export zlib_version="1.2.11"
#   wget http://www.zlib.net/zlib-${zlib_version}.tar.gz && tar xzvf zlib-${zlib_version}.tar.gz
#   cd "${ZLIB_SRC}-${zlib_version}"

# For Cloudflare Zlib:
git clone --depth 1 https://github.com/cloudflare/zlib

cd "$ZLIB_SRC"

./configure

make -j2 && make test
make install
```

OpenSSL:

```bash
cd "${ngx_src}"

export openssl_version="1.1.1b"

export OPENSSL_SRC="${ngx_src}/openssl-${openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && tar xzvf openssl-${openssl_version}.tar.gz

cd "${ngx_src}/openssl-${openssl_version}"

# Please run this and add as a compiler param:
export __GCC_SSL=("__SIZEOF_INT128__:enable-ec_nistp_64_gcc_128")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    echo -en "$_cc_value is supported on this machine\n"
    _openssl_gcc+="$_cc_value "

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

make -j2 && make test
make install

# Setup PATH environment variables:
cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=${OPENSSL_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${OPENSSL_DIR}/lib:${LD_LIBRARY_PATH}
__EOF__

chmod +x /etc/profile.d/openssl.sh && source /etc/profile.d/openssl.sh

# To make the OpenSSL 1.1.1b version visible globally first:
mv /usr/bin/openssl /usr/bin/openssl-old
ln -s ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

cat > /etc/ld.so.conf.d/openssl.conf << __EOF__
${OPENSSL_DIR}/lib
__EOF__
```

LuaJIT:

```bash
# I recommend to use OpenResty's branch (openresty/luajit2) instead of LuaJIT (LuaJIT/LuaJIT), but both installation methods are similar:
cd "${ngx_src}"

export LUAJIT_SRC="${ngx_src}/luajit2"
export LUAJIT_LIB="/usr/local/lib"
export LUAJIT_INC="/usr/local/include/luajit-2.1"

# For original LuaJIT:
#   git clone http://luajit.org/git/luajit-2.0 luajit2
#   cd "$LUAJIT_SRC"

# For OpenResty's LuaJIT:
git clone --depth 1 https://github.com/openresty/luajit2

cd "$LUAJIT_SRC"

# Add to compile with debugging symbols:
#   CFLAGS='-g' make ...
make && make install

ln -s /usr/local/lib/libluajit-5.1.so.2.1.0 /usr/local/lib/liblua.so
```

<a id="sregex"></a>sregex:

  > Required for `replace-filter-nginx-module` module.

```bash
cd "${ngx_src}"

git clone --depth 1 https://github.com/openresty/sregex

cd "${ngx_src}/sregex"

make && make install
```

jemalloc:

  > To verify `jemalloc` in use: `lsof -n | grep jemalloc`.

```bash
cd "${ngx_src}"

export JEMALLOC_SRC="${ngx_src}/jemalloc"
export JEMALLOC_INC="/usr/local/include/jemalloc"

git clone --depth 1 https://github.com/jemalloc/jemalloc

cd "$JEMALLOC_SRC"

./autogen.sh

make && make install
```

Update links and cache to the shared libraries for both types of installation:

```bash
ldconfig
```

###### Get Nginx sources

```bash
cd "${ngx_base}"

wget https://nginx.org/download/nginx-${ngx_version}.tar.gz

# or alternative:
#   git clone --depth 1 https://github.com/nginx/nginx master

tar zxvf nginx-${ngx_version}.tar.gz -C "${ngx_master}" --strip 1
```

###### Download 3rd party modules

```bash
cd "${ngx_modules}"

for i in \
https://github.com/simplresty/ngx_devel_kit \
https://github.com/openresty/lua-nginx-module \
https://github.com/openresty/set-misc-nginx-module \
https://github.com/openresty/echo-nginx-module \
https://github.com/openresty/headers-more-nginx-module \
https://github.com/openresty/replace-filter-nginx-module \
https://github.com/openresty/array-var-nginx-module \
https://github.com/openresty/encrypted-session-nginx-module \
https://github.com/vozlt/nginx-module-sysguard \
https://github.com/nginx-clojure/nginx-access-plus \
https://github.com/yaoweibin/ngx_http_substitutions_filter_module \
https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng \
https://github.com/vozlt/nginx-module-vts \
https://github.com/google/ngx_brotli ; do

  git clone --depth 1 "$i"

done

wget http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
mkdir delay-module && tar xzvf delay-module.tar.gz -C delay-module --strip 1
```

For `ngx_brotli`:

```bash
cd "${ngx_modules}/ngx_brotli"

git submodule update --init
```

I also use some modules from Tengine:

- `ngx_backtrace_module`
- `ngx_debug_pool`
- `ngx_debug_timer`
- `ngx_http_upstream_check_module`
- `ngx_http_footer_filter_module`

```bash
cd "${ngx_modules}"

git clone --depth 1 https://github.com/alibaba/tengine
```

If you use NAXSI:

```bash
cd "${ngx_modules}"

git clone --depth 1 https://github.com/nbs-system/naxsi
```

###### Build Nginx

```bash
cd "${ngx_master}"

# - you can also build NGINX without 3rd party modules
# - remember about compiler and linker options
# - don't set values for --with-openssl, --with-pcre, and --with-zlib if you select prebuilt packages for them
# - add to compile with debugging symbols: -O0 -g
#   - and remove -D_FORTIFY_SOURCE=2 if you use above
./configure --prefix=/etc/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --sbin-path=/usr/sbin/nginx \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --modules-path=/etc/nginx/modules \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-compat \
            --with-debug \
            --with-file-aio \
            --with-threads \
            --with-stream \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_degradation_module \
            --with-http_geoip_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_image_filter_module \
            --with-http_perl_module \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_secure_link_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-google_perftools_module \
            --with-openssl=${OPENSSL_SRC} \
            --with-openssl-opt="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong ${_openssl_gcc}" \
            --with-pcre=${PCRE_SRC} \
            --with-pcre-jit \
            --with-zlib=${ZLIB_SRC} \
            --without-http-cache \
            --without-http_memcached_module \
            --without-mail_pop3_module \
            --without-mail_imap_module \
            --without-mail_smtp_module \
            --without-http_fastcgi_module \
            --without-http_scgi_module \
            --without-http_uwsgi_module \
            --add-module=${ngx_modules}/ngx_devel_kit \
            --add-module=${ngx_modules}/encrypted-session-nginx-module \
            --add-module=${ngx_modules}/nginx-access-plus/src/c \
            --add-module=${ngx_modules}/ngx_http_substitutions_filter_module \
            --add-module=${ngx_modules}/nginx-sticky-module-ng \
            --add-module=${ngx_modules}/nginx-module-vts \
            --add-module=${ngx_modules}/ngx_brotli \
            --add-module=${ngx_modules}/tengine/modules/ngx_backtrace_module \
            --add-module=${ngx_modules}/tengine/modules/ngx_debug_pool \
            --add-module=${ngx_modules}/tengine/modules/ngx_debug_timer \
            --add-module=${ngx_modules}/tengine/modules/ngx_http_footer_filter_module \
            --add-module=${ngx_modules}/tengine/modules/ngx_http_upstream_check_module \
            --add-module=${ngx_modules}/tengine/modules/ngx_slab_stat \
            --add-dynamic-module=${ngx_modules}/lua-nginx-module \
            --add-dynamic-module=${ngx_modules}/set-misc-nginx-module \
            --add-dynamic-module=${ngx_modules}/echo-nginx-module \
            --add-dynamic-module=${ngx_modules}/headers-more-nginx-module \
            --add-dynamic-module=${ngx_modules}/replace-filter-nginx-module \
            --add-dynamic-module=${ngx_modules}/array-var-nginx-module \
            --add-dynamic-module=${ngx_modules}/nginx-module-sysguard \
            --add-dynamic-module=${ngx_modules}/delay-module \
            --add-dynamic-module=${ngx_modules}/naxsi/naxsi_src \
            --with-cc-opt="-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -O2 -g -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf" \
            --with-ld-opt="-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib"

make -j2 && make test
make install

ldconfig
```

Check NGINX version:

```bash
nginx -v
nginx version: nginx/1.16.0
```

And list all files in `/etc/nginx`:

```bash
.
├── fastcgi.conf
├── fastcgi.conf.default
├── fastcgi_params
├── fastcgi_params.default
├── html
│   ├── 50x.html
│   └── index.html
├── koi-utf
├── koi-win
├── mime.types
├── mime.types.default
├── modules
│   ├── ngx_http_array_var_module.so
│   ├── ngx_http_delay_module.so
│   ├── ngx_http_echo_module.so
│   ├── ngx_http_headers_more_filter_module.so
│   ├── ngx_http_lua_module.so
│   ├── ngx_http_naxsi_module.so
│   ├── ngx_http_replace_filter_module.so
│   ├── ngx_http_set_misc_module.so
│   └── ngx_http_sysguard_module.so
├── nginx.conf
├── nginx.conf.default
├── scgi_params
├── scgi_params.default
├── uwsgi_params
├── uwsgi_params.default
└── win-utf

2 directories, 26 files
```

###### Post installation tasks

Create a system user/group:

```bash
# Ubuntu/Debian
adduser --system --home /non-existent --no-create-home --shell /usr/sbin/nologin --disabled-login --disabled-password --gecos "nginx user" --group nginx

# RedHat/CentOS
groupadd -r -g 920 nginx

useradd --system --home-dir /non-existent --no-create-home --shell /usr/sbin/nologin --uid 920 --gid nginx nginx

passwd -l nginx
```

Create required directories:

```bash
for i in \
/var/www \
/var/log/nginx \
/var/cache/nginx ; do

  mkdir -p "$i" && chown -R nginx:nginx "$i"

done
```

Include the necessary error pages:

  > You can also define them e.g. in `/etc/nginx/errors.conf` or other file and attach it as needed in server contexts.

- default location: `/etc/nginx/html`
  ```bash
  50x.html  index.html
  ```

Update modules list and include `modules.conf` to your configuration:

```bash
_mod_dir="/etc/nginx/modules"
_mod_conf="/etc/nginx/modules.conf"

:>"${_mod_conf}"

for _module in $(ls "${_mod_dir}/") ; do echo -en "load_module\t\t${_mod_dir}/$_module;\n" >> "$_mod_conf" ; done
```

Create `logrotate` configuration:

```bash
cat > /etc/logrotate.d/nginx << __EOF__
/var/log/nginx/*.log {
  daily
  missingok
  rotate 14
  compress
  delaycompress
  notifempty
  create 0640 nginx nginx
  sharedscripts
  prerotate
    if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
      run-parts /etc/logrotate.d/httpd-prerotate; \
    fi \
  endscript
  postrotate
    invoke-rc.d nginx reload >/dev/null 2>&1
  endscript
}
__EOF__
```

Add systemd service:

```bash
cat > /lib/systemd/system/nginx.service << __EOF__
# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target
__EOF__
```

Reload systemd manager configuration:

```bash
systemctl daemon-reload
```

Enable NGINX service:

```bash
systemctl enable nginx
```

Test NGINX configuration:

```bash
nginx -t -c /etc/nginx/nginx.conf
```

#### Installation OpenResty on CentOS 7

  > _OpenResty is a full-fledged web application server by bundling the standard nginx core, lots of 3rd-party nginx modules, as well as most of their external dependencies._
  >
  > _This bundle is maintained by Yichun Zhang ([agentzh](https://github.com/agentzh))._

- Official github repository: [OpenResty](https://github.com/openresty/openresty)
- Official website: [OpenResty](https://openresty.org/en/)
- Official documentations: [OpenResty Getting Started](https://openresty.org/en/getting-started.html) and [OpenResty eBooks](https://openresty.org/en/ebooks.html)

OpenResty is a more than web server. I would call it a superset of the NGINX web server. OpenResty comes with LuaJIT, a just-in-time compiler for the Lua scripting language and many Lua libraries, lots of high quality 3rd-party NGINX modules, and most of their external dependencies.

OpenResty has good quality and performance. For me, the ability to run Lua scripts from within is also really great.

<details>
<summary><b>Show step-by-step OpenResty installation</b></summary><br>

* [Pre installation tasks](#pre-installation-tasks-1)
* [Dependencies](#dependencies-1)
* [Get OpenResty sources](#get-openresty-sources-1)
* [Download 3rd party modules](#download-3rd-party-modules-1)
* [Build OpenResty](#build-openresty)
* [Post installation tasks](#post-installation-tasks-1)

###### Pre installation tasks

Set the OpenResty version (I use newest and stable release):

```bash
export ngx_version="1.15.8.1"
```

Set temporary variables:

```bash
ngx_src="/usr/local/src"
ngx_base="${ngx_src}/openresty-${ngx_version}"
ngx_master="${ngx_base}/master"
ngx_modules="${ngx_base}/modules"
```

Create directories:

```bash
for i in "$ngx_base" "${ngx_master}" "$ngx_modules" ; do

  mkdir "$i"

done
```

###### Dependencies

  > In my configuration I used all prebuilt dependencies without `libssl-dev`, `zlib1g-dev`, and `libpcre2-dev` because I compiled them manually - for TLS 1.3 support. In addition, LuaJIT comes with OpenResty.

**Install prebuilt packages, export variables and set symbolic link:**

```bash
# It's important and required, regardless of chosen sources:
yum install gcc gcc-c++ kernel-devel bison perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel gd gd-devel GeoIP-devel libxml2-devel expat-devel gperftools-devel cpio gettext-devel autoconf jq

# In this example we use sources for all below packages so we do not install them:
yum install openssl-devel zlib-devel pcre-devel
```

  > Remember to build [`sregex`](#sregex) also if you use above steps.

**Or download and compile them:**

PCRE:

```bash
cd "${ngx_src}"

export pcre_version="8.42"

export PCRE_SRC="${ngx_base}/pcre-${pcre_version}"
export PCRE_LIB="/usr/local/lib"
export PCRE_INC="/usr/local/include"

wget https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.tar.gz && tar xzvf pcre-${pcre_version}.tar.gz

cd "$PCRE_SRC"

# Add to compile with debugging symbols:
#   CFLAGS='-O0 -g' ./configure
./configure

make -j2 && make test
make install
```

Zlib:

```bash
# I recommend to use Cloudflare Zlib version (cloudflare/zlib) instead of an original Zlib (zlib.net), but both installation methods are similar:
cd "${ngx_src}"

export ZLIB_SRC="${ngx_src}/zlib"
export ZLIB_LIB="/usr/local/lib"
export ZLIB_INC="/usr/local/include"

# For original Zlib:
#   export zlib_version="1.2.11"
#   wget http://www.zlib.net/zlib-${zlib_version}.tar.gz && tar xzvf zlib-${zlib_version}.tar.gz
#   cd "${ZLIB_SRC}-${zlib_version}"

# For Cloudflare Zlib:
git clone --depth 1 https://github.com/cloudflare/zlib

cd "$ZLIB_SRC"

./configure

make -j2 && make test
make install
```

OpenSSL:

```bash
cd "${ngx_src}"

export openssl_version="1.1.1b"

export OPENSSL_SRC="${ngx_src}/openssl-${openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && tar xzvf openssl-${openssl_version}.tar.gz

cd "${ngx_src}/openssl-${openssl_version}"

# Please run this and add as a compiler param:
export __GCC_SSL=("__SIZEOF_INT128__:enable-ec_nistp_64_gcc_128")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    echo -en "$_cc_value is supported on this machine\n"
    _openssl_gcc+="$_cc_value "

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

make -j2 && make test
make install

# Setup PATH environment variables:
cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=${OPENSSL_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${OPENSSL_DIR}/lib:${LD_LIBRARY_PATH}
__EOF__

chmod +x /etc/profile.d/openssl.sh && source /etc/profile.d/openssl.sh

# To make the OpenSSL 1.1.1b version visible globally first:
mv /usr/bin/openssl /usr/bin/openssl-old
ln -s ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

cat > /etc/ld.so.conf.d/openssl.conf << __EOF__
${OPENSSL_DIR}/lib
__EOF__
```

<a id="sregex"></a>sregex:

  > Required for `replace-filter-nginx-module` module.

```bash
cd "${ngx_src}"

git clone --depth 1 https://github.com/openresty/sregex

cd "${ngx_src}/sregex"

make && make install
```

jemalloc:

  > To verify `jemalloc` in use: `lsof -n | grep jemalloc`.

```bash
cd "${ngx_src}"

export JEMALLOC_SRC="/usr/local/src/jemalloc"
export JEMALLOC_INC="/usr/local/include/jemalloc"

git clone --depth 1 https://github.com/jemalloc/jemalloc

cd "$JEMALLOC_SRC"

./autogen.sh

make && make install
```

Update links and cache to the shared libraries for both types of installation:

```bash
ldconfig
```

###### Get OpenResty sources

```bash
cd "${ngx_base}"

wget https://openresty.org/download/openresty-${ngx_version}.tar.gz

tar zxvf openresty-${ngx_version}.tar.gz -C "${ngx_master}" --strip 1
```

###### Download 3rd party modules

```bash
cd "${ngx_modules}"

for i in \
https://github.com/openresty/replace-filter-nginx-module \
https://github.com/vozlt/nginx-module-sysguard \
https://github.com/nginx-clojure/nginx-access-plus \
https://github.com/yaoweibin/ngx_http_substitutions_filter_module \
https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng \
https://github.com/vozlt/nginx-module-vts \
https://github.com/google/ngx_brotli ; do

  git clone --depth 1 "$i"

done

wget http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
mkdir delay-module && tar xzvf delay-module.tar.gz -C delay-module --strip 1
```

For `ngx_brotli`:

```bash
cd "${ngx_modules}/ngx_brotli"

git submodule update --init
```

I also use some modules from Tengine:

- `ngx_backtrace_module`
- `ngx_debug_pool`
- `ngx_debug_timer`
- `ngx_http_upstream_check_module`
- `ngx_http_footer_filter_module`

```bash
cd "${ngx_modules}"

git clone --depth 1 https://github.com/alibaba/tengine
```

If you use NAXSI:

```bash
cd "${ngx_modules}"

git clone --depth 1 https://github.com/nbs-system/naxsi
```

###### Build OpenResty

```bash
cd "${ngx_master}"

# - you can also build OpenResty without 3rd party modules
# - remember about compiler and linker options
# - don't set values for --with-openssl, --with-pcre, and --with-zlib if you select prebuilt packages for them
# - add to compile with debugging symbols: -O0 -g
#   - and remove -D_FORTIFY_SOURCE=2 if you use above
./configure --prefix=/etc/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --sbin-path=/usr/sbin/nginx \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --modules-path=/etc/nginx/modules \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-compat \
            --with-debug \
            --with-file-aio \
            --with-threads \
            --with-stream \
            --with-stream_geoip_module \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_degradation_module \
            --with-http_geoip_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_image_filter_module \
            --with-http_perl_module \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_secure_link_module \
            --with-http_slice_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-google_perftools_module \
            --with-luajit \
            --with-openssl=${OPENSSL_SRC} \
            --with-openssl-opt="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong ${_openssl_gcc}" \
            --with-pcre=${PCRE_SRC} \
            --with-pcre-jit \
            --with-zlib=${ZLIB_SRC} \
            --without-http-cache \
            --without-http_memcached_module \
            --without-http_redis2_module \
            --without-http_redis_module \
            --without-http_rds_json_module \
            --without-http_rds_csv_module \
            --without-lua_redis_parser \
            --without-lua_rds_parser \
            --without-lua_resty_redis \
            --without-lua_resty_memcached \
            --without-lua_resty_mysql \
            --without-lua_resty_websocket \
            --without-mail_pop3_module \
            --without-mail_imap_module \
            --without-mail_smtp_module \
            --without-http_fastcgi_module \
            --without-http_scgi_module \
            --without-http_uwsgi_module \
            --add-module=${ngx_modules}/nginx-access-plus/src/c \
            --add-module=${ngx_modules}/ngx_http_substitutions_filter_module \
            --add-module=${ngx_modules}/nginx-module-vts \
            --add-module=${ngx_modules}/ngx_brotli \
            --add-module=${ngx_modules}/tengine/modules/ngx_backtrace_module \
            --add-module=${ngx_modules}/tengine/modules/ngx_debug_pool \
            --add-module=${ngx_modules}/tengine/modules/ngx_debug_timer \
            --add-module=${ngx_modules}/tengine/modules/ngx_http_footer_filter_module \
            --add-module=${ngx_modules}/tengine/modules/ngx_http_upstream_check_module \
            --add-module=${ngx_modules}/tengine/modules/ngx_slab_stat \
            --add-dynamic-module=${ngx_modules}/replace-filter-nginx-module \
            --add-dynamic-module=${ngx_modules}/nginx-module-sysguard \
            --add-dynamic-module=${ngx_modules}/delay-module \
            --add-dynamic-module=${ngx_modules}/naxsi/naxsi_src \
            --with-cc-opt="-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -O2 -g -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf" \
            --with-ld-opt="-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib"

make && make test
make install

ldconfig
```

Check OpenResty version:

```bash
nginx -v
nginx version: openresty/1.15.8.1
```

And list all files in `/etc/nginx`:

```bash
.
├── bin
│   ├── md2pod.pl
│   ├── nginx-xml2pod
│   ├── openresty -> /usr/sbin/nginx
│   ├── opm
│   ├── resty
│   ├── restydoc
│   └── restydoc-index
├── COPYRIGHT
├── fastcgi.conf
├── fastcgi.conf.default
├── fastcgi_params
├── fastcgi_params.default
├── koi-utf
├── koi-win
├── luajit
│   ├── bin
│   │   ├── luajit -> luajit-2.1.0-beta3
│   │   └── luajit-2.1.0-beta3
│   ├── include
│   │   └── luajit-2.1
│   │       ├── lauxlib.h
│   │       ├── luaconf.h
│   │       ├── lua.h
│   │       ├── lua.hpp
│   │       ├── luajit.h
│   │       └── lualib.h
│   ├── lib
│   │   ├── libluajit-5.1.a
│   │   ├── libluajit-5.1.so -> libluajit-5.1.so.2.1.0
│   │   ├── libluajit-5.1.so.2 -> libluajit-5.1.so.2.1.0
│   │   ├── libluajit-5.1.so.2.1.0
│   │   ├── lua
│   │   │   └── 5.1
│   │   └── pkgconfig
│   │       └── luajit.pc
│   └── share
│       ├── lua
│       │   └── 5.1
│       ├── luajit-2.1.0-beta3
│       │   └── jit
│       │       ├── bc.lua
│       │       ├── bcsave.lua
│       │       ├── dis_arm64be.lua
│       │       ├── dis_arm64.lua
│       │       ├── dis_arm.lua
│       │       ├── dis_mips64el.lua
│       │       ├── dis_mips64.lua
│       │       ├── dis_mipsel.lua
│       │       ├── dis_mips.lua
│       │       ├── dis_ppc.lua
│       │       ├── dis_x64.lua
│       │       ├── dis_x86.lua
│       │       ├── dump.lua
│       │       ├── p.lua
│       │       ├── v.lua
│       │       ├── vmdef.lua
│       │       └── zone.lua
│       └── man
│           └── man1
│               └── luajit.1
├── lualib
│   ├── cjson.so
│   ├── librestysignal.so
│   ├── ngx
│   │   ├── balancer.lua
│   │   ├── base64.lua
│   │   ├── errlog.lua
│   │   ├── ocsp.lua
│   │   ├── pipe.lua
│   │   ├── process.lua
│   │   ├── re.lua
│   │   ├── resp.lua
│   │   ├── semaphore.lua
│   │   ├── ssl
│   │   │   └── session.lua
│   │   └── ssl.lua
│   ├── resty
│   │   ├── aes.lua
│   │   ├── core
│   │   │   ├── base64.lua
│   │   │   ├── base.lua
│   │   │   ├── ctx.lua
│   │   │   ├── exit.lua
│   │   │   ├── hash.lua
│   │   │   ├── misc.lua
│   │   │   ├── ndk.lua
│   │   │   ├── phase.lua
│   │   │   ├── regex.lua
│   │   │   ├── request.lua
│   │   │   ├── response.lua
│   │   │   ├── shdict.lua
│   │   │   ├── time.lua
│   │   │   ├── uri.lua
│   │   │   ├── utils.lua
│   │   │   ├── var.lua
│   │   │   └── worker.lua
│   │   ├── core.lua
│   │   ├── dns
│   │   │   └── resolver.lua
│   │   ├── limit
│   │   │   ├── conn.lua
│   │   │   ├── count.lua
│   │   │   ├── req.lua
│   │   │   └── traffic.lua
│   │   ├── lock.lua
│   │   ├── lrucache
│   │   │   └── pureffi.lua
│   │   ├── lrucache.lua
│   │   ├── md5.lua
│   │   ├── random.lua
│   │   ├── sha1.lua
│   │   ├── sha224.lua
│   │   ├── sha256.lua
│   │   ├── sha384.lua
│   │   ├── sha512.lua
│   │   ├── sha.lua
│   │   ├── shell.lua
│   │   ├── signal.lua
│   │   ├── string.lua
│   │   ├── upload.lua
│   │   └── upstream
│   │       └── healthcheck.lua
│   └── tablepool.lua
├── mime.types
├── mime.types.default
├── modules
│   ├── ngx_http_delay_module.so
│   ├── ngx_http_naxsi_module.so
│   ├── ngx_http_replace_filter_module.so
│   └── ngx_http_sysguard_module.so
├── nginx
│   └── html
│       ├── 50x.html
│       └── index.html
├── nginx.conf
├── nginx.conf.default
├── pod
│   ├── array-var-nginx-module-0.05
│   │   └── array-var-nginx-module-0.05.pod
│   ├── drizzle-nginx-module-0.1.11
│   │   └── drizzle-nginx-module-0.1.11.pod
│   ├── echo-nginx-module-0.61
│   │   └── echo-nginx-module-0.61.pod
│   ├── encrypted-session-nginx-module-0.08
│   │   └── encrypted-session-nginx-module-0.08.pod
│   ├── form-input-nginx-module-0.12
│   │   └── form-input-nginx-module-0.12.pod
│   ├── headers-more-nginx-module-0.33
│   │   └── headers-more-nginx-module-0.33.pod
│   ├── iconv-nginx-module-0.14
│   │   └── iconv-nginx-module-0.14.pod
│   ├── lua-5.1.5
│   │   └── lua-5.1.5.pod
│   ├── lua-cjson-2.1.0.7
│   │   └── lua-cjson-2.1.0.7.pod
│   ├── luajit-2.1
│   │   ├── changes.pod
│   │   ├── contact.pod
│   │   ├── ext_c_api.pod
│   │   ├── extensions.pod
│   │   ├── ext_ffi_api.pod
│   │   ├── ext_ffi.pod
│   │   ├── ext_ffi_semantics.pod
│   │   ├── ext_ffi_tutorial.pod
│   │   ├── ext_jit.pod
│   │   ├── ext_profiler.pod
│   │   ├── faq.pod
│   │   ├── install.pod
│   │   ├── luajit-2.1.pod
│   │   ├── running.pod
│   │   └── status.pod
│   ├── luajit-2.1-20190507
│   │   └── luajit-2.1-20190507.pod
│   ├── lua-rds-parser-0.06
│   ├── lua-redis-parser-0.13
│   │   └── lua-redis-parser-0.13.pod
│   ├── lua-resty-core-0.1.17
│   │   ├── lua-resty-core-0.1.17.pod
│   │   ├── ngx.balancer.pod
│   │   ├── ngx.base64.pod
│   │   ├── ngx.errlog.pod
│   │   ├── ngx.ocsp.pod
│   │   ├── ngx.pipe.pod
│   │   ├── ngx.process.pod
│   │   ├── ngx.re.pod
│   │   ├── ngx.resp.pod
│   │   ├── ngx.semaphore.pod
│   │   ├── ngx.ssl.pod
│   │   └── ngx.ssl.session.pod
│   ├── lua-resty-dns-0.21
│   │   └── lua-resty-dns-0.21.pod
│   ├── lua-resty-limit-traffic-0.06
│   │   ├── lua-resty-limit-traffic-0.06.pod
│   │   ├── resty.limit.conn.pod
│   │   ├── resty.limit.count.pod
│   │   ├── resty.limit.req.pod
│   │   └── resty.limit.traffic.pod
│   ├── lua-resty-lock-0.08
│   │   └── lua-resty-lock-0.08.pod
│   ├── lua-resty-lrucache-0.09
│   │   └── lua-resty-lrucache-0.09.pod
│   ├── lua-resty-memcached-0.14
│   │   └── lua-resty-memcached-0.14.pod
│   ├── lua-resty-mysql-0.21
│   │   └── lua-resty-mysql-0.21.pod
│   ├── lua-resty-redis-0.27
│   │   └── lua-resty-redis-0.27.pod
│   ├── lua-resty-shell-0.02
│   │   └── lua-resty-shell-0.02.pod
│   ├── lua-resty-signal-0.02
│   │   └── lua-resty-signal-0.02.pod
│   ├── lua-resty-string-0.11
│   │   └── lua-resty-string-0.11.pod
│   ├── lua-resty-upload-0.10
│   │   └── lua-resty-upload-0.10.pod
│   ├── lua-resty-upstream-healthcheck-0.06
│   │   └── lua-resty-upstream-healthcheck-0.06.pod
│   ├── lua-resty-websocket-0.07
│   │   └── lua-resty-websocket-0.07.pod
│   ├── lua-tablepool-0.01
│   │   └── lua-tablepool-0.01.pod
│   ├── memc-nginx-module-0.19
│   │   └── memc-nginx-module-0.19.pod
│   ├── nginx
│   │   ├── accept_failed.pod
│   │   ├── beginners_guide.pod
│   │   ├── chunked_encoding_from_backend.pod
│   │   ├── configure.pod
│   │   ├── configuring_https_servers.pod
│   │   ├── contributing_changes.pod
│   │   ├── control.pod
│   │   ├── converting_rewrite_rules.pod
│   │   ├── daemon_master_process_off.pod
│   │   ├── debugging_log.pod
│   │   ├── development_guide.pod
│   │   ├── events.pod
│   │   ├── example.pod
│   │   ├── faq.pod
│   │   ├── freebsd_tuning.pod
│   │   ├── hash.pod
│   │   ├── howto_build_on_win32.pod
│   │   ├── install.pod
│   │   ├── license_copyright.pod
│   │   ├── load_balancing.pod
│   │   ├── nginx_dtrace_pid_provider.pod
│   │   ├── nginx.pod
│   │   ├── ngx_core_module.pod
│   │   ├── ngx_google_perftools_module.pod
│   │   ├── ngx_http_access_module.pod
│   │   ├── ngx_http_addition_module.pod
│   │   ├── ngx_http_api_module_head.pod
│   │   ├── ngx_http_auth_basic_module.pod
│   │   ├── ngx_http_auth_jwt_module.pod
│   │   ├── ngx_http_auth_request_module.pod
│   │   ├── ngx_http_autoindex_module.pod
│   │   ├── ngx_http_browser_module.pod
│   │   ├── ngx_http_charset_module.pod
│   │   ├── ngx_http_core_module.pod
│   │   ├── ngx_http_dav_module.pod
│   │   ├── ngx_http_empty_gif_module.pod
│   │   ├── ngx_http_f4f_module.pod
│   │   ├── ngx_http_fastcgi_module.pod
│   │   ├── ngx_http_flv_module.pod
│   │   ├── ngx_http_geoip_module.pod
│   │   ├── ngx_http_geo_module.pod
│   │   ├── ngx_http_grpc_module.pod
│   │   ├── ngx_http_gunzip_module.pod
│   │   ├── ngx_http_gzip_module.pod
│   │   ├── ngx_http_gzip_static_module.pod
│   │   ├── ngx_http_headers_module.pod
│   │   ├── ngx_http_hls_module.pod
│   │   ├── ngx_http_image_filter_module.pod
│   │   ├── ngx_http_index_module.pod
│   │   ├── ngx_http_js_module.pod
│   │   ├── ngx_http_keyval_module.pod
│   │   ├── ngx_http_limit_conn_module.pod
│   │   ├── ngx_http_limit_req_module.pod
│   │   ├── ngx_http_log_module.pod
│   │   ├── ngx_http_map_module.pod
│   │   ├── ngx_http_memcached_module.pod
│   │   ├── ngx_http_mirror_module.pod
│   │   ├── ngx_http_mp4_module.pod
│   │   ├── ngx_http_perl_module.pod
│   │   ├── ngx_http_proxy_module.pod
│   │   ├── ngx_http_random_index_module.pod
│   │   ├── ngx_http_realip_module.pod
│   │   ├── ngx_http_referer_module.pod
│   │   ├── ngx_http_rewrite_module.pod
│   │   ├── ngx_http_scgi_module.pod
│   │   ├── ngx_http_secure_link_module.pod
│   │   ├── ngx_http_session_log_module.pod
│   │   ├── ngx_http_slice_module.pod
│   │   ├── ngx_http_spdy_module.pod
│   │   ├── ngx_http_split_clients_module.pod
│   │   ├── ngx_http_ssi_module.pod
│   │   ├── ngx_http_ssl_module.pod
│   │   ├── ngx_http_status_module.pod
│   │   ├── ngx_http_stub_status_module.pod
│   │   ├── ngx_http_sub_module.pod
│   │   ├── ngx_http_upstream_conf_module.pod
│   │   ├── ngx_http_upstream_hc_module.pod
│   │   ├── ngx_http_upstream_module.pod
│   │   ├── ngx_http_userid_module.pod
│   │   ├── ngx_http_uwsgi_module.pod
│   │   ├── ngx_http_v2_module.pod
│   │   ├── ngx_http_xslt_module.pod
│   │   ├── ngx_mail_auth_http_module.pod
│   │   ├── ngx_mail_core_module.pod
│   │   ├── ngx_mail_imap_module.pod
│   │   ├── ngx_mail_pop3_module.pod
│   │   ├── ngx_mail_proxy_module.pod
│   │   ├── ngx_mail_smtp_module.pod
│   │   ├── ngx_mail_ssl_module.pod
│   │   ├── ngx_stream_access_module.pod
│   │   ├── ngx_stream_core_module.pod
│   │   ├── ngx_stream_geoip_module.pod
│   │   ├── ngx_stream_geo_module.pod
│   │   ├── ngx_stream_js_module.pod
│   │   ├── ngx_stream_keyval_module.pod
│   │   ├── ngx_stream_limit_conn_module.pod
│   │   ├── ngx_stream_log_module.pod
│   │   ├── ngx_stream_map_module.pod
│   │   ├── ngx_stream_proxy_module.pod
│   │   ├── ngx_stream_realip_module.pod
│   │   ├── ngx_stream_return_module.pod
│   │   ├── ngx_stream_split_clients_module.pod
│   │   ├── ngx_stream_ssl_module.pod
│   │   ├── ngx_stream_ssl_preread_module.pod
│   │   ├── ngx_stream_upstream_hc_module.pod
│   │   ├── ngx_stream_upstream_module.pod
│   │   ├── ngx_stream_zone_sync_module.pod
│   │   ├── request_processing.pod
│   │   ├── server_names.pod
│   │   ├── stream_processing.pod
│   │   ├── switches.pod
│   │   ├── syntax.pod
│   │   ├── sys_errlist.pod
│   │   ├── syslog.pod
│   │   ├── variables_in_config.pod
│   │   ├── websocket.pod
│   │   ├── welcome_nginx_facebook.pod
│   │   └── windows.pod
│   ├── ngx_coolkit-0.2
│   ├── ngx_devel_kit-0.3.1rc1
│   │   └── ngx_devel_kit-0.3.1rc1.pod
│   ├── ngx_lua-0.10.15
│   │   └── ngx_lua-0.10.15.pod
│   ├── ngx_lua_upstream-0.07
│   │   └── ngx_lua_upstream-0.07.pod
│   ├── ngx_postgres-1.0
│   │   ├── ngx_postgres-1.0.pod
│   │   └── todo.pod
│   ├── ngx_stream_lua-0.0.7
│   │   ├── dev_notes.pod
│   │   └── ngx_stream_lua-0.0.7.pod
│   ├── opm-0.0.5
│   │   └── opm-0.0.5.pod
│   ├── rds-csv-nginx-module-0.09
│   │   └── rds-csv-nginx-module-0.09.pod
│   ├── rds-json-nginx-module-0.15
│   │   └── rds-json-nginx-module-0.15.pod
│   ├── redis2-nginx-module-0.15
│   │   └── redis2-nginx-module-0.15.pod
│   ├── redis-nginx-module-0.3.7
│   ├── resty-cli-0.24
│   │   └── resty-cli-0.24.pod
│   ├── set-misc-nginx-module-0.32
│   │   └── set-misc-nginx-module-0.32.pod
│   ├── srcache-nginx-module-0.31
│   │   └── srcache-nginx-module-0.31.pod
│   └── xss-nginx-module-0.06
│       └── xss-nginx-module-0.06.pod
├── resty.index
├── scgi_params
├── scgi_params.default
├── site
│   ├── lualib
│   ├── manifest
│   └── pod
├── uwsgi_params
├── uwsgi_params.default
└── win-utf

78 directories, 305 files
```

###### Post installation tasks

  > Check all post installation tasks from [Nginx on CentOS 7 - Post installation tasks](#post-installation-tasks) section.

</details>

#### Installation Tengine on Ubuntu 18.04

  > _Tengine is a web server originated by Taobao, the largest e-commerce website in Asia. It is based on the NGINX HTTP server and has many advanced features. There’s a lot of features in Tengine that do not (yet) exist in NGINX._

- Official github repository: [Tengine](https://github.com/alibaba/tengine)
- Official documentation: [Tengine Documentation](https://tengine.taobao.org/documentation.html)

Generally, Tengine is a great solution, including many patches, improvements, additional modules, and most importantly it is very actively maintained.

The build and installation process is very similar to [Install Nginx on Centos 7](#installation-nginx-on-centos-7). However, I will only specify the most important changes.

<details>
<summary><b>Show step-by-step Tengine installation</b></summary><br>

* [Pre installation tasks](#pre-installation-tasks-2)
* [Dependencies](#dependencies-2)
* [Get Tengine sources](#get-tengine-sources)
* [Download 3rd party modules](#download-3rd-party-modules-2)
* [Build Tengine](#build-tengine)
* [Post installation tasks](#post-installation-tasks-2)

###### Pre installation tasks

Set the Tengine version (I use newest and stable release):

```bash
export ngx_version="2.3.0"
```

Set temporary variables:

```bash
ngx_src="/usr/local/src"
ngx_base="${ngx_src}/tengine-${ngx_version}"
ngx_master="${ngx_base}/master"
ngx_modules="${ngx_base}/modules"
```

Create directories:

```bash
for i in "$ngx_base" "${ngx_master}" "$ngx_modules" ; do

  mkdir "$i"

done
```

###### Dependencies

Install prebuilt packages, export variables and set symbolic link:

```bash
apt-get install gcc make build-essential bison perl libperl-dev libphp-embed libxslt-dev libgd-dev libgeoip-dev libxml2-dev libexpat-dev libgoogle-perftools-dev libgoogle-perftools4 autoconf jq

# In this example we don't use zlib sources:
apt-get install zlib1g-dev
```

PCRE:

```bash
cd "${ngx_src}"

export pcre_version="8.42"

export PCRE_SRC="${ngx_base}/pcre-${pcre_version}"
export PCRE_LIB="/usr/local/lib"
export PCRE_INC="/usr/local/include"

wget https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.tar.gz && tar xzvf pcre-${pcre_version}.tar.gz

cd "$PCRE_SRC"

# Add to compile with debugging symbols:
#   CFLAGS='-O0 -g' ./configure
./configure

make -j2 && make test
make install
```

OpenSSL:

```bash
cd "${ngx_src}"

export openssl_version="1.1.1b"

export OPENSSL_SRC="${ngx_src}/openssl-${openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && tar xzvf openssl-${openssl_version}.tar.gz

cd "${ngx_src}/openssl-${openssl_version}"

# Please run this and add as a compiler param:
export __GCC_SSL=("__SIZEOF_INT128__:enable-ec_nistp_64_gcc_128")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    echo -en "$_cc_value is supported on this machine\n"
    _openssl_gcc+="$_cc_value "

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

make -j2 && make test
make install

# Setup PATH environment variables:
cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=${OPENSSL_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${OPENSSL_DIR}/lib:${LD_LIBRARY_PATH}
__EOF__

chmod +x /etc/profile.d/openssl.sh && source /etc/profile.d/openssl.sh

# To make the OpenSSL 1.1.1b version visible globally first:
mv /usr/bin/openssl /usr/bin/openssl-old
ln -s ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

cat > /etc/ld.so.conf.d/openssl.conf << __EOF__
${OPENSSL_DIR}/lib
__EOF__
```

LuaJIT:

```bash
# I recommend to use OpenResty's branch (openresty/luajit2) instead of LuaJIT (LuaJIT/LuaJIT), but both installation methods are similar:
cd "${ngx_src}"

export LUAJIT_SRC="${ngx_src}/luajit2"
export LUAJIT_LIB="/usr/local/lib"
export LUAJIT_INC="/usr/local/include/luajit-2.1"

# For original LuaJIT:
#   git clone http://luajit.org/git/luajit-2.0 luajit2
#   cd "$LUAJIT_SRC"

# For OpenResty's LuaJIT:
git clone --depth 1 https://github.com/openresty/luajit2

cd "$LUAJIT_SRC"

# Add to compile with debugging symbols:
#   CFLAGS='-g' make ...
make && make install

ln -s /usr/local/lib/libluajit-5.1.so.2.1.0 /usr/local/lib/liblua.so
```

sregex:

  > Required for `replace-filter-nginx-module` module.

```bash
cd "${ngx_src}"

git clone --depth 1 https://github.com/openresty/sregex

cd "${ngx_src}/sregex"

make && make install
```

jemalloc:

  > To verify `jemalloc` in use: `lsof -n | grep jemalloc`.

```bash
cd "${ngx_src}"

export JEMALLOC_SRC="/usr/local/src/jemalloc"
export JEMALLOC_INC="/usr/local/include/jemalloc"

git clone --depth 1 https://github.com/jemalloc/jemalloc

cd "$JEMALLOC_SRC"

./autogen.sh

make && make install
```

Update links and cache to the shared libraries for both types of installation:

```bash
ldconfig
```

###### Get Tengine sources

```bash
cd "${ngx_base}"

wget https://tengine.taobao.org/download/tengine-${ngx_version}.tar.gz

# or alternative:
#   git clone --depth 1 https://github.com/alibaba/tengine master

tar zxvf tengine-${ngx_version}.tar.gz -C "${ngx_master}"
```

###### Download 3rd party modules

  > Not all modules from [this](#3rd-party-modules) section working properly with Tengine (e.g. `ndk_http_module` and other dependent on it).

```bash
cd "${ngx_modules}"

for i in \
https://github.com/openresty/echo-nginx-module \
https://github.com/openresty/headers-more-nginx-module \
https://github.com/openresty/replace-filter-nginx-module \
https://github.com/nginx-clojure/nginx-access-plus \
https://github.com/yaoweibin/ngx_http_substitutions_filter_module \
https://github.com/vozlt/nginx-module-vts \
https://github.com/google/ngx_brotli ; do

  git clone --depth 1 "$i"

done

wget http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
mkdir delay-module && tar xzvf delay-module.tar.gz -C delay-module --strip 1
```

For `ngx_brotli`:

```bash
cd "${ngx_modules}/ngx_brotli"

git submodule update --init
```

If you use NAXSI:

```bash
cd "${ngx_modules}"

git clone --depth 1 https://github.com/nbs-system/naxsi
```

###### Build Tengine

```bash
cd "${ngx_master}"

# - you can also build Tengine without 3rd party modules
# - remember about compiler and linker options
# - don't set values for --with-openssl, --with-pcre, and --with-zlib if you select prebuilt packages for them
# - add to compile with debugging symbols: -O0 -g
#   - and remove -D_FORTIFY_SOURCE=2 if you use above
./configure --prefix=/etc/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --sbin-path=/usr/sbin/nginx \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --modules-path=/etc/nginx/modules \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-compat \
            --with-debug \
            --with-file-aio \
            --with-threads \
            --with-stream \
            --with-stream_geoip_module \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_degradation_module \
            --with-http_geoip_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_image_filter_module \
            --with-http_lua_module \
            --with-http_perl_module \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_secure_link_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-google_perftools_module \
            --with-openssl=${OPENSSL_SRC} \
            --with-openssl-opt="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong ${_openssl_gcc}" \
            --with-pcre=${PCRE_SRC} \
            --with-pcre-jit \
            --with-jemalloc=${JEMALLOC_SRC} \
            --without-http-cache \
            --without-http_memcached_module \
            --without-mail_pop3_module \
            --without-mail_imap_module \
            --without-mail_smtp_module \
            --without-http_fastcgi_module \
            --without-http_scgi_module \
            --without-http_uwsgi_module \
            --without-http_upstream_keepalive_module \
            --add-module=${ngx_master}/modules/ngx_backtrace_module \
            --add-module=${ngx_master}/modules/ngx_debug_pool \
            --add-module=${ngx_master}/modules/ngx_debug_timer \
            --add-module=${ngx_master}/modules/ngx_http_footer_filter_module \
            --add-module=${ngx_master}/modules/ngx_http_lua_module \
            --add-module=${ngx_master}/modules/ngx_http_proxy_connect_module \
            --add-module=${ngx_master}/modules/ngx_http_reqstat_module \
            --add-module=${ngx_master}/modules/ngx_http_slice_module \
            --add-module=${ngx_master}/modules/ngx_http_sysguard_module \
            --add-module=${ngx_master}/modules/ngx_http_trim_filter_module \
            --add-module=${ngx_master}/modules/ngx_http_upstream_check_module \
            --add-module=${ngx_master}/modules/ngx_http_upstream_consistent_hash_module \
            --add-module=${ngx_master}/modules/ngx_http_upstream_dynamic_module \
            --add-module=${ngx_master}/modules/ngx_http_upstream_keepalive_module \
            --add-module=${ngx_master}/modules/ngx_http_upstream_session_sticky_module \
            --add-module=${ngx_master}/modules/ngx_http_user_agent_module \
            --add-module=${ngx_master}/modules/ngx_slab_stat \
            --add-module=${ngx_modules}/nginx-access-plus/src/c \
            --add-module=${ngx_modules}/ngx_http_substitutions_filter_module \
            --add-module=${ngx_modules}/nginx-module-vts \
            --add-module=${ngx_modules}/ngx_brotli \
            --add-dynamic-module=${ngx_modules}/echo-nginx-module \
            --add-dynamic-module=${ngx_modules}/headers-more-nginx-module \
            --add-dynamic-module=${ngx_modules}/replace-filter-nginx-module \
            --add-dynamic-module=${ngx_modules}/delay-module \
            --add-dynamic-module=${ngx_modules}/naxsi/naxsi_src \
            --with-cc-opt="-I/usr/local/include -I${OPENSSL_INC} -I${LUAJIT_INC} -I${JEMALLOC_INC} -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC" \
            --with-ld-opt="-Wl,-E -L/usr/local/lib -ljemalloc -lpcre -Wl,-rpath,/usr/local/lib/,-z,relro -Wl,-z,now -pie"

make -j2 && make test
make install

ldconfig
```

Check Tengine version:

```bash
nginx -v
Tengine version: Tengine/2.3.0
nginx version: nginx/1.15.9
```

And list all files in `/etc/nginx`:

```bash
tree
.
├── fastcgi.conf
├── fastcgi.conf.default
├── fastcgi_params
├── fastcgi_params.default
├── html
│   ├── 50x.html
│   └── index.html
├── koi-utf
├── koi-win
├── mime.types
├── mime.types.default
├── modules
│   ├── ngx_http_delay_module.so
│   ├── ngx_http_echo_module.so
│   ├── ngx_http_headers_more_filter_module.so
│   ├── ngx_http_naxsi_module.so
│   └── ngx_http_replace_filter_module.so
├── nginx.conf
├── nginx.conf.default
├── scgi_params
├── scgi_params.default
├── uwsgi_params
├── uwsgi_params.default
└── win-utf

2 directories, 22 files
```

###### Post installation tasks

  > Check all post installation tasks from [Nginx on CentOS 7 - Post installation tasks](#post-installation-tasks) section.

</details>

#### Analyse configuration

It is an essential way for testing NGINX configuration:

```bash
nginx -t -c /etc/nginx/nginx.conf
```

An external tool for analyse NGINX configuration is `gixy`. The main goal of this tool is to prevent security misconfiguration and automate flaw detection:

```bash
gixy /etc/nginx/nginx.conf
```

#### Monitoring

##### GoAccess

Standard paths to the configuration file:

- `/etc/goaccess.conf`
- `/etc/goaccess/goaccess.conf`
- `/usr/local/etc/goaccess.conf`

Prior to start GoAccess enable these parameters:

```bash
time-format %H:%M:%S
date-format %d/%b/%Y
log-format  %h %^[%d:%t %^] "%r" %s %b "%R" "%u"
```

###### Build and install

```bash
# Ubuntu/Debian
apt-get install gcc make libncursesw5-dev libgeoip-dev libtokyocabinet-dev

# RHEL/CentOS
yum install gcc ncurses-devel geoip-devel tokyocabinet-devel

cd /usr/local/src/

wget -c https://tar.goaccess.io/goaccess-1.3.tar.gz && \
tar xzvfp goaccess-1.3.tar.gz

cd goaccess-1.3

./configure --enable-utf8 --enable-geoip=legacy --with-openssl=<path_to_openssl_sources> --sysconfdir=/etc/

make -j2 && make install

ln -s /usr/local/bin/goaccess /usr/bin/goaccess
```

  > You can always fetch default configuration from `/usr/local/src/goaccess-<version>/config/goaccess.conf` source tree.

###### Analyse log file and enable all recorded statistics

```bash
goaccess -f access.log -a
```

###### Analyse compressed log file

```bash
zcat access.log.1.gz | goaccess -a -p /etc/goaccess/goaccess.conf
```

###### Analyse log file remotely

```bash
ssh user@remote_host 'access.log' | goaccess -a
```

###### Analyse log file and generate html report

```bash
goaccess -p /etc/goaccess/goaccess.conf -f access.log --log-format=COMBINED -o /var/www/index.html
```

##### Ngxtop

###### Analyse log file

```bash
ngxtop -l access.log
```

###### Analyse log file and print requests with 4xx and 5xx

```bash
ngxtop -l access.log -i 'status >= 400' print request status
```

###### Analyse log file remotely

```bash
ssh user@remote_host tail -f access.log | ngxtop -f combined
```

#### Testing

  > You can change combinations and parameters of these commands.

###### Send request and show response headers

```bash
# 1)
curl -Iks <scheme>://<server_name>:<port>

# 2)
http -p Hh <scheme>://<server_name>:<port>

# 3)
htrace.sh -u <scheme>://<server_name>:<port> -h
```

###### Send request with http method, user-agent, follow redirects and show response headers

```bash
# 1)
curl -Iks --location -X GET -A "x-agent" <scheme>://<server_name>:<port>

# 2)
http -p Hh GET <scheme>://<server_name>:<port> User-Agent:x-agent --follow

# 3)
htrace.sh -u <scheme>://<server_name>:<port> -M GET --user-agent "x-agent" -h
```

###### Send multiple requests

```bash
# URL sequence substitution with a dummy query string:
curl -ks <scheme>://<server_name>:<port>?[1-20]

# With shell 'for' loop:
for i in {1..20} ; do curl -ks <scheme>://<server_name>:<port> ; done
```

###### Testing SSL connection

```bash
# 1)
echo | openssl s_client -connect <server_name>:<port>

# 2)
gnutls-cli --disable-sni -p 443 <server_name>
```

###### Testing SSL connection with SNI support

```bash
# 1)
echo | openssl s_client -servername <server_name> -connect <server_name>:<port>

# 2)
gnutls-cli -p 443 <server_name>
```

###### Testing SSL connection with specific SSL version

```bash
openssl s_client -tls1_2 -connect <server_name>:<port>
```

###### Testing SSL connection with specific cipher

```bash
openssl s_client -cipher 'AES128-SHA' -connect <server_name>:<port>
```

###### Verify 0-RTT

```bash
_host="example.com"

cat > req.in << __EOF__
HEAD / HTTP/1.1
Host: $_host
Connection: close
__EOF__

openssl s_client -connect ${_host}:443 -tls1_3 -sess_out session.pem -ign_eof < req.in
openssl s_client -connect ${_host}:443 -tls1_3 -sess_in session.pem -early_data req.in
```

##### Load testing with ApacheBench (ab)

  > Project documentation: [Apache HTTP server benchmarking tool](https://httpd.apache.org/docs/2.4/programs/ab.html)

Installation:

```bash
# Debian like:
apt-get install -y apache2-utils

# RedHat like:
yum -y install httpd-tools
```

This is a [great explanation](https://stackoverflow.com/a/12732410) about ApacheBench by [Mamsaac](https://stackoverflow.com/users/669111/mamsaac):

  > _The apache benchmark tool is very basic, and while it will give you a solid idea of some performance, it is a bad idea to only depend on it if you plan to have your site exposed to serious stress in production._

###### Standard test

```bash
ab -n 1000 -c 100 https://example.com/
```

###### Test with Keep-Alive header

```bash
ab -n 5000 -c 100 -k -H "Accept-Encoding: gzip, deflate" https://example.com/index.php
```

##### Load testing with wrk2

  > Project documentation: [wrk2](https://github.com/giltene/wrk2)

  > See [this](https://github.com/giltene/wrk2/blob/master/SCRIPTING) chapter to use the Lua API for wrk2. Also take a look at [wrk2 scripts](https://github.com/giltene/wrk2/tree/master/scripts).

Installation:

```bash
# Debian like:
apt-get install -y build-essential libssl-dev git zlib1g-dev
git clone https://github.com/giltene/wrk2 && cd wrk2
make
sudo cp wrk /usr/local/bin

# RedHat like:
yum -y groupinstall 'Development Tools'
yum -y install openssl-devel git
git clone https://github.com/giltene/wrk2 && cd wrk2
make
sudo cp wrk /usr/local/bin
```

###### Standard scenarios

```bash
# 1)
wrk -c 1 -t 1 -d 2s -R 5 -H "Host: example.com" https://example.com
Running 2s test @ https://example.com
  1 threads and 1 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    45.21ms   20.99ms 108.16ms   90.00%
    Req/Sec       -nan      -nan   0.00      0.00%
  10 requests in 2.01s, 61.69KB read
Requests/sec:      4.99
Transfer/sec:     30.76KB

# RPS:
6 09/Jul/2019:08:00:25
5 09/Jul/2019:08:00:26

# 2)
wrk -c 1 -t 1 -d 2s -R 25 -H "Host: example.com" https://example.com
Running 2s test @ https://example.com
  1 threads and 1 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    64.40ms   24.26ms 110.46ms   48.00%
    Req/Sec       -nan      -nan   0.00      0.00%
  50 requests in 2.01s, 308.45KB read
Requests/sec:     24.93
Transfer/sec:    153.77KB

# RPS:
12 09/Jul/2019:08:02:09
26 09/Jul/2019:08:02:10
13 09/Jul/2019:08:02:11

# 3)
wrk -c 5 -t 5 -d 2s -R 25 -H "Host: example.com" https://example.com
Running 2s test @ https://example.com
  5 threads and 5 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    47.97ms   25.79ms 136.45ms   90.00%
    Req/Sec       -nan      -nan   0.00      0.00%
  50 requests in 2.01s, 308.45KB read
Requests/sec:     24.92
Transfer/sec:    153.75KB

# RPS:
25 09/Jul/2019:08:03:56
25 09/Jul/2019:08:03:57
 5 09/Jul/2019:08:03:58

# 4)
wrk -c 5 -t 5 -d 2s -R 50 -H "Host: example.com" https://example.com
Running 2s test @ https://example.com
  5 threads and 5 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    45.09ms   18.63ms 130.69ms   91.00%
    Req/Sec       -nan      -nan   0.00      0.00%
  100 requests in 2.01s, 616.89KB read
Requests/sec:     49.85
Transfer/sec:    307.50KB

# RPS:
35 09/Jul/2019:08:05:00
50 09/Jul/2019:08:05:01
20 09/Jul/2019:08:05:02

# 5)
wrk -c 24 -t 12 -d 30s -R 2500 -H "Host: example.com" https://example.com
Running 30s test @ https://example.com
  12 threads and 24 connections
  Thread calibration: mean lat.: 3866.673ms, rate sampling interval: 13615ms
  Thread calibration: mean lat.: 3880.487ms, rate sampling interval: 13606ms
  Thread calibration: mean lat.: 3890.279ms, rate sampling interval: 13615ms
  Thread calibration: mean lat.: 3872.985ms, rate sampling interval: 13606ms
  Thread calibration: mean lat.: 3876.076ms, rate sampling interval: 13615ms
  Thread calibration: mean lat.: 3883.463ms, rate sampling interval: 13606ms
  Thread calibration: mean lat.: 3870.145ms, rate sampling interval: 13623ms
  Thread calibration: mean lat.: 3873.675ms, rate sampling interval: 13623ms
  Thread calibration: mean lat.: 3898.842ms, rate sampling interval: 13672ms
  Thread calibration: mean lat.: 3890.278ms, rate sampling interval: 13615ms
  Thread calibration: mean lat.: 3882.429ms, rate sampling interval: 13631ms
  Thread calibration: mean lat.: 3896.333ms, rate sampling interval: 13639ms
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    15.01s     4.32s   22.46s    57.62%
    Req/Sec    52.00      0.00    52.00    100.00%
  18836 requests in 30.01s, 113.52MB read
Requests/sec:    627.59
Transfer/sec:      3.78MB

# RPS:
 98 09/Jul/2019:08:06:13
627 09/Jul/2019:08:06:14
624 09/Jul/2019:08:06:15
640 09/Jul/2019:08:06:16
629 09/Jul/2019:08:06:17
627 09/Jul/2019:08:06:18
648 09/Jul/2019:08:06:19
624 09/Jul/2019:08:06:20
624 09/Jul/2019:08:06:21
631 09/Jul/2019:08:06:22
641 09/Jul/2019:08:06:23
627 09/Jul/2019:08:06:24
633 09/Jul/2019:08:06:25
636 09/Jul/2019:08:06:26
648 09/Jul/2019:08:06:27
626 09/Jul/2019:08:06:28
617 09/Jul/2019:08:06:29
636 09/Jul/2019:08:06:30
640 09/Jul/2019:08:06:31
627 09/Jul/2019:08:06:32
635 09/Jul/2019:08:06:33
639 09/Jul/2019:08:06:34
633 09/Jul/2019:08:06:35
598 09/Jul/2019:08:06:36
644 09/Jul/2019:08:06:37
632 09/Jul/2019:08:06:38
635 09/Jul/2019:08:06:39
624 09/Jul/2019:08:06:40
643 09/Jul/2019:08:06:41
635 09/Jul/2019:08:06:42
431 09/Jul/2019:08:06:43

# Other examples:
wrk -c 24 -t 12 -d 30s -R 2500 --latency https://example.com/index.php
```

###### POST call (with Lua)

Based on:

- [wrk2 scripts - post](https://github.com/giltene/wrk2/blob/master/scripts/post.lua)
- [POST request with wrk?](https://stackoverflow.com/questions/15261612/post-request-with-wrk)

Example 1:

```lua
-- lua/post-call.lua

request = function()

  wrk.method = "POST"
  wrk.body = "login=foo&password=bar"
  wrk.headers["Content-Type"] = "application/x-www-form-urlencoded"

  return wrk.format(wrk.method)

end
```

Example 2:

```lua
-- lua/post-call.lua

request = function()

  path = "/forms/int/d/1FAI"

  wrk.method = "POST"
  wrk.body = "{\"hash\":\"ooJeiveenai6iequ\",\"timestamp\":\"1562585990\",\"data\":[[\"cache\",\"x-cache\",\"true\"]]}"
  wrk.headers["Content-Type"] = "application/json; charset=utf-8"
  wrk.headers["Accept"] = "application/json"

  return wrk.format(wrk.method, path)

end
```

Example 3:

```lua
-- lua/post-call.lua

request = function()

  path = "/login"

  wrk.method = "POST"
  wrk.body = [[{
    "hash": "ooJeiveenai6iequ",
    "timestamp": "1562585990",
    "data":
    {
      login: "foo",
      password: "bar"
    },
  }]]
  wrk.headers["Content-Type"] = "application/json; charset=utf-8"

  return wrk.format(wrk.method, path)

end
```

Command:

```bash
# The first example:
wrk -c 12 -t 12 -d 30s -R 12000 -s lua/post-call.lua https://example.com/login

# Second and third example:
wrk -c 12 -t 12 -d 30s -R 12000 -s lua/post-call.lua https://example.com
```

###### Random paths (with Lua)

Based on:

- [Intelligent benchmark with wrk](https://medium.com/@felipedutratine/intelligent-benchmark-with-wrk-163986c1587f)
- [Confusion about benchmarking Linkerd](https://discourse.linkerd.io/t/confusion-about-benchmarking-linkerd/280)

Example 1:

```lua
-- lua/random-paths.lua

math.randomseed(os.time())

request = function()

  url_path = "/search?q=" .. math.random(0,100000)

  -- print(url_path)

  return wrk.format("GET", url_path)

end
```

Example 2:

```lua
-- lua/random-paths.lua

math.randomseed(os.time())

local connected = false

local host = "example.com"
local path = "/search?q="
local url  = "https://" .. host .. path

wrk.headers["Host"] = host

function ranValue(length)

  local res = ""

  for i = 1, length do

    res = res .. string.char(math.random(97, 122))

  end

  return res

end

request = function()

  url_path = path .. ranValue(32)

  -- print(url_path)

   if not connected then

      connected = true
      return wrk.format("CONNECT", host)

   end

  return wrk.format("GET", url_path)

end
```

Example 3:

```lua
-- lua/random-paths.lua

math.randomseed(os.time())

counter = 0

function ranValue(length)

  local res = ""

  for i = 1, length do

    res = res .. string.char(math.random(97, 122))

  end

  return res

end

request = function()

  path = "/accounts/" .. counter

  rval = ranValue(32)

  wrk.method = "POST"
  wrk.body   = [[{
    "user": counter,
    "action": "insert",
    "amount": rval
  }]]
  wrk.headers["Content-Type"] = "application/json"
  wrk.headers["Accept"] = "application/json"

  io.write(string.format("id: %4d, path: %14s,\tvalue: %s\n", counter, path, rval))

  counter = counter + 1
  if counter>500 then

    counter = 1

  end

  return wrk.format(wrk.method, path)

end
```

Command:

```bash
wrk -c 12 -t 12 -d 30s -R 12000 -s lua/random-paths.lua https://example.com/
```

###### Multiple paths (with Lua)

Example 1:

```lua
-- lua/multi-paths.lua

math.randomseed(os.time())
math.random(); math.random(); math.random()

function shuffle(paths)

  local j, k
  local n = #paths

  for i = 1, n do

    j, k = math.random(n), math.random(n)
    paths[j], paths[k] = paths[k], paths[j]

  end

  return paths

end

function load_url_paths_from_file(file)

  lines = {}

  local f=io.open(file,"r")
  if f~=nil then

    io.close(f)

  else

    return lines

  end

  for line in io.lines(file) do

    if not (line == '') then

      lines[#lines + 1] = line

    end

  end

  return shuffle(lines)

end

paths = load_url_paths_from_file("data/paths.list")

if #paths <= 0 then

  print("No paths found. You have to create a file data/paths.list with one path per line.")
  os.exit()

end

counter = 0

request = function()

  url_path = paths[counter]

  if counter > #paths then

    counter = 0

  end

  counter = counter + 1

  return wrk.format(nil, url_path)

end
```

- `data/paths.list`:

  ```
  / - it's not recommend, requests are being duplicated if you add only '/'
  /foo/bar
  /articles/id=25
  /3a06e672fad4bec2383748cfd82547ee.html
  ```

Command:

```bash
wrk -c 12 -t 12 -d 60s -R 200 -s lua/multi-paths.lua https://example.com
```

###### Random server address to each thread (with Lua)

Based on:

- [wrk2 scripts - addr](https://github.com/giltene/wrk2/blob/master/scripts/addr.lua)

Example 1:

```lua
-- lua/resolve-host.lua

local addrs = nil

function setup(thread)

  if not addrs then

    -- addrs = wrk.lookup(wrk.host, "443" or "http")
    addrs = wrk.lookup(wrk.host, wrk.port or "http")

    for i = #addrs, 1, -1 do

      if not wrk.connect(addrs[i]) then

        table.remove(addrs, i)

      end

    end

  end

  thread.addr = addrs[math.random(#addrs)]

end

function init(args)

  local msg = "thread remote socket: %s"
  print(msg:format(wrk.thread.addr))

end
```

Command:

```bash
wrk -c 12 -t 12 -d 30s -R 600 -s lua/resolve-host.lua https://example.com
```

###### Multiple json requests (with Lua)

Based on:

- [multi-request-json](https://github.com/jgsqware/wrk-report/blob/master/scripts/multi-request-json.lua)

You should install `luarocks`, `lua`, `luajit` and `lua-cjson` before use `multi-req.lua`:

```bash
# Debian like:
apt-get install lua5.1 libluajit-5.1-dev luarocks

# RedHat like:
yum install lua luajit-devel luarocks

# cjson:
luarocks install lua-cjson
```

```lua
-- lua/multi-req.lua

local cjson = require "cjson"
local cjson2 = cjson.new()
local cjson_safe = require "cjson.safe"

math.randomseed(os.time())
math.random(); math.random(); math.random()

function shuffle(paths)

  local j, k
  local n = #paths

  for i = 1, n do

    j, k = math.random(n), math.random(n)
    paths[j], paths[k] = paths[k], paths[j]

  end

  return paths

end

function load_request_objects_from_file(file)

  local data = {}
  local content

  local f=io.open(file,"r")
  if f~=nil then

    content = f:read("*all")
    io.close(f)

  else

    return lines

  end

  data = cjson.decode(content)

  return shuffle(data)

end

requests = load_request_objects_from_file("data/requests.json")

if #requests <= 0 then

  print("No requests found. You have to create a file data/requests.json.")
  os.exit()

end

print(" " .. #requests .. " requests")

counter = 1

request = function()

  local request_object = requests[counter]

  counter = counter + 1

  if counter > #requests then

    counter = 1

  end

  return wrk.format(request_object.method, request_object.path, request_object.headers, request_object.body)

end
```

- `data/requests.json`:

  ```json
  [
    {
      "path": "/id/1",
      "body": "ceR1caesaed2nohJei",
      "method": "GET",
      "headers": {
        "X-Custom-Header-1": "foo",
        "X-Custom-Header-2": "bar"
      }
    },
    {
      "path": "/id/2",
      "body": "{\"field\":\"value\"}",
      "method": "POST",
      "headers": {
        "Content-Type": "application/json",
        "X-Custom-Header-1": "foo",
        "X-Custom-Header-2": "bar"
      }
    }
  ]
  ```

Command:

```bash
wrk -c 12 -t 12 -d 30s -R 200 -s lua/multi-req.lua https://example.com
```

###### Debug mode (with Lua)

Based on:

- [wrk-debugging-environment](https://github.com/czerasz/wrk-debugging-environment/blob/master/environments/wrk/scripts/debug.lua)

```lua
-- lua/debug.lua

local file = io.open("data/debug.log", "w")

file:write("\n----------------------------------------\n")
file:write(os.date("%m/%d/%Y %I:%M %p"))
file:write("\n----------------------------------------\n")
file:close()

local file = io.open("data/debug.log", "a")

function typeof(var)

  local _type = type(var);
  if(_type ~= "table" and _type ~= "userdata") then

    return _type;

  end

  local _meta = getmetatable(var);
  if(_meta ~= nil and _meta._NAME ~= nil) then

    return _meta._NAME;

  else

    return _type;

  end

end

local function string(o)

  return '"' .. tostring(o) .. '"'

end

local function recurse(o, indent)

  if indent == nil then indent = '' end

  local indent2 = indent .. '  '

  if type(o) == 'table' then

    local s = indent .. '{' .. '\n'
    local first = true

    for k,v in pairs(o) do

      if first == false then s = s .. ', \n' end
      if type(k) ~= 'number' then k = string(k) end
      s = s .. indent2 .. '[' .. k .. '] = ' .. recurse(v, indent2)
      first = false

    end

    return s .. '\n' .. indent .. '}'

  else

    return string(o)

  end

end

local function var_dump(...)

  local args = {...}
  if #args > 1 then

    var_dump(args)

  else

    print(recurse(args[1]))

  end

end

max_requests = 0
counter = 1
show_body = 0

function setup(thread)

  thread:set("id", counter)
  counter = counter + 1

end

response = function (status, headers, body)

  file:write("\n----------------------------------------\n")
  file:write("Response " .. counter .. " with status: " .. status .. " on thread " .. id)
  file:write("\n----------------------------------------\n")

  file:write("[response] Headers:\n")

  for key, value in pairs(headers) do

    file:write("[response]  - " .. key  .. ": " .. value .. "\n")

  end

  if (show_body == 1) then

    file:write("[response] Body:\n")
    file:write(body .. "\n")

  end

  if (max_requests > 0) and (counter > max_requests) then

    wrk.thread:stop()

  end

  counter = counter + 1

end

done = function ()

  file:close()

end
```

Command:

```bash
wrk -c 12 -t 12 -d 15s -R 200 -s lua/debug.lua https://example.com
```

###### Analyse data pass to and from the threads

Based on:

- [wrk2 - setup](https://github.com/giltene/wrk2/blob/master/scripts/setup.lua)

```lua
-- lua/threads.lua

local counter = 1
local threads = {}

function setup(thread)

  thread:set("id", counter)
  table.insert(threads, thread)

  counter = counter + 1

end

function init(args)

  requests  = 0
  responses = 0

  -- local msg = "thread %d created"
  -- print(msg:format(id))

end

function request()

  requests = requests + 1
  return wrk.request()

end

function response(status, headers, body)

  responses = responses + 1

end

function done(summary, latency, requests)

  io.write("\n----------------------------------------\n")
  io.write(" Summary")
  io.write("\n----------------------------------------\n")

  for index, thread in ipairs(threads) do

    local id        = thread:get("id")
    local requests  = thread:get("requests")
    local responses = thread:get("responses")

    local msg = "thread %d : %d req , %d res"

    print(msg:format(id, requests, responses))

  end

end
```

Command:

```bash
wrk -c 12 -t 12 -d 5s -R 5000 -s lua/threads.lua https://example.com
```

###### Parsing wrk result and generate report

Installation:

```bash
go get -u github.com/jgsqware/wrk-report
```

Command:

```bash
wrk -c 12 -t 12 -d 15s -R 500 --latency https://example.com | wrk-report > report.html
```

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/reports/wrk-report-01.png" alt="wrk-report-01">
</p>

##### Load testing with locust

  > Project documentation: [Locust Documentation](https://docs.locust.io/en/stable/)

Installation:

```bash
# Python 2.x
python -m pip install locustio

# Python 3.x
python3 -m pip install locustio
```

About `locust`:

- `Number of users to simulate` - the number of users testing your application. Each user opens a TCP connection to your application and tests it.

- `Hatch rate (users spawned/second)` - for each second, how many users will be added to the current users until the total amount of users. Each hatch Locust calls the `on_start` function if you have.

For example:

- Number of users: 1000
- Hatch rate: 10

Each second 10 users added to current users starting from 0 so in 100 seconds you will have 1000 users. When it reaches to the number of users, the statistic will be reset.

Locust tries to emulate user behavior, it will pause each individual 'User' between `min_wait` and `max_wait` ms, to simulate the time between normal user actions.

  > Each of tasks will be executed in a random order, with a delay of `min_wait` and `max_wait` between the beginning of each task.

###### Multiple paths

```python
# python/multi-paths.py

import urllib3

from locust import HttpLocust, TaskSet, task

urllib3.disable_warnings()

multiheaders = """{
"Host": "example.com",
"User-Agent":"python-locust-test",
}
"""

self.client.get("/", headers=h)

def on_start(self):
  self.client.verify = False

class UserBehavior(TaskSet):

  @task
  class NonLoggedUserBehavior(TaskSet):

    # Home page
    @task(1)
    def index(self):
      self.client.get("/", headers=multiheaders, verify=False)

    # Status
    @task(1)
    def status(self):
      self.client.get("/status", verify=False)

    # Article
    @task(1)
    def article(self):
      self.client.get("/article/1044162375/", headers=multiheaders, verify=False)

    # About
    # Twice as much of requests:
    @task(2)
    def about(self):
      with self.client.get("/about", catch_response=True) as response:
        if response.text.find("author@example.com") > 0:
          response.success()
        else:
          response.failure("author@example.com not found in response")

class WebsiteUser(HttpLocust):

  task_set = UserBehavior
  min_wait = 1000 # ms, 1s
  max_wait = 5000 # ms, 5s
```

Command:

```bash
# Without web interface:
locust --host=https://example.com -f python/multi-paths.py -c 2000 -r 10 -t 1h 30m --no-web --print-stats --only-summary

# With web interface
locust --host=https://example.com -f python/multi-paths.py --print-stats --only-summary
```

###### Multiple paths with different user sessions

Look also:

- [How to Run Locust with Different Users](https://www.blazemeter.com/blog/how-to-run-locust-with-different-users/)

Create a file with user credentials:

```python
# python/credentials.py

USER_CREDENTIALS = [

  ("user5", "ShaePhu8aen8"),
  ("user4", "Cei5ohcha3he"),
  ("user3", "iedie8booChu"),
  ("user2", "iCuo4es1ahzu"),
  ("user1", "eeSh0yi0woo8")

  # ...

]
```

```python
# python/diff-users.py

import urllib3, logging, sys

from locust import HttpLocust, TaskSet, task
from credentials import USER_CREDENTIALS

urllib3.disable_warnings()

class UserBehavior(TaskSet):

  @task
  class LoggedUserBehavior(TaskSet):

    username = "default"
    password = "default"

    def on_start(self):
      if len(USER_CREDENTIALS) > 0:
        self.username, self.password = USER_CREDENTIALS.pop()

      self.client.post("/login", {
        'username': self.username, 'password': self.password
      })
      logging.info('username: %s, password: %s', self.username, self.password)

    def on_stop(self):
      self.client.post("/logout", verify=False)

    # Home page
    # 10x more often than other
    @task(10)
    def index(self):
      self.client.get("/", verify=False)

    # Enter specific url after client login
    @task(1)
    def random_gen(self):
      self.client.get("/random-generator", verify=False)

    # Client profile page
    @task(1)
    def profile(self):
      self.client.get("/profile", verify=False)

    # Contact page
    @task(1)
    def contact(self):
      self.client.post("/contact", {
        "email": "no-reply@example.com",
        "subject": "GNU/Linux and BSD",
        "message": "Free software, Yeah!"
      })

class WebsiteUser(HttpLocust):

  host = "https://api.example.com"
  task_set = UserBehavior
  min_wait = 2000   # ms, 2s
  max_wait = 15000  # ms, 15s
```

Command:

```bash
# Without web interface (for 5 users, see credentials.py):
locust -f python/diff-users.py -c 5 -r 5 -t 30m --no-web --print-stats --only-summary

# With web interface (for 5 users, see credentials.py)
locust -f python/diff-users.py --print-stats --only-summary
```

###### TCP SYN flood Denial of Service attack

```bash
hping3 -V -c 1000000 -d 120 -S -w 64 -p 80 --flood --rand-source <remote_host>
```

###### HTTP Denial of Service attack

```bash
# 1)
slowhttptest -g -o http_dos.stats -H -c 1000 -i 15 -r 200 -t GET -x 24 -p 3 -u <scheme>://<server_name>/index.php

slowhttptest -g -o http_dos.stats -B -c 5000 -i 5 -r 200 -t POST -l 180 -x 5 -u <scheme>://<server_name>/service/login

# 2)
pip3 install slowloris
slowloris <server_name>

# 3)
git clone https://github.com/jseidl/GoldenEye && cd GoldenEye
./goldeneye.py <scheme>://<server_name> -w 150 -s 75 -m GET
```

#### Debugging

  > You can change combinations and parameters of these commands. When carrying out the analysis, remember about [debug log](#beginner-use-debug-mode-for-debugging) and [log formats](#beginner-use-custom-log-formats-for-debugging).

##### Show information about processes

with `ps`:

```bash
# For all processes (master + workers):
ps axw -o pid,ppid,gid,user,etime,%cpu,%mem,vsz,rss,wchan,ni,command | egrep '([n]ginx|[P]ID)'

ps aux | grep [n]ginx
ps -lfC nginx

# For master process:
ps axw -o pid,ppid,gid,user,etime,%cpu,%mem,vsz,rss,wchan,ni,command | egrep '([n]ginx: master|[P]ID)'

ps aux | grep "[n]ginx: master"

# For worker/workers:
ps axw -o pid,ppid,gid,user,etime,%cpu,%mem,vsz,rss,wchan,ni,command | egrep '([n]ginx: worker|[P]ID)'

ps aux | grep "[n]ginx: worker"

# Show only pid, user and group for all NGINX processes:
ps -eo pid,comm,euser,supgrp | grep nginx
```

with `top`:

```bash
# For all processes (master + workers):
top -p $(pgrep -d , nginx)

# For master process:
top -p $(pgrep -f "nginx: master")
top -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: master") { print $1}')

# For one worker:
top -p $(pgrep -f "nginx: worker")
top -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: worker") { print $1}')

# For multiple workers:
top -p $(pgrep -f "nginx: worker" | sed '$!s/$/,/' | tr -d '\n')
top -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: worker") { print $1}' | sed '$!s/$/,/' | tr -d '\n')
```

##### Check memory usage

with `ps_mem`:

```bash
# For all processes (master + workers):
ps_mem -s -p $(pgrep -d , nginx)
ps_mem -d -p $(pgrep -d , nginx)

# For master process:
ps_mem -s -p $(pgrep -f "nginx: master")
ps_mem -s -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: master") { print $1}')

# For one worker:
ps_mem -s -p $(pgrep -f "nginx: worker")
ps_mem -s -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: worker") { print $1}')

# For multiple workers:
ps_mem -s -p $(pgrep -f "nginx: worker" | sed '$!s/$/,/' | tr -d '\n')
ps_mem -s -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: worker") { print $1}' | sed '$!s/$/,/' | tr -d '\n')
```

with `pmap`:

```bash
# For all processes (master + workers):
pmap $(pgrep -d ' ' nginx)
pmap $(pidof nginx)

# For master process:
pmap $(pgrep -f "nginx: master")
pmap $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: master") { print $1}')

# For one and multiple workers:
pmap $(pgrep -f "nginx: worker")
pmap $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: worker") { print $1}')
```

##### Show open files

```bash
# For all processes (master + workers):
lsof -n -p $(pgrep -d , nginx)

# For master process:
lsof -n -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: master") { print $1}')

# For one worker:
lsof -n -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: worker") { print $1}')

# For multiple workers:
lsof -n -p $(ps axw -o pid,command | awk '($2 " " $3 ~ "nginx: worker") { print $1}' | sed '$!s/$/,/' | tr -d '\n')
```

##### Dump configuration

From a configuration file and all attached files (from a disk, only what a new process would load):

```bash
nginx -T
nginx -T -c /etc/nginx/nginx.conf
```

From a running process:

  > For more information please see [GNU Debugger (gdb) - Dump configuration from a running process](#dump-configuration-from-a-running-process).

##### Get the list of configure arguments

```bash
nginx -V 2>&1 | grep arguments
```

##### Check if the module has been compiled

```bash
nginx -V 2>&1 | grep -- 'http_geoip_module'
```

##### Show the most accessed IP addresses

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s%20s\n%10s%20s\n' "AMOUNT" "IP_ADDRESS"
awk '{print $1}' access.log | sort | uniq -c | sort -nr
```

##### Show the top 5 visitors (IP addresses)

```bash
# - add this to the end for print header:
#   ... | xargs printf '%10s%10s%20s\n%10s%10s%20s\n' "NUM" "AMOUNT" "IP_ADDRESS"
cut -d ' ' -f1 access.log | sort | uniq -c | sort -nr | head -5 | nl
```

##### Show the most requested urls

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "URL"
awk -F\" '{print $2}' access.log | awk '{print $2}' | sort | uniq -c | sort -nr
```

##### Show the most requested urls containing 'string'

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "URL"
awk -F\" '($2 ~ "/string") { print $2}' access.log | awk '{print $2}' | sort | uniq -c | sort -nr
```

##### Show the most requested urls with http methods

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s %8s\t%s\n%10s %8s\t%s\n' "AMOUNT" "METHOD" "URL"
awk -F\" '{print $2}' access.log | awk '{print $1 "\t" $2}' | sort | uniq -c | sort -nr
```

##### Show the most accessed response codes

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "HTTP_CODE"
awk '{print $9}' access.log | sort | uniq -c | sort -nr
```

##### Analyse web server log and show only 2xx http codes

```bash
tail -n 100 -f access.log | grep "HTTP/[1-2].[0-1]\" [2]"
```

##### Analyse web server log and show only 5xx http codes

```bash
tail -n 100 -f access.log | grep "HTTP/[1-2].[0-1]\" [5]"
```

##### Show requests which result 502 and sort them by number per requests by url

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "URL"
awk '($9 ~ /502/)' access.log | awk '{print $7}' | sort | uniq -c | sort -nr
```

##### Show requests which result 404 for php files and sort them by number per requests by url

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "URL"
awk '($9 ~ /401/)' access.log | awk -F\" '($2 ~ "/*.php")' | awk '{print $7}' | sort | uniq -c | sort -nr
```

##### Calculating amount of http response codes

```bash
# Not less than 1 minute:
tail -2000 access.log | awk -v date=$(date -d '1 minutes ago' +"%d/%b/%Y:%H:%M") '$4 ~ date' | cut -d '"' -f3 | cut -d ' ' -f2 | sort | uniq -c | sort -nr

# Last 2000 requests from log file:
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "HTTP_CODE"
tail -2000 access.log | cut -d '"' -f3 | cut -d ' ' -f2 | sort | uniq -c | sort -nr
```

##### Calculating requests per second

```bash
# In real time:
tail -F access.log | pv -lr >/dev/null

# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s%24s%18s\n%10s%24s%18s\n' "AMOUNT" "DATE" "IP_ADDRESS"
awk '{print $4}' access.log | uniq -c | sort -nr | tr -d "["
```

##### Calculating requests per second with IP addresses

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s%24s%18s\n%10s%24s%18s\n' "AMOUNT" "DATE" "IP_ADDRESS"
awk '{print $4 " " $1}' access.log | uniq -c | sort -nr | tr -d "["
```

##### Calculating requests per second with IP addresses and urls

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s%24s%18s\t%s\n%10s%24s%18s\t%s\n' "AMOUNT" "DATE" "IP_ADDRESS" "URL"
awk '{print $4 " " $1 " " $7}' access.log | uniq -c | sort -nr | tr -d "["
```

##### Get entries within last n hours

```bash
awk -v _date=`date -d 'now-6 hours' +[%d/%b/%Y:%H:%M:%S` ' { if ($4 > _date) print $0}' access.log

# date command shows output for specific locale, for prevent this you should set LANG variable:
awk -v _date=$(LANG=en_us.utf-8 date -d 'now-6 hours' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _date) print $0}' access.log

# or:
export LANG=en_us.utf-8
awk -v _date=$(date -d 'now-6 hours' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _date) print $0}' access.log
```

##### Get entries between two timestamps (range of dates)

```bash
# 1)
awk '$4>"[05/Feb/2019:02:10" && $4<"[15/Feb/2019:08:20"' access.log

# 2)
# date command shows output for specific locale, for prevent this you should set LANG variable:
awk -v _dateB=$(LANG=en_us.utf-8 date -d '10:20' +[%d/%b/%Y:%H:%M:%S) -v _dateE=$(LANG=en_us.utf-8 date -d '20:30' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _dateB && $4 < _dateE) print $0}' access.log

# or:
export LANG=en_us.utf-8
awk -v _dateB=$(date -d '10:20' +[%d/%b/%Y:%H:%M:%S) -v _dateE=$(date -d '20:30' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _dateB && $4 < _dateE) print $0}' access.log

# 3)
# date command shows output for specific locale, for prevent this you should set LANG variable:
awk -v _dateB=$(LANG=en_us.utf-8 date -d 'now-12 hours' +[%d/%b/%Y:%H:%M:%S) -v _dateE=$(LANG=en_us.utf-8 date -d 'now-2 hours' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _dateB && $4 < _dateE) print $0}' access.log

# or:
export LANG=en_us.utf-8
awk -v _dateB=$(date -d 'now-12 hours' +[%d/%b/%Y:%H:%M:%S) -v _dateE=$(date -d 'now-2 hours' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _dateB && $4 < _dateE) print $0}' access.log
```

##### Get line rates from web server log

```bash
tail -F access.log | pv -N RAW -lc 1>/dev/null
```

##### Trace network traffic for all processes

```bash
strace -q -e trace=network -p `pidof nginx | sed -e 's/ /,/g'`
```

##### List all files accessed by a NGINX

```bash
strace -q -ff -e trace=file nginx 2>&1 | perl -ne 's/^[^"]+"(([^\\"]|\\[\\"nt])*)".*/$1/ && print'
```

##### Check that the `gzip_static` module is working

```bash
strace -q -p `pidof nginx | sed -e 's/ /,/g'` 2>&1 | grep gz
```

##### Which worker processing current request

Example 1 (more elegant way):

```bash
log_format debug-req-trace
                '$pid - "$request_method $scheme://$host$request_uri" '
                '$remote_addr:$remote_port $server_addr:$server_port '
                '$request_id';

# Output example:
31863 - "GET https://example.com/" 35.228.233.xxx:63784 10.240.20.2:443 be90154db5beb0e9dd13c5d91c8ecd4c
```

Example 2:

```bash
# Run strace in the background:
nohup strace -q -s 256 -p `pidof nginx | sed -e 's/ /,/g'` 2>&1 -o /tmp/nginx-req.trace </dev/null >/dev/null 2>/dev/null &

# Watch output file:
watch -n 0.1 "awk '/Host:/ {print \"pid: \" \$1 \", \" \"host: \" \$6}' /tmp/nginx-req.trace | sed 's/\\\r\\\n.*//'"

# Output example:
Every 0.1s: awk '/Host:/ {print "pid: " $1 ", " "host: " $6}' /tmp/nginx-req.trace | sed 's/\\r\\n.*//'

pid: 31863, host: example.com
```

##### Capture only http packets

```bash
ngrep -d eth0 -qt 'HTTP' 'tcp'
```

##### Extract User Agent from the http packets

```bash
tcpdump -ei eth0 -nn -A -s1500 -l | grep "User-Agent:"
```

##### Capture only http GET and POST packets

```bash
# 1)
tcpdump -ei eth0 -s 0 -A -vv \
'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420' or 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504f5354'

# 2)
tcpdump -ei eth0 -s 0 -v -n -l | egrep -i "POST /|GET /|Host:"
```

##### Capture requests and filter by source ip and destination port

```bash
ngrep -d eth0 "<server_name>" src host 10.10.252.1 and dst port 80
```

##### Dump a process's memory

  > For more information about analyse core dumps please see [GNU Debugger (gdb) - Core dump backtrace](#core-dump-backtrace).

A core dump is a file containing a process's address space (memory) when the process terminates unexpectedly. In other words is an instantaneous picture of a failing process at the moment it attempts to do something very wrong.

NGINX is unbelievably stable but sometimes it can happen that there is a unique termination of the running processes.

I think the best practice for core dumps are a properly collected core files, and associated information, we can often solve, and otherwise extract valuable information about the failing process.

To enable core dumps from NGINX configuration you should:

```bash
# In the main NGINX configuration file:
#   - specify the maximum possible size of the core dump for worker processes
#   - specify the maximum number of open files for worker processes
#   - specify a working directory in which a core dump file will be saved
#   - enable global debugging (optional)
worker_rlimit_core    500m;
worker_rlimit_nofile  65535;
working_directory     /var/dump/nginx;
error_log             /var/log/nginx/error.log debug;

# Make sure the /var/dump/nginx directory is writable:
chown nginx:nginx /var/dump/nginx
chmod 0770 /var/dump/nginx

# Disable the limit for the maximum size of a core dump file:
ulimit -c unlimited
# or:
sh -c "ulimit -c unlimited && exec su $LOGNAME"

# Enable core dumps for the setuid and setgid processes:
#   %e.%p.%h.%t - <executable_filename>.<pid>.<hostname>.<unix_time>
echo "/var/dump/nginx/core.%e.%p.%h.%t" | tee /proc/sys/kernel/core_pattern
sysctl -w fs.suid_dumpable=2 && sysctl -p
```

To generate a core dump of a running NGINX master process:

```bash
_pid=$(pgrep -f "nginx: master") ; gcore -o core.master $_pid
```

To generate a core dump of a running NGINX worker processes:

```bash
for _pid in $(pgrep -f "nginx: worker") ; do gcore -o core.worker $_pid ; done
```

Or other solution for above (to dump memory regions of running NGINX process):

```bash
# Set pid of NGINX master process:
_pid=$(pgrep -f "nginx: master")

# Generate gdb commands from the process's memory mappings using awk:
cat /proc/$_pid/maps | \
awk '$6 !~ "^/" {split ($1,addrs,"-"); print "dump memory mem_" addrs[1] " 0x" addrs[1] " 0x" addrs[2] ;}END{print "quit"}' > gdb.args

# Use gdb with the -x option to dump these memory regions to mem_* files:
gdb -p $_pid -x gdb.args

# Look for some (any) nginx.conf text:
grep -a worker_connections mem_*
grep -a server_name mem_*

# or:
strings mem_* | grep worker_connections
strings mem_* | grep server_name
```

##### GNU Debugger (gdb)

You can use GDB to extract very useful information about NGINX instances, e.g. the log from memory or configuration from running process.

###### Dump configuration from a running process

  > It's very useful when you need to verify which configuration has been loaded and restore a previous configuration if the version on disk has been accidentally removed or overwritten.

  > The `ngx_conf_t` is a type of a structure used for configuration parsing. It only exists during configuration parsing, and obviously you can't access it after configuration parsing is complete. For dump configuration from a running process you should use `ngx_conf_dump_t`.

```bash
# Save gdb arguments to a file, e.g. nginx.gdb:
set $cd = ngx_cycle->config_dump
set $nelts = $cd.nelts
set $elts = (ngx_conf_dump_t*)($cd.elts)
while ($nelts-- > 0)
  set $name = $elts[$nelts]->name.data
  printf "Dumping %s to nginx.conf.running\n", $name
append memory nginx.conf.running \
  $elts[$nelts]->buffer.start $elts[$nelts]->buffer.end
end

# Run gdb in a batch mode:
gdb -p $(pgrep -f "nginx: master") -batch -x nginx.gdb

# And open NGINX config:
less nginx.conf.running
```

or other solution:

```bash
# Save gdb functions to a file, e.g. nginx.gdb:
define dump_config
  set $cd = ngx_cycle->config_dump
  set $nelts = $cd.nelts
  set $elts = (ngx_conf_dump_t*)($cd.elts)
  while ($nelts-- > 0)
    set $name = $elts[$nelts]->name.data
    printf "Dumping %s to nginx.conf.running\n", $name
  append memory nginx.conf.running \
    $elts[$nelts]->buffer.start $elts[$nelts]->buffer.end
  end
end
document dump_config
  Dump NGINX configuration.
end

# Run gdb in a batch mode:
gdb -p $(pgrep -f "nginx: master") -iex "source nginx.gdb" -ex "dump_config" --batch

# And open NGINX config:
less nginx.conf.running
```

###### Show debug log in memory

First of all a buffer for debug logging should be enabled:

```bash
error_log   memory:64m debug;
```

and:

```bash
# Save gdb functions to a file, e.g. nginx.gdb:
define dump_debug_log
  set $log = ngx_cycle->log
  while ($log != 0) && ($log->writer != ngx_log_memory_writer)
    set $log = $log->next
  end
  if ($log->wdata != 0)
    set $buf = (ngx_log_memory_buf_t *) $log->wdata
    dump memory debug_mem.log $buf->start $buf->end
  end
end
document dump_debug_log
  Dump in memory debug log.
end

# Run gdb in a batch mode:
gdb -p $(pgrep -f "nginx: master") -iex "source nginx.gdb" -ex "dump_debug_log" --batch

# truncate the file:
sed -i 's/[[:space:]]*$//' debug_mem.log

# And open NGINX debug log:
less debug_mem.log
```

###### Core dump backtrace

  > The above functions ([GNU Debugger (gdb)](#gnu-debugger-gdb)) under discussion can be used with core files.

To backtrace core dumps which saved in `working_directory`:

```bash
gdb /usr/sbin/nginx /var/dump/nginx/core.nginx.8125.x-9s-web01-prod.1561475764
(gdb) bt
```

You can use also this recipe:

```bash
gdb --core /var/dump/nginx/core.nginx.8125.x-9s-web01-prod.1561475764
```

#### Shell aliases

```bash
alias ng.test='nginx -t -c /etc/nginx/nginx.conf'

alias ng.stop='ng.test && systemctl stop nginx'

alias ng.reload='ng.test && systemctl reload nginx'
alias ng.reload='ng.test && kill -HUP $(cat /var/run/nginx.pid)'
#                       ... kill -HUP $(ps auxw | grep [n]ginx | grep master | awk '{print $2}')

alias ng.restart='ng.test && systemctl restart nginx'
alias ng.restart='ng.test && kill -QUIT $(cat /var/run/nginx.pid) && /usr/sbin/nginx'
#                        ... kill -QUIT $(ps auxw | grep [n]ginx | grep master | awk '{print $2}') ...
```

#### Configuration snippets

##### Custom log formats

```bash
# Default main log format from the NGINX repository:
log_format main
                '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for"';

# Extended main log format:
log_format main-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent" '
                '$request_time';

# Debug log formats:
log_format debug-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" '
                '$request_completion';

log_format debug-level-1
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" $request_length '
                '$request_completion $connection $connection_requests '
                '"$http_user_agent"';

log_format debug-level-2
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" $request_length '
                '$request_completion $connection $connection_requests '
                '$remote_addr $remote_port $server_addr $server_port '
                '$http_x_forwarded_for "$http_referer" "$http_user_agent"';

# Debug log format for SSL:
log_format debug-ssl-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent" '
                '$request_time '
                '$tls_version $ssl_protocol $ssl_cipher';

# Log format for GeoIP module (ngx_http_geoip_module):
log_format geoip-level-0
                '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for" '
                '"$geoip_area_code $geoip_city_country_code $geoip_country_code"';
```

##### Restricting access with basic authentication

```bash
# 1) Generate file with htpasswd command:
htpasswd -c htpasswd_example.com.conf <username>

# 2) Include this file in specific context: (e.g. server):
server_name example.com;

  ...

  # These directives are optional, only if we need them:
  satisfy all;

  deny    10.255.10.0/24;
  allow   192.168.0.0/16;
  allow   127.0.0.1;
  deny    all;

  # It's important:
  auth_basic            "Restricted Area";
  auth_basic_user_file  /etc/nginx/acls/htpasswd_example.com.conf;

  location / {

    ...

  location /public/ {

    auth_basic off;

  }

  ...
```

##### Blocking/allowing IP addresses

Example 1:

```bash
# 1) File: /etc/nginx/acls/allow.map.conf

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

# 2) Include this file in http context:
include /etc/nginx/acls/allow.map.conf;

# 3) Turn on in a specific context (e.g. location):
server_name example.com;

  ...

  location / {

    proxy_pass http://localhost:80;
    client_max_body_size 10m;

  }

  location ~ ^/(backend|api|admin) {

    if ($globals_internal_map_acl) {

      set $pass 1;

    }

    if ($pass = 1) {

      proxy_pass http://localhost:80;
      client_max_body_size 10m;

    }

    if ($pass != 1) {

      rewrite ^(.*) https://example.com;

    }

  ...
```

Example 2:

```bash
# 1) File: /etc/nginx/acls/allow.geo.conf

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

# 2) Include this file in http context:
include /etc/nginx/acls/allow.geo.conf;

# 3) Turn on in a specific context (e.g. location):
server_name example.com;

  ...

  location / {

    proxy_pass http://localhost:80;
    client_max_body_size 10m;

  }

  location ~ ^/(backend|api|admin) {

    if ($globals_internal_geo_acl = 0) {

      return 403;

    }

    proxy_pass http://localhost:80;
    client_max_body_size 10m;

  ...
```

Example 3:

```bash
# 1) File: /etc/nginx/acls/allow.conf

### INTERNAL ###
allow 10.255.10.0/24;
allow 10.255.20.0/24;
allow 10.255.30.0/24;
allow 192.168.0.0/16;

### EXTERNAL ###
allow 35.228.233.xxx;

# 2) Include this file in http context:
include /etc/nginx/acls/allow.conf;

# 3) Turn on in a specific context (e.g. server):
server_name example.com;

  include /etc/nginx/acls/allow.conf;
  allow   35.228.233.xxx;
  deny    all;

  ...
```

##### Blocking referrer spam

Example 1:

```bash
# 1) File: /etc/nginx/limits.conf
map $http_referer $invalid_referer {

  hostnames;

  default                   0;

  # Invalid referrers:
  "invalid.com"             1;
  "~*spamdomain4.com"       1;
  "~*.invalid\.org"         1;

}

# 2) Include this file in http context:
include /etc/nginx/limits.conf;

# 3) Turn on in a specific context (e.g. server):
server_name example.com;

  if ($invalid_referer) { return 403; }

  ...
```

Example 2:

```bash
# 1) Turn on in a specific context (e.g. location):
location /check_status {

  if ($http_referer ~ "spam1\.com|spam2\.com|spam3\.com") {

    return 444;

  }

  ...
```

How to test?

```bash
siege -b -r 2 -c 40 -v https:/example.com/storage/img/header.jpg -H "Referer: https://spamdomain4.com/"
** SIEGE 4.0.4
** Preparing 5 concurrent users for battle.
The server is now under siege...
HTTP/1.1 403     0.11 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.12 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.18 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.18 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.19 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.10 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.11 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.11 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.12 secs:     124 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 403     0.12 secs:     124 bytes ==> GET  /storage/img/header.jpg

...
```

##### Limiting referrer spam

Example 1:

```bash
# 1) File: /etc/nginx/limits.conf
map $http_referer $limit_ip_key_by_referer {

  hostnames;

  # It's important because if you set numeric value, e.g. 0 rate limiting rule will be catch all referers:
  default                   "";

  # Invalid referrers (we restrict them):
  "invalid.com"             $binary_remote_addr;
  "~referer-xyz.com"        $binary_remote_addr;
  "~*spamdomain4.com"       $binary_remote_addr;
  "~*.invalid\.org"         $binary_remote_addr;

}

limit_req_zone $limit_ip_key_by_referer zone=req_for_remote_addr_by_referer:1m rate=5r/s;

# 2) Include this file in http context:
include /etc/nginx/limits.conf;

# 3) Turn on in a specific context (e.g. server):
server_name example.com;

  limit_req zone=req_for_remote_addr_by_referer burst=2;

  ...
```

How to test?

```bash
siege -b -r 2 -c 40 -v https:/example.com/storage/img/header.jpg -H "Referer: https://spamdomain4.com/"
** SIEGE 4.0.4
** Preparing 5 concurrent users for battle.
The server is now under siege...
HTTP/1.1 200     0.13 secs:    3174 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 503     0.14 secs:     206 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 503     0.15 secs:     206 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 503     0.10 secs:     206 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 503     0.10 secs:     206 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 503     0.10 secs:     206 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 200     0.63 secs:    3174 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 200     1.13 secs:    3174 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 200     1.00 secs:    3174 bytes ==> GET  /storage/img/header.jpg
HTTP/1.1 200     1.04 secs:    3174 bytes ==> GET  /storage/img/header.jpg

...
```

##### Limiting the rate of requests with burst mode

```bash
limit_req_zone $binary_remote_addr zone=req_for_remote_addr:64k rate=10r/m;
```

- key/zone type: `limit_req_zone`
- the unique key for limiter: `$binary_remote_addr`
  - limit requests per IP as following
- zone name: `req_for_remote_addr`
- zone size: `64k` (1024 IP addresses)
- rate is `0,16` request each second or `10` requests per minute (`1` request every `6` second)

Example of use:

```bash
location ~ /stats {

  limit_req zone=req_for_remote_addr burst=5;

  ...
```

- set maximum requests as `rate` * `burst` in `burst` seconds
  - with bursts not exceeding `5` requests:
    + `0,16r/s` * `5` = `0.80` requests per `5` seconds
    + `10r/m` * `5` = `50` requests per `5` minutes

Testing queue:

```bash
# siege -b -r 1 -c 12 -v https://x409.info/stats/
** SIEGE 4.0.4
** Preparing 12 concurrent users for battle.
The server is now under siege...
HTTP/1.1 200 *   0.20 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 503     0.20 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.20 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.21 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.22 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.22 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.23 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 200 *   6.22 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *  12.24 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *  18.27 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *  24.30 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *  30.32 secs:       2 bytes ==> GET  /stats/
             |
             - burst=5
             - 0,16r/s, 10r/m - 1r every 6 seconds

Transactions:              6 hits
Availability:          50.00 %
Elapsed time:          30.32 secs
Data transferred:       0.01 MB
Response time:         15.47 secs
Transaction rate:       0.20 trans/sec
Throughput:             0.00 MB/sec
Concurrency:            3.06
Successful transactions:   6
Failed transactions:       6
Longest transaction:   30.32
Shortest transaction:   0.20
```

##### Limiting the rate of requests with burst mode and nodelay

```bash
limit_req_zone $binary_remote_addr zone=req_for_remote_addr:50m rate=2r/s;
```

- key/zone type: `limit_req_zone`
- the unique key for limiter: `$binary_remote_addr`
  - limit requests per IP as following
- zone name: `req_for_remote_addr`
- zone size: `50m` (800,000 IP addresses)
- rate is `2` request each second or `120` requests per minute (`2` requests every `1` second)

Example of use:

```bash
location ~ /stats {

  limit_req zone=req_for_remote_addr burst=5 nodelay;

  ...
```

- set maximum requests as `rate` * `burst` in `burst` seconds
  - with bursts not exceeding `5` requests
    + `2r/s` * `5` = `10` requests per `5` seconds
    + `120r/m` * `5` = `600` requests per `5` minutes
- allocates slots in the queue according to the `burst` parameter with `nodelay`

Testing queue:

```bash
# siege -b -r 1 -c 12 -v https://x409.info/stats/
** SIEGE 4.0.4
** Preparing 12 concurrent users for battle.
The server is now under siege...
HTTP/1.1 200 *   0.18 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *   0.18 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *   0.19 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *   0.19 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *   0.19 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 200 *   0.19 secs:       2 bytes ==> GET  /stats/
HTTP/1.1 503     0.19 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.19 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.20 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.21 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.21 secs:    1501 bytes ==> GET  /stats/
HTTP/1.1 503     0.22 secs:    1501 bytes ==> GET  /stats/
             |
             - burst=5 with nodelay
             - 2r/s, 120r/m - 1r every 0.5 second

Transactions:              6 hits
Availability:          50.00 %
Elapsed time:           0.23 secs
Data transferred:       0.01 MB
Response time:          0.39 secs
Transaction rate:      26.09 trans/sec
Throughput:             0.04 MB/sec
Concurrency:           10.17
Successful transactions:   6
Failed transactions:       6
Longest transaction:    0.22
Shortest transaction:   0.18
```

##### Limiting the number of connections

```bash
limit_conn_zone $binary_remote_addr zone=conn_for_remote_addr:1m;
```

- key/zone type: `limit_conn_zone`
- the unique key for limiter: `$binary_remote_addr`
  - limit requests per IP as following
- zone name: `conn_for_remote_addr`
- zone size: `1m` (16,000 IP addresses)

Example of use:

```bash
location ~ /stats {

  limit_conn conn_for_remote_addr 1;

  ...
```

- limit a single IP address to make no more than `1` connection from IP at the same time

Testing queue:

```bash
# siege -b -r 1 -c 100 -t 10s --no-parser https://x409.info/stats/
defaulting to time-based testing: 10 seconds
** SIEGE 4.0.4
** Preparing 100 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:            364 hits
Availability:          32.13 %
Elapsed time:           9.00 secs
Data transferred:       1.10 MB
Response time:          2.37 secs
Transaction rate:      40.44 trans/sec
Throughput:             0.12 MB/sec
Concurrency:           95.67
Successful transactions: 364
Failed transactions:     769
Longest transaction:    1.10
Shortest transaction:   0.38
```

##### Adding and removing the `www` prefix

- `www` to `non-www`:

```bash
server {

  ...

  server_name www.domain.com;

  # $scheme will get the http or https protocol:
  return 301 $scheme://domain.com$request_uri;

}
```

- `non-www` to `www`:

```bash
server {

  ...

  server_name domain.com;

  # $scheme will get the http or https protocol:
  return 301 $scheme://www.domain.com$request_uri;

}
```

##### Redirect POST request with payload to external endpoint

**POST** data is passed in the body of the request, which gets dropped if you do a standard redirect.

Look at this:

| <b>DESCRIPTION</b> | <b>PERMANENT</b> | <b>TEMPORARY</b> |
| :---         | :---         | :---         |
| allows changing the request method from POST to GET | 301 | 302 |
| does not allow changing the request method from POST to GET | 308 | 307 |

You can try with the HTTP status code 307, a RFC compliant browser should repeat the post request. You just need to write a NGINX rewrite rule with HTTP status code 307 or 308:

```bash
location /api {

  # HTTP 307 only for POST requests:
  if ($request_method = POST) {

    return 307 https://api.example.com?request_uri;

  }

  # You can keep this for non-POST requests:
  rewrite ^ https://api.example.com?request_uri permanent;

  client_max_body_size    10m;

  ...

}
```

##### Allow multiple cross-domains using the CORS headers

Example 1:

```bash
location ~* \.(?:ttf|ttc|otf|eot|woff|woff2)$ {

  if ( $http_origin ~* (https?://(.+\.)?(domain1|domain2|domain3)\.(?:me|co|com)$) ) {

    add_header "Access-Control-Allow-Origin" "$http_origin";

  }

}
```

Example 2 (more slightly configuration; for GETs and POSTs):

```bash
location / {

  if ($http_origin ~* (^https?://([^/]+\.)*(domainone|domaintwo)\.com$)) {

    set $cors "true";

  }

  # Determine the HTTP request method used:
  if ($request_method = 'GET') {

    set $cors "${cors}get";

  }

  if ($request_method = 'POST') {

    set $cors "${cors}post";

  }

  if ($cors = "true") {

    # Catch all in case there's a request method we're not dealing with properly:
    add_header 'Access-Control-Allow-Origin' "$http_origin";

  }

  if ($cors = "trueget") {

    add_header 'Access-Control-Allow-Origin' "$http_origin";
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';

  }

  if ($cors = "truepost") {

    add_header 'Access-Control-Allow-Origin' "$http_origin";
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';

  }

}
```

##### Set correct scheme passed in X-Forwarded-Proto

```bash
# Sets a $real_scheme variable whose value is the scheme passed by the load
# balancer in X-Forwarded-Proto (if any), defaulting to $scheme.
# Similar to how the HttpRealIp module treats X-Forwarded-For.
map $http_x_forwarded_proto $real_scheme {

  default $http_x_forwarded_proto;
  ''      $scheme;

}
```

#### Other snippets

###### Create a temporary static backend

Python 3.x:

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

Python 2.x:

```bash
python -m SimpleHTTPServer 8000
```

###### Create a temporary static backend with SSL support

Python 3.x:

```bash
from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl

httpd = HTTPServer(('localhost', 4443), BaseHTTPRequestHandler)

httpd.socket = ssl.wrap_socket (httpd.socket,
        keyfile="path/to/key.pem",
        certfile='path/to/cert.pem', server_side=True)

httpd.serve_forever()
```

Python 2.x:

```bash
import BaseHTTPServer, SimpleHTTPServer
import ssl

httpd = BaseHTTPServer.HTTPServer(('localhost', 4443),
        SimpleHTTPServer.SimpleHTTPRequestHandler)

httpd.socket = ssl.wrap_socket (httpd.socket,
        keyfile="path/tp/key.pem",
        certfile='path/to/cert.pem', server_side=True)

httpd.serve_forever()
```

###### Generate private key without passphrase

```bash
# _len: 2048, 4096
( _fd="private.key" ; _len="4096" ; \
openssl genrsa -out ${_fd} ${_len} )
```

###### Generate CSR

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; \
openssl req -out ${_fd_csr} -new -key ${_fd} )
```

###### Generate CSR (metadata from existing certificate)

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; _fd_crt="cert.crt" ; \
openssl x509 -x509toreq -in ${_fd_crt} -out ${_fd_csr} -signkey ${_fd} )
```

###### Generate CSR with -config param

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; \
openssl req -new -sha256 -key ${_fd} -out ${_fd_csr} \
-config <(
cat <<-EOF
[req]
default_bits        = 2048
default_md          = sha256
prompt              = no
distinguished_name  = dn
req_extensions      = req_ext

[ dn ]
C   = "<two-letter ISO abbreviation for your country>"
ST  = "<state or province where your organisation is legally located>"
L   = "<city where your organisation is legally located>"
O   = "<legal name of your organisation>"
OU  = "<section of the organisation>"
CN  = "<fully qualified domain name>"

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = <fully qualified domain name>
DNS.2 = <next domain>
DNS.3 = <next domain>
EOF
))
```

Other values in `[ dn ]`:

  > Look at this great explanation: [How to create multidomain certificates using config files](https://apfelboymchen.net/gnu/notes/openssl%20multidomain%20with%20config%20files.html)

```
countryName            = "DE"                     # C=
stateOrProvinceName    = "Hessen"                 # ST=
localityName           = "Keller"                 # L=
postalCode             = "424242"                 # L/postalcode=
streetAddress          = "Crater 1621"            # L/street=
organizationName       = "apfelboymschule"        # O=
organizationalUnitName = "IT Department"          # OU=
commonName             = "example.com"            # CN=
emailAddress           = "webmaster@example.com"  # CN/emailAddress=
```

###### Generate private key and CSR

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; _len="4096" ; \
openssl req -out ${_fd_csr} -new -newkey rsa:${_len} -nodes -keyout ${_fd} )
```

###### Generate ECDSA private key

```bash
# _curve: prime256v1, secp521r1, secp384r1
( _fd="private.key" ; _curve="prime256v1" ; \
openssl ecparam -out ${_fd} -name ${_curve} -genkey )

# _curve: X25519
( _fd="private.key" ; _curve="x25519" ; \
openssl genpkey -algorithm ${_curve} -out ${_fd} )
```

###### Generate private key with CSR (ECC)

```bash
# _curve: prime256v1, secp521r1, secp384r1
( _fd="domain.com.key" ; _fd_csr="domain.com.csr" ; _curve="prime256v1" ; \
openssl ecparam -out ${_fd} -name ${_curve} -genkey ; \
openssl req -new -key ${_fd} -out ${_fd_csr} -sha256 )
```

###### Generate self-signed certificate

```bash
# _len: 2048, 4096
( _fd="domain.key" ; _fd_out="domain.crt" ; _len="4096" ; _days="365" ; \
openssl req -newkey rsa:${_len} -nodes \
-keyout ${_fd} -x509 -days ${_days} -out ${_fd_out} )
```

###### Generate self-signed certificate from existing private key

```bash
# _len: 2048, 4096
( _fd="domain.key" ; _fd_out="domain.crt" ; _days="365" ; \
openssl req -key ${_fd} -nodes \
-x509 -days ${_days} -out ${_fd_out} )
```

###### Generate self-signed certificate from existing private key and csr

```bash
# _len: 2048, 4096
( _fd="domain.key" ; _fd_csr="domain.csr" ; _fd_out="domain.crt" ; _days="365" ; \
openssl x509 -signkey ${_fd} -nodes \
-in ${_fd_csr} -req -days ${_days} -out ${_fd_out} )
```

###### Generate multidomain certificate

```bash
certbot certonly -d example.com -d www.example.com
```

###### Generate wildcard certificate

```bash
certbot certonly --manual --preferred-challenges=dns -d example.com -d *.example.com
```

###### Generate certificate with 4096 bit private key

```bash
certbot certonly -d example.com -d www.example.com --rsa-key-size 4096
```

###### Generate DH Param key

```bash
openssl dhparam -out /etc/nginx/ssl/dhparam_4096.pem 4096
```

###### Extract private key from pfx

```bash
( _fd_pfx="cert.pfx" ; _fd_key="key.pem" ; \
openssl pkcs12 -in ${_fd_pfx} -nocerts -nodes -out ${_fd_key} )
```

###### Extract private key and certs from pfx

```bash
( _fd_pfx="cert.pfx" ; _fd_pem="key_certs.pem" ; \
openssl pkcs12 -in ${_fd_pfx} -nodes -out ${_fd_pem} )
```

###### Convert DER to PEM

```bash
( _fd_der="cert.crt" ; _fd_pem="cert.pem" ; \
openssl x509 -in ${_fd_der} -inform der -outform pem -out ${_fd_pem} )
```

###### Convert PEM to DER

```bash
( _fd_der="cert.crt" ; _fd_pem="cert.pem" ; \
openssl x509 -in ${_fd_pem} -outform der -out ${_fd_der} )
```

###### Verification of the private key

```bash
( _fd="private.key" ; \
openssl rsa -noout -text -in ${_fd} )
```

###### Verification of the public key

```bash
# 1)
( _fd="public.key" ; \
openssl pkey -noout -text -pubin -in ${_fd} )

# 2)
( _fd="private.key" ; \
openssl rsa -inform PEM -noout -in ${_fd} &> /dev/null ; \
if [ $? = 0 ] ; then echo -en "OK\n" ; fi )
```

###### Verification of the certificate

```bash
( _fd="certificate.crt" ; # format: pem, cer, crt \
openssl x509 -noout -text -in ${_fd} )
```

###### Verification of the CSR

```bash
( _fd_csr="request.csr" ; \
openssl req -text -noout -in ${_fd_csr} )
```

###### Check whether the private key and the certificate match

```bash
(openssl rsa -noout -modulus -in private.key | openssl md5 ; \
openssl x509 -noout -modulus -in certificate.crt | openssl md5) | uniq
```

# Base Rules

These are the basic set of rules to keep NGINX in good condition.

#### :beginner: Organising Nginx configuration

###### Rationale

  > When your NGINX configuration grow, the need for organising your configuration will also grow. Well organised code is:
  >
  > - easier to understand
  > - easier to maintain
  > - easier to work with

  > Use `include` directive to move common server settings into a separate files and to attach your specific code to global config, contexts and other.

  > I always try to keep multiple directories in root of configuration tree. These directories stores all configuration files which are attached to the main file. I prefer following structure:
  >
  > - `html` - for default static files, e.g. global 5xx error page
  > - `master` - for main configuration, e.g. acls, listen directives, and domains
  >   - `_acls` - for access control lists, e.g. geo or map modules
  >   - `_basic` - for rate limiting rules, redirect maps, or proxy params
  >   - `_listen` - for all listen directives; also stores SSL configuration
  >   - `_server` - for domains (localhost) configuration; also stores all backends definitions
  > - `modules` - for modules which are dynamically loading into NGINX
  > - `snippets` - for NGINX aliases, configuration templates, e.g. logrotate
  >
  > I attach some of them, if necessary, to files which has `server` directives.

###### Example

```bash
# Store this configuration in https.conf for example:
listen 10.240.20.2:443 ssl;

ssl_certificate /etc/nginx/master/_server/example.com/certs/nginx_example.com_bundle.crt;
ssl_certificate_key /etc/nginx/master/_server/example.com/certs/example.com.key;

# Include this file to the server section:
server {

  include /etc/nginx/master/_listen/10.240.20.2/https.conf;

  # And other:
  include /etc/nginx/master/_static/errors.conf;
  include /etc/nginx/master/_server/_helpers/global.conf;

  ...

  server_name domain.com www.domain.com;

  ...
```

###### External resources

- [Organize your data and code](https://kbroman.org/steps2rr/pages/organize.html)

#### :beginner: Format, prettify and indent your Nginx code

###### Rationale

  > Work with unreadable configuration files is terrible, if syntax isn’t very readable, it makes your eyes sore, and you suffers from headaches.

  > When your code is formatted, it is significantly easier to maintain, debug, optimise, and can be read and understood in a short amount of time. You should eliminate code style violations from your NGINX configuration files.

  > Choose your formatter style and setup a common config for it. Some rules are universal, but the most important thing is to keep a consistent NGINX code style throughout your code base:
  >
  > - use whitespaces and blank lines to arrange and separate code blocks
  > - use tabs for indents - they are consistent, customizable and allow mistakes to be more noticeable (unless you are a 4 space kind of guy)
  > - use comments to explain why things are done not what is done
  > - use meaningful naming conventions
  > - simple is better than complex but complex is better than complicated

  > Some would say that NGINX's files are written in their own language or syntax so we should not overdo it with above rules. I think it's worth sticking to the general (programming) rules and make your and other NGINX adminstrators life easier.

###### Example

```bash
# Bad code style:
http {
  include    nginx/proxy.conf;
  include    /etc/nginx/fastcgi.conf;
  index    index.html index.htm index.php;

  default_type application/octet-stream;
  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log   logs/access.log    main;
  sendfile on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts

  ...

# Good code style:
http {

  # Attach global rules:
  include         /etc/nginx/proxy.conf;
  include         /etc/nginx/fastcgi.conf;

  index           index.html index.htm index.php;

  default_type    application/octet-stream;

  # Standard log format:
  log_format      main '$remote_addr - $remote_user [$time_local]  $status '
                       '"$request" $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';

  access_log      /var/log/nginx/access.log main;

  sendfile        on;
  tcp_nopush      on;

  # This seems to be required for some vhosts:
  server_names_hash_bucket_size 128;

  ...
```

###### External resources

- [Programming style](https://en.wikipedia.org/wiki/Programming_style)
- [Toward Developing Good Programming Style](https://www2.cs.arizona.edu/~mccann/style_c.html)
- [nginx-config-formatter](https://github.com/1connect/nginx-config-formatter)
- [Format and beautify nginx config files](https://github.com/vasilevich/nginxbeautifier)

#### :beginner: Use `reload` option to change configurations on the fly

###### Rationale

  > Use the `reload` option to achieve a graceful reload of the configuration without stopping the server and dropping any packets. This function of the master process allows to rolls back the changes and continues to work with stable and old working configuration.

  > This ability of NGINX is very critical in a high-uptime and dynamic environments for keeping the load balancer or standalone server online.

  > Master process checks the syntax validity of the new configuration and tries to apply all changes. If this procedure has been accomplished, the master process create new worker processes and sends shutdown messages to old. Old workers stops accepting new connections after received a shut down signal but current requests are still processing. After that, the old workers exit.

  > When you restart the NGINX service you might encounter situation in which NGINX will stop, and won't start back again, because of syntax error. Reload method is safer than restarting because before old process will be terminated, new configuration file is parsed and whole process is aborted if there are any problems with it.

  > To stop processes with waiting for the worker processes to finish serving current requests use `nginx -s quit` command. It's better than `nginx -s stop` for fast shutdown.

  From NGINX documentation:

  > _In order for NGINX to re-read the configuration file, a HUP signal should be sent to the master process. The master process first checks the syntax validity, then tries to apply new configuration, that is, to open log files and new listen sockets. If this fails, it rolls back changes and continues to work with old configuration. If this succeeds, it starts new worker processes, and sends messages to old worker processes requesting them to shut down gracefully. Old worker processes close listen sockets and continue to service old clients. After all clients are serviced, old worker processes are shut down._

###### Example

```bash
# 1)
systemctl reload nginx

# 2)
service nginx reload

# 3)
/etc/init.d/nginx reload

# 4)
/usr/sbin/nginx -s reload

# 5)
kill -HUP $(cat /var/run/nginx.pid)
# or
kill -HUP $(pgrep -f "nginx: master")

# 6)
/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
```

###### External resources

- [Changing Configuration](https://nginx.org/en/docs/control.html#reconfiguration)
- [Commands (from this handbook)](#commands)

#### :beginner: Separate `listen` directives for 80 and 443

###### Rationale

  > If you served HTTP and HTTPS with the exact same config (a single server that handles both HTTP and HTTPS requests) NGINX is intelligent enough to ignore the SSL directives if loaded over port 80.

  > I don't like duplicating the rules, but separate `listen` directives is certainly to help you maintain and modify your configuration.

  > It's useful if you pin multiple domains to one IP address. This allows you to attach one listen directive (e.g. if you keep it in the configuration file) to multiple domains configurations.

###### Example

```bash
# For HTTP:
server {

  listen 10.240.20.2:80;

  ...

}

# For HTTPS:
server {

  listen 10.240.20.2:443 ssl;

  ...

}
```

###### External resources

- [Understanding the Nginx Configuration File Structure and Configuration Contexts](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)
- [Configuring HTTPS servers](http://nginx.org/en/docs/http/configuring_https_servers.html)

#### :beginner: Define the `listen` directives explicitly with `address:port` pair

###### Rationale

  > NGINX translates all incomplete `listen` directives by substituting missing values with their default values.

  > And what's more, will only evaluate the `server_name` directive when it needs to distinguish between server blocks that match to the same level in the listen directive.

  > Set IP address and port number to prevents soft mistakes which may be difficult to debug.

###### Example

```bash
server {

  # This block will be processed:
  listen 192.168.252.10;  # --> 192.168.252.10:80

  ...

}

server {

  listen 80;  # --> *:80 --> 0.0.0.0:80
  server_name api.random.com;

  ...

}
```

###### External resources

- [Nginx HTTP Core Module - Listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen)
- [Understanding different values for nginx 'listen' directive](https://serverfault.com/questions/875140/understanding-different-values-for-nginx-listen-directive)

#### :beginner: Prevent processing requests with undefined server names

###### Rationale

  > NGINX should prevent processing requests with undefined server names (also on IP address). It protects against configuration errors, e.g. traffic forwarding to incorrect backends. The problem is easily solved by creating a default dummy vhost that catches all requests with unrecognized Host headers.

  > If none of the listen directives have the `default_server` parameter then the first server with the `address:port` pair will be the default server for this pair (it means that the NGINX always has a default server).

  > If someone makes a request using an IP address instead of a server name, the `Host` request header field will contain the IP address and the request can be handled using the IP address as the server name.

  > The server name `_` is not required in modern versions of NGINX. If a server with a matching listen and `server_name` cannot be found, NGINX will use the default server. If your configurations are spread across multiple files, there evaluation order will be ambiguous, so you need to mark the default server explicitly.

  > It is a simple procedure for all non defined server names:
  >
  > - one `server` block, with...
  > - complete `listen` directive, with...
  > - `default_server` parameter, with...
  > - only one `server_name` definition, and...
  > - preventively I add it at the beginning of the configuration

  > Also good point is `return 444;` for default server name because this will close the connection and log it internally, for any domain that isn't defined in NGINX.

###### Example

```bash
# Place it at the beginning of the configuration file to prevent mistakes:
server {

  # Add default_server to your listen directive in the server that you want to act as the default:
  listen 10.240.20.2:443 default_server ssl;

  # We catch:
  #   - invalid domain names
  #   - requests without the "Host" header
  #   - and all others (also due to the above setting)
  #   - default_server in server_name directive is not required - I add this for a better understanding and I think it's an unwritten standard
  # ...but you should know that it's irrelevant, really, you can put in everything there.
  server_name _ "" default_server;

  ...

  return 444;

  # We can also serve:
  # location / {

    # static file (error page):
    # root /etc/nginx/error-pages/404;
    # or redirect:
    # return 301 https://badssl.com;

    # return 444;

  # }

}

server {

  listen 10.240.20.2:443 ssl;

  server_name domain.com;

  ...

}

server {

  listen 10.240.20.2:443 ssl;

  server_name domain.org;

  ...

}
```

###### External resources

- [Server names](https://nginx.org/en/docs/http/server_names.html)
- [How processes a request](https://nginx.org/en/docs/http/request_processing.html)
- [nginx: how to specify a default server](https://blog.gahooa.com/2013/08/21/nginx-how-to-specify-a-default-server/)

#### :beginner: Never use a hostname in a listen or upstream directives

###### Rationale

  > Generaly, uses of hostnames in the listen or upstream directives is a bad practice.

  > In the worst case NGINX won't be able to bind to the desired TCP socket which will prevent NGINX from starting at all.

  > The best and safer way is to know the IP address that needs to be bound to and use that address instead of the hostname. This also prevents NGINX from needing to look up the address and removes dependencies on external and internal resolvers.

  > Uses of `$hostname` (the machine’s hostname) variable in the `server_name` directive is also example of bad practice (it's similar to use hostname label).

  > I believe it is also necessary to set IP address and port number pair to prevents soft mistakes which may be difficult to debug.

###### Example

Bad configuration:

```bash
upstream {

  server http://x-9s-web01-prod:8080;

}

server {

  listen rev-proxy-prod:80;

  ...

}
```

Good configuration:

```bash
upstream {

  server http://192.168.252.200:8080;

}

server {

  listen 10.10.100.20:80;

  ...

}
```

###### External resources

- [Using a Hostname to Resolve Addresses](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#using-a-hostname-to-resolve-addresses)
- [Define the listen directives explicitly with address:port pair (from this handbook)](#beginner-define-the-listen-directives-explicitly-with-addressport-pair)

#### :beginner: Use only one SSL config for the listen directive

###### Rationale

  > For sharing a single IP address between several HTTPS servers you should use one SSL config (e.g. protocols, ciphers, curves) because changes will affect only the default server.

  > Remember that regardless of SSL parameters you are able to use multiple SSL certificates on the same `listen` directive (IP address).

  > Another good idea is to move common server settings into a separate file, i.e. `common/example.com.conf` and then include it in separate `server` blocks.

  > If you want to set up different SSL configurations for the same IP address then it will fail. It's important because SSL configuration is presented for default server - if none of the listen directives have the `default_server` parameter then the first server in your configuration will be default server. So you should use only one SSL setup with several names on the same IP address. It's also to prevent mistakes and configuration mismatch.

  From NGINX documentation:

  > _This is caused by SSL protocol behaviour. The SSL connection is established before the browser sends an HTTP request and nginx does not know the name of the requested server. Therefore, it may only offer the default server’s certificate._

  Also take a look at this:

  > _A more generic solution for running several HTTPS servers on a single IP address is TLS Server Name Indication extension (SNI, RFC 6066), which allows a browser to pass a requested server name during the SSL handshake and, therefore, the server will know which certificate it should use for the connection._

###### Example

```bash
# Store this configuration in e.g. https.conf:
listen 192.168.252.10:443 default_server ssl http2;

ssl_protocols TLSv1.2;
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384";

ssl_prefer_server_ciphers on;

ssl_ecdh_curve secp521r1:secp384r1;

...

# Include this file to the server context (attach domain-a.com for specific listen directive):
server {

  include             /etc/nginx/https.conf;

  server_name         domain-a.com;

  ssl_certificate     domain-a.com.crt;
  ssl_certificate_key domain-a.com.key;

  ...

}

# Include this file to the server context (attach domain-b.com for specific listen directive):
server {

  include             /etc/nginx/https.conf;

  server_name         domain-b.com;

  ssl_certificate     domain-b.com.crt;
  ssl_certificate_key domain-b.com.key;

  ...

}
```

###### External resources

- [Nginx one ip and multiple ssl certificates](https://serverfault.com/questions/766831/nginx-one-ip-and-multiple-ssl-certificates)
- [Configuring HTTPS servers](http://nginx.org/en/docs/http/configuring_https_servers.html)

#### :beginner: Use geo/map modules instead of allow/deny

###### Rationale

  > Use `map` or `geo` modules (one of them) to prevent users abusing your servers. This allows to create variables with values depending on the client IP address.

  > Since variables are evaluated only when used, the mere existence of even a large number of declared e.g. geo variables does not cause any extra costs for request processing.

  > These directives provides the perfect way to block invalid visitors e.g. with `ngx_http_geoip_module`.

  > I use both modules for a large lists. You should've thought about it because this rule requires to use several `if` conditions. I think that `allow/deny` directives are better solution for simple lists, after all. Take a look at the example below:

```bash
# Allow/deny:
location /internal {

  include acls/internal.conf;
  allow   192.168.240.0/24;
  deny    all;

  ...

# vs geo/map:
location /internal {

  if ($globals_internal_map_acl) {
    set $pass 1;
  }

  if ($pass = 1) {
    proxy_pass http://localhost:80;
  }

  if ($pass != 1) {
    return 403;
  }

  ...

}
```

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
- [Blocking/allowing IP addresses (from this handbook)](#blockingallowing-ip-addresses)

#### :beginner: Map all the things...

###### Rationale

  > Manage a large number of redirects with maps and use them to customise your key-value pairs.

  > The map directive maps strings, so it is possible to represent e.g. `192.168.144.0/24` as a regular expression and continue to use the map directive.

  > Map module provides a more elegant solution for clearly parsing a big list of regexes, e.g. User-Agents, Referrers.

  > You can also use `include` directive for your maps so your config files would look pretty.

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

# Turn on in a specific context (e.g. location):
if ($device_redirect = "mobile") {

  return 301 https://m.domain.com$request_uri;

}
```

###### External resources

- [Module ngx_http_map_module](http://nginx.org/en/docs/http/ngx_http_map_module.html)
- [Cool Nginx feature of the week](https://www.ignoredbydinosaurs.com/posts/236-cool-nginx-feature-of-the-week)

#### :beginner: Set global root directory for unmatched locations

###### Rationale

  > Set global `root` inside server directive for requests. It specifies the root directory for undefined locations.

  From official documentation:

  > _If you add a root to every location block then a location block that isn’t matched will have no root. Therefore, it is important that a root directive occur prior to your location blocks, which can then override this directive if they need to._

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

#### :beginner: Use return directive for URL redirection (301, 302)

###### Rationale

  > It's a simple rule. You should use server blocks and `return` statements as they're way faster than evaluating RegEx.

  > It is simpler and faster because NGINX stops processing the request (and doesn't have to process a regular expressions).

###### Example

```bash
server {

  server_name www.example.com;

  # return    301 https://$host$request_uri;
  return      301 $scheme://www.example.com$request_uri;

}
```

###### External resources

- [Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)
- [How to do an Nginx redirect](https://bjornjohansen.no/nginx-redirect)
- [Adding and removing the www prefix (from this handbook)](#adding-and-removing-the-www-prefix)
- [Avoid checks server_name with if directive (from this handbook)](#beginner-avoid-checks-server_name-with-if-directive)

#### :beginner: Configure log rotation policy

###### Rationale

  > Log files gives you feedback about the activity and performance of the server as well as any problems that may be occurring. They are records details about requests and NGINX internals. Unfortunately, logs use more disk space.

  > You should define a process which periodically archiving the current log file and starting a new one, renames and optionally compresses the current log files, delete old log files, and force the logging system to begin using new log files.

  > I think the best tool for this is a `logrotate`. I use it everywhere if I want to manage logs automatically, and for a good night's sleep also. It is a simple program to rotate logs, uses crontab to work. It's scheduled work, not a daemon, so no need to reload its configuration.

###### Example

- for manually rotation:

  ```bash
  # Check manually (all log files):
  logrotate -dv /etc/logrotate.conf

  # Check manually with force rotation (specific log file):
  logrotate -dv --force /etc/logrotate.d/nginx
  ```

- for automate rotation:

  ```bash
  cat > /etc/logrotate.d/nginx << __EOF__
  /var/log/nginx/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 nginx nginx
    sharedscripts
    prerotate
      if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
        run-parts /etc/logrotate.d/httpd-prerotate; \
      fi \
    endscript
    postrotate
      # test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`
      invoke-rc.d nginx reload >/dev/null 2>&1
    endscript
  }

  /var/log/nginx/localhost/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 nginx nginx
    sharedscripts
    prerotate
      if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
        run-parts /etc/logrotate.d/httpd-prerotate; \
      fi \
    endscript
    postrotate
      # test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`
      invoke-rc.d nginx reload >/dev/null 2>&1
    endscript
  }

  /var/log/nginx/domains/example.com/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 nginx nginx
    sharedscripts
    prerotate
      if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
        run-parts /etc/logrotate.d/httpd-prerotate; \
      fi \
    endscript
    postrotate
      # test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`
      invoke-rc.d nginx reload >/dev/null 2>&1
    endscript
  }
  __EOF__
  ```

###### External resources

- [Understanding logrotate utility](https://support.rackspace.com/how-to/understanding-logrotate-utility/)
- [Rotating Linux Log Files - Part 2: Logrotate](http://www.ducea.com/2006/06/06/rotating-linux-log-files-part-2-logrotate/)
- [Managing Logs with Logrotate](https://serversforhackers.com/c/managing-logs-with-logrotate)
- [nginx and Logrotate](https://drumcoder.co.uk/blog/2012/feb/03/nginx-and-logrotate/)
- [nginx log rotation](https://wincent.com/wiki/nginx_log_rotation)

#### :beginner: Don't duplicate index directive, use it only in the http block

###### Rationale

  > Use the index directive one time. It only needs to occur in your `http` context and it will be inherited below.

  > I think we should be careful about duplicating the same rules. But, of course, rules duplication is sometimes okay or not necessarily a great evil.

###### Example

Bad configuration:

```bash
http {

  ...

  index index.php index.htm index.html;

  server {

    server_name www.example.com;

    location / {

      index index.php index.html index.$geo.html;

      ...

    }

  }

  server {

    server_name www.example.com;

    location / {

      index index.php index.htm index.html;

      ...

    }

    location /data {

      index index.php;

      ...

    }

    ...

}
```

Good configuration:

```bash
http {

  ...

  index index.php index.htm index.html index.$geo.html;

  server {

    server_name www.example.com;

    location / {

      ...

    }

  }

  server {

    server_name www.example.com;

    location / {

      ...

    }

    location /data {

      ...

    }

    ...

}
```

###### External resources

- [Pitfalls and Common Mistakes - Multiple Index Directives](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#multiple-index-directives)

# Debugging

NGINX has many methods for troubleshooting configuration problems. In this chapter I will present a few ways to deal with them.

#### :beginner: Use custom log formats

###### Rationale

  > Anything you can access as a variable in NGINX config, you can log, including non-standard http headers, etc. so it's a simple way to create your own log format for specific situations.

  > This is extremely helpful for debugging specific `location` directives.

###### Example

```bash
# Default main log format from the NGINX repository:
log_format main
                '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for"';

# Extended main log format:
log_format main-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent" '
                '$request_time';

# Debug log formats:
log_format debug-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" '
                '$request_completion';
```

###### External resources

- [Module ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html)
- [Nginx: Custom access log format and error levels](https://fabianlee.org/2017/02/14/nginx-custom-access-log-format-and-error-levels/)
- [nginx: Log complete request/response with all headers?](https://serverfault.com/questions/636790/nginx-log-complete-request-response-with-all-headers)
- [Custom log formats (from this handbook)](#custom-log-formats)

#### :beginner: Use debug mode to track down unexpected behaviour

###### Rationale

  > There's probably more detail than you want, but that can sometimes be a lifesaver (but log file growing rapidly on a very high-traffic sites).

  > Generally, the `error_log` directive is specified in the `main` context but you can specified inside a particular `server` or a `location` block, the global settings will be overridden and such `error_log` directive will set its own path to the log file and the level of logging.

  > It is possible to enable the debugging log for a particular IP address or a range of IP addresses (see examples).

  > The alternative method of storing the debug log is keep it in the memory (to a cyclic memory buffer). The memory buffer on the debug level does not have significant impact on performance even under high load.

  > If you want to logging of `ngx_http_rewrite_module` (at the `notice` level) you should enable `rewrite_log on;` in a `http`, `server`, or `location` contexts.

  > Words of caution:
  >
  >   - never leave debug logging to a file on in production
  >   - don't forget to revert debug-level for `error_log` on a very high traffic sites
  >   - absolutely use log rotation policy

###### Example

- Debugging log to a file:

```bash
# Turn on in a specific context, e.g.:
#   - global    - for global logging
#   - http      - for http and all locations logging
#   - location  - for specific location
error_log /var/log/nginx/error-debug.log debug;
```

- Debugging log to memory:

  ```bash
  error_log memory:32m debug;
  ```

  > You can read more about that in the [Show debug log in memory](#show-debug-log-in-memory) chapter.

- Debugging log for a IP address/range:

  ```bash
  events {

    debug_connection    192.168.252.15/32;
    debug_connection    10.10.10.0/24;

  }
  ```

- Debugging log for each server:

  ```bash
  error_log /var/log/nginx/debug.log debug;

  ...

  http {

    server {

      # To enable debugging:
      error_log /var/log/nginx/domain.com/domain.com-debug.log debug;
      # To disable debugging:
      error_log /var/log/nginx/domain.com/domain.com-debug.log;

      ...

    }

  }
  ```

###### External resources

- [A debugging log](https://nginx.org/en/docs/debugging_log.html)
- [A little note to all nginx admins there - debug log](https://www.reddit.com/r/sysadmin/comments/7bofyp/a_little_note_to_all_nginx_admins_there/)

#### :beginner: Disable daemon, master process, and all workers except one

###### Rationale

  > These directives with following values are mainly used during development and debugging, e.g. while testing a bug/feature.

  > `daemon off` and `master_process off` lets me test configurations rapidly.

  > For normal production the NGINX server will start in the background (`daemon on`). In this way NGINX and other services are running and talking to each other. One server runs many services.

  > In a development or debugging environment (you should never run NGINX in production with this), using `master_process off`, I usually run NGINX in the foreground without the master process and press `^C` (`SIGINT`) to terminated it simply.

  > `worker_processes 1` is also very useful because can reduce number of worker processes and the data they generate, so that is pretty comfortable for us to debug.

###### Example

```bash
# From configuration file (global context):
daemon            off
master_process    off;
worker_processes  1;

# From shell (oneliner):
/usr/sbin/nginx -t -g 'daemon off; master_process off; worker_processes 1;'
```

###### External resources

- [Core functionality](https://nginx.org/en/docs/ngx_core_module.html)

#### :beginner: Use core dumps to figure out why NGINX keep crashing

###### Rationale

  > A core dump is basically a snapshot of the memory when the program crashed.

  > NGINX is a very stable daemon but sometimes it can happen that there is a unique termination of the running NGINX process.

  > It ensures two important directives that should be enabled if you want the memory dumps to be saved, however, in order to properly handle memory dumps, there are a few things to do. For fully information about it see [Dump a process's memory (from this handbook)](#dump-a-processs-memory).

  > You should always enable core dumps when your NGINX instance receive an unexpected error or when it crashed.

###### Example

```bash
worker_rlimit_core    500m;
worker_rlimit_nofile  65535;
working_directory     /var/dump/nginx;
```

###### External resources

- [Debugging - Core dump](https://www.nginx.com/resources/wiki/start/topics/tutorials/debugging/#core-dump)
- [Dump a process's memory (from this handbook)](#dump-a-processs-memory)

# Performance

NGINX is a insanely fast, but you can adjust a few things to make sure it's as fast as possible for your use case.

#### :beginner: Adjust worker processes

###### Rationale

  > The `worker_processes` directive is the sturdy spine of life for NGINX. This directive is responsible for letting our virtual server know many workers to spawn once it has become bound to the proper IP and port(s) and its value is helpful in CPU-intensive work.

  > The safest setting is to use the number of cores by passing `auto`. You can adjust this value to maximum throughput under high concurrency.

  Official NGINX documentation say:

  > _When one is in doubt, setting it to the number of available CPU cores would be a good start (the value "auto" will try to autodetect it). [...] running one worker process per CPU core – makes the most efficient use of hardware resources._

  > How many worker processes do you need? Do some multiple load testing. Hit the app hard and see what happens with only one. Then add some more to it and hit it again. At some point you'll reach a point of truly saturating the server resources. That's when you know you have the right balance.

  > I think for high load proxy servers (also standalone servers) interesting value is `ALL_CORES - 1` (or more) because if you're running NGINX with other critical services on the same server, you're just going to thrash the CPUs with all the context switching required to manage all of those processes.

  > Rule of thumb: If much time is spent blocked on I/O, worker processes should be increased further.

  > Increasing the number of worker processes is a great way to overcome a single CPU core bottleneck, but may opens a whole [new set of problems](https://blog.cloudflare.com/the-sad-state-of-linux-socket-balancing/).

###### Example

```bash
# The safest way:
worker_processes auto;

# VCPU = 4 , expr $(nproc --all) - 1
worker_processes 3;
```

###### External resources

- [Nginx Core Module - worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes)

#### :beginner: Use HTTP/2

###### Rationale

  > HTTP/2 will make our applications faster, simpler, and more robust. The primary goals for HTTP/2 are to reduce latency by enabling full request and response multiplexing, minimise protocol overhead via efficient compression of HTTP header fields, and add support for request prioritisation and server push.

  > HTTP/2 is backwards-compatible with HTTP/1.1, so it would be possible to ignore it completely and everything will continue to work as before because if the client that does not support HTTP/2 will never ask the server for an HTTP/2 communication upgrade: the communication between them will be fully HTTP1/1.

  > Note that HTTP/2 multiplexes many requests within a single TCP connection. Typically, a single TCP connection is established to a server when HTTP/2 is in use.

  > You should also include the `ssl` parameter, required because browsers do not support HTTP/2 without encryption.

  > HTTP/2 has a extremely large [blacklist](https://http2.github.io/http2-spec/#BadCipherSuites) of old and insecure ciphers, so you should avoid them.

###### Example

```bash
server {

  listen 10.240.20.2:443 ssl http2;

  ...
```

###### External resources

- [Introduction to HTTP/2](https://developers.google.com/web/fundamentals/performance/http2/)
- [What is HTTP/2 - The Ultimate Guide](https://kinsta.com/learn/what-is-http2/)
- [The HTTP/2 Protocol: Its Pros & Cons and How to Start Using It](https://www.upwork.com/hiring/development/the-http2-protocol-its-pros-cons-and-how-to-start-using-it/)

#### :beginner: Maintaining SSL sessions

###### Rationale

  > This improves performance from the clients’ perspective, because it eliminates the need for a new (and time-consuming) SSL handshake to be conducted each time a request is made.

  > The TLS RFC recommends that sessions are not kept alive for more than 24 hours (it is the maximum time). But a while ago, I found `ssl_session_timeout` with less time (e.g. 15 minutes) for prevent abused by advertisers like Google and Facebook.

  > Default, "built-in" session cache is not optimal as it can be used by only one worker process and can cause memory fragmentation. It is much better to use shared cache.

  > When using `ssl_session_cache`, the performance of keep-alive connections over SSL might be enormously increased. 10M value of this is a good starting point (1MB shared cache can hold approximately 4,000 sessions). With `shared` a cache shared between all worker processes (a cache with the same name can be used in several virtual servers).

  > Most servers do not purge sessions or ticket keys, thus increasing the risk that a server compromise would leak data from previous (and future) connections.

  Ivan Ristić (Founder of Hardenize) say:

  > _Session resumption either creates a large server-side cache that can be broken into or, with tickets, kills forward secrecy. So you have to balance performance (you don't want your users to use full handshakes on every connection) and security (you don't want to compromise it too much). Different projects dictate different settings. [...] One reason not to use a very large cache (just because you can) is that popular implementations don't actually delete any records from there; even the expired sessions are still in the cache and can be recovered. The only way to really delete is to overwrite them with a new session. [...] These days I'd probably reduce the maximum session duration to 4 hours, down from 24 hours currently in my book. But that's largely based on a gut feeling that 4 hours is enough for you to reap the performance benefits, and using a shorter lifetime is always better._

###### Example

```bash
ssl_session_cache   shared:NGX_SSL_CACHE:10m;
ssl_session_timeout 12h;
ssl_session_tickets off;
ssl_buffer_size     1400;
```

###### External resources

- [SSL Session (cache)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache)
- [Speeding up TLS: enabling session reuse](https://vincent.bernat.ch/en/blog/2011-ssl-session-reuse-rfc5077)
- [ssl_session_cache in Nginx and the ab benchmark](https://www.peterbe.com/plog/ssl_session_cache-ab)

#### :beginner: Use exact names in a `server_name` directive where possible

###### Rationale

  > Exact names, wildcard names starting with an asterisk, and wildcard names ending with an asterisk are stored in three hash tables bound to the listen ports.

  > The exact names hash table is searched first. If a name is not found, the hash table with wildcard names starting with an asterisk is searched. If the name is not found there, the hash table with wildcard names ending with an asterisk is searched. Searching wildcard names hash table is slower than searching exact names hash table because names are searched by domain parts.

  > Regular expressions are tested sequentially and therefore are the slowest method and are non-scalable. For these reasons, it is better to use exact names where possible.

###### Example

```bash
# It is more efficient to define them explicitly:
server {

    listen       80;

    server_name  example.org  www.example.org  *.example.org;

    ...

}

# Than to use the simplified form:
server {

    listen       80;

    server_name  .example.org;

    ...

}
```

###### External resources

- [Server names](https://nginx.org/en/docs/http/server_names.html)
- [Virtual server logic](#virtual-server-logic)

#### :beginner: Avoid checks `server_name` with `if` directive

###### Rationale

  > When NGINX receives a request no matter what is the subdomain being requested, be it `www.example.com` or just the plain `example.com` this `if` directive is always evaluated. Since you’re requesting NGINX to check for the `Host` header for every request. It’s extremely inefficient.

  > Instead use two server directives like the example below. This approach decreases NGINX processing requirements.

###### Example

Bad configuration:

```bash
server {

  ...

  server_name                 domain.com www.domain.com;

  if ($host = www.domain.com) {

    return                    301 https://domain.com$request_uri;

  }

  server_name                 domain.com;

  ...

}
```

Good configuration:

```bash
server {

    server_name               www.domain.com;

    return                    301 $scheme://domain.com$request_uri;

    # If you force your web traffic to use HTTPS:
    #                         301 https://domain.com$request_uri;

    ,,,

}

server {

    listen                    80;

    server_name               domain.com;

    ...

}
```

###### External resources

- [If Is Evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/)
- [if, break, and set (from this handbook)](#if-break-and-set)

#### :beginner: Use `$request_uri` to avoid using regular expressions

###### Rationale

  > With built-in variable `$request_uri` we can effectively avoid doing any capturing or matching at all. By default, the regex is costly and will slow down the performance.

  > This rule is addressing passing the URL unchanged to a new host, sure return is more efficient just passing through the existing URI.

  I think the best explanation comes from the official documentation:

  > _Don’t feel bad here, it’s easy to get confused with regular expressions. In fact, it’s so easy to do that we should make an effort to keep them neat and clean._

###### Example

Bad configuration:

```bash
# 1)
rewrite ^/(.*)$ https://example.com/$1 permanent;

# 2)
rewrite ^ https://example.com$request_uri? permanent;
```

Good configuration:

```bash
return 301 https://example.com$request_uri;
```

###### External resources

- [Pitfalls and Common Mistakes - Taxing Rewrites](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#taxing-rewrites)

#### :beginner: Use `try_files` directive to ensure a file exists

###### Rationale

  > `try_files` is definitely a very useful thing. You can use `try_files` directive to check a file exists in a specified order.

  > You should use `try_files` instead of `if` directive. It's definitely better way than using `if` for this action because `if` directive is extremely inefficient since it is evaluated every time for every request.

  > The advantage of using `try_files` is that the behavior switches immediately with one command. I think the code is more readable also.

  > `try_files` allows you:
  >
  > - to check if the file exists from a predefined list
  > - to check if the file exists from a specified directory
  > - to use an internal redirect if none of the files are found

###### Example

Bad configuration:

```bash

  ...

  root /var/www/example.com;

  location /images {

    if (-f $request_filename) {

      expires 30d;
      break;

    }

  ...

}
```

Good configuration:

```bash

  ...

  root /var/www/example.com;

  location /images {

    try_files $uri =404;

  ...

}
```

###### External resources

- [Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)
- [Pitfalls and Common Mistakes](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/)
- [Serving Static Content](https://docs.nginx.com/nginx/admin-guide/web-server/serving-static-content/)
- [Serve files with nginx conditionally](http://www.lazutkin.com/blog/2014/02/23/serve-files-with-nginx-conditionally/)

#### :beginner: Use `return` directive instead of `rewrite` for redirects

###### Rationale

  > You should use server blocks and `return` statements as they're way simpler and faster than evaluating RegEx via location blocks. This directive stops processing and returns the specified code to a client.

###### Example

Bad configuration:

```bash
server {

  ...

  if ($host = api.domain.com) {

    rewrite     ^/(.*)$ http://example.com/$1 permanent;

  }

  ...
```

Good configuration:

```bash
server {

  ...

  if ($host = api.domain.com) {

    return      403;

    # or other examples:
    # return    301 https://domain.com$request_uri;
    # return    301 $scheme://$host$request_uri;

  }

  ...
```

###### External resources

- [If Is Evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/)
- [NGINX - rewrite vs redirect](http://think-devops.com/blogs/nginx-rewrite-redirect.html)
- [rewrite vs return (from this handbook)](#rewrite-vs-return)

#### :beginner: Enable PCRE JIT to speed up processing of regular expressions

###### Rationale

  > Enables the use of JIT for regular expressions to speed-up their processing.

  > By compiling NGINX with the PCRE library, you can perform complex manipulations with your `location` blocks and use the powerful `rewrite` and `return` directives.

  > PCRE JIT can speed up processing of regular expressions significantly. NGINX with `pcre_jit` is magnitudes faster than without it.

  > If you’ll try to use `pcre_jit on;` without JIT available, or if NGINX was compiled with JIT available, but currently loaded PCRE library does not support JIT, will warn you during configuration parsing.

  > The `--with-pcre-jit` is only needed when you compile PCRE library using NGNIX configure (`./configure --with-pcre=`). When using a system PCRE library whether or not JIT is supported depends on how the library was compiled.

  From NGINX documentation:

  > _The JIT is available in PCRE libraries starting from version 8.20 built with the `--enable-jit` configuration parameter. When the PCRE library is built with nginx (`--with-pcre=`), the JIT support is enabled via the `--with-pcre-jit` configuration parameter._

###### Example

```bash
# In global context:
pcre_jit on;
```

###### External resources

- [Core functionality - pcre jit](https://nginx.org/en/docs/ngx_core_module.html#pcre_jit)

#### :beginner: Make an exact location match to speed up the selection process

###### Rationale

  > Exact location matches are often used to speed up the selection process by immediately ending the execution of the algorithm.

###### Example

```bash
# Matches the query / only and stops searching:
location = / {

  ...

}

# Matches the query /v9 only and stops searching:
location = /v9 {

  ...

}

...

# Matches any query due to the fact that all queries begin at /,
# but regular expressions and any longer conventional blocks will be matched at first place:
location / {

  ...

}
```

###### External resources

- [Untangling the nginx location block matching algorithm](https://artfulrobot.uk/blog/untangling-nginx-location-block-matching-algorithm)

#### :beginner: Use `limit_conn` to improve limiting the download speed

###### Rationale

  > NGINX provides two directives to limiting download speed:
  >   - `limit_rate_after` - sets the amount of data transferred before the `limit_rate` directive takes effect
  >   - `limit_rate` - allows you to limit the transfer rate of individual client connections (past exceeding `limit_rate_after`)

  > This solution limits NGINX download speed per connection, so, if one user opens multiple e.g. video files, it will be able to download `X * the number of times` he connected to the video files.

  > To prevent this situation use `limit_conn_zone` and `limit_conn` directives.

###### Example

```bash
# Create limit connection zone:
limit_conn_zone $binary_remote_addr zone=conn_for_remote_addr:1m;

# Add rules to limiting the download speed:
limit_rate_after 1m;  # run at maximum speed for the first 1 megabyte
limit_rate 250k;      # and set rate limit after 1 megabyte

# Enable queue:
location /videos {

  # Max amount of data by one client: 10 megabytes (limit_rate_after * 10)
  limit_conn conn_for_remote_addr 10;

  ...
```

###### External resources

- [How to Limit Nginx download Speed](https://www.scalescale.com/tips/nginx/how-to-limit-nginx-download-speed/)

# Hardening

In this chapter I will talk about some of the NGINX hardening approaches and security standards.

#### :beginner: Always keep NGINX up-to-date

###### Rationale

  > NGINX is a very secure and stable but vulnerabilities in the main binary itself do pop up from time to time. It's the main reason for keep NGINX up-to-date as hard as you can.

  > A very safe way to plan the update is once a new stable version is released but for me the most common way to handle NGINX updates is to wait a few weeks after the stable release.

  > Before update/upgrade NGINX remember about do it on the testing environment.

  > Most modern GNU/Linux distros will not push the latest version of NGINX into their default package lists so maybe you should consider install it from sources.

###### External resources

- [Installing from prebuilt packages (from this handbook)](#installing-from-prebuilt-packages)
- [Installing from source (from this handbook)](#installing-from-source)

#### :beginner: Run as an unprivileged user

###### Rationale

  > There is no real difference in security just by changing the process owner name. On the other hand in security, the principle of least privilege states that an entity should be given no more permission than necessary to accomplish its goals within a given system. This way only master process runs as root.

  > This is the default NGINX behaviour, but remember to check it.

###### Example

```bash
# Edit nginx.conf:
user nginx;

# Set owner and group for root (app, default) directory:
chown -R nginx:nginx /var/www/domain.com
```

###### External resources

- [Why does nginx starts process as root?](https://unix.stackexchange.com/questions/134301/why-does-nginx-starts-process-as-root)

#### :beginner: Disable unnecessary modules

###### Rationale

  > It is recommended to disable any modules which are not required as this will minimise the risk of any potential attacks by limiting the operations allowed by the web server.

  > The best way to unload unused modules is use the `configure` option during installation. If you have static linking a shared module you should re-compile NGINX.

  > Use only high quality modules and remember about that:
  >
  > _Unfortunately, many third‑party modules use blocking calls, and users (and sometimes even the developers of the modules) aren’t aware of the drawbacks. Blocking operations can ruin NGINX performance and must be avoided at all costs._

###### Example

```bash
# 1) During installation:
./configure --without-http_autoindex_module

# 2) Comment modules in the configuration file e.g. modules.conf:
# load_module                 /usr/share/nginx/modules/ndk_http_module.so;
# load_module                 /usr/share/nginx/modules/ngx_http_auth_pam_module.so;
# load_module                 /usr/share/nginx/modules/ngx_http_cache_purge_module.so;
# load_module                 /usr/share/nginx/modules/ngx_http_dav_ext_module.so;
load_module                   /usr/share/nginx/modules/ngx_http_echo_module.so;
# load_module                 /usr/share/nginx/modules/ngx_http_fancyindex_module.so;
load_module                   /usr/share/nginx/modules/ngx_http_geoip_module.so;
load_module                   /usr/share/nginx/modules/ngx_http_headers_more_filter_module.so;
# load_module                 /usr/share/nginx/modules/ngx_http_image_filter_module.so;
# load_module                 /usr/share/nginx/modules/ngx_http_lua_module.so;
load_module                   /usr/share/nginx/modules/ngx_http_perl_module.so;
# load_module                 /usr/share/nginx/modules/ngx_mail_module.so;
# load_module                 /usr/share/nginx/modules/ngx_nchan_module.so;
# load_module                 /usr/share/nginx/modules/ngx_stream_module.so;
```

###### External resources

- [nginx-modules](https://github.com/nginx-modules)

#### :beginner: Protect sensitive resources

###### Rationale

  > Hidden directories and files should never be web accessible - sometimes critical data are published during application deploy. If you use control version system you should defninitely drop the access to the critical hidden directories like a `.git` or `.svn` to prevent expose source code of your application.

  > Sensitive resources contains items that abusers can use to fully recreate the source code used by the site and look for bugs, vulnerabilities, and exposed passwords.

###### Example

```bash
if ($request_uri ~ "/\.git") {

  return 403;

}

# or
location ~ /\.git {

  deny all;

}

# or
location ~* ^.*(\.(?:git|svn|htaccess))$ {

  return 403;

}

# or all . directories/files excepted .well-known
location ~ /\.(?!well-known\/) {

  deny all;

}
```

###### External resources

- [Hidden directories and files as a source of sensitive information about web application](https://github.com/bl4de/research/tree/master/hidden_directories_leaks)

#### :beginner: Hide Nginx version number

###### Rationale

  > Disclosing the version of NGINX running can be undesirable, particularly in environments sensitive to information disclosure.

  But the "Official Apache Documentation (Apache Core Features)" (yep, it's not a joke...) say:

  > _Setting ServerTokens to less than minimal is not recommended because it makes it more difficult to debug interoperational problems. Also note that disabling the Server: header does nothing at all to make your server more secure. The idea of "security through obscurity" is a myth and leads to a false sense of safety._

###### Example

```bash
server_tokens off;
```

###### External resources

- [Remove Version from Server Header Banner in nginx](https://geekflare.com/remove-server-header-banner-nginx/)
- [Reduce or remove server headers](https://www.tunetheweb.com/security/http-security-headers/server-header/)

#### :beginner: Hide Nginx server signature

###### Rationale

  > In my opinion there is no real reason or need to show this much information about your server. It is easy to look up particular vulnerabilities once you know the version number.

  > You should compile NGINX from sources with `ngx_headers_more` to used `more_set_headers` directive.

###### Example

```bash
more_set_headers "Server: Unknown";
```

###### External resources

- [Shhh... don’t let your response headers talk too loudly](https://www.troyhunt.com/shhh-dont-let-your-response-headers/)
- [How to change (hide) the Nginx Server Signature?](https://stackoverflow.com/questions/24594971/how-to-changehide-the-nginx-server-signature)

#### :beginner: Hide upstream proxy headers

###### Rationale

  > When NGINX is used to proxy requests to an upstream server (such as a PHP-FPM instance), it can be beneficial to hide certain headers sent in the upstream response (e.g. the version of PHP running).

###### Example

```bash
proxy_hide_header X-Powered-By;
proxy_hide_header X-AspNetMvc-Version;
proxy_hide_header X-AspNet-Version;
proxy_hide_header X-Drupal-Cache;
```

###### External resources

- [Remove insecure http headers](https://veggiespam.com/headers/)

#### :beginner: Force all connections over TLS

###### Rationale

  > TLS provides two main services. For one, it validates the identity of the server that the user is connecting to for the user. It also protects the transmission of sensitive information from the user to the server.

  > In my opinion you should always use HTTPS instead of HTTP to protect your website, even if it doesn’t handle sensitive communications. The application can have many sensitive places that should be protected.

  > Always put login page, registration forms, all subsequent authenticated pages, contact forms, and payment details forms in HTTPS to prevent injection and sniffing. Them must be accessed only over TLS to ensure your traffic is secure.

  > If page is available over TLS, it must be composed completely of content which is transmitted over TLS. Requesting subresources using the insecure HTTP protocol weakens the security of the entire page and HTTPS protocol. Modern browsers should blocked or report all active mixed content delivered via HTTP on pages by default.

  > Also remember to implement the [HTTP Strict Transport Security (HSTS)](#beginner-http-strict-transport-security).

  > We have currently the first free and open CA - [Let's Encrypt](https://letsencrypt.org/) - so generating and implementing certificates has never been so easy. It was created to provide free and easy-to-use TLS and SSL certificates.

###### Example

- force all traffic to use TLS:

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

- force e.g. login page to use TLS:

  ```bash
  server {

    listen 10.240.20.2:80;

    server_name domain.com;

    ...

    location ^~ /login {

      return 301 https://domain.com$request_uri;

    }

  }
  ```

###### External resources

- [Should we force user to HTTPS on website?](https://security.stackexchange.com/questions/23646/should-we-force-user-to-https-on-website)
- [Force a user to HTTPS](https://security.stackexchange.com/questions/137542/force-a-user-to-https)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)

#### :beginner: Use only the latest supported OpenSSL version

###### Rationale

  > Before start see [Release Strategy Policies](https://www.openssl.org/policies/releasestrat.html) and [Changelog](https://www.openssl.org/news/changelog.html) on the OpenSSL website.

  > Criteria for choosing OpenSSL version can vary and it depends all on your use.

  > The latest versions of the major OpenSSL library are (may be changed):
  >
  >   - the next version of OpenSSL will be 3.0.0
  >   - version 1.1.1 will be supported until 2023-09-11 (LTS)
  >     - last minor version: 1.1.1c (May 23, 2019)
  >   - version 1.1.0 will be supported until 2019-09-11
  >     - last minor version: 1.1.0k (May 28, 2018)
  >   - version 1.0.2 will be supported until 2019-12-31 (LTS)
  >     - last minor version: 1.0.2s (May 28, 2018)
  >   - any other versions are no longer supported

  > In my opinion the only safe way is based on the up-to-date and still supported version of the OpenSSL. And what's more, I recommend to hang on to the latest versions (e.g. 1.1.1).

  > If your system repositories do not have the newest OpenSSL, you can do the [compilation](https://github.com/trimstray/nginx-admins-handbook#installing-from-source) process (see OpenSSL sub-section).

###### External resources

- [OpenSSL Official Website](https://www.openssl.org/)
- [OpenSSL Official Blog](https://www.openssl.org/blog/)
- [OpenSSL Official Newslog](https://www.openssl.org/news/newslog.html)

#### :beginner: Use min. 2048-bit private keys

###### Rationale

  > Advisories recommend 2048 for now. Security experts are projecting that 2048 bits will be sufficient for commercial use until around the year 2030 (as per NIST).

  > The latest version of FIPS-186 also say the U.S. Federal Government generate (and use) digital signatures with 1024, 2048, or 3072 bit key lengths.

  > Generally there is no compelling reason to choose 4096 bit keys over 2048 provided you use sane expiration intervals.

  > If you want to get **A+ with 100%s on SSL Lab** (for Key Exchange) you should definitely use 4096 bit private keys. That's the main reason why you should use them.

  > Longer keys take more time to generate and require more CPU and power when used for encrypting and decrypting, also the SSL handshake at the start of each connection will be slower. It also has a small impact on the client side (e.g. browsers).

  > You can test above on your server with `openssl speed rsa` but remember: in OpenSSL speed tests you see difference on block cipher speed, while in real life most cpu time is spent on asymmetric algorithms during ssl handshake. On the other hand, modern processors are capable of executing at least 1k of RSA 1024-bit signs per second on a single core, so this isn't usually an issue.

  > Use of alternative solution: [ECC Certificate Signing Request (CSR)](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography) - `ECDSA` certificates contain an `ECC` public key. `ECC` keys are better than `RSA & DSA` keys in that the `ECC` algorithm is harder to break.

  The "SSL/TLS Deployment Best Practices" book say:

  > _The cryptographic handshake, which is used to establish secure connections, is an operation whose cost is highly influenced by private key size. Using a key that is too short is insecure, but using a key that is too long will result in "too much" security and slow operation. For most web sites, using RSA keys stronger than 2048 bits and ECDSA keys stronger than 256 bits is a waste of CPU power and might impair user experience. Similarly, there is little benefit to increasing the strength of the ephemeral key exchange beyond 2048 bits for DHE and 256 bits for ECDHE._

  Konstantin Ryabitsev (Reddit):

  > _Generally speaking, if we ever find ourselves in a world where 2048-bit keys are no longer good enough, it won't be because of improvements in brute-force capabilities of current computers, but because RSA will be made obsolete as a technology due to revolutionary computing advances. If that ever happens, 3072 or 4096 bits won't make much of a difference anyway. This is why anything above 2048 bits is generally regarded as a sort of feel-good hedging theatre._

  **My recommendation:**

  > Use 2048-bit key instead of 4096-bit at this moment.

###### Example

```bash
### Example (RSA):
( _fd="domain.com.key" ; _len="2048" ; openssl genrsa -out ${_fd} ${_len} )

# Let's Encrypt:
certbot certonly -d domain.com -d www.domain.com --rsa-key-size 2048

### Example (ECC):
# _curve: prime256v1, secp521r1, secp384r1
( _fd="domain.com.key" ; _fd_csr="domain.com.csr" ; _curve="prime256v1" ; \
openssl ecparam -out ${_fd} -name ${_curve} -genkey ; \
openssl req -new -key ${_fd} -out ${_fd_csr} -sha256 )

# Let's Encrypt (from above):
certbot --csr ${_fd_csr} -[other-args]
```

For `x25519`:

```bash
( _fd="private.key" ; _curve="x25519" ; \
openssl genpkey -algorithm ${_curve} -out ${_fd} )
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

```bash
( _fd="domain.com.key" ; _len="2048" ; openssl genrsa -out ${_fd} ${_len} )

# Let's Encrypt:
certbot certonly -d domain.com -d www.domain.com
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>90%</b>

###### External resources

- [Key Management Guidelines by NIST](https://csrc.nist.gov/Projects/Key-Management/Key-Management-Guidelines)
- [Recommendation for Transitioning the Use of Cryptographic Algorithms and Key Lengths](https://csrc.nist.gov/publications/detail/sp/800-131a/archive/2011-01-13)
- [FIPS PUB 186-4 - Digital Signature Standard (DSS)](http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf) <sup>[pdf]</sup>
- [Cryptographic Key Length Recommendations](https://www.keylength.com/)
- [So you're making an RSA key for an HTTPS certificate. What key size do you use?](https://certsimple.com/blog/measuring-ssl-rsa-keys)
- [RSA Key Sizes: 2048 or 4096 bits?](https://danielpocock.com/rsa-key-sizes-2048-or-4096-bits/)
- [Create a self-signed ECC certificate](https://msol.io/blog/tech/create-a-self-signed-ecc-certificate/)

#### :beginner: Keep only TLS 1.3 and TLS 1.2

###### Rationale

  > It is recommended to run TLS 1.2/1.3 and fully disable SSLv2, SSLv3, TLS 1.0 and TLS 1.1 that have protocol weaknesses and uses older cipher suites (do not provide any modern ciper modes).

  > TLS 1.0 and TLS 1.1 must not be used (see [Deprecating TLSv1.0 and TLSv1.1](https://tools.ietf.org/id/draft-moriarty-tls-oldversions-diediedie-00.html)) and were superceded by TLS 1.2, which has now itself been superceded by TLS 1.3. They are also actively being deprecated in accordance with guidance from government agencies (e.g. NIST SP 80052r2) and industry consortia such as the Payment Card Industry Association (PCI) [PCI-TLS1].

  > TLS 1.2 and TLS 1.3 are both without security issues. Only these versions provides modern cryptographic algorithms. TLS 1.3 is a new TLS version that will power a faster and more secure web for the next few years. What's more, TLS 1.3 comes without a ton of stuff (was removed): renegotiation, compression, and many legacy algorithms: DSA, RC4, SHA1, MD5, CBC MAC-then-Encrypt ciphers. TLS 1.0 and TLS 1.1 protocols will be removed from browsers at the beginning of 2020.

  > TLS 1.2 does require careful configuration to ensure obsolete cipher suites with identified vulnerabilities are not used in conjunction with it. TLS 1.3 removes the need to make these decisions. TLS 1.3 version also improves TLS 1.2 security, privace and performance issues.

  > Before enabling specific protocol version, you should check which ciphers are supported by the protocol. So if you turn on TLS 1.2 and TLS 1.3 both remember about [the correct (and strong)](#beginner-use-only-strong-ciphers) ciphers to handle them. Otherwise, they will not be anyway works without supported ciphers (no TLS handshake will succeed).

  > I think the best way to deploy secure configuration is: enable TLS 1.2 without any CBC Ciphers (is safe enough) only TLS 1.3 is safer because of its handling improvement and the exclusion of everything that went obsolete since TLS 1.2 came up.

  > If you told NGINX to use TLS 1.3, it will use TLS 1.3 only where is available. NGINX supports TLS 1.3 since version 1.13.0 (released in April 2017), when built against OpenSSL 1.1.1 or more.

  > For TLS 1.3, think about using [`ssl_early_data`](#beginner-prevent-replay-attacks-on-zero-round-trip-time) to allow TLS 1.3 0-RTT handshakes.

  **My recommendation:**

  > Use only [TLSv1.3 and TLSv1.2](#keep-only-tls1.2-tls13).

###### Example

TLS 1.3 + 1.2:

```bash
ssl_protocols TLSv1.3 TLSv1.2;
```

TLS 1.2:

```bash
ssl_protocols TLSv1.2;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

TLS 1.3 + 1.2 + 1.1:

```bash
ssl_protocols TLSv1.3 TLSv1.2 TLSv1.1;
```

TLS 1.2 + 1.1:

```bash
ssl_protocols TLSv1.2 TLSv1.1;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>95%</b>

###### External resources

- [The Transport Layer Security (TLS) Protocol Version 1.2](https://www.ietf.org/rfc/rfc5246.txt)
- [The Transport Layer Security (TLS) Protocol Version 1.3](https://tools.ietf.org/html/draft-ietf-tls-tls13-18)
- [TLS1.2 - Every byte explained and reproduced](https://tls12.ulfheim.net/)
- [TLS1.3 - Every byte explained and reproduced](https://tls13.ulfheim.net/)
- [TLS1.3 - OpenSSLWiki](https://wiki.openssl.org/index.php/TLS1.3)
- [TLS v1.2 handshake overview](https://medium.com/@ethicalevil/tls-handshake-protocol-overview-a39e8eee2cf5)
- [An Overview of TLS 1.3 - Faster and More Secure](https://kinsta.com/blog/tls-1-3/)
- [A Detailed Look at RFC 8446 (a.k.a. TLS 1.3)](https://blog.cloudflare.com/rfc-8446-aka-tls-1-3/)
- [Differences between TLS 1.2 and TLS 1.3](https://www.wolfssl.com/differences-between-tls-1-2-and-tls-1-3/)
- [TLS 1.3 in a nutshell](https://assured.se/2018/08/29/tls-1-3-in-a-nut-shell/)
- [TLS 1.3 is here to stay](https://www.ssl.com/article/tls-1-3-is-here-to-stay/)
- [How to enable TLS 1.3 on Nginx](https://ma.ttias.be/enable-tls-1-3-nginx/)
- [How to deploy modern TLS in 2019?](https://blog.probely.com/how-to-deploy-modern-tls-in-2018-1b9a9cafc454)
- [Deploying TLS 1.3: the great, the good and the bad](https://media.ccc.de/v/33c3-8348-deploying_tls_1_3_the_great_the_good_and_the_bad)
- [Downgrade Attack on TLS 1.3 and Vulnerabilities in Major TLS Libraries](https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2019/february/downgrade-attack-on-tls-1.3-and-vulnerabilities-in-major-tls-libraries/)
- [Phase two of our TLS 1.0 and 1.1 deprecation plan](https://www.fastly.com/blog/phase-two-our-tls-10-and-11-deprecation-plan)
- [Deprecating TLS 1.0 and 1.1 - Enhancing Security for Everyone](https://www.keycdn.com/blog/deprecating-tls-1-0-and-1-1)
- [TLS/SSL Explained – Examples of a TLS Vulnerability and Attack, Final Part](https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/)
- [This POODLE bites: exploiting the SSL 3.0 fallback](https://security.googleblog.com/2014/10/this-poodle-bites-exploiting-ssl-30.html)
- [Are You Ready for 30 June 2018? Saying Goodbye to SSL/early TLS](https://blog.pcisecuritystandards.org/are-you-ready-for-30-june-2018-sayin-goodbye-to-ssl-early-tls)
- [Deprecating TLSv1.0 and TLSv1.1](https://tools.ietf.org/id/draft-moriarty-tls-oldversions-diediedie-00.html)

#### :beginner: Use only strong ciphers

###### Rationale

  > This parameter changes quite often, the recommended configuration for today may be out of date tomorrow.

  > To check ciphers supported by OpenSSL on your server: `openssl ciphers -s -v`, `openssl ciphers -s -v ECDHE` or `openssl ciphers -s -v DHE`.

  > For more security use only strong and not vulnerable cipher suites. Place `ECDHE` and `DHE` suites at the top of your list. The order is important because `ECDHE` suites are faster, you want to use them whenever clients supports them. `Ephemeral DHE/ECDHE` are recommended and support Perfect Forward Secrecy.

  > For backward compatibility software components you should use less restrictive ciphers. Not only that you have to enable at least one special `AES128` cipher for HTTP/2 support regarding to [RFC7540: TLS 1.2 Cipher Suites](https://tools.ietf.org/html/rfc7540#section-9.2.2), you also have to allow `prime256` elliptic curves which reduces the score for key exchange by another 10% even if a secure server preferred order is set.

  > Also modern cipher suites (e.g. from Mozilla recommendations) suffers from compatibility troubles mainly because drops `SHA-1`. But be careful if you want to use ciphers with `HMAC-SHA-1` - there's a perfectly good [explanation](https://crypto.stackexchange.com/a/26518) why.

  > If you want to get **A+ with 100%s on SSL Lab** (for Cipher Strength) you should definitely disable `128-bit` ciphers. That's the main reason why you should not use them.

  > In my opinion `128-bit` symmetric encryption doesn’t less secure. Moreover, there are about 30% faster and still secure. For example TLS 1.3 use `TLS_AES_128_GCM_SHA256 (0x1301)` (for TLS-compliant applications).

  > It is not possible to control ciphers for TLS 1.3 without support from client to use new API for TLS 1.3 cipher suites. NGINX isn't able to influence that so at this moment it's always on (also if you disable potentially weak cipher from NGINX). On the other hand the ciphers in TLSv1.3 have been restricted to only a handful of completely secure ciphers by leading crypto experts.

  > For TLS 1.2 you should consider disable weak ciphers without forward secrecy like ciphers with `CBC` algorithm. Using them also reduces the final grade because they don't use ephemeral keys. In my opinion you should use ciphers with `AEAD` (TLS 1.3 supports only these suites) encryption because they don't have any known weaknesses.

  > Disable TLS cipher modes (all ciphers that start with `TLS_RSA`) that use RSA encryption because they are vulnerable to [ROBOT](https://robotattack.org/) attack. Not all servers that support RSA key exchange are vulnerable. But it is recommended to disable RSA key exchange ciphers as it does not support forward secrecy.

  > You should also absolutely disable weak ciphers regardless of the TLS version do you use, like those with `DSS`, `DSA`, `DES/3DES`, `RC4`, `MD5`, `SHA1`, `null`, anon in the name.

  > We have a nice online tool for testing compatibility cipher suites with user agents: [CryptCheck](https://cryptcheck.fr/suite/). I think it will be very helpful for you.

  **My recommendation:**

  > Use only [TLSv1.3 and TLSv1.2](#keep-only-tls1.2-tls13) with below cipher suites:
  ```bash
  ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384:TLS13-AES-128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256";
  ```

###### Example

Cipher suites for TLS 1.3:

```bash
ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384";
```

Cipher suites for TLS 1.2:

```bash
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384";
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

Cipher suites for TLS 1.3:

```bash
ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384:TLS13-AES-128-GCM-SHA256";
```

Cipher suites for TLS 1.2:

```bash
# 1)
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384";

# 2)
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256";

# 3)
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256";

# 4)
ssl_ciphers "EECDH+CHACHA20:EDH+AESGCM:AES256+EECDH:AES256+EDH";
```

Cipher suites for TLS 1.1 + 1.2:

```bash
# 1)
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256";

# 2)
ssl_ciphers "ECDHE-ECDSA-CHACHA20-POLY1305:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:!AES256-GCM-SHA256:!AES256-GCM-SHA128:!aNULL:!MD5";
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>90%</b>

This will also give a baseline for comparison with [Mozilla SSL Configuration Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/):

- Modern profile with OpenSSL 1.1.0b (TLSv1.2)

```bash
ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
```

- Intermediate profile with OpenSSL 1.1.0b (TLSv1, TLSv1.1 and TLSv1.2)

```bash
ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS';
```

###### External resources

- [TLS Cipher Suites](https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-4)
- [SSL/TLS: How to choose your cipher suite](https://technology.amis.nl/2017/07/04/ssltls-choose-cipher-suite/)
- [HTTP/2 and ECDSA Cipher Suites](https://sparanoid.com/note/http2-and-ecdsa-cipher-suites/)
- [Which SSL/TLS Protocol Versions and Cipher Suites Should I Use?](https://www.securityevaluators.com/ssl-tls-protocol-versions-cipher-suites-use/)
- [Recommendations for a cipher string by OWASP](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/TLS_Cipher_String_Cheat_Sheet.md)
- [Recommendations for TLS/SSL Cipher Hardening by Acunetix](https://www.acunetix.com/blog/articles/tls-ssl-cipher-hardening/)
- [Mozilla’s Modern compatibility suite](https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility)
- [Why use Ephemeral Diffie-Hellman](https://tls.mbed.org/kb/cryptography/ephemeral-diffie-hellman)
- [Cipher Suite Breakdown](https://blogs.technet.microsoft.com/askpfeplat/2017/12/26/cipher-suite-breakdown/)
- [OpenSSL IANA Mapping](https://testssl.sh/openssl-iana.mapping.html)
- [Goodbye TLS_RSA](https://lightshipsec.com/goodbye-tls_rsa/)

#### :beginner: Use more secure ECDH Curve

###### Rationale

  > In my opinion your main source of knowledge should be [The SafeCurves web site](https://safecurves.cr.yp.to/). This site reports security assessments of various specific curves.

  > For a SSL server certificate, an "elliptic curve" certificate will be used only with digital signatures (`ECDSA` algorithm).

  > `x25519` is a more secure (also with SafeCurves requirements) but slightly less compatible option. I think to maximise interoperability with existing browsers and servers, stick to `P-256 prime256v1` and `P-384 secp384r1` curves. Of course there's tons of different opinions about `P-256` and `P-384` curves.

  > NSA Suite B says that NSA uses curves `P-256` and `P-384` (in OpenSSL, they are designated as, respectively, `prime256v1` and `secp384r1`). There is nothing wrong with `P-521`, except that it is, in practice, useless. Arguably, `P-384` is also useless, because the more efficient `P-256` curve already provides security that cannot be broken through accumulation of computing power.

  > Bernstein and Lange believe that the NIST curves are not optimal and there are better (more secure) curves that work just as fast, e.g. `x25519`.

  > Keep an eye also on this:
  >
  > _Secure implementations of the standard curves are theoretically possible but very hard._
  >
  > The SafeCurves say:
  >   - `NIST P-224`, `NIST P-256` and `NIST P-384` are UNSAFE
  >
  > From the curves described here only `x25519` is a curve meets all SafeCurves requirements.

  > I think you can use `P-256` to minimise trouble. If you feel that your manhood is threatened by using a 256-bit curve where a 384-bit curve is available, then use `P-384`: it will increases your computational and network costs.

  > If you use TLS 1.3 you should enable `prime256v1` signature algorithm. Without this SSL Lab reports `TLS_AES_128_GCM_SHA256 (0x1301)` signature as weak.

  > If you do not set `ssl_ecdh_curve`, then NGINX will use its default settings, e.g. Chrome will prefer `x25519`, but it is **not recommended** because you can not control default settings (seems to be `P-256`) from the NGINX.

  > Explicitly set `ssl_ecdh_curve X25519:prime256v1:secp521r1:secp384r1;` **decreases the Key Exchange SSL Labs rating**.

  > Definitely do not use the `secp112r1`, `secp112r2`, `secp128r1`, `secp128r2`, `secp160k1`, `secp160r1`, `secp160r2`, `secp192k1` curves. They have a too small size for security application according to NIST recommendation.

  **My recommendation:**

  > Use only [TLSv1.3 and TLSv1.2](#keep-only-tls1.2-tls13) and [only strong ciphers](#use-only-strong-ciphers) with above curves:
  ```bash
  ssl_ecdh_curve X25519:secp521r1:secp384r1:prime256v1;
  ```

###### Example

Curves for TLS 1.2:

```bash
ssl_ecdh_curve secp521r1:secp384r1:prime256v1;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

```bash
# Alternative (this one doesn’t affect compatibility, by the way; it’s just a question of the preferred order).

# This setup downgrade Key Exchange score but is recommended for TLS 1.2 + 1.3:
ssl_ecdh_curve X25519:secp521r1:secp384r1:prime256v1;
```

###### External resources

- [Elliptic Curves for Security](https://tools.ietf.org/html/rfc7748)
- [Standards for Efficient Cryptography Group](http://www.secg.org/)
- [SafeCurves: choosing safe curves for elliptic-curve cryptography](https://safecurves.cr.yp.to/)
- [A note on high-security general-purpose elliptic curves](https://eprint.iacr.org/2013/647)
- [P-521 is pretty nice prime](https://blog.cr.yp.to/20140323-ecdsa.html)
- [Safe ECC curves for HTTPS are coming sooner than you think](https://certsimple.com/blog/safe-curves-and-openssl)
- [Cryptographic Key Length Recommendations](https://www.keylength.com/)
- [Testing for Weak SSL/TLS Ciphers, Insufficient Transport Layer Protection (OTG-CRYPST-001)](https://www.owasp.org/index.php/Testing_for_Weak_SSL/TLS_Ciphers,_Insufficient_Transport_Layer_Protection_(OTG-CRYPST-001))
- [Elliptic Curve performance: NIST vs Brainpool](https://tls.mbed.org/kb/cryptography/elliptic-curve-performance-nist-vs-brainpool)
- [Which elliptic curve should I use?](https://security.stackexchange.com/questions/78621/which-elliptic-curve-should-i-use/91562)

#### :beginner: Use strong Key Exchange

###### Rationale

  > The DH key is only used if DH ciphers are used. Modern clients prefer `ECDHE` instead and if your NGINX accepts this preference then the handshake will not use the DH param at all since it will not do a `DHE` key exchange but an `ECDHE` key exchange.

  > Most of the modern profiles from places like Mozilla's ssl config generator no longer recommend using this.

  > Default key size in OpenSSL is `1024 bits` - it's vulnerable and breakable. For the best security configuration use your own `4096 bit` DH Group or use known safe ones pre-defined DH groups (it's recommended) from [mozilla](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096).

###### Example

```bash
# To generate a DH key:
openssl dhparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

# To produce "DSA-like" DH parameters:
openssl dhparam -dsaparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

# To generate a ECDH key:
openssl ecparam -out /etc/nginx/ssl/ecparam.pem -name prime256v1

# NGINX configuration:
ssl_dhparam /etc/nginx/ssl/dhparams_4096.pem;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

###### External resources

- [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
- [Guide to Deploying Diffie-Hellman for TLS](https://weakdh.org/sysadmin.html)
- [Pre-defined DHE groups](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096)
- [Instructs OpenSSL to produce "DSA-like" DH parameters](https://security.stackexchange.com/questions/95178/diffie-hellman-parameters-still-calculating-after-24-hours/95184#95184)
- [OpenSSL generate different types of self signed certificate](https://security.stackexchange.com/questions/44251/openssl-generate-different-types-of-self-signed-certificate)

#### :beginner: Prevent Replay Attacks on Zero Round-Trip Time

###### Rationale

  > This rules is only important for TLS 1.3. By default enabling TLS 1.3 will not enable 0-RTT support. After all, you should be fully aware of all the potential exposure factors and related risks with the use of this option.

  > 0-RTT Handshakes is part of the replacement of TLS Session Resumption and was inspired by the QUIC Protocol.

  > 0-RTT creates a significant security risk. With 0-RTT, a threat actor can intercept an encrypted client message and resend it to the server, tricking the server into improperly extending trust to the threat actor and thus potentially granting the threat actor access to sensitive data.

  > On the other hand, including 0-RTT (Zero Round Trip Time Resumption) results in a significant increase in efficiency and connection times. TLS 1.3 has a faster handshake that completes in 1-RTT. Additionally, it has a particular session resumption mode where, under certain conditions, it is possible to send data to the server on the first flight (0-RTT).

  > For example, Cloudflare only supports 0-RTT for [GET requests with no query parameters](https://new.blog.cloudflare.com/introducing-0-rtt/) in an attempt to limit the attack surface. Moreover, in order to improve identify connection resumption attempts, they relay this information to the origin by adding an extra header to 0-RTT requests. This header uniquely identifies the request, so if one gets repeated, the origin will know it's a replay attack (the application needs to track values received from that and reject duplicates on non-idempotent endpoints).

  > To protect against such attacks at the application layer, the `$ssl_early_data` variable should be used. You'll also need to ensure that the `Early-Data` header is passed to your application. `$ssl_early_data` returns 1 if TLS 1.3 early data is used and the handshake is not complete.

  > However, as part of the upgrade, you should disable 0-RTT until you can audit your application for this class of vulnerability.

  > In order to send early-data, client and server [must support PSK exchange mode](https://tools.ietf.org/html/rfc8446#section-2.3) (session cookies).

  > In addition, I would like to recommend [this](https://news.ycombinator.com/item?id=16667036) great discussion about TLS 1.3 and 0-RTT.

  If you are unsure to enable 0-RTT, look what Cloudflare say about it:

  > _Generally speaking, 0-RTT is safe for most web sites and applications. If your web application does strange things and you’re concerned about its replay safety, consider not using 0-RTT until you can be certain that there are no negative effects. [...] TLS 1.3 is a big step forward for web performance and security. By combining TLS 1.3 with 0-RTT, the performance gains are even more dramatic._

###### Example

Test 0-RTT with OpenSSL:

```bash
# 1)
_host="example.com"

cat > req.in << __EOF__
HEAD / HTTP/1.1
Host: $_host
Connection: close
__EOF__
# or:
# echo -e "GET / HTTP/1.1\r\nHost: $_host\r\nConnection: close\r\n\r\n" > req.in

openssl s_client -connect ${_host}:443 -tls1_3 -sess_out session.pem -ign_eof < req.in
openssl s_client -connect ${_host}:443 -tls1_3 -sess_in session.pem -early_data req.in

# 2)
python -m sslyze --early_data "$_host"
```

Enable 0-RTT with `$ssl_early_data` variable:

```bash
server {

  ...

  ssl_protocols   TLSv1.2 TLSv1.3;
  # To enable 0-RTT (TLS 1.3):
  ssl_early_data  on;

  location / {

    proxy_pass       http://backend_x20;
    # It protect against such attacks at the application layer:
    proxy_set_header Early-Data $ssl_early_data;

  }

  ...

}
```

###### External resources

- [Security Review of TLS1.3 0-RTT](https://github.com/tlswg/tls13-spec/issues/1001)
- [Introducing Zero Round Trip Time Resumption (0-RTT)](https://new.blog.cloudflare.com/introducing-0-rtt/)
- [What Application Developers Need To Know About TLS Early Data (0RTT)](https://blog.trailofbits.com/2019/03/25/what-application-developers-need-to-know-about-tls-early-data-0rtt/)
- [Replay Attacks on Zero Round-Trip Time: The Case of the TLS 1.3 Handshake Candidates](https://eprint.iacr.org/2017/082.pdf)
- [0-RTT and Anti-Replay](https://tools.ietf.org/html/rfc8446#section-8)
- [Using Early Data in HTTP (2017)](https://tools.ietf.org/id/draft-thomson-http-replay-00.html_)
- [Using Early Data in HTTP (2018)](https://tools.ietf.org/html/draft-ietf-httpbis-replay-04)
- [0-RTT Handshakes](https://ldapwiki.com/wiki/0-RTT%20Handshakes)

#### :beginner: Defend against the BEAST attack

###### Rationale

  > Generally the BEAST attack relies on a weakness in the way CBC mode is used in SSL/TLS.

  > More specifically, to successfully perform the BEAST attack, there are some conditions which needs to be met:
  >
  >   - vulnerable version of SSL must be used using a block cipher (CBC in particular)
  >   - JavaScript or a Java applet injection - should be in the same origin of the web site
  >   - data sniffing of the network connection must be possible

  > To prevent possible use BEAST attacks you should enable server-side protection, which causes the server ciphers should be preferred over the client ciphers, and completely excluded TLS 1.0 from your protocol stack.

###### Example

```bash
ssl_prefer_server_ciphers on;
```

###### External resources

- [An Illustrated Guide to the BEAST Attack](https://commandlinefanatic.com/cgi-bin/showarticle.cgi?article=art027)
- [Is BEAST still a threat?](https://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html)
- [Beat the BEAST with TLS 1.1/1.2 and More](https://blogs.cisco.com/security/beat-the-beast-with-tls)

#### :beginner: Mitigation of CRIME/BREACH attacks

###### Rationale

  > Disable HTTP compression or compress only zero sensitive content.

  > You should probably never use TLS compression. Some user agents (at least Chrome) will disable it anyways. Disabling SSL/TLS compression stops the attack very effectively. A deployment of HTTP/2 over TLS 1.2 must disable TLS compression (please see [RFC 7540: 9.2. Use of TLS Features](https://tools.ietf.org/html/rfc7540#section-9.2)).

  > CRIME exploits SSL/TLS compression which is disabled since nginx 1.3.2. BREACH exploits HTTP compression

  > Some attacks are possible (e.g. the real BREACH attack is a complicated) because of gzip (HTTP compression not TLS compression) being enabled on SSL requests. In most cases, the best action is to simply disable gzip for SSL.

  > Compression is not the only requirement for the attack to be done so using it does not mean that the attack will succeed. Generally you should consider whether having an accidental performance drop on HTTPS sites is better than HTTPS sites being accidentally vulnerable.

  > You shouldn't use HTTP compression on private responses when using TLS.

  > I would gonna to prioritise security over performance but compression can be (I think) okay to HTTP compress publicly available static content like css or js and HTML content with zero sensitive info (like an "About Us" page).

  > Remember: by default, NGINX doesn't compress image files using its per-request gzip module.

  > Gzip static module is better, for 2 reasons:
  >
  >   - you don't have to gzip for each request
  >   - you can use a higher gzip level

  > You should put the `gzip_static on;` inside the blocks that configure static files, but if you’re only running one site, it’s safe to just put it in the http block.

###### Example

```bash
# Disable dynamic HTTP compression:
gzip off;

# Enable dynamic HTTP compression for specific location context:
location / {

  gzip on;

  ...

}

# Enable static gzip compression:
location ^~ /assets/ {

  gzip_static on;

  ...

}
```

###### External resources

- [Is HTTP compression safe?](https://security.stackexchange.com/questions/20406/is-http-compression-safe)
- [HTTP compression continues to put encrypted communications at risk](https://www.pcworld.com/article/3051675/http-compression-continues-to-put-encrypted-communications-at-risk.html)
- [SSL/TLS attacks: Part 2 – CRIME Attack](http://niiconsulting.com/checkmate/2013/12/ssltls-attacks-part-2-crime-attack/)
- [Defending against the BREACH Attack](https://blog.qualys.com/ssllabs/2013/08/07/defending-against-the-breach-attack)
- [To avoid BREACH, can we use gzip on non-token responses?](https://security.stackexchange.com/questions/172581/to-avoid-breach-can-we-use-gzip-on-non-token-responses)
- [Don't Worry About BREACH](https://blog.ircmaxell.com/2013/08/dont-worry-about-breach.html)
- [Module ngx_http_gzip_static_module](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html)
- [Offline Compression with Nginx](https://theartofmachinery.com/2016/06/06/nginx_gzip_static.html)

#### :beginner: HTTP Strict Transport Security

###### Rationale

  > Generally HSTS is a way for websites to tell browsers that the connection should only ever be encrypted. This prevents MITM attacks, downgrade attacks, sending plain text cookies and session ids.

  > The header indicates for how long a browser should unconditionally refuse to take part in unsecured HTTP connection for a specific domain.

  > You had better be pretty sure that your website is indeed all HTTPS before you turn this on because HSTS adds complexity to your rollback strategy. Google recommend enabling HSTS this way:
  >
  >   1) Roll out your HTTPS pages without HSTS first
  >   2) Start sending HSTS headers with a short `max-age`. Monitor your traffic both from users and other clients, and also dependents' performance, such as ads
  >   3) Slowly increase the HSTS `max-age`
  >   4) If HSTS doesn't affect your users and search engines negatively, you can, if you wish, ask your site to be added to the HSTS preload list used by most major browsers

###### Example

```bash
add_header Strict-Transport-Security "max-age=63072000; includeSubdomains" always;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>A+</b>

###### External resources

- [HTTP Strict Transport Security Cheat Sheet](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)
- [Security HTTP Headers - Strict-Transport-Security](https://zinoui.com/blog/security-http-headers#strict-transport-security)
- [Is HSTS as a proper substitute for HTTP-to-HTTPS redirects?](https://www.reddit.com/r/bigseo/comments/8zw45d/is_hsts_as_a_proper_substitute_for_httptohttps/)
- [How to configure HSTS on www and other subdomains](https://www.danielmorell.com/blog/how-to-configure-hsts-on-www-and-other-subdomains)

#### :beginner: Reduce XSS risks (Content-Security-Policy)

###### Rationale

  > CSP reduce the risk and impact of XSS attacks in modern browsers.

  > Whitelisting known-good resource origins, refusing to execute potentially dangerous inline scripts, and banning the use of eval are all effective mechanisms for mitigating cross-site scripting attacks.

  > CSP is a good defence-in-depth measure to make exploitation of an accidental lapse in that less likely.

  > Before enable this header you should discuss with developers about it. They probably going to have to update your application to remove any inline script and style, and make some additional modifications there.

###### Example

```bash
# This policy allows images, scripts, AJAX, and CSS from the same origin, and does not allow any other resources to load.
add_header Content-Security-Policy "default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self';" always;
```

###### External resources

- [Content Security Policy (CSP) Quick Reference Guide](https://content-security-policy.com/)
- [Content Security Policy – OWASP](https://www.owasp.org/index.php/Content_Security_Policy)
- [Security HTTP Headers - Content-Security-Policy](https://zinoui.com/blog/security-http-headers#content-security-policy)

#### :beginner: Control the behaviour of the Referer header (Referrer-Policy)

###### Rationale

  > Determine what information is sent along with the requests.

###### Example

```bash
add_header Referrer-Policy "no-referrer";
```

###### External resources

- [A new security header: Referrer Policy](https://scotthelme.co.uk/a-new-security-header-referrer-policy/)
- [Security HTTP Headers - Referrer-Policy](https://zinoui.com/blog/security-http-headers#referrer-policy)

#### :beginner: Provide clickjacking protection (X-Frame-Options)

###### Rationale

  > Helps to protect your visitors against clickjacking attacks. It is recommended that you use the `x-frame-options` header on pages which should not be allowed to render a page in a frame.

###### Example

```bash
add_header X-Frame-Options "SAMEORIGIN" always;
```

###### External resources

- [Clickjacking Defense Cheat Sheet](https://www.owasp.org/index.php/Clickjacking_Defense_Cheat_Sheet)
- [Security HTTP Headers - X-Frame-Options](https://zinoui.com/blog/security-http-headers#x-frame-options)

#### :beginner: Prevent some categories of XSS attacks (X-XSS-Protection)

###### Rationale

  > Enable the cross-site scripting (XSS) filter built into modern web browsers.

###### Example

```bash
add_header X-XSS-Protection "1; mode=block" always;
```

###### External resources

- [X-XSS-Protection HTTP Header](https://www.tunetheweb.com/security/http-security-headers/x-xss-protection/)
- [Security HTTP Headers - X-XSS-Protection](https://zinoui.com/blog/security-http-headers#x-xss-protection)

#### :beginner: Prevent Sniff Mimetype middleware (X-Content-Type-Options)

###### Rationale

  > It prevents the browser from doing MIME-type sniffing (prevents "mime" based attacks).

###### Example

```bash
add_header X-Content-Type-Options "nosniff" always;
```

###### External resources

- [X-Content-Type-Options HTTP Header](https://www.keycdn.com/support/x-content-type-options)
- [Security HTTP Headers - X-Content-Type-Options](https://zinoui.com/blog/security-http-headers#x-content-type-options)

#### :beginner: Deny the use of browser features (Feature-Policy)

###### Rationale

  > This header protects your site from third parties using APIs that have security and privacy implications, and also from your own team adding outdated APIs or poorly optimised images.

###### Example

```bash
add_header Feature-Policy "geolocation 'none'; midi 'none'; notifications 'none'; push 'none'; sync-xhr 'none'; microphone 'none'; camera 'none'; magnetometer 'none'; gyroscope 'none'; speaker 'none'; vibrate 'none'; fullscreen 'none'; payment 'none'; usb 'none';";
```

###### External resources

- [Feature Policy Explainer](https://docs.google.com/document/d/1k0Ua-ZWlM_PsFCFdLMa8kaVTo32PeNZ4G7FFHqpFx4E/edit)
- [Policy Controlled Features](https://github.com/w3c/webappsec-feature-policy/blob/master/features.md)
- [Security HTTP Headers - Feature-Policy](https://zinoui.com/blog/security-http-headers#feature-policy)

#### :beginner: Reject unsafe HTTP methods

###### Rationale

  > Set of methods support by a resource. An ordinary web server supports the `HEAD`, `GET` and `POST` methods to retrieve static and dynamic content. Other (e.g. `OPTIONS`, `TRACE`) methods should not be supported on public web servers, as they increase the attack surface.

###### Example

```bash
add_header Allow "GET, POST, HEAD" always;

if ($request_method !~ ^(GET|POST|HEAD)$) {

  return 405;

}
```

###### External resources

- [Vulnerability name: Unsafe HTTP methods](https://www.onwebsecurity.com/security/unsafe-http-methods.html)

#### :beginner: Prevent caching of sensitive data

###### Rationale

  > This policy should be implemented by the application architect, however, I know from experience that this does not always happen.

  > Don' to cache or persist sensitive data. As browsers have different default behaviour for caching HTTPS content, pages containing sensitive information should include a `Cache-Control` header to ensure that the contents are not cached.

  > One option is to add anticaching headers to relevant HTTP/1.1 and HTTP/2 responses, e.g. `Cache-Control: no-cache, no-store` and `Expires: 0`.

  > To cover various browser implementations the full set of headers to prevent content being cached should be:
  >
  > `Cache-Control: no-cache, no-store, private, must-revalidate, max-age=0, no-transform`
  > `Pragma: no-cache`
  > `Expires: 0`

###### Example

```bash
location /api {

  expires 0;
  add_header Cache-Control "no-cache, no-store";

}
```

###### External resources

- [RFC 2616 - Hypertext Transfer Protocol (HTTP/1.1): Standards Track](https://tools.ietf.org/html/rfc2616)
- [RFC 7234 - Hypertext Transfer Protocol (HTTP/1.1): Caching](https://tools.ietf.org/html/rfc7234)
- [HTTP Cache Headers - A Complete Guide](https://www.keycdn.com/blog/http-cache-headers)
- [Caching best practices & max-age gotchas](https://jakearchibald.com/2016/caching-best-practices/)
- [Increasing Application Performance with HTTP Cache Headers](https://devcenter.heroku.com/articles/increasing-application-performance-with-http-cache-headers)
- [HTTP Caching](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching)

#### :beginner: Control Buffer Overflow attacks

###### Rationale

  > Buffer overflow attacks are made possible by writing data to a buffer and exceeding that buffers’ boundary and overwriting memory fragments of a process. To prevent this in NGINX we can set buffer size limitations for all clients.

###### Example

```bash
client_body_buffer_size 100k;
client_header_buffer_size 1k;
client_max_body_size 100k;
large_client_header_buffers 2 1k;
```

###### External resources

- [SCG WS nginx](https://www.owasp.org/index.php/SCG_WS_nginx)

#### :beginner: Mitigating Slow HTTP DoS attacks (Closing Slow Connections)

###### Rationale

  > Close connections that are writing data too infrequently, which can represent an attempt to keep connections open as long as possible.

  > You can close connections that are writing data too infrequently, which can represent an attempt to keep connections open as long as possible (thus reducing the server’s ability to accept new connections).

###### Example

```bash
client_body_timeout 10s;
client_header_timeout 10s;
keepalive_timeout 5s 5s;
send_timeout 10s;
```

###### External resources

- [Mitigating DDoS Attacks with NGINX and NGINX Plus](https://www.nginx.com/blog/mitigating-ddos-attacks-with-nginx-and-nginx-plus/)
- [SCG WS nginx](https://www.owasp.org/index.php/SCG_WS_nginx)
- [How to Protect Against Slow HTTP Attacks](https://blog.qualys.com/securitylabs/2011/11/02/how-to-protect-against-slow-http-attacks)
- [Effectively Using and Detecting The Slowloris HTTP DoS Tool](https://ma.ttias.be/effectively-using-detecting-the-slowloris-http-dos-tool/)

# Reverse Proxy

One of the frequent uses of the NGINX is setting it up as a proxy server.

#### :beginner: Use pass directive compatible with backend protocol

###### Rationale

  > All `proxy_*` directives are related to the backends that use the specific backend protocol.

  > You should use `proxy_pass` only for HTTP servers working on the backend layer (set also the `http://` protocol before referencing the HTTP backend) and other `*_pass` directives only for non-HTTP backend servers (like a uWSGI or FastCGI).

  > Directives such as `uwsgi_pass`, `fastcgi_pass`, or `scgi_pass` are designed specifically for non-HTTP apps and you should use them instead of the `proxy_pass` (non-HTTP talking).

  > For example: `uwsgi_pass` uses an uwsgi protocol. `proxy_pass` uses normal HTTP to talking with uWSGI server. uWSGI docs claims that uwsgi protocol is better, faster and can benefit from all of uWSGI special features. You can send to uWSGI information what type of data you are sending and what uWSGI plugin should be invoked to generate response. With http (`proxy_pass`) you won't get that.

###### Example

Bad configuration:

```bash
server {

  location /app/ {

    # For this, you should use uwsgi_pass directive.
    proxy_pass      192.168.154.102:4000;         # backend layer: uWSGI Python app.

  }

  ...

}

Good configuration:

```bash
server {

  location /app/ {

    proxy_pass      http://192.168.154.102:80;    # backend layer: OpenResty as a front for app.

  }

  location /app/v3 {

    uwsgi_pass      192.168.154.102:8080;         # backend layer: uWSGI Python app.

  }

  location /app/v4 {

    fastcgi_pass    192.168.154.102:8081;         # backend layer: php-fpm app.

  }
  ...

}
```

###### External resources

- [Passing a Request to a Proxied Server](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/#passing-a-request-to-a-proxied-server)
- [Reverse proxy (from this handbook)](#reverse-proxy)

#### :beginner: Be careful with trailing slashes in proxy_pass directive

###### Rationale

  > Be careful with trailing slashes because NGINX replaces part literally and you could end up with some strange url.

  > If `proxy_pass` used without URI (i.e. without path after `server:port`) NGINX will put URI from original request exactly as it was with all double slashes, `../` and so on.

  > URI in `proxy_pass` acts like alias directive, means NGINX will replace part that matches location prefix with URI in `proxy_pass` directive (which I intentionally made the same as location prefix) so URI will be the same as requested but normalized (without doule slashes and all that staff).

###### Example

```bash
location = /a {

  proxy_pass http://127.0.0.1:8080/a;

  ...

}

location ^~ /a/ {

  proxy_pass http://127.0.0.1:8080/a/;

  ...

}
```

###### External resources

- [ngx_http_proxy_module - proxy_pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)

#### :beginner: Set and pass Host header only with $host variable

###### Rationale

  > You should almost always use `$host` as a incoming host variable, because it's the only one guaranteed to have something sensible regardless of how the user-agent behaves, unless you specifically need the semantics of one of the other variables.

  > `$host` is simply `$http_host` with some processing (stripping port number and lowercasing) and a default value (of the `server_name`), so there's no less "exposure" to the `Host` header sent by the client when using `$http_host`. There's no danger in this though.

  > The difference is explained in the NGINX documentation:
  >
  >   - `$host` contains "in this order of precedence: host name from the request line, or host name from the 'Host' request header field, or the server name matching a request"
  >   - `$http_host` contains the content of the HTTP `Host` header field, if it was present in the request (equals always the `HTTP_HOST` request header)
  >   - `$server_name` contains the `server_name` of the virtual host which processed the request, as it was defined in the NGINX configuration. If a server contains multiple server names, only the first one will be present in this variable

  > `http_host`, moreover, is better than `$host:$server_port` because it uses the port as present in the URL, unlike `$server_port` which uses the port that NGINX listens on.

###### Example

```bash
proxy_set_header    Host    $host;
```

###### External resources

- [RFC2616 - 5.2 The Resource Identified by a Request](http://tools.ietf.org/html/rfc2616#section-5.2)
- [RFC2616 - 14.23 Host](http://tools.ietf.org/html/rfc2616#section-14.23)
- [Nginx proxy_set_header - Host header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header)
- [What is the difference between Nginx variables $host, $http_host, and $server_name?](https://serverfault.com/questions/706438/what-is-the-difference-between-nginx-variables-host-http-host-and-server-na/706439#706439)
- [HTTP_HOST and SERVER_NAME Security Issues](https://expressionengine.com/blog/http-host-and-server-name-security-issues)
- [Reasons to use '$http_host' instead of '$host' with 'proxy_set_header Host' in template?](https://github.com/jwilder/nginx-proxy/issues/763#issuecomment-286481168)
- [Tip: keep the Host header via nginx proxy_pass](https://www.simplicidade.org/notes/2011/02/15/tip-keep-the-host-header-via-nginx-proxy_pass/)
- [What is a Host Header Attack?](https://www.acunetix.com/blog/articles/automated-detection-of-host-header-attacks/)
- [Practical HTTP Host header attacks](https://www.skeletonscribe.net/2013/05/practical-http-host-header-attacks.html)

#### :beginner: Set properly values of the X-Forwarded-For header

###### Rationale

  > In the light of the latest httpoxy vulnerabilities, there is really a need for a full example, how to use `HTTP_X_FORWARDED_FOR` properly. In short, the load balancer sets the 'most recent' part of the header. In my opinion, for security reasons, the proxy servers must be specified by the administrator manually.

  > `X-Forwarded-For` is the custom HTTP header that carries along the original IP address of a client so the app at the other end knows what it is. Otherwise it would only see the proxy IP address, and that makes some apps angry.

  > The `X-Forwarded-For` depends on the proxy server, which should actually pass the IP address of the client connecting to it. Where a connection passes through a chain of proxy servers, `X-Forwarded-For` can give a comma-separated list of IP addresses with the first being the furthest downstream (that is, the user). Because of this, servers behind proxy servers need to know which of them are trustworthy.

  > The proxy used can set this header to anything it wants to, and therefore you can't trust its value. Most proxies do set the correct value though. This header is mostly used by caching proxies, and in those cases you're in control of the proxy and can thus verify that is gives you the correct information. In all other cases its value should be considered untrustworthy.

  > Some systems also use `X-Forwarded-For` to enforce access control. A good number of applications rely on knowing the actual IP address of a client to help prevent fraud and enable access.

  > Value of the `X-Forwarded-For` header field can be set at the client's side - this can also be termed as `X-Forwarded-For` spoofing. However, when the web request is made via a proxy server, the proxy server modifies the `X-Forwarded-For` field by appending the IP address of the client (user). This will result in 2 comma separated IP addresses in the `X-Forwarded-For` field.

  > A reverse proxy is not source IP address transparent. This is a pain when you need the client source IP address to be correct in the logs of the backend servers. I think the best solution of this problem is configure the load balancer to add/modify an `X-Forwarded-For` header with the source IP of the client and forward it to the backend in the correct form.

  > Unfortunately, on the proxy side we are not able to solve this problem (all solutions can be spoofable), it is important that this header is correctly interpreted by application servers. Doing so ensures that the apps or downstream services have accurate information on which to make their decisions, including those regarding access and authorization.

  There is also an interesing idea what to do in this situation:

  > _To prevent this we must distrust that header by default and follow the IP address breadcrumbs backwards from our server. First we need to make sure the `REMOTE_ADDR` is someone we trust to have appended a proper value to the end of `X-Forwarded-For`. If so then we need to make sure we trust the `X-Forwarded-For` IP to have appended the proper IP before it, so on and so forth. Until, finally we get to an IP we don’t trust and at that point we have to assume that’s the IP of our user._ - it comes from [Proxies & IP Spoofing](https://xyu.io/2013/07/04/proxies-ip-spoofing/) by [Xiao Yu](https://github.com/xyu).

###### Example

```bash
# The whole purpose that it exists is to do the appending behavior:
proxy_set_header    X-Forwarded-For    $proxy_add_x_forwarded_for;
# Above is equivalent for this:
proxy_set_header    X-Forwarded-For    $http_x_forwarded_for,$remote_addr;
# The following is also equivalent for above but in this example we use http_realip_module:
proxy_set_header    X-Forwarded-For    "$http_x_forwarded_for, $realip_remote_addr";
```

###### External resources

- [Prevent X-Forwarded-For Spoofing or Manipulation](https://totaluptime.com/kb/prevent-x-forwarded-for-spoofing-or-manipulation/)
- [Bypass IP blocks with the X-Forwarded-For header](https://www.sjoerdlangkemper.nl/2017/03/01/bypass-ip-block-with-x-forwarded-for-header/)
- [Forwarded header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Forwarded)

#### :beginner: Don't use X-Forwarded-Proto with $scheme behind reverse proxy

###### Rationale

  > `X-Forwarded-Proto` can be set by the reverse proxy to tell the app whether it is HTTPS or HTTP or even an invalid name.

  > The scheme (i.e. HTTP, HTTPS) variable evaluated only on demand (used only for the current request).

  > Setting the `$scheme` variable will cause distortions if it uses more than one proxy along the way. For example: if the client go to the `https://example.com`, the proxy stores the scheme value as HTTPS. If the communication between the proxy and the next-level proxy takes place over HTTP, then the backend sees the scheme as HTTP. So if you set `$scheme` for X-Forwarded-Proto on the next-level proxy, app will see a different value than the one the client came with.

  > For resolve this problem you can also use [this](#set-correct-scheme-passed-in-x-forwarded-proto)) configuration snippet.

###### Example

```bash
# 1) client <-> proxy <-> backend
proxy_set_header    X-Forwarded-Proto  $scheme;

# 2) client <-> proxy <-> proxy <-> backend
# proxy_set_header  X-Forwarded-Proto  https;
proxy_set_header    X-Forwarded-Proto  $proxy_x_forwarded_proto;
```

###### External resources

- [Reverse Proxy - Passing headers (from this handbook)](#passing-headers)

#### :beginner: Always pass Host, X-Real-IP, and X-Forwarded stack headers to the backend

###### Rationale

  > When using NGINX as a reverse proxy you may want to pass through some information of the remote client to your backend web server. I think it's good practices because gives you more control of forwarded headers.

  > It's very important for servers behind proxy because it allow to interpret the client correctly. Proxies are the "eyes" of such servers, they should not allow a curved perception of reality. If not all requests are passed through a proxy, as a result, requests received directly from clients may contain e.g. inaccurate IP addresses in headers.

  > X-Forwarded headers are also important for statistics or filtering. Other example could be access control rules on your app, because without these headers filtering mechanism may not working properly.

  > If you use a front-end service like Apache or whatever else as the front-end to your APIs, you will need these headers to understand what IP or hostname was used to connect to the API.

  > Forwarding these headers is also important if you use the https protocol (it has become a standard nowadays).

  > However, I would not rely on either the presence of all X-Forwarded headers, or the validity of their data.

###### Example

```bash
location / {

  proxy_pass          http://bk_upstream_01;

  # The following headers also should pass to the backend:
  #   - Host - host name from the request line, or host name from the Host request header field, or the server name matching a request
  # proxy_set_header  Host               $host:$server_port;
  # proxy_set_header  Host               $http_host;
  proxy_set_header    Host               $host;

  #   - X-Real-IP - forwards the real visitor remote IP address to the proxied server
  proxy_set_header    X-Real-IP          $remote_addr;

  # X-Forwarded headers stack:
  #   - X-Forwarded-For - mark origin IP of client connecting to server through proxy
  # proxy_set_header  X-Forwarded-For    $remote_addr;
  # proxy_set_header  X-Forwarded-For    $http_x_forwarded_for,$remote_addr;
  # proxy_set_header  X-Forwarded-For    "$http_x_forwarded_for, $realip_remote_addr";
  proxy_set_header    X-Forwarded-For    $proxy_add_x_forwarded_for;

  #   - X-Forwarded-Host - mark origin host of client connecting to server through proxy
  # proxy_set_header  X-Forwarded-Host   $host:443;
  proxy_set_header    X-Forwarded-Host   $host:$server_port;

  #   - X-Forwarded-Server - the hostname of the proxy server
  proxy_set_header    X-Forwarded-Server $host;

  #   - X-Forwarded-Port - defines the original port requested by the client
  # proxy_set_header  X-Forwarded-Port   443;
  proxy_set_header    X-Forwarded-Port   $server_port;

  #   - X-Forwarded-Proto - mark protocol of client connecting to server through proxy
  # proxy_set_header  X-Forwarded-Proto  https;
  # proxy_set_header  X-Forwarded-Proto  $proxy_x_forwarded_proto;
  proxy_set_header    X-Forwarded-Proto  $scheme;

}
```

###### External resources

- [Reverse Proxy - Passing headers (from this handbook)](#passing-headers)
- [Set properly values of the X-Forwarded-For header (from this handbook)](#beginner-set-properly-values-of-the-x-forwarded-for-header)
- [Don't use X-Forwarded-Proto with $scheme behind reverse proxy (from this handbook)](#beginner-dont-use-x-forwarded-proto-with-scheme-behind-reverse-proxy)
- [Forwarding Visitor’s Real-IP + Nginx Proxy/Fastcgi backend correctly](https://easyengine.io/tutorials/nginx/forwarding-visitors-real-ip/)
- [Using the Forwarded header](https://www.nginx.com/resources/wiki/start/topics/examples/forwarded/)

#### :beginner: Use custom headers without X- prefix

###### Rationale

  > Internet Engineering Task Force released a new RFC ([RFC-6648](https://tools.ietf.org/html/rfc6648)), recommending deprecation of `X-` prefix.

  > The `X-` in front of a header name customarily has denoted it as experimental/non-standard/vendor-specific. Once it's a standard part of HTTP, it'll lose the prefix.

  > If it’s possible for new custom header to be standardized, use a non-used and meaningful header name.

  > The use of custom headers with `X-` prefix is not forbidden but discouraged. In other words, you can keep using `X-` prefixed headers, but it's not recommended and you may not document them as if they are public standard.

###### Example

Not recommended configuration:

```bash
add_header X-Backend-Server $hostname;
```

Recommended configuration:

```bash
add_header Backend-Server   $hostname;
```

###### External resources

- [Use of the "X-" Prefix in Application Protocols](https://tools.ietf.org/html/draft-saintandre-xdash-00)
- [Custom HTTP headers : naming conventions](https://stackoverflow.com/questions/3561381/custom-http-headers-naming-conventions/3561399#3561399)

# Load Balancing

Load balancing is a useful mechanism to distribute incoming traffic around several capable servers. We may improve of some rules about the NGINX working as a load balancer.

#### :beginner: Tweak passive health checks

###### Rationale

  > Monitoring for health is important on all types of load balancing mainly for business continuity. Passive checks watches for failed or timed-out connections as they pass through NGINX as requested by a client.

  > This functionality is enabled by default but the parameters mentioned here allow you to tweak their behaviour. Default values are: `max_fails=1` and `fail_timeout=10s`.

###### Example

```bash
upstream backend {

  server bk01_node:80 max_fails=3 fail_timeout=5s;
  server bk02_node:80 max_fails=3 fail_timeout=5s;

}
```

###### External resources

- [Module ngx_http_upstream_module](https://nginx.org/en/docs/http/ngx_http_upstream_module.html)

#### :beginner: Don't disable backends by comments, use `down` parameter

###### Rationale

  > Sometimes we need to turn off backends e.g. at maintenance-time. I think good solution is marks the server as permanently unavailable with `down` parameter even if the downtime takes a short time.

  > It's also important if you use IP Hash load balancing technique. If one of the servers needs to be temporarily removed, it should be marked with this parameter in order to preserve the current hashing of client IP addresses.

  > Comments are good for really permanently disable servers or if you want to leave information for historical purposes.

  > NGINX also provides a `backup` parameter which marks the server as a backup server. It will be passed requests when the primary servers are unavailable. I use this option rarely for the above purposes and only if I am sure that the backends will work at the maintenance time.

###### Example

```bash
upstream backend {

  server bk01_node:80 max_fails=3 fail_timeout=5s down;
  server bk02_node:80 max_fails=3 fail_timeout=5s;

}
```

###### External resources

- [Module ngx_http_upstream_module](https://nginx.org/en/docs/http/ngx_http_upstream_module.html)

# Others

This rules aren't strictly related to the NGINX but in my opinion they're also very important aspect of security.

#### :beginner: Enable DNS CAA Policy

###### Rationale

  > DNS CAA policy helps you to control which Certificat Authorities are allowed to issue certificates for your domain becaues if no CAA record is present, any CA is allowed to issue a certificate for the domain.

###### Example

Generic configuration (Google Cloud DNS, Route 53, OVH, and other hosted services) for Let's Encrypt:

```bash
example.com. CAA 0 issue "letsencrypt.org"
```

Standard Zone File (BIND, PowerDNS and Knot DNS) for Let's Encrypt:

```bash
example.com. IN CAA 0 issue "letsencrypt.org"
```

###### External resources

- [DNS Certification Authority Authorization (CAA) Resource Record](https://tools.ietf.org/html/rfc6844)
- [CAA Records](https://support.dnsimple.com/articles/caa-record/)
- [CAA Record Helper](https://sslmate.com/caa/)

#### :beginner: Define security policies with `security.txt`

###### Rationale

  > The main purpose of `security.txt` is to help make things easier for companies and security researchers when trying to secure platforms. It also provides information to assist in disclosing security vulnerabilities.

  > When security researchers detect potential vulnerabilities in a page or application, they will try to contact someone "appropriate" to "responsibly" reveal the problem. It's worth taking care of getting to the right address.

  > This file should be placed under the `/.well-known/` path, e.g. `/.well-known/security.txt` ([RFC5785](https://tools.ietf.org/html/rfc5785)) of a domain name or IP address for web properties.

###### Example

```bash
curl -ks https://example.com/.well-known/security.txt

Contact: security@example.com
Contact: +1-209-123-0123
Encryption: https://example.com/pgp.txt
Preferred-Languages: en
Canonical: https://example.com/.well-known/security.txt
Policy: https://example.com/security-policy.html
```

And from Google:

```bash
curl -ks https://www.google.com/.well-known/security.txt

Contact: https://g.co/vulnz
Contact: mailto:security@google.com
Encryption: https://services.google.com/corporate/publickey.txt
Acknowledgements: https://bughunter.withgoogle.com/
Policy: https://g.co/vrp
Hiring: https://g.co/SecurityPrivacyEngJobs
# Flag: BountyCon{075e1e5eef2bc8d49bfe4a27cd17f0bf4b2b85cf}
```

###### External resources

- [A Method for Web Security Policies](https://tools.ietf.org/html/draft-foudil-securitytxt-05)
- [security.txt](https://securitytxt.org/)

# Configuration Examples

  > Remember to make a copy of the current configuration and all files/directories.

This chapter is still work in progress.

## Installation

I used step-by-step tutorial from this handbook [Installing from source](#installing-from-source).

## Configuration

I used Google Cloud instance with following parameters:

| <b>ITEM</b> | <b>VALUE</b> | <b>COMMENT</b> |
| :---         | :---         | :---         |
| VM | Google Cloud Platform | |
| vCPU | 2x | |
| Memory | 4096MB | |
| HTTP | Varnish on port 80 | |
| HTTPS | NGINX on port 443 | |

## Reverse Proxy

This chapter describes the basic configuration of my proxy server (for [blkcipher.info](https://blkcipher.info) domain).

  > Configuration is based on the [installation from source](#installing-from-source) chapter. If you go through the installation process step by step you can use the following configuration (minor adjustments may be required).

#### Import configuration

It's very simple - clone the repo, backup your current configuration and perform full directory sync:

```bash
git clone https://github.com/trimstray/nginx-admins-handbook

tar czvfp ~/nginx.etc.tgz /etc/nginx && mv /etc/nginx /etc/nginx.old

rsync -avur lib/nginx/ /etc/nginx/
```

  > If you compiled NGINX from source you should also update/refresh modules. All compiled modules are stored in `/usr/local/src/nginx-${ngx_version}/master/objs` and installed in accordance with the value of the `--modules-path` variable.

#### Set bind IP address

###### Find and replace 192.168.252.2 string in directory and file names

```bash
cd /etc/nginx
find . -depth -not -path '*/\.git*' -name '*192.168.252.2*' -execdir bash -c 'mv -v "$1" "${1//192.168.252.2/xxx.xxx.xxx.xxx}"' _ {} \;
```

###### Find and replace 192.168.252.2 string in configuration files

```bash
cd /etc/nginx
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/192.168.252.2/xxx.xxx.xxx.xxx/g'
```

#### Set your domain name

###### Find and replace blkcipher.info string in directory and file names

```bash
cd /etc/nginx
find . -not -path '*/\.git*' -depth -name '*blkcipher.info*' -execdir bash -c 'mv -v "$1" "${1//blkcipher.info/example.com}"' _ {} \;
```

###### Find and replace blkcipher.info string in configuration files

```bash
cd /etc/nginx
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/blkcipher_info/example_com/g'
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/blkcipher.info/example.com/g'
```

#### Regenerate private keys and certs

###### For localhost

```bash
cd /etc/nginx/master/_server/localhost/certs

# Private key + Self-signed certificate:
( _fd="localhost.key" ; _fd_crt="nginx_localhost_bundle.crt" ; \
openssl req -x509 -newkey rsa:2048 -keyout ${_fd} -out ${_fd_crt} -days 365 -nodes \
-subj "/C=X0/ST=localhost/L=localhost/O=localhost/OU=X00/CN=localhost" )
```

###### For `default_server`

```bash
cd /etc/nginx/master/_server/defaults/certs

# Private key + Self-signed certificate:
( _fd="defaults.key" ; _fd_crt="nginx_defaults_bundle.crt" ; \
openssl req -x509 -newkey rsa:2048 -keyout ${_fd} -out ${_fd_crt} -days 365 -nodes \
-subj "/C=X1/ST=default/L=default/O=default/OU=X11/CN=default_server" )
```

###### For your domain (e.g. Let's Encrypt)

```bash
cd /etc/nginx/master/_server/example.com/certs

# For multidomain:
certbot certonly -d example.com -d www.example.com --rsa-key-size 2048

# For wildcard:
certbot certonly --manual --preferred-challenges=dns -d example.com -d *.example.com --rsa-key-size 2048

# Copy private key and chain:
cp /etc/letsencrypt/live/example.com/fullchain.pem nginx_example.com_bundle.crt
cp /etc/letsencrypt/live/example.com/privkey.pem example.com.key
```

#### Update modules list

Update modules list and include `modules.conf` to your configuration:

```bash
_mod_dir="/etc/nginx/modules"

:>"${_mod_dir}.conf"

for _module in $(ls "${_mod_dir}/") ; do echo -en "load_module\t\t${_mod_dir}/$_module;\n" >> "${_mod_dir}.conf" ; done
```

#### Generating the necessary error pages

  > In the example (`lib/nginx`) error pages are included from `lib/nginx/master/_static/errors.conf` file.

- default location: `/etc/nginx/html`:
  ```bash
  50x.html  index.html
  ```
- custom location: `/usr/share/www`:
  ```bash
  cd /etc/nginx/snippets/http-error-pages

  ./httpgen

  # You can also sync sites/ directory with /etc/nginx/html:
  #   rsync -var sites/ /etc/nginx/html/
  rsync -var sites/ /usr/share/www/
  ```

#### Add new domain

###### Updated `nginx.conf`

```bash
# At the end of the file (in 'IPS/DOMAINS' section):
include /etc/nginx/master/_server/domain.com/servers.conf;
include /etc/nginx/master/_server/domain.com/backends.conf;
```
###### Init domain directory

```bash
cd /etc/nginx/cd master/_server
cp -R example.com domain.com

cd domain.com
find . -not -path '*/\.git*' -depth -name '*example.com*' -execdir bash -c 'mv -v "$1" "${1//example.com/domain.com}"' _ {} \;
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/example_com/domain_com/g'
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/example.com/domain.com/g'
```

#### Create log directories

```bash
mkdir -p /var/log/nginx/localhost
mkdir -p /var/log/nginx/defaults
mkdir -p /var/log/nginx/others
mkdir -p /var/log/nginx/domains/blkcipher.info

chown -R nginx:nginx /var/log/nginx
```

#### Logrotate configuration

```bash
cp /etc/nginx/snippets/logrotate.d/nginx /etc/logrotate.d/
```

#### Test your configuration

```bash
nginx -t -c /etc/nginx/nginx.conf
```
