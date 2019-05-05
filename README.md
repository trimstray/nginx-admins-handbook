<div align="center">
  <h1>Nginx Admin's Handbook</h1>
</div>

<div align="center">
  <b><code>My notes on Nginx administration basics, tips & tricks, caveats, and gotchas.</code></b>
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
  * [General disclaimer](#general-disclaimer)
  * [Contributing & Support](#contributing--support)
  * [Reports: blkcipher.info](#reports-blkcipherinfo)
    * [SSL Labs](#ssl-labs)
    * [Mozilla Observatory](#mozilla-observatory)
  * [Printable high-res hardening checklists](#printable-high-res-hardening-checklists)
- **[Books](#books)**
  * [Nginx Essentials](#nginx-essentials)
  * [Nginx Cookbook](#nginx-cookbook)
  * [Nginx HTTP Server](#nginx-http-server)
  * [Nginx High Performance](#nginx-high-performance)
  * [Mastering Nginx](#mastering-nginx)
- **[External Resources](#external-resources)**
  * [About Nginx](#about-nginx)
  * [Based on the Nginx](#based-on-the-nginx)
  * [Cheatsheets & References](#cheatsheets--references)
  * [Performance & Hardening](#performance--hardening)
  * [Playgrounds](#playgrounds)
  * [Config generators](#config-generators)
  * [Static analyzers](#static-analyzers)
  * [Log analyzers](#log-analyzers)
  * [Performance analyzers](#performance-analyzers)
  * [Benchmarking tools](#benchmarking-tools)
  * [Development](#development)
  * [Online tools](#online-tools)
  * [Other stuff](#other-stuff)
- **[Helpers](#helpers)**
  * [Nginx directories and files](#nginx-directories-and-files)
  * [Nginx commands](#nginx-commands)
  * [Nginx processes](#nginx-processes)
  * [Configuration syntax](#configuration-syntax)
  * [Nginx contexts](#nginx-contexts)
  * [Request processing stages](#request-processing-stages)
  * [Connection processing](#connection-processing)
  * [Server blocks](#server-blocks)
    * [Server blocks logic](#server-blocks-logic)
    * [The listen directive](#the-listen-directive)
    * [Matching location](#matching-location)
  * [Error log severity levels](#error-log-severity-levels)
  * [Rate Limiting](#rate-limiting)
  * [Analyse configuration](#analyse-configuration)
  * [Monitoring](#monitoring)
    * [GoAccess](#goaccess)
      * [Analyse log file and enable all recorded statistics](#analyse-log-file-and-enable-all-recorded-statistics)
      * [Analyse compressed log file](#analyse-compressed-log-file)
      * [Analyse log file remotely](#analyse-log-file-remotely)
      * [Analyse log file and generate html report](#analyse-log-file-and-generate-html-report)
    * [Ngxtop](#ngxtop)
      * [Analyse log file](#analyse-log-file)
      * [Analyse log file and print requests with 4xx and 5xx](#analyse-log-file-and-print-requests-with-4xx-and-5xx)
      * [Analyse log file remotely](##analyse-log-file-remotely-1)
  * [Debugging](#debugging)
    * [Check if the module has been compiled](#check-if-the-module-has-been-compiled)
    * [See the top 5 IP addresses in a web server log](#see-the-top-5-ip-addresses-in-a-web-server-log)
    * [Analyse web server log and show only 2xx http codes](#analyse-web-server-log-and-show-only-2xx-http-codes)
    * [Analyse web server log and show only 5xx http codes](#analyse-web-server-log-and-show-only-5xx-http-codes)
    * [Get range of dates in a web server log](#get-range-of-dates-in-a-web-server-log)
    * [Get line rates from web server log](#get-line-rates-from-web-server-log)
    * [Trace network traffic for all Nginx processes](#trace-network-traffic-for-all-nginx-processes)
    * [List all files accessed by a Nginx](#list-all-files-accessed-by-a-nginx)
  * [Shell aliases](#shell-aliases)
  * [Configuration snippets](#configuration-snippets)
    * [Restricting access with basic authentication](#restricting-access-with-basic-authentication)
    * [Blocking/allowing IP addresses](#blockingallowing-ip-addresses)
    * [Blocking referrer spam](#blocking-referrer-spam)
    * [Limiting referrer spam](#limiting-referrer-spam)
    * [Limiting the rate of requests with burst mode](#limiting-the-rate-of-requests-with-burst-mode)
    * [Limiting the rate of requests with burst mode and nodelay](#limiting-the-rate-of-requests-with-burst-mode-and-nodelay)
    * [Limiting the number of connections](#limiting-the-number-of-connections)
 * [Installation from source](#installation-from-source)
    * [Dependencies](#dependencies)
    * [Nginx package](#nginx-package)
    * [Example of installation on Ubuntu](#example-of-installation-on-ubuntu)
      * [Pre installation tasks](#pre-installation-tasks)
      * [Install or build dependencies](#install-or-build-dependencies)
      * [Get Nginx sources](#get-nginx-sources)
      * [Download 3rd party modules](#download-3rd-party-modules)
      * [Build Nginx](#build-nginx)
      * [Post installation tasks](#post-installation-tasks)
  * [Installation from prebuilt packages](#installation-from-prebuilt-packages)
    * [RHEL7 or CentOS 7](#rhel7-or-centos-7)
    * [Debian or Ubuntu](#debian-or-ubuntu)
  * [Tengine Web Server](#tengine-web-server)
    * [Example of installation on Ubuntu](#example-of-installation-on-ubuntu-1)
      * [Pre installation tasks](#pre-installation-tasks-1)
      * [Install or build dependencies](#install-or-build-dependencies-1)
      * [Get Tengine sources](#get-tengine-sources)
      * [Download 3rd party modules](#download-3rd-party-modules-1)
      * [Build Tengine](#build-tengine)
      * [Post installation tasks](#post-installation-tasks-1)
- **[Base Rules](#base-rules)**
  * [Organising Nginx configuration](#beginner-organising-nginx-configuration)
  * [Separate listen directives for 80 and 443](#beginner-separate-listen-directives-for-80-and-443)
  * [Define the listen directives explicitly with address:port pair](#beginner-define-the-listen-directives-explicitly-with-addressport-pair)
  * [Prevent processing requests with undefined server names](#beginner-prevent-processing-requests-with-undefined-server-names)
  * [Use reload method to change configurations on the fly](#beginner-use-reload-method-to-change-configurations-on-the-fly)
  * [Use only one SSL config for specific listen directive](#beginner-use-only-one-ssl-config-for-specific-listen-directive)
  * [Force all connections over TLS](#beginner-force-all-connections-over-tls)
  * [Use geo/map modules instead allow/deny](#beginner-use-geomap-modules-instead-allowdeny)
  * [Map all the things...](#beginner-map-all-the-things)
  * [Drop the same root inside location block](#beginner-drop-the-same-root-inside-location-block)
  * [Use debug mode for debugging](#beginner-use-debug-mode-for-debugging)
  * [Use custom log formats for debugging](#beginner-use-custom-log-formats-for-debugging)
- **[Performance](#performance)**
  * [Adjust worker processes](#beginner-adjust-worker-processes)
  * [Use HTTP/2](#beginner-use-http2)
  * [Maintaining SSL sessions](#beginner-maintaining-ssl-sessions)
  * [Use exact names in server_name directive where possible](#beginner-use-exact-names-in-server-name-directive-where-possible)
  * [Avoid checks server_name with if directive](#beginner-avoid-checks-server_name-with-if-directive)
  * [Make an exact location match to speed up the selection process](#beginner-make-an-exact-location-match-to-speed-up-the-selection-process)
  * [Use limit_conn to improve limiting the download speed](#beginner-use-limit_conn-to-improve-limiting-the-download-speed)
- **[Hardening](#hardening)**
  * [Run as an unprivileged user](#beginner-run-as-an-unprivileged-user)
  * [Disable unnecessary modules](#beginner-disable-unnecessary-modules)
  * [Protect sensitive resources](#beginner-protect-sensitive-resources)
  * [Hide Nginx version number](#beginner-hide-nginx-version-number)
  * [Hide Nginx server signature](#beginner-hide-nginx-server-signature)
  * [Hide upstream proxy headers](#beginner-hide-upstream-proxy-headers)
  * [Use min. 2048-bit private keys](#beginner-use-min-2048-bit-private-keys)
  * [Keep only TLS 1.2 and TLS 1.3](#beginner-keep-only-tls-12-and-tls-13)
  * [Use only strong ciphers](#beginner-use-only-strong-ciphers)
  * [Use more secure ECDH Curve](#beginner-use-more-secure-ecdh-curve)
  * [Use strong Key Exchange](#beginner-use-strong-key-exchange)
  * [Defend against the BEAST attack](#beginner-defend-against-the-beast-attack)
  * [Disable HTTP compression (mitigation of CRIME/BREACH attacks)](#beginner-disable-http-compression-mitigation-of-crimebreach-attacks)
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
- **[Load Balancing](#load-balancing)**
  * [Tweak passive health checks](#beginner-tweak-passive-health-checks)
  * [Don't disable backends by comments, use down parameter](#beginner-dont-disable-backends-by-comments-use-down-parameter)
- **[Others](#others)**
  * [Enable DNS CAA Policy](#beginner-enable-dns-caa-policy)
- **[Configuration Examples](#configuration-examples)**
  * [Reverse Proxy](#reverse-proxy)
    * [Installation](#installation)
    * [Configuration](#configuration)
    * [Import configuration](#import-configuration)
    * [Set bind IP address](#set-bind-ip-address)
    * [Set your domain name](#set-your-domain-name)
    * [Regenerate private keys and certs](#regenerate-private-keys-and-certs)
    * [Add new domain](#add-new-domain)
    * [Test your configuration](#test-your-configuration)

# Introduction

<a href="https://www.nginx.com/"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx_logo.png" align="right"></a>

  > Before using the **Nginx** please read **[Beginner’s Guide](http://nginx.org/en/docs/beginners_guide.html)**.

<p align="justify"><b>Nginx</b> (<i>/ˌɛndʒɪnˈɛks/ EN-jin-EKS</i>) is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev. For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler.</p>

To increase your knowledge, read **[Nginx Documentation](https://nginx.org/en/docs/)**.

Nginx is a fast, light-weight and powerful web server that can also be used as a load balancer and caching server. It provides the core of complete web stacks.

## General disclaimer

This is not an official document. It is rather a collection of some rules and papers, best practices and recommendations used by me (also in production environments but not only), and which may be useful especially for other administrators. Many of these rules refer to external resources.

Throughout this handbook you will explore the many features of Nginx and how to use them. This guide is fairly comprehensive, and touches a lot of the functions (e.g. security, performance) of Nginx server.

I created this repository to helps us to configure high performing Nginx web and proxy servers that are fast, secure and stable.

Before you start remember about the two most important things:

  > **`Do not follow guides just to get 100% of something. Think about what you actually do at your server!`**

  > **`These guidelines provides recommendations for very restrictive setup.`**

## Contributing & Support

If you find something which doesn't make sense, or something doesn't seem right, please make a pull request and please add valid and well-reasoned explanations about your changes or comments.

Before adding a pull request, please see the **[contributing guidelines](CONTRIBUTING.md)**.

If this project is useful and important for you, you can bring **positive energy** by giving some **good words** or **supporting this project**. Thank you!

## Reports: blkcipher.info

Many of these recipes have been applied to the configuration of my private website.

  > An example configuration is in [configuration examples](#configuration-examples) chapter.

  > Is also based on this version of [printable high-res hardening checklist](https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx-hardening-checklist-tls13.png).

### SSL Labs

  > Read about SSL Labs grading [here](https://community.qualys.com/docs/DOC-6321-ssl-labs-grading-2018) (SSL Labs Grading 2018).

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

I also got the highest note from Mozilla:

<p align="center">
  <a href="https://observatory.mozilla.org/analyze/blkcipher.info?third-party=false">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/blkcipher_mozilla_observatory_preview.png" alt="blkcipher_mozilla_observatory_preview">
  </a>
</p>

## Printable high-res hardening checklists

Hardening checklists (High-Res 5000x8200) based on these recipes:

  > For `*.xcf` and `*.pdf` formats please see [this](https://github.com/trimstray/nginx-admins-handbook/tree/master/static/img) directory.

- **A+** with all **100%’s** on @ssllabs and **120/100** on @mozilla observatory:

  > It provides very restrictive setup with 4096-bit private key, only TLS 1.2 and also modern strict TLS cipher suites (non 128-bits).

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx-hardening-checklist-tls12-100p.png" alt="nginx-hardening-checklist-100p" width="75%" height="75%">
</p>

- **A+** on @ssllabs and **120/100** on @mozilla observatory with TLS 1.3 support:

  > It provides less restrictive setup with 2048-bit private key, TLS 1.2 and 1.3 and also modern strict TLS cipher suites.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx-hardening-checklist-tls13.png" alt="nginx-hardening-checklist-tls13" width="75%" height="75%">
</p>

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
- _Step–by-step tutorials for performance testing using open source software_
- _Tune the TCP stack to make the most of the available infrastructure_

<sup><i>This short review comes from this book or the store.</i></sup>

#### [Mastering Nginx](https://www.amazon.com/Mastering-Nginx-Dimitri-Aivaliotis/dp/1849517444)

Authors: **Dimitri Aivaliotis**

_Written for experienced systems administrators and engineers, this book teaches you from scratch how to configure Nginx for any situation. Step-by-step instructions and real-world code snippets clarify even the most complex areas._

<sup><i>This short review comes from this book or the store.</i></sup>

# External Resources

##### About Nginx

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.nginx.com/"><b>Nginx Official Project</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://nginx.org/en/docs/"><b>Nginx Official Documentation</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nginx/nginx"><b>Nginx Official Read-only Mirror</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://docs.nginx.com/nginx/admin-guide/"><b>Nginx Official Admin Guide</b></a><br>
</p>

##### Based on the Nginx

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://openresty.org/"><b>OpenResty</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://tengine.taobao.org/"><b>The Tengine Web Server</b></a><br>
</p>

##### Cheatsheets & References

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/"><b>Pitfalls and Common Mistakes (Official)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://gist.github.com/carlessanagustin/9509d0d31414804da03b"><b>Nginx Cheatsheet</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.scalescale.com/tips/nginx/"><b>Nginx Tutorials, Linux Sysadmin Configuration & Optimizing Tips and Tricks</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/h5bp/server-configs-nginx"><b>Nginx boilerplate configs</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nginx-boilerplate/nginx-boilerplate"><b>Awesome Nginx configuration template</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/SimulatedGREG/nginx-cheatsheet"><b>Nginx Quick Reference</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/fcambus/nginx-resources"><b>A collection of resources covering Nginx and more</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/lebinh/nginx-conf"><b>A collection of useful Nginx configuration snippets</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://openresty.org/download/agentzh-nginx-tutorials-en.html"><b>agentzh's Nginx Tutorials</b></a><br>
</p>

##### Performance & Hardening

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/denji/nginx-tuning"><b>Nginx Tuning For Best Performance by Denji</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/projects/best-practices/"><b>SSL/TLS Deployment Best Practices</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.ssllabs.com/projects/rating-guide/index.html"><b>SSL Server Rating Guide</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.upguard.com/blog/how-to-build-a-tough-nginx-server-in-15-steps"><b>How to Build a Tough NGINX Server in 15 Steps</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html"><b>Top 25 Nginx Web Server Best Security Practices</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://calomel.org/nginx.html"><b>Nginx Secure Web Server</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://cipherli.st/"><b>Strong ciphers for Apache, Nginx, Lighttpd and more</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html"><b>Strong SSL Security on Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://enable-cors.org/index.html"><b>Enable cross-origin resource sharing (CORS)</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://istlsfastyet.com/"><b>TLS has exactly one performance problem: it is not used widely enough</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/nbs-system/naxsi"><b>NAXSI - WAF for Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://geekflare.com/install-modsecurity-on-nginx/"><b>ModSecurity for Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.owasp.org/index.php/Transport_Layer_Protection_Cheat_Sheet"><b>Transport Layer Protection Cheat Sheet</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://wiki.mozilla.org/Security/Server_Side_TLS"><b>Security/Server Side TLS</b></a><br>
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
</p>

##### Log analyzers

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://goaccess.io/"><b>GoAccess</b></a> - is a fast, terminal-based log analyzer (quickly analyze and view web server statistics in real time).<br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.graylog.org/"><b>Graylog</b></a> - is a leading centralized log management for capturing, storing, and enabling real-time analysis.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.elastic.co/products/logstash"><b>Logstash</b></a> - is an open source, server-side data processing pipeline.<br>
</p>

##### Performance analyzers

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/lebinh/ngxtop"><b>ngxtop</b></a> - parses your nginx access log and outputs useful, top-like, metrics of your nginx server.<br>
</p>

##### Benchmarking tools

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://httpd.apache.org/docs/2.4/programs/ab.html"><b>ab</b></a> - is a single-threaded command line tool for measuring the performance of HTTP web servers.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.joedog.org/siege-home/"><b>siege</b></a> - is an http load testing and benchmarking utility.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/wg/wrk"><b>wrk</b></a> - is a modern HTTP benchmarking tool capable of generating significant load.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/codesenberg/bombardier"><b>bombardier</b></a> - is a HTTP(S) benchmarking tool.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/cmpxchg16/gobench"><b>gobench</b></a> - is a HTTP/HTTPS load testing and benchmarking tool.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/rakyll/hey"><b>hey</b></a> - is a HTTP load generator, ApacheBench (ab) replacement, formerly known as rakyll/boom.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/tarekziade/boom"><b>boom</b></a> - is a script you can use to quickly smoke-test your web app deployment.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://jmeter.apache.org/"><b>JMeter™</b></a> - is designed to load test functional behavior and measure performance.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://gatling.io/"><b>Gatling</b></a> - is a powerful open-source load and performance testing tool for web applications.<br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/locustio/locust"><b>locust</b></a> - is an easy-to-use, distributed, user load testing tool.<br>
</p>

##### Development

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.evanmiller.org/nginx-modules-guide.html"><b>Emiller’s Guide To Nginx Module Development</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.openmymind.net/An-Introduction-To-OpenResty-Nginx-Lua/"><b>An Introduction To OpenResty (nginx + lua) - Part 1</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.openmymind.net/An-Introduction-To-OpenResty-Part-2/"><b>An Introduction To OpenResty - Part 2 - Concepts</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.openmymind.net/An-Introduction-To-OpenResty-Part-3/"><b>An Introduction To OpenResty - Part 3
</b></a><br>
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
&nbsp;&nbsp;:black_small_square: <a href="https://gchq.github.io/CyberChef/"><b>A web app for encryption, encoding, compression and data analysis</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://nginx.viraptor.info/"><b>Nginx location match tester</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://detailyang.github.io/nginx-location-match-visible/"><b>Nginx location match visible</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://cryptcheck.fr/suite/"><b>User agent compatibility (Cipher suite)</b></a><br>
</p>

##### Other stuff

<p>
&nbsp;&nbsp;:black_small_square: <a href="https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml"><b>Transport Layer Security (TLS) Parameters</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://wiki.mozilla.org/Security/Server_Side_TLS"><b>Security/Server Side TLS by Mozilla</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.veracode.com/blog/2014/03/guidelines-for-setting-security-headers"><b>Guidelines for Setting Security Headers</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://zinoui.com/blog/security-http-headers"><b>Security HTTP Headers</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://www.aosabook.org/en/nginx.html"><b>The Architecture of Open Source Applications - Nginx</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.bbc.co.uk/blogs/internet/entries/17d22fb8-cea2-49d5-be14-86e7a1dcde04"><b>BBC Digital Media Distribution: How we improved throughput by 4x</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://github.com/jiangwenyuan/nuster/wiki/Web-cache-server-performance-benchmark:-nuster-vs-nginx-vs-varnish-vs-squid"><b>Web cache server performance benchmark: nuster vs nginx vs varnish vs squid</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="http://www.kegel.com/c10k.html"><b>The C10K problem by Dan Kegel</b></a><br>
&nbsp;&nbsp;:black_small_square: <a href="https://suniphrase.wordpress.com/2015/10/27/jemalloc-vs-tcmalloc-vs-dlmalloc/"><b>jemalloc vs tcmalloc vs dlmalloc</b></a><br>
</p>

# Helpers

#### Nginx directories and files

  > If you compile Nginx server by default all files and directories are available from `/usr/local/nginx` location.

For prebuilt Nginx package paths can be as follows:

- `/etc/nginx` - is the default configuration root for the Nginx service
- `/etc/nginx/nginx.conf` - is the default configuration entry point used by the Nginx services. Includes the top-level http block and all other configuration files
- `/usr/share/nginx` - is the default root directory for requests, contains `html` directory and basic static files
- `/var/log/nginx` - is the default log (access and error log) location for Nginx
- `/var/lib/nginx` or `/var/cache/nginx` - is the default temporary files location for Nginx
- `/etc/nginx/conf`, `/etc/nginx/conf.d` or `/etc/nginx/sites-enabled` - contains custom/vhosts configuration files
- `/usr/local/nginx/logs` or `/var/run/nginx` - contains information about Nginx process(es)

#### Nginx commands

- `nginx -h` - shows the help
- `nginx -v` - shows the Nginx version
- `nginx -V` - shows the extended information about Nginx: version, build parameters and configuration arguments
- `nginx -t` - tests the Nginx configuration
- `nginx -c` - sets configuration file (default: `/etc/nginx/nginx.conf`)
- `nginx -p` - sets prefix path (default: `/etc/nginx/`)
- `nginx -T` - tests the Nginx configuration and prints the validated configuration on the screen
- `nginx -s` - sends a signal to the Nginx master process:
  - `stop` - discontinues the Nginx process immediately
  - `quit` - stops the Nginx process after it finishes processing
inflight requests
  - `reload` - reloads the configuration without stopping Nginx processes
  - `reopen` - instructs Nginx to reopen log files
- `nginx -g` - sets [global directives](https://nginx.org/en/docs/ngx_core_module.html) out of configuration file

#### Configuration syntax

Work in progress.

#### Nginx processes

Nginx has **one master process** and **one or more worker processes**.

The main purposes of the master process is to read and evaluate configuration files, as well as maintain the worker processes (respawn when a worker dies), handle signals, notify workers, opens log files, and, of course binding to ports.

Master process should be started as **root** user, because this will allow Nginx to open sockets below 1024 (it needs to be able to listen on port 80 for HTTP and 443 for HTTPS).

The worker processes do the actual processing of requests and get commands from master process. They runs in an event loop, handle network connections, read and write content to disk, and communicate with upstream servers. These are spawned by the master process, and the user and group will as specified (unprivileged).

  > Nginx has also cache loader and cache manager processes but only if you enable caching.

The following signals can be sent to the Nginx master process:

| <b>SIGNAL</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `TERM`, `INT` | quick shutdown |
| `QUIT` | graceful shutdown |
| `KILL` | halts a stubborn process |
| `HUP` | configuration reload, start new workers, gracefully shutdown the old worker processes |
| `USR1` | reopen the log files |
| `USR2` | upgrade executable on the fly |
| `WINCH` | gracefully shutdown the worker processes |

There’s no need to control the worker processes yourself. However, they support some signals too:

| <b>SIGNAL</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `TERM`, `INT` | quick shutdown |
| `QUIT` | graceful shutdown |
| `USR1` | reopen the log files |

#### Nginx contexts

The Nginx contexts structure looks like this:

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

#### Request processing stages

- `NGX_HTTP_POST_READ_PHASE` - first phase, read the request header
  - example modules: [ngx_http_realip_module](https://nginx.org/en/docs/http/ngx_http_realip_module.html)
- `NGX_HTTP_SERVER_REWRITE_PHASE` - implementation of rewrite directives defined in a server block
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

You may feel lost now (me too...) so I let myself put this great preview:

<p align="center">
  <a href="https://www.nginx.com/resources/library/infographic-inside-nginx/">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/request-flow.png" alt="request-flow">
  </a>
</p>

<sup><i>This infographic comes from [Inside NGINX](https://www.nginx.com/resources/library/infographic-inside-nginx/) official library.</i></sup>

#### Connection processing

Nginx supports a variety of connection processing methods which depends on the platform used. For more information please see [Connection processing methods](https://nginx.org/en/docs/events.html) explanation.

Okay, so how many simultaneous connections can be processed by Nginx?

```bash
worker_processes * max_connections = max clients
```

According to this: if you are only running **2** worker processes with **512** worker connections, you will be able to serve **1024** clients.

  > It is a bit confusing because the value of `worker_connections` does not directly translate into the number of clients that can be served simultaneously. Each clients (e.g. browsers) opens a number of parallel connections to download various components that compose a web page, for example, images, scripts, and so on.

#### Server blocks

  > Nginx does have **Server Blocks** (like a Virtual Hosts is an Apache) that use the `listen` and `server_name` directives to bind to tcp sockets.

Before start reading this chapter you should know what regular expressions are and how they works. I recommend two great and short write-ups about regular expressions created by [Jonny Fox](https://medium.com/@jonny.fox):

- [Regex tutorial — A quick cheatsheet by examples](https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285)
- [Regex cookbook — Top 10 Most wanted regex](https://medium.com/factory-mind/regex-cookbook-most-wanted-regex-aa721558c3c1)

Why? Regular expressions can be used in both the `location` and `server_name` directives, and sometimes you must have a great skill of reading them. Of course, you should create the most readable regular expressions that do not become spaghetti code - impossible to debug and maintain.

It's short example of server block context (two server blocks):

```bash
http {

  index index.html;
  root /var/www/example.com/default;

  server {

    listen 10.10.250.10:80;
    server_name www.example.com;

    access_log logs/example.access.log main;

    root /var/www/example.com/public;

    ...

  }

  server {

    listen 10.10.250.11:80;
    server_name "~^(api.)?example\.com api.de.example.com";

    access_log logs/example.access.log main;

    proxy_pass http://localhost:8080;

    ...

  }

}
```

##### Server blocks logic

Nginx uses the following logic to determining which virtual server (server block) should be used:

1) Match the `address:port` pair to the `listen` directive - that can be multiple server blocks with `listen` directives of the same specificity that can handle the request

2) Match the `Host` header field against the `server_name` directive as a string (the exact names hash table)

3) Match the `Host` header field against the `server_name` directive with a
wildcard at the beginning of the string (the hash table with wildcard names starting with an asterisk)

    > If one is found, that block will be used to serve the request. If multiple matches are found, the longest match will be used to serve the request.

4) Match the `Host` header field against the `server_name` directive with a
wildcard at the end of the string (the hash table with wildcard names ending with an asterisk)

    > If one is found, that block is used to serve the request. If multiple matches are found, the longest match will be used to serve the request.

5) Match the `Host` header field against the `server_name` directive as a regular expression

    > The first `server_name` with a regular expression that matches the `Host` header will be used to serve the request.

6) If all the `Host` headers doesn't match, then direct to the `listen` directive marked as `default_server`

7) If all the `Host` headers doesn't match and there is no `default_server`,
direct to the first server with a `listen` directive that satisfies first step

8) Finally, Nginx goes to the Location Context

<sup><i>This short list is based on [Mastering Nginx - The virtual server section](#mastering-nginx).</i></sup>

##### The `listen` directive

Nginx use the `address:port` combination for handle incoming connections. This pair is assigned to the `listen` directive.

The `listen` directive can be set to:

- an IP address/port combination (`127.0.0.1:80;`)
- a lone IP address, if only address is given, the port `80` is used (`127.0.0.1;`) - becomes `127.0.0.1:80;`
- a lone port which will listen to every interface on that port (`80;` or `*:80;`) - becomes `0.0.0.0:80;`
- the path to a UNIX-domain socket (`unix:/var/run/nginx.sock;`)

If the `listen` directive is not present then either `*:80` is used (runs with the superuser privileges), or `*:8000` otherwise.

1) Nginx translates all incomplete `listen` directives by substituting missing values with their default values (see above)

2) Nginx attempts to collect a list of the server blocks that match the request most specifically based on the `address:port`

3) If any block that is functionally using `0.0.0.0`, will not be selected if there are matching blocks that list a specific IP

4) If there is only one most specific match, that server block will be used to serve the request

5) If there are multiple server blocks with the same level of matching, Nginx then begins to evaluate the `server_name` directive of each server block

Look at this short example:

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

##### Matching location

  > For each request, Nginx goes through a process to choose the best location block that will be used to serve that request.

Let's short introduction something about this:

- the exact match is the best priority (processed first); ends search if match
- the prefix match is the second priority; there are two types of prefixes: `^~` and `(none)`, if this match used the `^~` prefix, searching stops
- the regular expression match has the lowest priority; there are two types of prefixes: `~` and `~*`; in the order they are defined in the configuration file
- if regular expression searching yielded a match, that result is used, otherwise, the match from prefix searching is used

Short example from the [Nginx documentation](https://nginx.org/en/docs/http/ngx_http_core_module.html#location):

```bash
location = / {
  # matches the query / only.
  [ configuration A ]
}
location / {
  # matches any query, since all queries begin with /, but regular
  # expressions and any longer conventional blocks will be
  # matched first.
  [ configuration B ]
}
location /documents/ {
  # matches any query beginning with /documents/ and continues searching,
  # so regular expressions will be checked. This will be matched only if
  # regular expressions don't find a match.
  [ configuration C ]
}
location ^~ /images/ {
  # matches any query beginning with /images/ and halts searching,
  # so regular expressions will not be checked.
  [ configuration D ]
}
location ~* \.(gif|jpg|jpeg)$ {
  # matches any request ending in gif, jpg, or jpeg. However, all
  # requests to the /images/ directory will be handled by
  # Configuration D.
  [ configuration E ]
}
```

To help you understand how does the Nginx location match works:

- [Nginx location match tester](https://nginx.viraptor.info/)
- [Nginx location match visible](https://detailyang.github.io/nginx-location-match-visible/)

First of all please see on the following location syntax:

```bash
location optional_modifier location_match { ... }
```

`location_match` in the above defines what Nginx should check the request URI against. The `optional_modifier` below will cause the associated location block to be interpreted as follows:

  - `(none)`: if no modifiers are present, the location is interpreted as a prefix match. To determine a match, the location will now be matched against the beginning of the URI

  - `=`: is an exact match, without any wildcards, prefix matching or regular expressions; forces a literal match between the request URI and the location parameter

  - `~`: if a tilde modifier is present, this location must be used for case sensitive matching (RE match)

  - `~*`: if a tilde and asterisk modifier is used, the location must be used for case insensitive matching (RE match)

  - `^~`: assuming this block is the best non-RE match, a carat followed by a tilde modifier means that RE matching will not take place

The process of choosing Nginx location block is as follows:

1) Prefix-based Nginx location matches (=no regular expression). Each location will be checked against the request URI

2) Nginx searches for an exact match. If a "=" modifier exactly matches the request URI, this specific location block is chosen right away

3) If no exact (meaning no "=" modifier) location block is found, Nginx will continue with non-exact prefixes. It starts with the longest matching prefix location for this URI, with the following approach:

    - In case the longest matching prefix location has the "^~" modifier, Nginx will stop its search right away and choose this location

    - Assuming the longest matching prefix location doesn’t use the "^~"modifier, the match is temporarily stored and the process continues

4) As soon as the longest matching prefix location is chosen and stored, Nginx continues to evaluate the case-sensitive and insensitive regular expression locations. The first regular expression location that fits the URI is selected right away to process the request

5) If no regular expression locations are found that match the request URI, the previously stored prefix location is selected to serve the request

In order to better understand how this process work please see this short cheatsheet that will allow you to design your location blocks in a predictable way:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx_location_cheatsheet.png" alt="nginx-location-cheatsheet">
</p>

  > I recommend to use external tools for testing regular expressions. For more please see [online tools](#online-tools) chapter.

Ok, so we have following more complicated configuration:

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

And here is the table with the results:

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
| `/static3/logo.png` | <sup>1)</sup> prefix match for `/static3`<br><sup>2)</sup> prefix match for `/`<br><sup>3)</sup> case insensitive regex match for `.(png\|ico\|gif)$` | `.(png\|ico\|gif\|xcf)$` |
| `/static4/logo.jpg` | <sup>1)</sup> priority prefix match for `/static4`<br><sup>2)</sup> prefix match for `/` | `/static4` |
| `/static4/logo.png` | <sup>1)</sup> priority prefix match for `/static4`<br><sup>2)</sup> prefix match for `/` | `/static4` |
| `/static5/logo.jpg` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `logo.jpg$` | `logo.jpg$` |
| `/static5/logo.png` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> prefix match for `/` | `.(png\|ico\|gif\|xcf)$` |
| `/static5/logo.xcf` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `logo.xcf$` | `logo.xcf$` |
| `/static5/logo.ico` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> prefix match for `/` | `.(png\|ico\|gif\|xcf)$` |

#### Error log severity levels

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

#### Rate Limiting

  > All rate limiting rules (definitions) should be added to the Nginx `http` context.

Rate limiting rules are useful for:

- traffic shaping
- traffic optimizing
- slow down the rate of incoming requests
- protect http requests flood
- protect against slow http attacks
- prevent consume a lot of bandwidth
- mitigating ddos attacks
- protect brute-force attacks

Nginx has following variables (unique keys) that can be used in a rate limiting rules:

| <b>VARIABLE</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `$remote_addr` | client address |
| `$binary_remote_addr`| client address in a binary form, it is smaller and saves space then `remote_addr` |
| `$server_name` | name of the server which accepted a request |
| `$request_uri` | full original request URI (with arguments) |
| `$query_string` | arguments in the request line |

<sup><i>Please see [official doc](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables) for more information about variables.</i></sup>

Nginx also provides following keys:

| <b>KEY</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `limit_req_zone` | stores the current number of excessive requests |
| `limit_conn_zone` | stores the maximum allowed number of connections |

and directives:

| <b>DIRECTIVE</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `limit_req` | sets the shared memory zone and the maximum burst size of requests |
| `limit_conn` | sets the shared memory zone and the maximum allowed number of connections to the server per a client IP |

Keys are used to store the state of each IP address and how often it has accessed a limited object. This information are stored in shared memory available from all Nginx worker processes.

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

`limit_req_zone` key lets you set `rate` parameter (optional) - it defines the rate limited URL(s).

For enable queue you should use `limit_req` or `limit_conn` directives (see above). `limit_req` also provides optional parameters:

| <b>PARAMETER</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `burst=<num>` | sets the maximum number of excessive requests that await to be processed in a timely manner; maximum requests as `rate` * `burst` in `burst` seconds |
| `nodelay`| it imposes a rate limit without constraining the allowed spacing between requests; default Nginx would return 503 response and not handle excessive requests |

  > `nodelay` parameters are only useful when you also set a `burst`.

Without `nodelay` option Nginx would wait (no 503 response) and handle excessive requests with some delay.

#### Analyse configuration

It is an essential way for testing Nginx configuration:

```bash
nginx -t -c /etc/nginx/nginx.conf;
```

An external tool for analyse Nginx configuration is `gixy`:

```bash
gixy /etc/nginx/nginx.conf
```

#### Monitoring

##### GoAccess

  > Paths configuration file:
  >
  >   - `/etc/goaccess.conf`
  >   - `/etc/goaccess/goaccess.conf`
  >   - `/usr/local/etc/goaccess.conf`

Prior to start GoAccess enable these parameters:

```bash
time-format %H:%M:%S
date-format %d/%b/%Y
log-format  %h %^[%d:%t %^] "%r" %s %b "%R" "%u"
```

###### Analyse log file and enable all recorded statistics

```bash
goaccess -f /path/to/logfile -a
```

###### Analyse compressed log file

```bash
zcat /path/to/logfile.1.gz | goaccess -a -p /etc/goaccess/goaccess.conf
```

###### Analyse log file remotely

```bash
ssh user@remote_host '/path/to/logfile' | goaccess -a
```

###### Analyse log file and generate html report

```bash
goaccess -p /etc/goaccess/goaccess.conf -f /path/to/logfile --log-format=COMBINED -o /var/www/index.html
```

##### Ngxtop

###### Analyse log file

```bash
ngxtop -l /path/to/logfile
```

###### Analyse log file and print requests with 4xx and 5xx

```bash
ngxtop -l /path/to/logfile -i 'status >= 400' print request status
```

###### Analyse log file remotely

```bash
ssh user@remote_host tail -f /path/to/logfile | ngxtop -f combined
```

#### Debugging

###### Check if the module has been compiled

```bash
nginx -V 2>&1 | grep -- 'http_geoip_module'
```

###### See the top 5 IP addresses in a web server log

```bash
cut -d ' ' -f1 /path/to/logfile | sort | uniq -c | sort -nr | head -5 | nl
```

###### Analyse web server log and show only 2xx http codes

```bash
tail -n 100 -f /path/to/logfile | grep "HTTP/[1-2].[0-1]\" [2]"
```

###### Analyse web server log and show only 5xx http codes

```bash
tail -n 100 -f /path/to/logfile | grep "HTTP/[1-2].[0-1]\" [5]"
```

###### Calculating requests per second

```bash
# In real time:
tail -F /path/to/logfile | pv -lr >/dev/null

awk '{print $4}' /path/to/logfile | uniq -c | sort -rn | head | tr -d "["
```

###### Get range of dates in a web server log

```bash
# 1)
awk '/05\/Feb\/2019:09:2.*/,/05\/Feb\/2019:09:5.*/' /path/to/logfile

# 2)
awk '/'$(date -d "1 hours ago" "+%d\\/%b\\/%Y:%H:%M")'/,/'$(date "+%d\\/%b\\/%Y:%H:%M")'/ { print $0 }' /path/to/logfile
```

###### Get line rates from web server log

```bash
tail -F /path/to/logfile | pv -N RAW -lc 1>/dev/null
```

###### Trace network traffic for all Nginx processes

```bash
strace -e trace=network -p `pidof nginx | sed -e 's/ /,/g'`
```

###### List all files accessed by a Nginx

```bash
strace -ff -e trace=file nginx 2>&1 | perl -ne 's/^[^"]+"(([^\\"]|\\[\\"nt])*)".*/$1/ && print'
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

###### Restricting access with basic authentication

```bash
# 1) generate file with htpasswd command:
htpasswd -c htpasswd_example.com.conf <username>

# 2) include this file in specific context: (e.g. server):
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

###### Blocking/allowing IP addresses

Example 1:

```bash
# 1) file: /etc/nginx/acls/allow.map.conf

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

# 2) include this file in http context:
include /etc/nginx/acls/allow.map.conf;

# 3) turn on in a specific context (e.g. location):
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

    if ($globals_internal_map_acl) {

      proxy_pass http://localhost:80;
      client_max_body_size 10m;

    }

    if ($globals_internal_map_acl) {

      rewrite ^(.*) https://example.com;

    }

  ...
```

Example 2:

```bash
# 1) file: /etc/nginx/acls/allow.geo.conf

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

# 2) include this file in http context:
include /etc/nginx/acls/allow.geo.conf;

# 3) turn on in a specific context (e.g. location):
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
# 1) file: /etc/nginx/acls/allow.conf

### INTERNAL ###
allow 10.255.10.0/24;
allow 10.255.20.0/24;
allow 10.255.30.0/24;
allow 192.168.0.0/16;

### EXTERNAL ###
allow 35.228.233.xxx;

# 2) include this file in http context:
include /etc/nginx/acls/allow.conf;

# 3) turn on in a specific context (e.g. server):
server_name example.com;

  include /etc/nginx/acls/allow.conf;
  allow   35.228.233.xxx;
  deny    all;

  ...
```

###### Blocking referrer spam

Example 1:

```bash
# 1) file: /etc/nginx/limits.conf

map $http_referer $invalid_referer {

  hostnames;

  default                   0;

  # Invalid referrers:
  "https://invalid.com/"    1;
  "~*spamdomain4.com"       1;
  "~*.invalid\.org"         1;

}

# 2) include this file in http context:
include /etc/nginx/limits.conf;

# 3) turn on in a specific context (e.g. server):
server_name example.com;

  if ($invalid_referer) { return 403; }

  ...
```

Example 2:

```bash
# 1) turn on in a specific context (e.g. location):
location /check_status {

  if ($http_referer ~ "spam1\.com|spam2\.com|spam3\.com") {

    return 444;

  }

  ...
```

###### Limiting referrer spam

Example 1:

```bash
# 1) file: /etc/nginx/limits.conf

map $http_referer $limit_ip_key_by_referer {

  default                   $binary_remote_addr;

  # Invalid referrers:
  "https://invalid.com/"    1;
  "~*spamdomain4.com"       1;
  "~*.invalid\.org"         1;

}

limit_req_zone $limit_ip_key_by_referer zone=req_for_remote_addr_by_referer:1m rate=5r/s;

# 2) turn on in a specific context (e.g. server):
server_name example.com;

  limit_req zone=req_for_remote_addr_by_referer burst=2;

  ...
```

###### Limiting the rate of requests with burst mode

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

###### Limiting the rate of requests with burst mode and nodelay

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

###### Limiting the number of connections

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

#### Installation from source

There are currently two versions of Nginx:

- **stable** - is recommended, doesn’t include all of the latest features, but has critical bug fixes from mainline release
- **mainline** - is typically quite stable as well, includes the latest features and bug fixes and is always up to date

##### Dependencies

Mandatory requirements:

  > Download, compile and install or install prebuilt packages from your distribution repository.

- [OpenSSL](https://www.openssl.org/source/) library
- [Zlib](https://zlib.net/) library
- [PCRE](https://ftp.pcre.org/pub/pcre/) library
- [LuaJIT v2.1](https://github.com/LuaJIT/LuaJIT) or [OpenResty's LuaJIT2](https://github.com/openresty/luajit2) library
- [jemalloc](https://github.com/jemalloc/jemalloc) library

If you download and compile above sources the good point is to install additional packages (dependent on the system version) before building Nginx:

| <b>Debian Like</b> | <b>RedHat Like</b> | <b>Comment</b> |
| :---         | :---         | :---         |
| `gcc make build-essential bison` | `gcc gcc-c++ kernel-devel bison` | |
| `perl libperl-dev` | `perl perl-ExtUtils-Embed` | |
| `libssl-dev`* | `openssl-devel`* | |
| `zlib1g-dev`* | `zlib-devel`* | |
| `libpcre2-dev`* | `pcre-devel`* | |
| `libluajit-5.1-dev`* | `luajit-devel`* | |
| `libxslt-dev` | `libxslt libxslt-devel` | |
| `libgd-dev` | `gd gd-devel` | |
| `libgeoip-dev` | `GeoIP-devel` | |
| `libxml2-dev` | `libxml2-dev` | |
| `libexpat-dev` | `expat-devel` | |
| `libgoogle-perftools-dev`<br>`libgoogle-perftools4` | `gperftools-devel` | |
| | `cpio` | |
| | `gettext-devel` | |
| `autoconf` | `autoconf` | for `jemalloc` from sources |
| `libjemalloc1`<br>`libjemalloc-dev`* | `jemalloc`<br>`jemalloc-devel`* | for `jemalloc` |
| `libpam0g-dev` | `pam-devel` | for `ngx_http_auth_pam_module` |

<sup><i>* If you don't use from sources.</i></sup>

Shell one-liner example:

```bash
# Ubuntu/Debian
apt-get install gcc make build-essential bison perl libperl-dev libssl-dev zlib1g-dev libpcre2-dev libluajit-5.1-dev libxslt-dev libgd-dev libgeoip-dev libxml2-dev libexpat-dev libgoogle-perftools-dev libgoogle-perftools4 autoconf

# RedHat/CentOS
yum install gcc gcc-c++ kernel-devel bison perl perl-ExtUtils-Embed openssl-devel zlib-devel pcre-devel luajit-devel libxslt libxslt-devel gd gd-devel GeoIP-devel libxml2-dev expat-devel gperftools-devel cpio gettext-devel autoconf
```

##### Nginx package

- [Nginx](https://nginx.org/download/) source code

  > Before starting, please see [Installation and Compile-Time Options](https://www.nginx.com/resources/wiki/start/topics/tutorials/installoptions/) and [Installing NGINX Open Source](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#configure).

##### Example of installation on Ubuntu

###### Pre installation tasks

Set the Nginx version (I use stable release):

```bash
export ngx_version="1.16.0"
```

Create directories:

```bash
mkdir /usr/local/src/nginx-${ngx_version}
mkdir /usr/local/src/nginx-${ngx_version}/master
mkdir /usr/local/src/nginx-${ngx_version}/modules
```

###### Install or build dependencies

  > In my configuration I used all prebuilt dependencies without `libssl-dev`, `libluajit-5.1-dev` and `libpcre2-dev` because I compiled them manually - for TLS 1.3 support and with OpenResty recommendation for LuaJIT.

Before start please see this short system locations:

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

**Install prebuilt packages, export variables and set symbolic link:**

```bash
apt-get install gcc make build-essential bison perl libperl-dev libxslt-dev libgd-dev libgeoip-dev libxml2-dev libexpat-dev libgoogle-perftools-dev libgoogle-perftools4 autoconf

# Also if you don't use sources:
apt-get install libssl-dev zlib1g-dev libpcre2-dev libluajit-5.1-dev

# For LuaJIT:
export LUA_LIB=/usr/local/x86_64-linux-gnu/
export LUA_INC=/usr/include/luajit-2.1/

ln -s /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 /usr/local/lib/liblua.so
```

  > Remember to build [`sregex`](#sregex) also if you use above steps.

**Or download and compile them:**

PCRE:

```bash
cd /usr/local/src/

wget https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz && tar xzvf pcre-8.42.tar.gz

cd /usr/local/src/pcre-8.42

./configure

make -j2 && make test
make install

export PCRE_LIB=/usr/local/lib
export PCRE_INC=/usr/local/include
```

Zlib:

```bash
cd /usr/local/src/

wget http://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz

cd /usr/local/src/zlib-1.2.11

./configure

make -j2 && make test
make install
```

OpenSSL:

```bash
cd /usr/local/src/

wget https://www.openssl.org/source/openssl-1.1.1b.tar.gz && tar xzvf openssl-1.1.1b.tar.gz

cd /usr/local/src/openssl-1.1.1b

./config --prefix=/usr/local/openssl-1.1.1b --openssldir=/usr/local/openssl-1.1.1b shared zlib no-ssl3 no-weak-ssl-ciphers

make -j2 && make test
make install

export OPENSSL_LIB=/usr/local/openssl-1.1.1b/lib
export OPENSSL_INC=/usr/local/openssl-1.1.1b/include

# Setup PATH environment variables:
cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=/usr/local/openssl-1.1.1b/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/openssl-1.1.1b/lib:${LD_LIBRARY_PATH}
__EOF__

chmod +x /etc/profile.d/openssl.sh && source /etc/profile.d/openssl.sh

# To make the OpenSSL 1.1.1b version visible globally first:
mv /usr/bin/openssl /usr/bin/openssl-1.1.0g
ln -s /usr/local/openssl-1.1.1b/bin/openssl /usr/bin/openssl

cat > /etc/ld.so.conf.d/openssl.conf << __EOF__
/usr/local/openssl-1.1.1b/lib
__EOF__
```

LuaJIT:

```bash
# I recommend to use OpenResty's branch (openresty/luajit2) instead LuaJIT (LuaJIT/LuaJIT):
cd /usr/local/src/ && git clone https://github.com/openresty/luajit2

cd luajit2

make && make install

export LUA_LIB=/usr/local/lib/
export LUA_INC=/usr/local/include/luajit-2.1/

ln -s /usr/local/lib/libluajit-5.1.so.2.1.0 /usr/local/lib/liblua.so
```

<a id="sregex"></a>sregex:

  > Required for `replace-filter-nginx-module` module.

```bash
cd /usr/local/src/ && git clone https://github.com/openresty/sregex

cd sregex

make && make install
```

jemalloc:

  > To verify `jemalloc` in use: `lsof -n | grep jemalloc`.

```bash
cd /usr/local/src/ && git clone https://github.com/jemalloc/jemalloc

cd jemalloc

./autogen.sh

make && make install
```

Update links and cache to the shared libraries for both types of installation:

```bash
ldconfig
```

###### Get Nginx sources

```bash
cd /usr/local/src/nginx-${ngx_version}

wget https://nginx.org/download/nginx-${ngx_version}.tar.gz

# or alternative:
#   git clone --depth 1 https://github.com/nginx/nginx master

tar zxvf nginx-${ngx_version}.tar.gz -C /usr/local/src/nginx-${ngx_version}/master --strip 1
```

###### Download 3rd party modules

  > Not all external modules can work properly with your currently Nginx version. You should read the documentation of each module before adding it to the modules list. You should also to check what version of module is compatible with your Nginx release.

Modules can be compiled as a shared object (`*.so` file) and then dynamically loaded into Nginx at runtime (`--add-dynamic-module`). On the other hand you can also built them into Nginx at compile time and linked to the Nginx binary statically (`--add-module`).

I mixed both variants because some of the modules are built-in automatically even if I try them to be compiled as a dynamic modules.

You can download external modules from:

- [NGINX 3rd Party Modules](https://www.nginx.com/resources/wiki/modules/)
- [OpenResty - Components](https://openresty.org/en/components.html)
- [Tengine - Modules](https://github.com/alibaba/tengine/tree/master/modules)

A short description of the modules that I used (not only) in this step-by-step tutorial:

- [`ngx_devel_kit`](https://github.com/simplresty/ngx_devel_kit) - module that adds additional generic tools that module developers can use in their own modules; is already being used in quite a few third party modules
- [`lua-nginx-module`](https://github.com/openresty/lua-nginx-module) - embed the Power of Lua into Nginx
- [`set-misc-nginx-module`](https://github.com/openresty/set-misc-nginx-module) - various `set_xxx` directives added to Nginx's rewrite module
- [`echo-nginx-module`](https://github.com/openresty/echo-nginx-module) - module for bringing the power of `echo`, `sleep`, `time` and more to Nginx's config file
- [`headers-more-nginx-module`](https://github.com/openresty/headers-more-nginx-module) - set, add, and clear arbitrary output headers
- [`replace-filter-nginx-module`](https://github.com/openresty/replace-filter-nginx-module) - streaming regular expression replacement in response bodies
- [`array-var-nginx-module`](https://github.com/openresty/array-var-nginx-module) - add supports for array-typed variables to Nginx config files
- [`encrypted-session-nginx-module`](https://github.com/openresty/encrypted-session-nginx-module) - encrypt and decrypt Nginx variable values
- [`nginx-module-sysguard`](https://github.com/vozlt/nginx-module-sysguard) - module to protect servers when system load or memory use goes too high
- [`nginx-access-plus`](https://github.com/nginx-clojure/nginx-access-plus) - allows limiting access to certain http request methods and client addresses
- [`ngx_http_substitutions_filter_module`](https://github.com/yaoweibin/ngx_http_substitutions_filter_module) - module which can do both regular expression and fixed string substitutions
- [`nginx-sticky-module-ng`](https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/src) - module to add a sticky cookie to be always forwarded to the same
- [`ngx_http_delay_module`](http://mdounin.ru/hg/ngx_http_delay_module) - allows to delay requests for a given time
- [`nginx-backtrace`](https://github.com/alibaba/nginx-backtrace)* - module to dump backtrace when a worker process exits abnormally
- [`ngx_debug_pool`](https://github.com/chobits/ngx_debug_pool)* - provides access to information of memory usage for Nginx memory pool
- [`ngx_debug_timer`](https://github.com/hongxiaolong/ngx_debug_timer)* - provides access to information of timer usage for Nginx
- [`nginx_upstream_check_module`](https://github.com/yaoweibin/nginx_upstream_check_module)* - health checks upstreams for Nginx
- [`nginx-http-footer-filter`](https://github.com/alibaba/nginx-http-footer-filter)* - module that prints some text in the footer of a request upstream server
- [`memc-nginx-module`](https://github.com/agentzh/memc-nginx-module) - extended version of the standard Memcached module
- [`nginx-rtmp-module`](https://github.com/arut/nginx-rtmp-module) - Nginx-based Media Streaming Server
- [`ngx-fancyindex`](https://github.com/aperezdc/ngx-fancyindex) - generates of file listings, like the built-in autoindex module does, but adding a touch of style
- [`ngx_log_if`](https://github.com/cfsego/ngx_log_if) - allows you to control when not to write down access log
- [`nginx-http-user-agent`](https://github.com/alibaba/nginx-http-user-agent) - module to match browsers and crawlers
- [`ngx_http_auth_pam_module`](https://github.com/sto/ngx_http_auth_pam_module) - module to use PAM for simple http authentication

<sup><i>* Available in Tengine Web Server (but these modules may have been updated/patched by Tengine Team).</i></sup>

```bash
cd /usr/local/src/nginx-${ngx_version}/modules/

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
https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng ; do

  git clone --depth 1 "$i"

done

wget http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
mkdir delay-module && tar xzvf delay-module.tar.gz -C delay-module --strip 1
```

I also use some modules from Tengine:

- `ngx_backtrace_module`
- `ngx_debug_pool`
- `ngx_debug_timer`
- `ngx_http_upstream_check_module`
- `ngx_http_upstream_session_sticky_module`
- `ngx_http_footer_filter_module`

```bash
cd /usr/local/src/nginx-${ngx_version}/modules/

git clone --depth 1 https://github.com/alibaba/tengine
```

###### Build Nginx

```bash
cd /usr/local/src/nginx-${ngx_version}/master

# You can also build Nginx without 3rd party modules.
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
            --with-openssl=/usr/local/src/openssl-1.1.1b \
            --with-openssl-opt=no-weak-ssl-ciphers \
            --with-openssl-opt=no-ssl3 \
            --with-pcre=/usr/local/src/pcre-8.42 \
            --with-pcre-jit \
            --without-http-cache \
            --without-http_memcached_module \
            --without-mail_pop3_module \
            --without-mail_imap_module \
            --without-mail_smtp_module \
            --without-http_fastcgi_module \
            --without-http_scgi_module \
            --without-http_uwsgi_module \
            --with-cc-opt='-I/usr/local/include -I/usr/local/openssl-1.1.1b/include -I/usr/local/include/luajit-2.1/ -I/usr/local/include/jemalloc -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' \
            --with-ld-opt='-Wl,-E -L/usr/local/lib -ljemalloc -lpcre -Wl,-rpath,/usr/local/lib/,-z,relro -Wl,-z,now -pie' \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/ngx_devel_kit \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/encrypted-session-nginx-module \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/nginx-access-plus/src/c \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/ngx_http_substitutions_filter_module \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/nginx-sticky-module-ng \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/tengine/modules/ngx_backtrace_module \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/tengine/modules/ngx_debug_pool \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/tengine/modules/ngx_debug_timer \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/tengine/modules/ngx_http_upstream_check_module \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/tengine/modules/ngx_http_footer_filter_module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/lua-nginx-module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/set-misc-nginx-module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/echo-nginx-module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/headers-more-nginx-module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/replace-filter-nginx-module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/array-var-nginx-module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/nginx-module-sysguard \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/delay-module

make -j2 && make test
make install

ldconfig
```

Check Nginx version:

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

2 directories, 25 files
```

###### Post installation tasks

Create a system user/group:

```bash
adduser --system --home /non-existent --no-create-home --shell /usr/sbin/nologin --disabled-login --disabled-password --gecos "nginx user" --group nginx
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

Enable Nginx service:

```bash
systemctl enable nginx
```

Test Nginx configuration:

```bash
nginx -t -c /etc/nginx/nginx.conf
```

#### Installation from prebuilt packages

##### RHEL7 or CentOS 7

###### From EPEL

```bash
# Install epel repository:
yum install epel-release
# or alternative:
#   wget -c https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#   yum install epel-release-latest-7.noarch.rpm

# Install Nginx:
yum install nginx
```

###### From Software Collections

```bash
# Install and enable scl:
yum install centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms

# Install Nginx (rh-nginx14, rh-nginx16, rh-nginx18):
yum install rh-nginx16

# Enable Nginx from SCL:
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

# Install Nginx:
yum install nginx
```

##### Debian or Ubuntu

Check available flavors of Nginx before install. For more information please see [this](https://askubuntu.com/a/556382) great answer by [Thomas Ward](https://askubuntu.com/users/10616/thomas-ward).

###### From Debian/Ubuntu Repository

```bash
# Install Nginx:
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

# Install Nginx:
apt-get update
apt-get install nginx
```

#### Tengine Web Server

  > _Tengine is a web server originated by Taobao, the largest e-commerce website in Asia. It is based on the Nginx HTTP server and has many advanced features. There’s a lot of features in Tengine that do not (yet) exist in Nginx._

- Official github repository: [Tengine](https://github.com/alibaba/tengine)
- Official documentation: [Tengine Documentation](https://tengine.taobao.org/documentation.html)

Generally, Tengine is a great solution, including many patches, improvements, additional modules, and most importantly it is very actively maintained.

The build and installation process is very similar to [installation from source](#installation-from-source) for Nginx. However, I will only specify the most important changes.

##### Example of installation on Ubuntu

###### Pre installation tasks

Create directories:

```bash
mkdir /usr/local/src/tengine
mkdir /usr/local/src/tengine/master
mkdir /usr/local/src/tengine/modules
```

###### Install or build dependencies

Install prebuilt packages, export variables and set symbolic link:

```bash
apt-get install gcc make build-essential bison perl libperl-dev libxslt-dev libgd-dev libgeoip-dev libxml2-dev libexpat-dev libgoogle-perftools-dev libgoogle-perftools4 autoconf

# Also if you don't use sources:
apt-get install zlib1g-dev
```

PCRE:

```bash
cd /usr/local/src/

wget https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz && tar xzvf pcre-8.42.tar.gz

cd /usr/local/src/pcre-8.42

./configure

make -j2 && make test
make install

export PCRE_LIB=/usr/local/lib
export PCRE_INC=/usr/local/include
```

OpenSSL:

```bash
cd /usr/local/src/

wget https://www.openssl.org/source/openssl-1.1.1b.tar.gz && tar xzvf openssl-1.1.1b.tar.gz

cd /usr/local/src/openssl-1.1.1b

./config --prefix=/usr/local/openssl-1.1.1b --openssldir=/usr/local/openssl-1.1.1b shared zlib no-ssl3 no-weak-ssl-ciphers

make -j2 && make test
make install

export OPENSSL_LIB=/usr/local/openssl-1.1.1b/lib
export OPENSSL_INC=/usr/local/openssl-1.1.1b/include

# Setup PATH environment variables:
cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=/usr/local/openssl-1.1.1b/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/openssl-1.1.1b/lib:${LD_LIBRARY_PATH}
__EOF__

chmod +x /etc/profile.d/openssl.sh && source /etc/profile.d/openssl.sh

# To make the OpenSSL 1.1.1b version visible globally first:
mv /usr/bin/openssl /usr/bin/openssl-1.1.0g
ln -s /usr/local/openssl-1.1.1b/bin/openssl /usr/bin/openssl

cat > /etc/ld.so.conf.d/openssl.conf << __EOF__
/usr/local/openssl-1.1.1b/lib
__EOF__
```

LuaJIT:

```bash
# I recommend to use OpenResty's branch (openresty/luajit2) instead LuaJIT (LuaJIT/LuaJIT):
cd /usr/local/src/ && git clone https://github.com/openresty/luajit2

cd luajit2

make && make install

export LUA_LIB=/usr/local/lib/
export LUA_INC=/usr/local/include/luajit-2.1/

ln -s /usr/local/lib/libluajit-5.1.so.2.1.0 /usr/local/lib/liblua.so
```

sregex:

  > Required for `replace-filter-nginx-module` module.

```bash
cd /usr/local/src/ && git clone https://github.com/openresty/sregex

cd sregex

make && make install
```

jemalloc:

  > To verify `jemalloc` in use: `lsof -n | grep jemalloc`.

```bash
cd /usr/local/src/ && git clone https://github.com/jemalloc/jemalloc

cd jemalloc

./autogen.sh

make && make install
```

Update links and cache to the shared libraries for both types of installation:

```bash
ldconfig
```

###### Get Tengine sources

```bash
cd /usr/local/src/tengine

git clone https://github.com/alibaba/tengine master
```

###### Download 3rd party modules

  > Not all modules from [this](#download-3rd-party-modules) section working properly with Tengine (e.g. `ndk_http_module` and other dependent on it).

```bash
cd /usr/local/src/tengine/modules/

for i in \
https://github.com/openresty/echo-nginx-module \
https://github.com/openresty/headers-more-nginx-module \
https://github.com/openresty/replace-filter-nginx-module \
https://github.com/nginx-clojure/nginx-access-plus \
https://github.com/yaoweibin/ngx_http_substitutions_filter_module ; do

  git clone --depth 1 "$i"

done

wget http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
mkdir delay-module && tar xzvf delay-module.tar.gz -C delay-module --strip 1
```

###### Build Tengine

```bash
cd /usr/local/src/tengine/master

# You can also build Tengine without 3rd party modules.
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
            --with-http_backtrace_module \
            --with-http_debug_pool_module \
            --with-http_debug_timer_module \
            --with-http_degradation_module \
            --with-http_footer_filter_module \
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
            --with-http_sysguard_module \
            --with-http_upstream_check_module \
            --with-http_upstream_session_sticky_module \
            --with-http_v2_module \
            --with-google_perftools_module \
            --with-openssl=/usr/local/src/openssl-1.1.1b \
            --with-openssl-opt=no-weak-ssl-ciphers \
            --with-openssl-opt=no-ssl3 \
            --with-pcre=/usr/local/src/pcre-8.42 \
            --with-pcre-jit \
            --with-jemalloc=/usr/local/src/jemalloc \
            --without-http-cache \
            --without-http_memcached_module \
            --without-mail_pop3_module \
            --without-mail_imap_module \
            --without-mail_smtp_module \
            --without-http_fastcgi_module \
            --without-http_scgi_module \
            --without-http_uwsgi_module \
            --with-cc-opt='-I/usr/local/include -I/usr/local/openssl-1.1.1b/include -I/usr/local/include/luajit-2.1/ -I/usr/local/include/jemalloc -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' \
            --with-ld-opt='-Wl,-E -L/usr/local/lib -ljemalloc -lpcre -Wl,-rpath,/usr/local/lib/,-z,relro -Wl,-z,now -pie' \
            --add-module=/usr/local/src/tengine/modules/nginx-access-plus/src/c \
            --add-module=/usr/local/src/tengine/modules/ngx_http_substitutions_filter_module \
            --add-dynamic-module=/usr/local/src/tengine/modules/echo-nginx-module \
            --add-dynamic-module=/usr/local/src/tengine/modules/headers-more-nginx-module \
            --add-dynamic-module=/usr/local/src/tengine/modules/replace-filter-nginx-module \
            --add-dynamic-module=/usr/local/src/tengine/modules/delay-module

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
│   └── ngx_http_replace_filter_module.so
├── nginx.conf
├── nginx.conf.default
├── scgi_params
├── scgi_params.default
├── uwsgi_params
├── uwsgi_params.default
└── win-utf

2 directories, 21 files
```

###### Post installation tasks

  > Check all post installation tasks from [post installation tasks - Nginx](#post-installation-tasks) section.

# Base Rules

#### :beginner: Organising Nginx configuration

###### Rationale

  > When your Nginx configuration grow, the need for organising your configuration will also grow. Well organised code is:
  >
  > - easier to understand
  > - easier to maintain
  > - easier to work with

  > Use `include` directive to move common server settings into a separate files and to attach your Nginx specific code to global config, contexts and other.

###### Example

```bash
# Store this configuration in e.g. https-ssl-common.conf
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

#### :beginner: Separate `listen` directives for 80 and 443

###### Rationale

  > I don't like duplicating the rules, but it's certainly an easy and maintainable way.

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

#### :beginner: Define the `listen` directives explicitly with `address:port` pair

###### Rationale

  > Nginx translates all incomplete `listen` directives by substituting missing values with their default values.

  > Nginx will only evaluate the `server_name` directive when it needs to distinguish between server blocks that match to the same level in the listen directive.

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

  > Nginx should prevent processing requests with undefined server names (also on IP address). It also protects against configuration errors and don't pass traffic to incorrect backends. The problem is easily solved by creating a default catch all server config.

  > If none of the listen directives have the `default_server` parameter then the first server with the `address:port` pair will be the default server for this pair (it means that Nginx always has a default server).

  > If someone makes a request using an IP address instead of a server name, the `Host` request header field will contain the IP address and the request can be handled using the IP address as the server name.

  > Also good point is `return 444;` for default server name because this will close the connection and log it internally, for any domain that isn't defined in Nginx.

###### Example

```bash
# Place it at the beginning of the configuration file to prevent mistakes.
server {

  # Add default_server to your listen directive in the server that you want to act as the default.
  listen 10.240.20.2:443 default_server ssl;

  # We catch:
  #   - invalid domain names
  #   - requests without the "Host" header
  #   - and all others (also due to the above setting)
  #   - default_server in server_name directive is not required - I add this for a better understanding
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
- [How nginx processes a request](https://nginx.org/en/docs/http/request_processing.html)
- [nginx: how to specify a default server](https://blog.gahooa.com/2013/08/21/nginx-how-to-specify-a-default-server/)

#### :beginner: Use `reload` method to change configurations on the fly

###### Rationale

  > Use the `reload` method of Nginx to achieve a graceful reload of the configuration without stopping the server and dropping any packets.

  > This ability of Nginx is very critical in a high-uptime, dynamic environments for keeping the load balancer or standalone server online.

  > When you restart Nginx you might encounter situation in which Nginx will stop, and won't start back again, because of syntax error. Reload method is safer than restarting because before old process will be terminated, new configuration file is parsed and whole process is aborted if there are any problems with it.

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
kill -HUP $(ps auxw | grep [n]ginx | grep master | awk '{print $2}')
```

###### External resources

- [Changing Configuration](https://nginx.org/en/docs/control.html#reconfiguration)

#### :beginner: Use only one SSL config for specific listen directive

###### Rationale

  > For sharing a single IP address between several HTTPS servers you should use one SSL config (e.g. protocols, ciphers, curves) because changes will affect only the default server.

  > Remember that regardless of SSL parameters, you are able to use multiple SSL certificates.

  > If you want to set up different SSL configurations for the same IP address then it will fail. It's important because SSL configuration is presented for default server - if none of the listen directives have the `default_server` parameter then the first server in your configuration. So you should use only one SSL setup with several names on the same IP address.

  > It's also to prevent mistakes and configuration mismatch.

###### Example

```bash
# Store this configuration in e.g. https.conf
listen 192.168.252.10:443 default_server ssl http2;

ssl_protocols TLSv1.2;
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384";

ssl_prefer_server_ciphers on;

ssl_ecdh_curve secp521r1:secp384r1;

...

# Include this file to the server context (attach domain-a.com for specific listen directive)
server {

  include /etc/nginx/https.conf;

  server_name domain-a.com;

  ...

}

# Include this file to the server context (attach domain-b.com for specific listen directive)
server {

  include /etc/nginx/https.conf;

  server_name domain-b.com;

  ...

}
```

###### External resources

- [Nginx one ip and multiple ssl certificates](https://serverfault.com/questions/766831/nginx-one-ip-and-multiple-ssl-certificates)

#### :beginner: Force all connections over TLS

###### Rationale

  > You should always use HTTPS instead of HTTP to protect your website, even if it doesn’t handle sensitive communications.

  > We have currently the first free and open CA - [Let's Encrypt](https://letsencrypt.org/) - so generating and implementing certificates has never been so easy. It was created to provide free and easy-to-use TLS and SSL certificates.

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
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)

#### :beginner: Use geo/map modules instead allow/deny

###### Rationale

  > Use map or geo modules (one of them) to prevent users abusing your servers.

  > This allows to create variables with values depending on the client IP address.

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
- [Blocking/allowing IP addresses](#blockingallowing-ip-addresses)

#### :beginner: Map all the things...

###### Rationale

  > Manage a large number of redirects with Nginx maps.

  > Map module provides a more elegant solution for clearly parsing a big list of regexes, e.g. User-Agents, Referrers.

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

# turn on in a specific context (e.g. location):
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

  > There's probably more detail than you want, but that can sometimes be a lifesaver (but log file growing rapidly on a very high-traffic sites).

###### Example

```bash
rewrite_log on;
error_log /var/log/nginx/error-debug.log debug;
```

###### External resources

- [A debugging log](https://nginx.org/en/docs/debugging_log.html)

#### :beginner: Use custom log formats for debugging

###### Rationale

  > Anything you can access as a variable in Nginx config, you can log, including non-standard http headers, etc. so it's a simple way to create your own log format for specific situations.

  > This is extremely helpful for debugging specific `location` directives.

###### Example

```bash
# Default main log format from nginx repository:
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
                '$request_completion $connection $connection_requests';

log_format debug-level-2
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" $request_length '
                '$request_completion $connection $connection_requests '
                '$server_addr $server_port $remote_addr $remote_port';
```

###### External resources

- [Module ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html)
- [Nginx: Custom access log format and error levels](https://fabianlee.org/2017/02/14/nginx-custom-access-log-format-and-error-levels/)
- [nginx: Log complete request/response with all headers?](https://serverfault.com/questions/636790/nginx-log-complete-request-response-with-all-headers)

# Performance

#### :beginner: Adjust worker processes

###### Rationale

  > The `worker_processes` directive is the sturdy spine of life for Nginx. This directive is responsible for letting our virtual server know many workers to spawn once it has become bound to the proper IP and port(s).

  > I think for high load proxy servers (also standalone servers) good value is `ALL_CORES - 1` (please test it before used).

  > Rule of thumb: If much time is spent blocked on I/O, worker processes should be increased further.

  Official Nginx documentation say:

  > _When one is in doubt, setting it to the number of available CPU cores would be a good start (the value "auto" will try to autodetect it)._

###### Example

```bash
# VCPU = 4 , expr $(nproc --all) - 1
worker_processes 3;
```

###### External resources

- [Nginx Core Module - worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes)

#### :beginner: Use HTTP/2

###### Rationale

  > The primary goals for HTTP/2 are to reduce latency by enabling full request and response multiplexing, minimize protocol overhead via efficient compression of HTTP header fields, and add support for request prioritization and server push.

  > HTTP/2 will make our applications faster, simpler, and more robust.

  > HTTP/2 is backwards-compatible with HTTP/1.1, so it would be possible to ignore it completely and everything will continue to work as before because if the client that does not support HTTP/2 will never ask the server for an HTTP/2 communication upgrade: the communication between them will be fully HTTP1/1.

###### Example

```bash
# For https:
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

  > Most servers do not purge sessions or ticket keys, thus increasing the risk that a server compromise would leak data from previous (and future) connections.

  > Set SSL Session Timeout to `5` minutes for prevent abused by advertisers like Google and Facebook.

###### Example

```bash
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 5m;
ssl_session_tickets off;
ssl_buffer_size 1400;
```

###### External resources

- [SSL Session (cache)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache)
- [Speeding up TLS: enabling session reuse](https://vincent.bernat.ch/en/blog/2011-ssl-session-reuse-rfc5077)

#### :beginner: Use exact names in `server_name` directive where possible

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

# than to use the simplified form:
server {

    listen       80;

    server_name  .example.org;

    ...

}
```

###### External resources

- [Server names](https://nginx.org/en/docs/http/server_names.html)
- [Virtual server logic](#virtual-server-logic)

#### :beginner: Avoid checks `server_name` with if directive

###### Rationale

  > When Nginx receives a request no matter what is the subdomain being requested, be it `www.example.com` or just the plain `example.com` this if directive is always evaluated. Since you’re requesting Nginx to check for the `Host` header for every request. It’s extremely inefficient.

  > Instead use two server directives like the example below. This approach decreases Nginx processing requirements.

###### Example

```bash
# Bad configuration:
server {

  ...

  server_name                 domain.com www.domain.com;

  if ($host = www.domain.com) {

    return                    301 https://domain.com$request_uri;

  }

  server_name                 domain.com;

  ...

}

# Good configuration:
server {

    server_name               www.domain.com;
    return                    301 $scheme://domain.com$request_uri;
    # If you force your web traffic to use HTTPS:
    #                         301 https://domain.com$request_uri;

}

server {

    listen                    80;

    server_name               domain.com;

    ...

}
```

###### External resources

- [If Is Evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/)

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

  > Nginx provides two directives to limiting download speed:
  >   - `limit_rate_after` - sets the amount of data transferred before the `limit_rate` directive takes effect
  >   - `limit_rate` - allows you to limit the transfer rate of individual client connections (past exceeding `limit_rate_after`)

  > This solution limits Nginx download speed per connection, so, if one user opens multiple e.g. video files, it will be able to download `X * the number of times` he connected to the video files.

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

#### :beginner: Run as an unprivileged user

###### Rationale

  > There is no real difference in security just by changing the process owner name. On the other hand in security, the principle of least privilege states that an entity should be given no more permission than necessary to accomplish its goals within a given system. This way only master process runs as root.

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

  > It is recommended to disable any modules which are not required as this will minimize the risk of any potential attacks by limiting the operations allowed by the web server.

  > The best way to disable unused modules you should use the `configure` option during installation.

###### Example

```bash
# During installation:
./configure --without-http_autoindex_module

# Comment modules in the configuration file e.g. modules.conf:
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

  > Hidden directories and files should never be web accessible. If you use control version system you should defninitely drop the access to the critical hidden directories like a `.git` or `.svn` to prevent expose source code of your application.

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

- [Hidden directories and files as a source of sensitive information about web application](https://medium.com/@_bl4de/hidden-directories-and-files-as-a-source-of-sensitive-information-about-web-application-84e5c534e5ad)

#### :beginner: Hide Nginx version number

###### Rationale

  > Disclosing the version of Nginx running can be undesirable, particularly in environments sensitive to information disclosure.

  But the "Official Apache Documentation (Apache Core Features)" say:

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

  > You should compile Nginx from sources with `ngx_headers_more` to used `more_set_headers` directive.

###### Example

```bash
more_set_headers "Server: Unknown";
```

###### External resources

- [Shhh... don’t let your response headers talk too loudly](https://www.troyhunt.com/shhh-dont-let-your-response-headers/)
- [How to change (hide) the Nginx Server Signature?](https://stackoverflow.com/questions/24594971/how-to-changehide-the-nginx-server-signature)

#### :beginner: Hide upstream proxy headers

###### Rationale

  > When Nginx is used to proxy requests to an upstream server (such as a PHP-FPM instance), it can be beneficial to hide certain headers sent in the upstream response (e.g. the version of PHP running).

###### Example

```bash
proxy_hide_header X-Powered-By;
proxy_hide_header X-AspNetMvc-Version;
proxy_hide_header X-AspNet-Version;
proxy_hide_header X-Drupal-Cache;
```

###### External resources

- [Remove insecure http headers](https://veggiespam.com/headers/)

#### :beginner: Use min. 2048-bit private keys

###### Rationale

  > Advisories recommend 2048 for now. Security experts are projecting that 2048 bits will be sufficient for commercial use until around the year 2030 (as per NIST).

  > Generally there is no compelling reason to choose 4096 bit keys over 2048 provided you use sane expiration intervals.

  > If you want to get **A+ with 100%s on SSL Lab** (for Key Exchange) you should definitely use 4096 bit private keys. That's the main reason why you should use them.

  > Longer keys take more time to generate and require more CPU (please use `openssl speed rsa` on your server) and power when used for encrypting and decrypting, also the SSL handshake at the start of each connection will be slower. It also has a small impact on the client side (e.g. browsers).

  > Use of alternative solution: [ECC Certificate Signing Request (CSR)](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography) - `ECDSA` certificates contain an `ECC` public key. `ECC` keys are better than `RSA & DSA` keys in that the `ECC` algorithm is harder to break.

  The "SSL/TLS Deployment Best Practices" book say:

  > _The cryptographic handshake, which is used to establish secure connections, is an operation whose cost is highly influenced by private key size. Using a key that is too short is insecure, but using a key that is too long will result in "too much" security and slow operation. For most web sites, using RSA keys stronger than 2048 bits and ECDSA keys stronger than 256 bits is a waste of CPU power and might impair user experience. Similarly, there is little benefit to increasing the strength of the ephemeral key exchange beyond 2048 bits for DHE and 256 bits for ECDHE._

  Konstantin Ryabitsev (Reddit):

  > _Generally speaking, if we ever find ourselves in a world where 2048-bit keys are no longer good enough, it won't be because of improvements in brute-force capabilities of current computers, but because RSA will be made obsolete as a technology due to revolutionary computing advances. If that ever happens, 3072 or 4096 bits won't make much of a difference anyway. This is why anything above 2048 bits is generally regarded as a sort of feel-good hedging theatre._

  **My recommendation:**

  > Use 2048-bit key instead 4096-bit at this moment.

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

&nbsp;&nbsp;<sub><a href="#beginner-use-min-2048-bit-private-keys"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_100.png" alt="arrowtr_100"></a></sub>

```bash
( _fd="domain.com.key" ; _len="2048" ; openssl genrsa -out ${_fd} ${_len} )

# Let's Encrypt:
certbot certonly -d domain.com -d www.domain.com
```

&nbsp;&nbsp;<sub><a href="#beginner-use-min-2048-bit-private-keys"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_90.png" alt="arrowtr_90"></a></sub>

###### External resources

- [Key Management Guidelines by NIST](https://csrc.nist.gov/Projects/Key-Management/Key-Management-Guidelines)
- [Cryptographic Key Length Recommendations](https://www.keylength.com/)
- [So you're making an RSA key for an HTTPS certificate. What key size do you use?](https://certsimple.com/blog/measuring-ssl-rsa-keys)
- [RSA Key Sizes: 2048 or 4096 bits?](https://danielpocock.com/rsa-key-sizes-2048-or-4096-bits/)
- [Create a self-signed ECC certificate](https://msol.io/blog/tech/create-a-self-signed-ecc-certificate/)

#### :beginner: Keep only TLS 1.2 and TLS 1.3

###### Rationale

  > It is recommended to run TLS 1.1/1.2/1.3 and fully disable SSLv2, SSLv3 and TLS 1.0 that have protocol weaknesses.

  > TLS 1.1 and 1.2 are both without security issues - but only TLS 1.2 and TLS 1.3 provides modern cryptographic algorithms. TLS 1.3 is a new TLS version that will power a faster and more secure web for the next few years. TLS 1.0 and TLS 1.1 protocols will be removed from browsers at the beginning of 2020.

  > TLS 1.2 does require careful configuration to ensure obsolete cipher suites with identified vulnerabilities are not used in conjunction with it. TLS 1.3 removes the need to make these decisions. TLS 1.3 version also improves TLS 1.2 security, privace and performance issues.

  > Before enabling specific protocol version, you should check which ciphers are supported by the protocol. So if you turn on TLS 1.1, TLS 1.2 and TLS 1.3 both remember about [the correct (and strong)](#beginner-use-only-strong-ciphers) ciphers to handle them. Otherwise, they will not be anyway works without supported ciphers (no TLS handshake will succeed).

  > If you told Nginx to use TLS 1.3, it will use TLS 1.3 only where is available. Nginx supports TLS 1.3 since version 1.13.0 (released in April 2017), when built against OpenSSL 1.1.1 or more.

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

&nbsp;&nbsp;<sub><a href="#beginner-keep-only-tls-12-and-tls-13"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_100.png" alt="arrowtr_100"></a></sub>

TLS 1.3 + 1.2 + 1.1:

```bash
ssl_protocols TLSv1.3 TLSv1.2 TLSv1.1;
```

TLS 1.2 + 1.1:

```bash
ssl_protocols TLSv1.2 TLSv1.1;
```

&nbsp;&nbsp;<sub><a href="#beginner-keep-only-tls-12-and-tls-13"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_95.png" alt="arrowtr_95"></a></sub>

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
- [TLS 1.3 is here to stay](https://www.ssl.com/article/tls-1-3-is-here-to-stay/)
- [How to enable TLS 1.3 on Nginx](https://ma.ttias.be/enable-tls-1-3-nginx/)
- [Phase two of our TLS 1.0 and 1.1 deprecation plan](https://www.fastly.com/blog/phase-two-our-tls-10-and-11-deprecation-plan)
- [Deprecating TLS 1.0 and 1.1 - Enhancing Security for Everyone](https://www.keycdn.com/blog/deprecating-tls-1-0-and-1-1)
- [TLS/SSL Explained – Examples of a TLS Vulnerability and Attack, Final Part](https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/)
- [This POODLE bites: exploiting the SSL 3.0 fallback](https://security.googleblog.com/2014/10/this-poodle-bites-exploiting-ssl-30.html)

#### :beginner: Use only strong ciphers

###### Rationale

  > This parameter changes quite often, the recommended configuration for today may be out of date tomorrow.

  > To check ciphers supports by OpenSSL on your server use: `openssl ciphers -s -v` or `openssl ciphers -s -v ECDHE`.

  > For more security use only strong and not vulnerable ciphersuite.

  > Place `ECDHE` and `DHE` suites at the top of your list. The order is important; because `ECDHE` suites are faster, you want to use them whenever clients supports them.

  > For backward compatibility software components you should use less restrictive ciphers. Not only that you have to enable at least one special `AES128` cipher for HTTP/2 support regarding to [RFC7540: TLS 1.2 Cipher Suites](https://tools.ietf.org/html/rfc7540#section-9.2.2) you also have to allow `prime256` elliptic curves which reduces the score for key exchange by another 10% even if a secure server preferred order is set.

  > If you want to get **A+ with 100%s on SSL Lab** (for Cipher Strength) you should definitely disable `128-bit` ciphers. That's the main reason why you should not use them.

  > In my opinion `128-bit` symmetric encryption doesn’t less secure. For example TLS 1.3 use `TLS_AES_128_GCM_SHA256 (0x1301)` (for TLS-compliant applications). It is not possible to control ciphers for TLS 1.3 without support from client to use new API for TLSv1.3 ciphersuites so at this moment it's always on (also if you disable potentially weak cipher from Nginx). On the other hand the ciphers in TLSv1.3 have been restricted to only a handful of completely secure ciphers by leading crypto experts.

  > For TLS 1.2 you should consider disable weak ciphers without forward secrecy like ciphers with `CBC` algorithm. Using them also reduces the final grade because they don't use ephemeral keys, so there is no forward secrecy.

  > You should also definitely disable weak ciphers regardless of the TLS version do you use, like those with `DSS`, `DSA`, `DES/3DES`, `RC4`, `MD5`, `SHA1`, `null`, anon in the name.

  **My recommendation:**

  > Use only [TLSv1.3 and TLSv1.2](#keep-only-tls1.2-tls13) with below ciphersuites:
  ```bash
  ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384:TLS13-AES-128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256";
  ```

###### Example

Ciphersuite for TLS 1.3:

```bash
ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384";
```

Ciphersuite for TLS 1.2:

```bash
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384";
```

&nbsp;&nbsp;<sub><a href="#beginner-use-only-strong-ciphers"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_100.png" alt="arrowtr_100"></a></sub>

Ciphersuite for TLS 1.3:

```bash
ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384:TLS13-AES-128-GCM-SHA256";
```

Ciphersuite for TLS 1.2:

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

Ciphersuite for TLS 1.1 + 1.2:

```bash
# 1)
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256";

# 2)
ssl_ciphers "ECDHE-ECDSA-CHACHA20-POLY1305:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:!AES256-GCM-SHA256:!AES256-GCM-SHA128:!aNULL:!MD5";
```

&nbsp;&nbsp;<sub><a href="#beginner-use-only-strong-ciphers"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_90.png" alt="arrowtr_90"></a></sub>

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

#### :beginner: Use more secure ECDH Curve

###### Rationale

  > For a SSL server certificate, an "elliptic curve" certificate will be used only with digital signatures (`ECDSA` algorithm).

  > `x25519` is a more secure but slightly less compatible option. To maximise interoperability with existing browsers and servers, stick to `P-256 prime256v1` and `P-384 secp384r1` curves.

  > NSA Suite B says that NSA uses curves `P-256` and `P-384` (in OpenSSL, they are designated as, respectively, `prime256v1` and `secp384r1`). There is nothing wrong with `P-521`, except that it is, in practice, useless. Arguably, `P-384` is also useless, because the more efficient `P-256` curve already provides security that cannot be broken through accumulation of computing power.

  > Use `P-256` to minimize trouble. If you feel that your manhood is threatened by using a 256-bit curve where a 384-bit curve is available, then use `P-384`: it will increases your computational and network costs.

  > If you use TLS 1.3 you should enable `prime256v1` signature algorithm. Without this SSL Lab reports `TLS_AES_128_GCM_SHA256 (0x1301)` signature as weak.

  > If you do not set `ssh_ecdh_curve`, then the Nginx will use its default settings, e.g. Chrome will prefer `x25519`, but this is **not recommended** because you can not control the Nginx's default settings (seems to be `P-256`).

  > Explicitly set `ssh_ecdh_curve X25519:prime256v1:secp521r1:secp384r1;` **decreases the Key Exchange SSL Labs rating**.

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

&nbsp;&nbsp;<sub><a href="#beginner-use-more-secure-ecdh-curve"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_100.png" alt="arrowtr_100"></a></sub>

```bash
# Alternative (this one doesn’t affect compatibility, by the way; it’s just a question of the preferred order).

# This setup downgrade Key Exchange score but is recommended for TLS 1.2 + 1.3:
ssl_ecdh_curve X25519:secp521r1:secp384r1:prime256v1;
```

###### External resources

- [Standards for Efficient Cryptography Group](http://www.secg.org/)
- [SafeCurves: choosing safe curves for elliptic-curve cryptography](https://safecurves.cr.yp.to/)
- [P-521 is pretty nice prime](https://blog.cr.yp.to/20140323-ecdsa.html)
- [Safe ECC curves for HTTPS are coming sooner than you think](https://certsimple.com/blog/safe-curves-and-openssl)
- [Cryptographic Key Length Recommendations](https://www.keylength.com/)
- [Testing for Weak SSL/TLS Ciphers, Insufficient Transport Layer Protection (OTG-CRYPST-001)](https://www.owasp.org/index.php/Testing_for_Weak_SSL/TLS_Ciphers,_Insufficient_Transport_Layer_Protection_(OTG-CRYPST-001))
- [Elliptic Curve performance: NIST vs Brainpool](https://tls.mbed.org/kb/cryptography/elliptic-curve-performance-nist-vs-brainpool)
- [Which elliptic curve should I use?](https://security.stackexchange.com/questions/78621/which-elliptic-curve-should-i-use/91562)

#### :beginner: Use strong Key Exchange

###### Rationale

  > The DH key is only used if DH ciphers are used. Modern clients prefer `ECDHE` instead and if your Nginx accepts this preference then the handshake will not use the DH param at all since it will not do a `DHE` key exchange but an `ECDHE` key exchange.

  > Most of the "modern" profiles from places like Mozilla's ssl config generator no longer recommend using this.

  > Default key size in OpenSSL is `1024 bits` - it's vulnerable and breakable. For the best security configuration use your own `4096 bit` DH Group or use known safe ones pre-defined DH groups (it's recommended) from [mozilla](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096).

###### Example

```bash
# To generate a DH key:
openssl dhparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

# To produce "DSA-like" DH parameters:
openssl dhparam -dsaparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

# To generate a ECDH key:
openssl ecparam -out /etc/nginx/ssl/ecparam.pem -name prime256v1

# Nginx configuration:
ssl_dhparam /etc/nginx/ssl/dhparams_4096.pem;
```

&nbsp;&nbsp;<sub><a href="#beginner-use-strong-key-exchange"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_100.png" alt="arrowtr_100"></a></sub>

###### External resources

- [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
- [Guide to Deploying Diffie-Hellman for TLS](https://weakdh.org/sysadmin.html)
- [Pre-defined DHE groups](https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096)
- [Instructs OpenSSL to produce "DSA-like" DH parameters](https://security.stackexchange.com/questions/95178/diffie-hellman-parameters-still-calculating-after-24-hours/95184#95184)
- [OpenSSL generate different types of self signed certificate](https://security.stackexchange.com/questions/44251/openssl-generate-different-types-of-self-signed-certificate)

#### :beginner: Defend against the BEAST attack

###### Rationale

  > Enables server-side protection from BEAST attacks.

###### Example

```bash
ssl_prefer_server_ciphers on;
```

###### External resources

- [Is BEAST still a threat?](https://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html)

#### :beginner: Disable HTTP compression (mitigation of CRIME/BREACH attacks)

###### Rationale

  > You should probably never use TLS compression. Some user agents (at least Chrome) will disable it anyways. Disabling SSL/TLS compression stops the attack very effectively. A deployment of HTTP/2 over TLS 1.2 must disable TLS compression (please see [RFC 7540: 9.2. Use of TLS Features](https://tools.ietf.org/html/rfc7540#section-9.2).

  > Some attacks are possible (e.g. the real BREACH attack is a complicated) because of gzip (HTTP compression not TLS compression) being enabled on SSL requests. In most cases, the best action is to simply disable gzip for SSL.

  > Compression is not the only requirement for the attack to be done so using it does not mean that the attack will succeed. Generally you should consider whether having an accidental performance drop on HTTPS sites is better than HTTPS sites being accidentally vulnerable.

  > You shouldn't use HTTP compression on private responses when using TLS.

  > Compression can be (I think) okay to HTTP compress publicly available static content like css or js and HTML content with zero sensitive info (like an "About Us" page).

###### Example

```bash
gzip off;
```

###### External resources

- [Is HTTP compression safe?](https://security.stackexchange.com/questions/20406/is-http-compression-safe)
- [HTTP compression continues to put encrypted communications at risk](https://www.pcworld.com/article/3051675/http-compression-continues-to-put-encrypted-communications-at-risk.html)
- [SSL/TLS attacks: Part 2 – CRIME Attack](http://niiconsulting.com/checkmate/2013/12/ssltls-attacks-part-2-crime-attack/)
- [To avoid BREACH, can we use gzip on non-token responses?](https://security.stackexchange.com/questions/172581/to-avoid-breach-can-we-use-gzip-on-non-token-responses)
- [Don't Worry About BREACH](https://blog.ircmaxell.com/2013/08/dont-worry-about-breach.html)

#### :beginner: HTTP Strict Transport Security

###### Rationale

  > The header indicates for how long a browser should unconditionally refuse to take part in unsecured HTTP connection for a specific domain.

###### Example

```bash
add_header Strict-Transport-Security "max-age=63072000; includeSubdomains" always;
```

&nbsp;&nbsp;<sub><a href="#beginner-http-strict-transport-security"><img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/arrowtr_A+.png" alt="arrowtr_A+"></a></sub>

###### External resources

- [HTTP Strict Transport Security Cheat Sheet](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)
- [Security HTTP Headers - Strict-Transport-Security](https://zinoui.com/blog/security-http-headers#strict-transport-security)

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

#### :beginner: Control the behavior of the Referer header (Referrer-Policy)

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

  > This header protects your site from third parties using APIs that have security and privacy implications, and also from your own team adding outdated APIs or poorly optimized images.

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

#### :beginner: Control Buffer Overflow attacks

###### Rationale

  > Buffer overflow attacks are made possible by writing data to a buffer and exceeding that buffers’ boundary and overwriting memory fragments of a process. To prevent this in Nginx we can set buffer size limitations for all clients.

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
keepalive_timeout 5s 5s;
send_timeout 10s;
```

###### External resources

- [Mitigating DDoS Attacks with NGINX and NGINX Plus](https://www.nginx.com/blog/mitigating-ddos-attacks-with-nginx-and-nginx-plus/)
- [SCG WS nginx](https://www.owasp.org/index.php/SCG_WS_nginx)

# Load Balancing

#### :beginner: Tweak passive health checks

###### Rationale

  > Monitoring for health is important on all types of load balancing mainly for business continuity. Passive checks watches for failed or timed-out connections as they pass through Nginx as requested by a client.

  > This functionality is enabled by default but the parameters mentioned here allow you to tweak their behavior. Default values are: `max_fails=1` and `fail_timeout=10s`.

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

  > Comments are good for really permanently disable servers or if you want to leave information for historical purposes.

  > Nginx also provides a `backup` parameter which marks the server as a backup server. It will be passed requests when the primary servers are unavailable. I use this option rarely for the above purposes and only if I am sure that the backends will work at the maintenance time.

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

#### :beginner: Enable DNS CAA Policy

###### Rationale

  > This rule isn't strictly related to Nginx but in my opinion it's also very important important aspect of security.

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

# Configuration Examples

  > Remember to make a copy of the current configuration and all files/directories.

## Installation

I used step-by-step tutorial from [Installation from source](#installation-from-source).

## Configuration

Configuration of Google Cloud instance:

| <b>ITEM</b> | <b>VALUE</b> | <b>COMMENT</b> |
| :---         | :---         | :---         |
| VM | Google Cloud Platform | |
| vCPU | 2x | |
| Memory | 4096MB | |
| HTTP | Varnish on port 80 | |
| HTTPS | Nginx on port 443 | |

## Reverse Proxy

This chapter describes the basic configuration of my proxy server (for [blkcipher.info](https://blkcipher.info) domain).

  > Configuration of my Reverse Proxy server is based on [installation from source](#installation-from-source) chapter. If you go through the installation process step by step you can use the following configuration (minor adjustments may be required).

#### Import configuration

It's very simple - clone the repo, backup your current configuration and perform full directory sync:

```bash
git clone https://github.com/trimstray/nginx-admins-handbook.git

tar czvfp ~/nginx.etc.tgz /etc/nginx && mv /etc/nginx /etc/nginx.old

rsync -avur lib/nginx/ /etc/nginx/
```

  > If you compiled Nginx you should also update/refresh modules. All compiled modules are stored in `/usr/local/src/nginx-${ngx_version}/master/objs` and installed in accordance with the value of the `--modules-path` variable.

#### Set bind IP address

###### Find and replace 192.168.252.2 string in directory and file names

```bash
cd /etc/nginx
find . -depth -name '*192.168.252.2*' -execdir bash -c 'mv -v "$1" "${1//192.168.252.2/xxx.xxx.xxx.xxx}"' _ {} \;
```

###### Find and replace 192.168.252.2 string in configuration files

```bash
cd /etc/nginx
find . -type f -print0 | xargs -0 sed -i 's/192.168.252.2/xxx.xxx.xxx.xxx/g'
```

#### Set your domain name

###### Find and replace blkcipher.info string in directory and file names

```bash
cd /etc/nginx
find . -depth -name '*blkcipher.info*' -execdir bash -c 'mv -v "$1" "${1//blkcipher.info/example.com}"' _ {} \;
```

###### Find and replace blkcipher.info string in configuration files

```bash
cd /etc/nginx
find . -type f -print0 | xargs -0 sed -i 's/blkcipher_info/example_com/g'
find . -type f -print0 | xargs -0 sed -i 's/blkcipher.info/example.com/g'
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
find . -depth -name '*example.com*' -execdir bash -c 'mv -v "$1" "${1//example.com/domain.com}"' _ {} \;
find . -type f -print0 | xargs -0 sed -i 's/example_com/domain_com/g'
find . -type f -print0 | xargs -0 sed -i 's/example.com/domain.com/g'
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
