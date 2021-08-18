# Helpers

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

- **[≡ Helpers](#helpers)**
  * [Installing from prebuilt packages](#installing-from-prebuilt-packages)
    * [RHEL7 or CentOS 7](#rhel7-or-centos-7)
    * [Debian or Ubuntu](#debian-or-ubuntu)
    * [FreeBSD](#freebsd)
  * [Installing from source](#installing-from-source)
    * [Automatic installation on RHEL/Debian/BSD](#automatic-installation-on-rheldebianbsd)
    * [Nginx package](#nginx-package)
    * [Dependencies](#dependencies)
    * [Patches](#patches)
    * [3rd party modules](#3rd-party-modules)
    * [Configure options](#configure-options)
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
    * [Installation Nginx on FreeBSD 11.3](#installation-nginx-on-freebsd-113)
    * [Installation Nginx on FreeBSD 12.1 (from ports)](#installation-nginx-on-freebsd-121-from-ports)
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
    * [Build OpenSSL 1.0.2-chacha version](HELPERS.md#build-openssl-102-chacha-version)
    * [Send request and show response headers](#send-request-and-show-response-headers)
    * [Send request with http method, user-agent, follow redirects and show response headers](#send-request-with-http-method-user-agent-follow-redirects-and-show-response-headers)
    * [Send multiple requests](#send-multiple-requests)
    * [Testing SSL connection](#testing-ssl-connection)
    * [Testing SSL connection (debug mode)](#testing-ssl-connection-debug-mode)
    * [Testing SSL connection with SNI support](#testing-ssl-connection-with-sni-support)
    * [Testing SSL connection with specific SSL version](#testing-ssl-connection-with-specific-ssl-version)
    * [Testing SSL connection with specific cipher](#testing-ssl-connection-with-specific-cipher)
    * [Testing OCSP Stapling](#testing-ocsp-stapling)
    * [Verify 0-RTT](#verify-0-rtt)
    * [Testing SCSV](#testing-scsv)
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
    * [Show information about processes](#show-information-about-processes)
    * [Check memory usage](#check-memory-usage)
    * [Show open files](#show-open-files)
    * [Check segmentation fault messages](#check-segmentation-fault-messages)
    * [Dump configuration](#dump-configuration)
    * [Get the list of configure arguments](#get-the-list-of-configure-arguments)
    * [Check if the module has been compiled](#check-if-the-module-has-been-compiled)
    * [Show the most accessed IP addresses](#show-the-most-accessed-ip-addresses)
    * [Show the most accessed IP addresses (ip and url)](#show-the-most-accessed-ip-addresses-ip-and-url)
    * [Show the most accessed IP addresses (method, code, ip, and url)](#show-the-most-accessed-ip-addresses-method-code-ip-and-url)
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
    * [Capture HTTP requests/responses in real time, filter by GET, HEAD and save to a file](#capture-http-requests--responses-in-real-time-filter-by-get-head-and-save-to-a-file)
    * [Dump a process's memory](#dump-a-processs-memory)
    * [GNU Debugger (gdb)](#gnu-debugger-gdb)
      * [Dump configuration from a running process](#dump-configuration-from-a-running-process)
      * [Show debug log in memory](#show-debug-log-in-memory)
      * [Core dump backtrace](#core-dump-backtrace)
    * [Debugging socket leaks](#debugging-socket-leaks)
  * [Shell aliases](#shell-aliases)
  * [Configuration snippets](#configuration-snippets)
    * [Nginx server header removal](#nginx-server-header-removal)
    * [Custom log formats](#custom-log-formats)
    * [Log only 4xx/5xx](#log-only-4xx5xx)
    * [Restricting access with basic authentication](#restricting-access-with-basic-authentication)
    * [Restricting access with client certificate](#restricting-access-with-client-certificate)
    * [Restricting access by geographical location](#restricting-access-by-geographical-location)
      * [GeoIP 2 database](#geoip-2-database)
    * [Dynamic error pages with SSI](#dynamic-error-pages-with-ssi)
    * [Blocking/allowing IP addresses](#blockingallowing-ip-addresses)
    * [Blocking referrer spam](#blocking-referrer-spam)
    * [Limiting referrer spam](#limiting-referrer-spam)
    * [Blocking User-Agent](#blocking-user-agent)
    * [Limiting User-Agent](#limiting-user-agent)
    * [Limiting the rate of requests with burst mode](#limiting-the-rate-of-requests-with-burst-mode)
    * [Limiting the rate of requests with burst mode and nodelay](#limiting-the-rate-of-requests-with-burst-mode-and-nodelay)
    * [Limiting the rate of requests per IP with geo and map](#limiting-the-rate-of-requests-per-ip-with-geo-and-map)
    * [Limiting the number of connections](#limiting-the-number-of-connections)
    * [Using trailing slashes](#using-trailing-slashes)
    * [Properly redirect all HTTP requests to HTTPS](#properly-redirect-all-http-requests-to-https)
    * [Adding and removing the www prefix](#adding-and-removing-the-www-prefix)
    * [Proxy/rewrite and keep the original URL](#proxyrewrite-and-keep-the-original-url)
    * [Proxy/rewrite and keep the part of original URL](#proxyrewrite-and-keep-the-part-of-original-url)
    * [Proxy/rewrite without changing the original URL (in browser)](#proxyrewrite-without-changing-the-original-url-in-browser)
    * [Modify 301/302 response body](#modify-301302-response-body)
    * [Redirect POST request with payload to external endpoint](#redirect-post-request-with-payload-to-external-endpoint)
    * [Route to different backends based on HTTP method](#route-to-different-backends-based-on-HTTP-method)
    * [Allow multiple cross-domains using the CORS headers](#allow-multiple-cross-domains-using-the-cors-headers)
    * [Set correct scheme passed in X-Forwarded-Proto](#set-correct-scheme-passed-in-x-forwarded-proto)
  * [Other snippets](#other-snippets)
    * [Recreate base directory](#recreate-base-directory)
    * [Create a temporary static backend](#create-a-temporary-static-backend)
    * [Create a temporary static backend with SSL support](#create-a-temporary-static-backend-with-ssl-support)
    * [Generate password file with htpasswd command](#generate-password-file-with-htpasswd-command)
    * [Generate private key without passphrase](#generate-private-key-without-passphrase)
    * [Generate private key with passphrase](#generate-private-key-with-passphrase)
    * [Remove passphrase from private key](#remove-passphrase-from-private-key)
    * [Encrypt existing private key with a passphrase](#encrypt-existing-private-key-with-a-passphrase)
    * [Generate CSR](#generate-csr)
    * [Generate CSR (metadata from existing certificate)](#generate-csr-metadata-from-existing-certificate)
    * [Generate CSR with -config param](#generate-csr-with--config-param)
    * [Generate private key and CSR](#generate-private-key-and-csr)
    * [List available EC curves](#list-available-ec-curves)
    * [Print ECDSA private and public keys](#print-ecdsa-private-and-public-keys)
    * [Generate ECDSA private key](#generate-ecdsa-private-key)
    * [Generate private key and CSR (ECC)](#generate-private-key-with-csr-ecc)
    * [Generate self-signed certificate](#generate-self-signed-certificate)
    * [Generate self-signed certificate from existing private key](#generate-self-signed-certificate-from-existing-private-key)
    * [Generate self-signed certificate from existing private key and csr](#generate-self-signed-certificate-from-existing-private-key-and-csr)
    * [Generate multidomain certificate (Certbot)](#generate-multidomain-certificate-certbot)
    * [Generate wildcard certificate (Certbot)](#generate-wildcard-certificate-certbot)
    * [Generate certificate with 4096 bit private key (Certbot)](#generate-certificate-with-4096-bit-private-key-certbot)
    * [Generate DH public parameters](#generate-dh-public-parameters)
    * [Display DH public parameters](#display-dh-public-parameters)
    * [Extract private key from pfx](#extract-private-key-from-pfx)
    * [Extract private key and certs from pfx](#extract-private-key-and-certs-from-pfx)
    * [Extract certs from p7b](#extract-certs-from-p7b)
    * [Convert DER to PEM](#convert-der-to-pem)
    * [Convert PEM to DER](#convert-pem-to-der)
    * [Verification of the certificate's supported purposes](#verification-of-the-certificates-supported-purposes)
    * [Check private key](#check-private-key)
    * [Verification of the private key](#verification-of-the-private-key)
    * [Get public key from private key](#get-public-key-from-private-key)
    * [Verification of the public key](#verification-of-the-public-key)
    * [Verification of the certificate](#verification-of-the-certificate)
    * [Verification of the CSR](#verification-of-the-csr)
    * [Check the private key and the certificate are match](#check-the-private-key-and-the-certificate-are-match)
    * [Check the private key and the CSR are match](#check-the-private-key-and-the-csr-are-match)
    * [TLSv1.3 and CCM ciphers](#tlsv13-and-ccm-ciphers)

#### Installing from prebuilt packages

  > **:bookmark: [Always keep NGINX up-to-date - Hardening - P1](RULES.md#beginner-always-keep-nginx-up-to-date)**

##### RHEL7 or CentOS 7

###### From EPEL

```bash
# Install epel repository:
yum install epel-release
# or alternative:
#   wget -c --no-check-certificate -c https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
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

##### FreeBSD

###### From FreeBSD Repository

```bash
# Install NGINX:
pkg install nginx
```

  > If you install NGINX on FreeBSD/OpenBSD please see [Tuning FreeBSD for the highload](http://nginx.org/en/docs/freebsd_tuning.html).

#### Installing from source

  > **:bookmark: [Always keep NGINX up-to-date - Hardening - P1](RULES.md#beginner-always-keep-nginx-up-to-date)**

The build is configured using the `configure` command. The configure shell script attempts to guess correct values for various system-dependent variables used during compilation. It uses those values to create a `Makefile`. Of course you can adjust certain environment variables to make configure able to find the packages like a `zlib` or `openssl`, and of many other options (paths, modules).

Before the beginning installation process please read these important articles which describes exactly the entire installation process and the parameters using the `configure` command:

- [Installation and Compile-Time Options](https://www.nginx.com/resources/wiki/start/topics/tutorials/installoptions/)
- [Installing NGINX Open Source](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#configure)
- [Building nginx from Sources](https://nginx.org/en/docs/configure.html)

In this chapter I'll present several very similar methods of installation:

- [Installation Nginx on CentOS 7](#installation-nginx-on-centos-7)
- [Installation OpenResty on CentOS 7](#installation-openresty-on-centos-7)
- [Installation Tengine on Ubuntu 18.04](#installation-tengine-on-ubuntu-1804)
- [Installation Nginx on FreeBSD 11.3](#installation-nginx-on-freebsd-113)
- [Installation Nginx on FreeBSD 12.1 (from ports)](#installation-nginx-on-freebsd-121-from-ports)

Each of them is suited towards a high performance as well as high-concurrency applications. They work great as a high-end proxy servers too. Of course, if you want you can use the default installation (remember about [dependencies](#dependencies)):

```bash
./configure
make && make install
```

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

##### Automatic installation on RHEL/Debian/BSD

Installing from source consists of multiple steps. If you don't want to pass through all of them manually, you can run automated script. I created it to facilitate the whole installation process.

  > It supports Debian and RHEL like distributions, and FreeBSD system.

This tool is located in `lib/ngx_installer.sh`. Configuration file is in `lib/ngx_installer.conf`, variables is in `lib/ngx_installer.vars`. By default, it show prompt to confirm steps but you can disable it if you want:

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

| <b>Debian Like</b> | <b>RedHat Like</b> | <b>FreeBSD\*\*</b> | <b>Comment</b> |
| :---         | :---         | :---         | :---         |
| `gcc`<br>`make`<br>`build-essential`<br>`linux-headers*`<br>`bison` | `gcc`<br>`gcc-c++`<br>`kernel-devel`<br>`bison` | `gcc`<br>`gmake`<br>`bison` | |
| `perl`<br>`libperl-dev`<br>`libphp-embed` | `perl`<br>`perl-devel`<br>`perl-ExtUtils-Embed` | `perl5-devel` | |
| `libssl-dev`* | `openssl-devel`* | | |
| `zlib1g-dev`* | `zlib-devel`* | | |
| `libpcre2-dev`* | `pcre-devel`* | `pcre`* | |
| `lua5.1`<br>`libluajit-5.1-dev`* | `lua`<br>`luajit-devel`* | `lua51`<br>`luajit` | |
| `libxslt-dev` | `libxslt libxslt-devel` | `libxslt` | |
| `libgd-dev` | `gd gd-devel` | `libgd` | |
| `libgeoip-dev` | `GeoIP-devel` | | |
| `libxml2-dev` | `libxml2-devel` | `libxml2` | |
| `libexpat-dev` | `expat-devel` | `expat` | |
| `libgoogle-perftools-dev`<br>`libgoogle-perftools4` | `gperftools-devel` | | |
| | `cpio` | | |
| | `gettext-devel` | | |
| `autoconf` | `autoconf` | `autoconf` | for `jemalloc` from sources |
| `libjemalloc1`<br>`libjemalloc-dev`* | `jemalloc`<br>`jemalloc-devel`* | | for `jemalloc` |
| `libpam0g-dev` | `pam-devel` | | for `ngx_http_auth_pam_module` |
| `jq` | `jq` | `jq` | for [http error pages](https://github.com/trimstray/nginx-admins-handbook/tree/master/lib/nginx/snippets/http-error-pages) generator |
| `git` | `git` | `git` | for `ngx_installer.sh` |
| `wget` | `wget` | `wget` | for `ngx_installer.sh` |
| | | `ncurses` | for `ngx_installer.sh` |

<sup><i>* If you don't use from sources.</i></sup><br>
<sup><i>\*\* The package list for FreeBSD may be incomplete.</i></sup>

Shell one-liners:

```bash
# Ubuntu/Debian
apt-get install gcc make build-essential bison perl libperl-dev lua5.1 libphp-embed libxslt-dev libgd-dev libgeoip-dev libxml2-dev libexpat-dev libgoogle-perftools-dev libgoogle-perftools4 autoconf

apt-get install libssl-dev zlib1g-dev libpcre2-dev libluajit-5.1-dev

apt-get install jq git wget logrotate

# RedHat/CentOS
yum install gcc gcc-c++ kernel-devel bison perl perl-devel perl-ExtUtils-Embed lua libxslt libxslt-devel gd gd-devel GeoIP-devel libxml2-devel expat-devel gperftools-devel cpio gettext-devel autoconf

yum install openssl-devel zlib-devel pcre-devel luajit-devel

yum install jq git wget logrotate

# FreeBSD
pkg install gcc gmake bison perl5-devel lua51 libxslt libgd libxml2 expat autoconf

pkg install pcre luajit

pkg install jq git wget ncurses texinfo gettext gettext-tools
```

##### Patches

- [nginx-remove-server-header.patch](https://gitlab.com/buik/nginx/blob/master/nginx-remove-server-header.patch) - to hide NGINX `Server` header (and more), see also this rule: [Hide Nginx server signature](RULES.md#beginner-hide-nginx-server-signature)
- [TLSv1.3 and CCM ciphers](#tlsv13-and-ccm-ciphers) - to enable `TLS_AES_128_CCM_SHA256` and `TLS_AES_128_CCM_8_SHA256` cipher suites

##### 3rd party modules

  > Not all external modules can work properly with your currently NGINX version. You should read the documentation of each module before adding it to the modules list. You should also to check what version of module is compatible with your NGINX release. What's more, be careful before adding modules on production. Some of them can cause strange behaviors, increased memory and CPU usage, and also reduce the overall performance of NGINX.

  > Before installing external modules please read [Event-Driven architecture](NGINX_BASICS.md#event-driven-architecture) section to understand why poor quality 3rd party modules may reduce NGINX performance.

  > If you have running NGINX on your server, and if you want to add new modules, you'll need to compile them against the same version of NGINX that's currently installed (`nginx -v`) and to make new module compatible with the existing NGINX binary, you need to use the same compile flags (`nginx -V`). For more please see [How to Compile Dynamic NGINX Modules](https://gorails.com/blog/how-to-compile-dynamic-nginx-modules).

  > If you use, e.g. `--with-stream=dynamic`, then all those `stream_xxx` modules must also be built as NGINX dynamic modules. Otherwise you would definitely see those linker errors.

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

- [`ngx_chash_map`](https://github.com/Wine93/chash-map-nginx-module) - creates variables whose values are mapped to group by consistent hashing method

- [`ngx_security_headers`](https://github.com/GetPageSpeed/ngx_security_headers) - adds security headers and removes insecure headers easily

- [`ngx_http_ip2location_module`](https://github.com/ip2location/ip2location-nginx) - enables user to easily perform client's IP to geographical location lookup by using IP2Location database

- [`ngx_http_ip2proxy`](https://github.com/ip2location/ip2location-nginx) - detects visitor IP addresses which are used as VPN anonymizer, open proxies, web proxies and Tor exits

- [`nginx-length-hiding-filter-module`](https://github.com/nulab/nginx-length-hiding-filter-module) - provides functionality to append randomly generated HTML comment to the end of response body to hide correct response length and make it difficult for attackers to guess secure token

<sup><i>* Available in Tengine Web Server (but these modules may have been updated/patched by Tengine Team).</i></sup><br>
<sup><i>** Is already being used in quite a few third party modules.</i></sup>

##### Configure options

Out of the box you probably do not need to provide any flags yourself, the configure script should detect automatically some reasonable defaults.

However, in order to optimize for speed and/or security, you should probably provide a few compiler flags. Red Hat published an article about the flag collections they consider good - see [Compiler and linker](#compiler-and-linker) chapter for more information.

Another reasonable way to do it would be to copy the options used by your distribution provided packages. The maintainer probably knows what he was doing, and you at least know it works for your use case.

There are some of the NGINX configuration options, for more information please see [Building nginx from Sources](http://nginx.org/en/docs/configure.html).

##### Compiler and linker

Out of the box you probably do not need to provide any flags yourself, the configure script should detect automatically some reasonable defaults. However, in order to optimise for speed and/or security, you should probably provide a few compiler flags.

See [this](https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc/) recommendations by RedHat. You should also read [Compilation and Installation](https://wiki.openssl.org/index.php/Compilation_and_Installation) for OpenSSL.

There are examples:

```bash
# Example of use compiler options:
# 1)
--with-cc-opt="-I/usr/local/include -I${OPENSSL_INC} -I${LUAJIT_INC} -I${JEMALLOC_INC} -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC"
# 2)
--with-cc-opt="-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -O3 -g -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf"
# 3)
--with-cc-opt="-I/usr/local/include"

# Example of use linker options:
# 1)
--with-ld-opt="-Wl,-E -L/usr/local/lib -ljemalloc -lpcre -Wl,-rpath,/usr/local/lib,-z,relro -Wl,-z,now -pie"
# 2)
--with-ld-opt="-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib"
# 3)
--with-ld-opt="-L/usr/local/lib"

# For installation on FreeBSD:
--with-cc-opt="-I/usr/local/include"
--with-ld-opt="-L/usr/local/lib"
```

###### Debugging Symbols

Debugging symbols helps obtain additional information for debugging, such as functions, variables, data structures, source file and line number information.

However, if you get the `No symbol table info available` error when you run a `(gdb) backtrace` you should to recompile NGINX with support of debugging symbols. For this it is essential to include debugging symbols with the `-g` flag and make the debugger output easier to understand by disabling compiler optimization with the `-O0` flag:

  > If you use `-O0` remember about disable `-D_FORTIFY_SOURCE=2`, if you don't do it you will get: `error: #warning _FORTIFY_SOURCE requires compiling with optimization (-O)`.

```bash
./configure --with-debug --with-cc-opt='-O0 -g' ...
```

Also if you get errors similar to one of them:

```
Missing separate debuginfo for /usr/lib64/libluajit-5.1.so.2 ...
Reading symbols from /lib64/libcrypt.so.1...(no debugging symbols found) ...
```

You should also recompile libraries with `-g` compiler option and optional with `-O0`. For more information please read [3.9 Options for Debugging Your Program](https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html).

##### SystemTap

SystemTap is a scripting language and tool for dynamically instrumenting running production Linux kernel-based operating systems. It's required for `openresty-systemtap-toolkit` for OpenResty.

  > It's good [all-in-one tutorial](https://gist.github.com/notsobad/b8f5ebb9b99f3a818f30) about install and configure SystemTap on CentOS 7/Ubuntu distributions. In case of problems please see this [SystemTap](https://github.com/shawfdong/hyades/wiki/SystemTap) document.

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
export ngx_version="1.16.0"
```

Set temporary variables:

```bash
export ngx_src="/usr/local/src"
export ngx_base="${ngx_src}/nginx-${ngx_version}"
export ngx_master="${ngx_base}/master"
export ngx_modules="${ngx_base}/modules"

export NGX_PREFIX="/etc/nginx"
export NGX_CONF="${NGX_PREFIX}/nginx.conf"
```

Create directories:

```bash
for i in "${ngx_base}" "${ngx_master}" "${ngx_modules}" ; do

  mkdir "$i"

done
```

Set user/group variables:

```bash
export NGINX_USER="nginx"
export NGINX_GROUP="nginx"
export NGINX_UID="920"
export NGINX_GID="920"
```

###### Dependencies

  > In my configuration I used all prebuilt dependencies without `libssl-dev`, `zlib1g-dev`, `libluajit-5.1-dev`, and `libpcre2-dev` because I compiled them manually - for TLS 1.3 support and with OpenResty recommendation for LuaJIT.

**Install prebuilt packages, export variables and set symbolic link:**

```bash
# It's important and required, regardless of chosen sources:
yum install gcc gcc-c++ kernel-devel bison perl perl-devel perl-ExtUtils-Embed lua libxslt libxslt-devel gd gd-devel GeoIP-devel libxml2-devel expat-devel gperftools-devel cpio gettext-devel autoconf jq git wget logrotate

# In this example we use sources for all below packages so we do not install them:
# yum install openssl-devel zlib-devel pcre-devel luajit-devel

# For LuaJIT (luajit-devel):
export LUAJIT_LIB="/usr/local/lib"

# For original:
# export LUAJIT_INC="/usr/local/include/luajit-2.0"

# For OpenResty's:
export LUAJIT_INC="/usr/local/include/luajit-2.1"

for i in libluajit-5.1.so libluajit-5.1.so.2 liblua.so libluajit.so ; do

  # For original LuaJIT:
  # ln -sf /usr/local/lib/libluajit-5.1.so.2.0.5 ${LUAJIT_LIB}/${i}

  # For OpenResty's LuaJIT:
  ln -sf /usr/local/lib/libluajit-5.1.so.2.1.0 ${LUAJIT_LIB}/${i}

done

# ln -sf /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 ${LUAJIT_LIB}/liblua.so
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

wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.tar.gz && tar xzvf pcre-${pcre_version}.tar.gz

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
#   wget -c --no-check-certificate http://www.zlib.net/zlib-${zlib_version}.tar.gz
#   mkdir -p zlib && tar xzvf zlib-${zlib_version}.tar.gz -C zlib
# or:
#   git clone --depth 1 https://github.com/madler/zlib

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

export openssl_version="1.1.1c"

export OPENSSL_SRC="${ngx_src}/openssl-${openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

wget -c --no-check-certificate https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && tar xzvf openssl-${openssl_version}.tar.gz

cd "${ngx_src}/openssl-${openssl_version}"

# Please run this and add as a compiler param:
export __GCC_SSL=("__SIZEOF_INT128__:enable-ec_nistp_64_gcc_128")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    if [[ -n "$_cc_key" ]] && [[ -n "$_cc_value" ]] ; then

      echo -en "$_cc_value is supported on this machine\n"

      _openssl_gcc+="$_cc_value "

    else

      _openssl_gcc=""

    fi

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
if [[ -z "$_openssl_gcc" ]] ; then

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong

else

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

fi

make -j2 && make test
make install

# Setup PATH environment variables:
cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=${OPENSSL_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${OPENSSL_DIR}/lib:${LD_LIBRARY_PATH}
__EOF__

chmod +x /etc/profile.d/openssl.sh && source /etc/profile.d/openssl.sh

# To make the OpenSSL version visible globally first:
if [[ -e "/usr/bin/openssl" ]] ; then

  _openssl_version=$(openssl version | awk '{print $2}')
  _openssl_date=$(date '+%Y%m%d%H%M%S')
  _openssl_str="openssl-${_openssl_version}-${_openssl_date}"

  mv /usr/bin/openssl /usr/bin/${_openssl_str}

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

else

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

fi

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

# For original LuaJIT:
# export LUAJIT_INC="/usr/local/include/luajit-2.0"
# git clone http://luajit.org/git/luajit-2.0.git luajit2

# For OpenResty's LuaJIT:
export LUAJIT_INC="/usr/local/include/luajit-2.1"
git clone --depth 1 https://github.com/openresty/luajit2

cd "$LUAJIT_SRC"

# Add to compile with debugging symbols:
#   CFLAGS='-g' make ...
make && make install

for i in libluajit-5.1.so libluajit-5.1.so.2 liblua.so libluajit.so ; do

  # For original LuaJIT:
  # ln -sf /usr/local/lib/libluajit-5.1.so.2.0.5 ${LUAJIT_LIB}/${i}

  # For OpenResty's LuaJIT:
  ln -sf /usr/local/lib/libluajit-5.1.so.2.1.0 ${LUAJIT_LIB}/${i}

done

# ln -sf /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 ${LUAJIT_LIB}/liblua.so
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

wget -c --no-check-certificate https://nginx.org/download/nginx-${ngx_version}.tar.gz

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

wget -c --no-check-certificate http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
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
./configure --prefix=$NGX_PREFIX \
            --conf-path=$NGX_CONF \
            --sbin-path=/usr/sbin/nginx \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=$NGINX_USER \
            --group=$NGINX_GROUP \
            --modules-path=${NGX_PREFIX}/modules \
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

Show NGINX version and parameters:

```bash
nginx -V
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
# Debian/Ubuntu
groupadd -r -g $NGINX_GID $NGINX_GROUP

adduser --system --home /non-existent --no-create-home --shell /usr/sbin/nologin --disabled-login --disabled-password --gecos \'nginx user\' --uid $NGINX_UID --group $NGINX_GROUP $NGINX_USER

# RedHat/CentOS
groupadd -r -g $NGINX_GID $NGINX_GROUP

useradd --system --home-dir /non-existent --no-create-home --shell /usr/sbin/nologin --comment \'nginx user\' --uid $NGINX_UID --gid $NGINX_GROUP $NGINX_USER

passwd -l $NGINX_USER
```

Create required directories:

```bash
for i in \
/var/www \
/var/log/nginx \
/var/cache/nginx ; do

  mkdir -p "$i" && chown -R ${NGINX_USER}:${NGINX_GROUP} "$i"

done
```

Include the necessary error pages:

  > You can also define them e.g. in `/etc/nginx/errors.conf` or other file and attach it as needed in server contexts.

- default location: `/etc/nginx/html`
  ```
  50x.html  index.html
  ```

Update modules list and include `modules.conf` to your configuration:

```bash
_mod_dir="${NGX_PREFIX}/modules"

:>"${_mod_dir}.conf"

for _module in $(ls "${_mod_dir}/") ; do

  echo -en "load_module ${_mod_dir}/$_module;\n" >> "${_mod_dir}.conf"

done
```

Create `logrotate` configuration:

```bash
_logrotate_path="/etc/logrotate.d"

cat > "${_logrotate_path}/nginx" << __EOF__
/var/log/nginx/*.log {
  daily
  missingok
  rotate 14
  compress
  delaycompress
  notifempty
  create 0640 $NGINX_USER $NGINX_GROUP
  sharedscripts
  prerotate
    if [ -d ${_logrotate_path}/httpd-prerotate ]; then \
      run-parts ${_logrotate_path}/httpd-prerotate; \
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

Show NGINX version and parameters:

```bash
nginx -V
```

Test NGINX configuration:

```bash
nginx -t -c $NGX_CONF
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
export ngx_src="/usr/local/src"
export ngx_base="${ngx_src}/nginx-${ngx_version}"
export ngx_master="${ngx_base}/master"
export ngx_modules="${ngx_base}/modules"

export NGX_PREFIX="/etc/nginx"
export NGX_CONF="${NGX_PREFIX}/nginx.conf"
```

Create directories:

```bash
for i in "${ngx_base}" "${ngx_master}" "${ngx_modules}" ; do

  mkdir "$i"

done
```

Set user/group variables:

```bash
export NGINX_USER="nginx"
export NGINX_GROUP="nginx"
export NGINX_UID="920"
export NGINX_GID="920"
```

###### Dependencies

  > In my configuration I used all prebuilt dependencies without `libssl-dev`, `zlib1g-dev`, and `libpcre2-dev` because I compiled them manually - for TLS 1.3 support. In addition, LuaJIT comes with OpenResty.

**Install prebuilt packages, export variables and set symbolic link:**

```bash
# It's important and required, regardless of chosen sources:
yum install gcc gcc-c++ kernel-devel bison perl perl-devel perl-ExtUtils-Embed lua libxslt libxslt-devel gd gd-devel GeoIP-devel libxml2-devel expat-devel gperftools-devel cpio gettext-devel autoconf jq git wget logrotate

# In this example we use sources for all below packages so we do not install them:
# yum install openssl-devel zlib-devel pcre-devel
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

wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.tar.gz && tar xzvf pcre-${pcre_version}.tar.gz

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
#   wget -c --no-check-certificate http://www.zlib.net/zlib-${zlib_version}.tar.gz && tar xzvf zlib-${zlib_version}.tar.gz or git clone --depth 1 https://github.com/madler/zlib
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

export openssl_version="1.1.1c"

export OPENSSL_SRC="${ngx_src}/openssl-${openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

wget -c --no-check-certificate https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && tar xzvf openssl-${openssl_version}.tar.gz

cd "${ngx_src}/openssl-${openssl_version}"

# Please run this and add as a compiler param:
export __GCC_SSL=("__SIZEOF_INT128__:enable-ec_nistp_64_gcc_128")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    if [[ -n "$_cc_key" ]] && [[ -n "$_cc_value" ]] ; then

      echo -en "$_cc_value is supported on this machine\n"

      _openssl_gcc+="$_cc_value "

    else

      _openssl_gcc=""

    fi

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
if [[ -z "$_openssl_gcc" ]] ; then

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong

else

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

fi

make -j2 && make test
make install

# Setup PATH environment variables:
cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=${OPENSSL_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${OPENSSL_DIR}/lib:${LD_LIBRARY_PATH}
__EOF__

chmod +x /etc/profile.d/openssl.sh && source /etc/profile.d/openssl.sh

# To make the OpenSSL version visible globally first:
if [[ -e "/usr/bin/openssl" ]] ; then

  _openssl_version=$(openssl version | awk '{print $2}')
  _openssl_date=$(date '+%Y%m%d%H%M%S')
  _openssl_str="openssl-${_openssl_version}-${_openssl_date}"

  mv /usr/bin/openssl /usr/bin/${_openssl_str}

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

else

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

fi

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

wget -c --no-check-certificate https://openresty.org/download/openresty-${ngx_version}.tar.gz

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

wget -c --no-check-certificate http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
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
./configure --prefix=$NGX_PREFIX \
            --conf-path=$NGX_CONF \
            --sbin-path=/usr/sbin/nginx \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=$NGINX_USER \
            --group=$NGINX_GROUP \
            --modules-path=${NGX_PREFIX}/modules \
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

Show OpenResty version and parameters:

```bash
nginx -V
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

The build and installation process is very similar to [Installation Nginx on CentOS 7](#installation-nginx-on-centos-7). However, I will only specify the most important changes.

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
export ngx_src="/usr/local/src"
export ngx_base="${ngx_src}/nginx-${ngx_version}"
export ngx_master="${ngx_base}/master"
export ngx_modules="${ngx_base}/modules"

export NGX_PREFIX="/etc/nginx"
export NGX_CONF="${NGX_PREFIX}/nginx.conf"
```

Create directories:

```bash
for i in "${ngx_base}" "${ngx_master}" "${ngx_modules}" ; do

  mkdir "$i"

done
```

Set user/group variables:

```bash
export NGINX_USER="nginx"
export NGINX_GROUP="nginx"
export NGINX_UID="920"
export NGINX_GID="920"
```

###### Dependencies

Install prebuilt packages, export variables and set symbolic link:

```bash
apt-get install gcc make build-essential bison perl libperl-dev lua5.1 libphp-embed libxslt-dev libgd-dev libgeoip-dev libxml2-dev libexpat-dev libgoogle-perftools-dev libgoogle-perftools4 autoconf jq git wget logrotate

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

wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.tar.gz && tar xzvf pcre-${pcre_version}.tar.gz

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

export openssl_version="1.1.1c"

export OPENSSL_SRC="${ngx_src}/openssl-${openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

wget -c --no-check-certificate https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && tar xzvf openssl-${openssl_version}.tar.gz

cd "${ngx_src}/openssl-${openssl_version}"

# Please run this and add as a compiler param:
export __GCC_SSL=("__SIZEOF_INT128__:enable-ec_nistp_64_gcc_128")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    if [[ -n "$_cc_key" ]] && [[ -n "$_cc_value" ]] ; then

      echo -en "$_cc_value is supported on this machine\n"

      _openssl_gcc+="$_cc_value "

    else

      _openssl_gcc=""

    fi

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
if [[ -z "$_openssl_gcc" ]] ; then

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong

else

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

fi

make -j2 && make test
make install

# Setup PATH environment variables:
cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=${OPENSSL_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${OPENSSL_DIR}/lib:${LD_LIBRARY_PATH}
__EOF__

chmod +x /etc/profile.d/openssl.sh && source /etc/profile.d/openssl.sh

# To make the OpenSSL version visible globally first:
if [[ -e "/usr/bin/openssl" ]] ; then

  _openssl_version=$(openssl version | awk '{print $2}')
  _openssl_date=$(date '+%Y%m%d%H%M%S')
  _openssl_str="openssl-${_openssl_version}-${_openssl_date}"

  mv /usr/bin/openssl /usr/bin/${_openssl_str}

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

else

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

fi

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

# For original LuaJIT:
# export LUAJIT_INC="/usr/local/include/luajit-2.0"
# git clone http://luajit.org/git/luajit-2.0.git luajit2

# For OpenResty's LuaJIT:
export LUAJIT_INC="/usr/local/include/luajit-2.1"
git clone --depth 1 https://github.com/openresty/luajit2

cd "$LUAJIT_SRC"

# Add to compile with debugging symbols:
#   CFLAGS='-g' make ...
make && make install

for i in libluajit-5.1.so libluajit-5.1.so.2 liblua.so libluajit.so ; do

  # For original LuaJIT:
  # ln -sf /usr/local/lib/libluajit-5.1.so.2.0.5 ${LUAJIT_LIB}/${i}

  # For OpenResty's LuaJIT:
  ln -sf /usr/local/lib/libluajit-5.1.so.2.1.0 ${LUAJIT_LIB}/${i}

done

# ln -sf /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 ${LUAJIT_LIB}/liblua.so
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

wget -c --no-check-certificate https://tengine.taobao.org/download/tengine-${ngx_version}.tar.gz

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

wget -c --no-check-certificate http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
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
./configure --prefix=$NGX_PREFIX \
            --conf-path=$NGX_CONF \
            --sbin-path=/usr/sbin/nginx \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=$NGINX_USER \
            --group=$NGINX_GROUP \
            --modules-path=${NGX_PREFIX}/modules \
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

Show Tengine version and parameters:

```bash
nginx -V
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

#### Installation Nginx on FreeBSD 11.3

  > The build and installation process is very similar to [Installation Nginx on CentOS 7](#installation-nginx-on-centos-7). However, I will only specify the most important changes. On FreeBSD you can also build NGINX from ports.

<details>
<summary><b>Show step-by-step NGINX installation</b></summary><br>

* [Pre installation tasks](#pre-installation-tasks-3)
* [Dependencies](#dependencies-3)
* [Get OpenResty sources](#get-openresty-sources-3)
* [Download 3rd party modules](#download-3rd-party-modules-3)
* [Build Nginx](#build-nginx-1)
* [Post installation tasks](#post-installation-tasks-3)

###### Pre installation tasks

Set NGINX version (I use stable release):

```bash
export ngx_version="1.16.0"
```

Set temporary variables:

```bash
export ngx_src="/usr/local/src"
export ngx_base="${ngx_src}/nginx-${ngx_version}"
export ngx_master="${ngx_base}/master"
export ngx_modules="${ngx_base}/modules"

export NGX_PREFIX="/etc/nginx"
export NGX_CONF="${NGX_PREFIX}/nginx.conf"
```

Create directories:

```bash
for i in "${ngx_base}" "${ngx_master}" "${ngx_modules}" ; do

  mkdir "$i"

done
```

Set user/group variables:

```bash
export NGINX_USER="nginx"
export NGINX_GROUP="nginx"
export NGINX_UID="920"
export NGINX_GID="920"
```

###### Dependencies

  > In my configuration I used all prebuilt dependencies without `openssl`, `zlib`, `luajit`, and `pcre` because I compiled them manually - for TLS 1.3 support and with OpenResty recommendation for LuaJIT.

**Install prebuilt packages, export variables and set symbolic link:**

```bash
# It's important and required, regardless of chosen sources:
pkg install gcc gmake bison perl5-devel lua51 libxslt libgd libxml2 expat autoconf jq git wget ncurses texinfo gettext gettext-tools

# In this example we use sources for all below packages so we do not install them:
# pkg install pcre luajit

# For LuaJIT (luajit):
export LUAJIT_SRC="${ngx_src}/luajit2"
export LUAJIT_LIB="/usr/local/lib"

# For original LuaJIT:
# export LUAJIT_INC="/usr/local/include/luajit-2.0"
# git clone http://luajit.org/git/luajit-2.0.git luajit2

# For OpenResty's LuaJIT:
export LUAJIT_INC="/usr/local/include/luajit-2.1"
git clone --depth 1 https://github.com/openresty/luajit2
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

wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.tar.gz && tar xzvf pcre-${pcre_version}.tar.gz

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
#   wget -c --no-check-certificate http://www.zlib.net/zlib-${zlib_version}.tar.gz && tar xzvf zlib-${zlib_version}.tar.gz or git clone --depth 1 https://github.com/madler/zlib
#   cd "${ZLIB_SRC}-${zlib_version}"

# For Cloudflare Zlib:
git clone --depth 1 https://github.com/cloudflare/zlib

cd "$ZLIB_SRC"

./configure

gmake -j2 && gmake test
gmake install
```

OpenSSL:

```bash
cd "${ngx_src}"

export openssl_version="1.1.1c"

export OPENSSL_SRC="${ngx_src}/openssl-${openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

wget -c --no-check-certificate https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && tar xzvf openssl-${openssl_version}.tar.gz

cd "${ngx_src}/openssl-${openssl_version}"

# Please run this and add as a compiler param:
export __GCC_SSL=("")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    if [[ -n "$_cc_key" ]] && [[ -n "$_cc_value" ]] ; then

      echo -en "$_cc_value is supported on this machine\n"

      _openssl_gcc+="$_cc_value "

    else

      _openssl_gcc=""

    fi

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
if [[ -z "$_openssl_gcc" ]] ; then

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong

else

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

fi

# To use/link openssl* port from your system (world):
if [[ ! $(grep -q "DEFAULT_VERSIONS+=ssl=openssl111" /etc/make.conf) ]] ; then

  echo -en "DEFAULT_VERSIONS+=ssl=openssl111\n" >> /etc/make.conf

fi

# After above, you will have to rebuild all required packages for build NGINX from sources.

make -j2 && make test
make install

if [[ -e "/usr/bin/openssl" ]] ; then

  _openssl_version=$(openssl version | awk '{print $2}')
  _openssl_date=$(date '+%Y%m%d%H%M%S')
  _openssl_str="openssl-${_openssl_version}-${_openssl_date}"

  mv /usr/bin/openssl /usr/bin/${_openssl_str}

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

else

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

fi

for i in libssl.so.1.1 libcrypto.so.1.1 ; do

  ln -sf ${ngx_src}/openssl-${openssl_version}/${i} /usr/lib/

done
```

Update links and cache to the shared libraries for both types of installation:

```bash
ldconfig
```

LuaJIT:

```bash
# I recommend to use OpenResty's branch (openresty/luajit2) instead of LuaJIT (LuaJIT/LuaJIT), but both installation methods are similar:
cd "${ngx_src}"

export LUAJIT_SRC="${ngx_src}/luajit2"
export LUAJIT_LIB="/usr/local/lib"

# For original LuaJIT:
export LUAJIT_INC="/usr/local/include/luajit-2.0"
git clone http://luajit.org/git/luajit-2.0.git luajit2

# For OpenResty's LuaJIT:
# export LUAJIT_INC="/usr/local/include/luajit-2.1"
# git clone --depth 1 https://github.com/openresty/luajit2

cd "$LUAJIT_SRC"

# Add to compile with debugging symbols:
#   CFLAGS='-g' make ...
gmake && gmake install

# On FreeBSD you should set them manually or use the following instructions:
for i in libluajit-5.1.so libluajit-5.1.so.2 liblua.so libluajit.so ; do

  # For original LuaJIT:
  ln -sf /usr/local/lib/libluajit-5.1.so.2.0.5 ${LUAJIT_LIB}/${i}

  # For OpenResty's LuaJIT:
  # ln -sf /usr/local/lib/libluajit-5.1.so.2.1.0 ${LUAJIT_LIB}/${i}

done

# ln -sf /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 ${LUAJIT_LIB}/liblua.so

# Without this you get:
/usr/bin/ld: /usr/local/lib/libluajit-5.1.a(lj_err.o): relocation R_X86_64_32S against `a local symbol' can not be used when making a shared object; recompile with -fPIC
/usr/local/lib/libluajit-5.1.a: could not read symbols: Bad value
cc: error: linker command failed with exit code 1 (use -v to see invocation)
gmake[1]: *** [objs/Makefile:2165: objs/ngx_http_lua_module.so] Error 1

# Because:
cd src && test -f libluajit.so && \
  install -m 0755 libluajit.so /usr/local/lib/libluajit-5.1.so.2.1.0 && \
  ldconfig -n /usr/local/lib && \
  ln -sf libluajit-5.1.so.2.1.0 /usr/local/lib/libluajit-5.1.so && \
  ln -sf libluajit-5.1.so.2.1.0 /usr/local/lib/libluajit-5.1.so.2 || :
ldconfig: illegal option -- n
usage: ldconfig [-32] [-aout | -elf] [-Rimrsv] [-f hints_file] [directory | file ...]
```

<a id="sregex"></a>sregex:

  > Required for `replace-filter-nginx-module` module.

```bash
cd "${ngx_src}"

git clone --depth 1 https://github.com/openresty/sregex

cd "${ngx_src}/sregex"

gmake && gmake install
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

gmake && gmake install
```

Update links and cache to the shared libraries for both types of installation:

```bash
ldconfig
```

###### Get Nginx sources

```bash
cd "${ngx_base}"

wget -c --no-check-certificate https://nginx.org/download/nginx-${ngx_version}.tar.gz

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

wget -c --no-check-certificate http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz
mkdir delay-module && tar xzvf delay-module.tar.gz -C delay-module --strip 1
```

For `ngx_brotli`:

```bash
cd "${ngx_modules}/ngx_brotli"

git submodule update --init
```

I also use some modules from Tengine:

- `ngx_backtrace_module` (build error)
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
./configure --prefix=$NGX_PREFIX \
            --conf-path=$NGX_CONF \
            --sbin-path=/usr/sbin/nginx \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=$NGINX_USER \
            --group=$NGINX_GROUP \
            --modules-path=${NGX_PREFIX}/modules \
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
            --with-cc-opt="-I/usr/local/include" \
            --with-ld-opt="-L/usr/local/lib"

# Unused modules (build errors):
# --with-http_geoip_module \
# --with-google_perftools_module \
# --add-module=${ngx_modules}/tengine/modules/ngx_backtrace_module \

gmake -j2 && gmake test
gmake install

ldconfig
```

Show NGINX version and parameters:

```bash
nginx -V
```

And list all files in `/etc/nginx`:

```bash
.
|-- fastcgi.conf
|-- fastcgi.conf.default
|-- fastcgi_params
|-- fastcgi_params.default
|-- html
|   |-- 50x.html
|   `-- index.html
|-- koi-utf
|-- koi-win
|-- mime.types
|-- mime.types.default
|-- modules
|   |-- ngx_http_array_var_module.so
|   |-- ngx_http_delay_module.so
|   |-- ngx_http_echo_module.so
|   |-- ngx_http_headers_more_filter_module.so
|   |-- ngx_http_lua_module.so
|   |-- ngx_http_naxsi_module.so
|   |-- ngx_http_replace_filter_module.so
|   |-- ngx_http_set_misc_module.so
|   `-- ngx_http_sysguard_module.so
|-- nginx.conf
|-- nginx.conf.default
|-- scgi_params
|-- scgi_params.default
|-- uwsgi_params
|-- uwsgi_params.default
`-- win-utf

2 directories, 26 files
```

###### Post installation tasks

Create a system user/group:

```bash
pw group add -g $NGINX_GID $NGINX_GROUP

pw user add -d /non-existent -n $NGINX_USER -g $NGINX_GROUP -s /usr/sbin/nologin -c \'nginx user\' -u $NGINX_UID -g $NGINX_GID -w no
```

Create required directories:

```bash
for i in \
/var/www \
/var/log/nginx \
/var/cache/nginx ; do

  mkdir -p "$i" && chown -R ${NGINX_USER}:${NGINX_GROUP} "$i"

done
```

Include the necessary error pages:

  > You can also define them e.g. in `${NGX_PREFIX}/errors.conf` or other file and attach it as needed in server contexts.

- default location: `${NGX_PREFIX}/html`
  ```
  50x.html  index.html
  ```

Update modules list and include `modules.conf` to your configuration:

```bash
_mod_dir="${NGX_PREFIX}/modules"

:>"${_mod_dir}.conf"

for _module in $(ls "${_mod_dir}/") ; do

  echo -en "load_module ${_mod_dir}/$_module;\n" >> "${_mod_dir}.conf"

done
```

Create `logrotate` configuration:

```bash
_logrotate_path="/usr/local/etc/logrotate.d"

cat > "${_logrotate_path}/nginx" << __EOF__
/var/log/nginx/*/*.log {
  daily
  rotate 90
  missingok
  sharedscripts
  compress
  postrotate
    kill -HUP `cat /var/run/nginx.pid`
  endscript
  dateext
}

/var/log/nginx/*.log {
  daily
  rotate 90
  missingok
  sharedscripts
  compress
  postrotate
    kill -HUP `cat /var/run/nginx.pid`
  endscript
  dateext
}
__EOF__
```

Or `newsyslog` configuration:

```bash
cat > "/etc/newsyslog.conf.d/nginx.conf" << __EOF__
/var/log/access.log               644  7     1024 *     JC /var/run/nginx.pid
/var/log/error.log                644  7     1024 *     JC /var/run/nginx.pid
__EOF__
```

Turn on NGINX service:

```bash
if ! grep -q nginx_enable=\"YES\" /etc/rc.conf ; then

  echo -en "nginx_enable=\"YES\"\\n" >> /etc/rc.conf

fi

# or:
sysrc nginx_enable="YES"
```

Show NGINX version and parameters:

```bash
nginx -V
```

Test NGINX configuration:

```bash
nginx -t -c $NGX_CONF
```

</details>

#### Installation Nginx on FreeBSD 12.1 (from ports)

  > The installation process is different from the previous ones, in my opinion is much simpler, however, has some limitations.

For more information please see:

- [The FreeBSD ports system](https://www.lpthe.jussieu.fr/~talon/freebsdports.html)
- [Exploring FreeBSD (3/3) – a tutorial from the Linux user’s perspective](https://eerielinux.wordpress.com/2015/10/25/exploring-freebsd-33-a-tutorial-from-the-linux-users-perspective/)
- [Non-interactive customization of FreeBSD ports AND saving config to /var/db/ports/\*/options](https://stackoverflow.com/questions/50293239/non-interactive-customization-of-freebsd-ports-and-saving-config-to-var-db-port)
- [Upgrading FreeBSD Ports](http://www.wonkity.com/~wblock/docs/html/portupgrade.html)

<details>
<summary><b>Show step-by-step NGINX installation</b></summary><br>

* [Pre installation tasks](#pre-installation-tasks-4)
* [Update FreeBSD ports tree](#update-freebsd-ports-tree)
* [Dependencies](#dependencies)
* [Download 3rd party modules](#download-3rd-party-modules-4)
* [Build Nginx](#build-nginx-2)
* [Post installation tasks](#post-installation-tasks-4)

###### Pre installation tasks

The following variables should be the same as the NGINX configuration (and compilation) options.

  > They do not affect the settings of the `configure` command.

```bash
export ngx_src="/usr/local/src"

# Default for NGINX port version:
export NGX_PREFIX="/usr/local/etc/nginx"
export NGX_CONF="${NGX_PREFIX}/nginx.conf"
```

Set user/group variables:

```bash
# Default for NGINX port version:
export NGINX_USER="www"
export NGINX_GROUP="www"
```

###### Update FreeBSD ports tree

```bash
cd /usr/ports
portsnap fetch
portsnap extract
portsnap update
```

###### Dependencies

**Install prebuilt packages, export variables and set symbolic link:**

  > Install the OpenSSL library only if the latest version is available. FreeBSD 12.1 has built-in OpenSSL 1.1.1d. If the latest available version is 1.1.1d you don't need to do anything more, go to the NGINX compilation and installation step.

```bash
# It's important and required, regardless of chosen sources:
pkg install gcc gmake bison perl5-devel pcre lua51 libxslt libgd libxml2 expat autoconf jq git wget ncurses texinfo gettext gettext-tools
```

OpenSSL (example 1):

```bash
# Searches ports for NGINX:
psearch openssl

cd /usr/ports/security/openssl111

# Parameters (from: /var/db/ports/security_openssl111/options):
OPTIONS_FILE_SET+=ASYNC
OPTIONS_FILE_SET+=CT
OPTIONS_FILE_SET+=MAN3
OPTIONS_FILE_UNSET+=RFC3779
OPTIONS_FILE_SET+=SHARED
OPTIONS_FILE_SET+=ZLIB
OPTIONS_FILE_UNSET+=ARIA
OPTIONS_FILE_UNSET+=DES
OPTIONS_FILE_UNSET+=GOST
OPTIONS_FILE_UNSET+=IDEA
OPTIONS_FILE_UNSET+=SM2
OPTIONS_FILE_UNSET+=SM3
OPTIONS_FILE_UNSET+=SM4
OPTIONS_FILE_UNSET+=RC2
OPTIONS_FILE_UNSET+=RC4
OPTIONS_FILE_UNSET+=RC5
OPTIONS_FILE_UNSET+=MD2
OPTIONS_FILE_UNSET+=MD4
OPTIONS_FILE_UNSET+=MDC2
OPTIONS_FILE_SET+=RMD160
OPTIONS_FILE_SET+=ASM
OPTIONS_FILE_SET+=SSE2
OPTIONS_FILE_SET+=THREADS
OPTIONS_FILE_SET+=EC
OPTIONS_FILE_SET+=NEXTPROTONEG
OPTIONS_FILE_SET+=SCTP
OPTIONS_FILE_UNSET+=SSL3
OPTIONS_FILE_UNSET+=TLS1
OPTIONS_FILE_UNSET+=TLS1_1
OPTIONS_FILE_SET+=TLS1_2

make config-recursive
make install

# If you want to remove parameters from the options file:
make rmconfig

# If you want to recompile OpenSSL from ports:
# - edit options file manually
make clean
make reinstall # make deinstall install
# - remove options file (see above command)
make config
make clean
make reinstall # make deinstall install

# To use/link openssl* port from your system (world):
if [[ ! $(grep -q "DEFAULT_VERSIONS+=ssl=openssl111" /etc/make.conf) ]] ; then

  echo -en "DEFAULT_VERSIONS+=ssl=openssl111\n" >> /etc/make.conf

fi

# After above, you will have to rebuild all required packages for build NGINX from sources.

if [[ -e "/usr/bin/openssl" ]] ; then

  _openssl_version=$(openssl version | awk '{print $2}')
  _openssl_date=$(date '+%Y%m%d%H%M%S')
  _openssl_str="openssl-${_openssl_version}-${_openssl_date}"

  mv /usr/bin/openssl /usr/bin/${_openssl_str}

  ln -sf /usr/ports/security/openssl111/work/stage/usr/local/bin/openssl /usr/bin/openssl

else

  ln -sf /usr/ports/security/openssl111/work/stage/usr/local/bin/openssl /usr/bin/openssl

fi
```

OpenSSL (example 2):

```bash
cd "${ngx_src}"

export openssl_version="1.1.1c"

export OPENSSL_SRC="${ngx_src}/openssl-${openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

wget -c --no-check-certificate https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && tar xzvf openssl-${openssl_version}.tar.gz

cd "${ngx_src}/openssl-${openssl_version}"

# Please run this and add as a compiler param:
export __GCC_SSL=("")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    if [[ -n "$_cc_key" ]] && [[ -n "$_cc_value" ]] ; then

      echo -en "$_cc_value is supported on this machine\n"

      _openssl_gcc+="$_cc_value "

    else

      _openssl_gcc=""

    fi

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
if [[ -z "$_openssl_gcc" ]] ; then

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong

else

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

fi

# To use/link openssl* port from your system (world):
if [[ ! $(grep -q "DEFAULT_VERSIONS+=ssl=openssl111" /etc/make.conf) ]] ; then

  echo -en "DEFAULT_VERSIONS+=ssl=openssl111\n" >> /etc/make.conf

fi

# After above, you will have to rebuild all required packages for build NGINX from sources.

make -j2 && make test
make install

if [[ -e "/usr/bin/openssl" ]] ; then

  _openssl_version=$(openssl version | awk '{print $2}')
  _openssl_date=$(date '+%Y%m%d%H%M%S')
  _openssl_str="openssl-${_openssl_version}-${_openssl_date}"

  mv /usr/bin/openssl /usr/bin/${_openssl_str}

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

else

  ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl

fi

for i in libssl.so.1.1 libcrypto.so.1.1 ; do

  ln -sf ${ngx_src}/openssl-${openssl_version}/${i} /usr/lib/

done
```

Update links and cache to the shared libraries for both types of installation:

```bash
ldconfig
```

###### Download 3rd party modules

Work in progress.

###### Build Nginx

Searches ports for NGINX:

```bash
psearch nginx
```

Go to the main NGINX port directory:

```bash
cd /usr/ports/www/nginx
```

Before these tasks create backup of your current NGINX config:

```bash
tar czvfp /usr/backup/nginx.tgz /usr/local/etc/nginx
```

Parameters:

```bash
# From /var/db/ports/www_nginx/options:
OPTIONS_FILE_SET+=DEBUG
OPTIONS_FILE_SET+=DEBUGLOG
OPTIONS_FILE_SET+=DSO
OPTIONS_FILE_SET+=FILE_AIO
OPTIONS_FILE_UNSET+=IPV6
OPTIONS_FILE_SET+=THREADS
OPTIONS_FILE_SET+=WWW
OPTIONS_FILE_UNSET+=GSSAPI_BASE
OPTIONS_FILE_UNSET+=GSSAPI_HEIMDAL
OPTIONS_FILE_UNSET+=GSSAPI_MIT
OPTIONS_FILE_UNSET+=MAIL
OPTIONS_FILE_UNSET+=MAIL_IMAP
OPTIONS_FILE_UNSET+=MAIL_POP3
OPTIONS_FILE_UNSET+=MAIL_SMTP
OPTIONS_FILE_UNSET+=MAIL_SSL
OPTIONS_FILE_UNSET+=GOOGLE_PERFTOOLS
OPTIONS_FILE_SET+=HTTP
OPTIONS_FILE_UNSET+=HTTP_ADDITION
OPTIONS_FILE_SET+=HTTP_AUTH_REQ
OPTIONS_FILE_SET+=HTTP_CACHE
OPTIONS_FILE_UNSET+=HTTP_DAV
OPTIONS_FILE_UNSET+=HTTP_FLV
OPTIONS_FILE_SET+=HTTP_GUNZIP_FILTER
OPTIONS_FILE_SET+=HTTP_GZIP_STATIC
OPTIONS_FILE_UNSET+=HTTP_IMAGE_FILTER
OPTIONS_FILE_UNSET+=HTTP_MP4
OPTIONS_FILE_UNSET+=HTTP_PERL
OPTIONS_FILE_UNSET+=HTTP_RANDOM_INDEX
OPTIONS_FILE_SET+=HTTP_REALIP
OPTIONS_FILE_SET+=HTTP_REWRITE
OPTIONS_FILE_UNSET+=HTTP_SECURE_LINK
OPTIONS_FILE_UNSET+=HTTP_SLICE
OPTIONS_FILE_UNSET+=HTTP_SLICE_AHEAD
OPTIONS_FILE_SET+=HTTP_SSL
OPTIONS_FILE_SET+=HTTP_STATUS
OPTIONS_FILE_SET+=HTTP_SUB
OPTIONS_FILE_UNSET+=HTTP_XSLT
OPTIONS_FILE_SET+=HTTPV2
OPTIONS_FILE_SET+=STREAM
OPTIONS_FILE_SET+=STREAM_SSL
OPTIONS_FILE_SET+=STREAM_SSL_PREREAD
OPTIONS_FILE_UNSET+=AJP
OPTIONS_FILE_UNSET+=AWS_AUTH
OPTIONS_FILE_UNSET+=BROTLI
OPTIONS_FILE_UNSET+=CACHE_PURGE
OPTIONS_FILE_UNSET+=CLOJURE
OPTIONS_FILE_UNSET+=CT
OPTIONS_FILE_UNSET+=DEVEL_KIT
OPTIONS_FILE_UNSET+=ARRAYVAR
OPTIONS_FILE_UNSET+=DRIZZLE
OPTIONS_FILE_SET+=DYNAMIC_UPSTREAM
OPTIONS_FILE_SET+=ECHO
OPTIONS_FILE_UNSET+=ENCRYPTSESSION
OPTIONS_FILE_UNSET+=FASTDFS
OPTIONS_FILE_UNSET+=FORMINPUT
OPTIONS_FILE_UNSET+=GRIDFS
OPTIONS_FILE_SET+=HEADERS_MORE
OPTIONS_FILE_UNSET+=HTTP_ACCEPT_LANGUAGE
OPTIONS_FILE_UNSET+=HTTP_AUTH_DIGEST
OPTIONS_FILE_UNSET+=HTTP_AUTH_KRB5
OPTIONS_FILE_UNSET+=HTTP_AUTH_LDAP
OPTIONS_FILE_UNSET+=HTTP_AUTH_PAM
OPTIONS_FILE_UNSET+=HTTP_DAV_EXT
OPTIONS_FILE_UNSET+=HTTP_EVAL
OPTIONS_FILE_UNSET+=HTTP_FANCYINDEX
OPTIONS_FILE_SET+=HTTP_FOOTER
OPTIONS_FILE_SET+=HTTP_GEOIP2
OPTIONS_FILE_SET+=HTTP_IP2LOCATION
OPTIONS_FILE_SET+=HTTP_IP2PROXY
OPTIONS_FILE_UNSET+=HTTP_JSON_STATUS
OPTIONS_FILE_UNSET+=HTTP_MOGILEFS
OPTIONS_FILE_UNSET+=HTTP_MP4_H264
OPTIONS_FILE_UNSET+=HTTP_NOTICE
OPTIONS_FILE_UNSET+=HTTP_PUSH
OPTIONS_FILE_UNSET+=HTTP_PUSH_STREAM
OPTIONS_FILE_UNSET+=HTTP_REDIS
OPTIONS_FILE_UNSET+=HTTP_RESPONSE
OPTIONS_FILE_UNSET+=HTTP_SUBS_FILTER
OPTIONS_FILE_UNSET+=HTTP_TARANTOOL
OPTIONS_FILE_UNSET+=HTTP_UPLOAD
OPTIONS_FILE_UNSET+=HTTP_UPLOAD_PROGRESS
OPTIONS_FILE_SET+=HTTP_UPSTREAM_CHECK
OPTIONS_FILE_SET+=HTTP_UPSTREAM_FAIR
OPTIONS_FILE_SET+=HTTP_UPSTREAM_STICKY
OPTIONS_FILE_UNSET+=HTTP_VIDEO_THUMBEXTRACTOR
OPTIONS_FILE_UNSET+=HTTP_ZIP
OPTIONS_FILE_UNSET+=ICONV
OPTIONS_FILE_UNSET+=LET
OPTIONS_FILE_UNSET+=LUA
OPTIONS_FILE_UNSET+=MEMC
OPTIONS_FILE_UNSET+=MODSECURITY
OPTIONS_FILE_UNSET+=MODSECURITY3
OPTIONS_FILE_SET+=NAXSI
OPTIONS_FILE_UNSET+=NJS
OPTIONS_FILE_UNSET+=PASSENGER
OPTIONS_FILE_UNSET+=POSTGRES
OPTIONS_FILE_UNSET+=RDS_CSV
OPTIONS_FILE_UNSET+=RDS_JSON
OPTIONS_FILE_UNSET+=REDIS2
OPTIONS_FILE_UNSET+=RTMP
OPTIONS_FILE_SET+=SET_MISC
OPTIONS_FILE_UNSET+=SFLOW
OPTIONS_FILE_UNSET+=SHIBBOLETH
OPTIONS_FILE_UNSET+=SLOWFS_CACHE
OPTIONS_FILE_UNSET+=SMALL_LIGHT
OPTIONS_FILE_UNSET+=SRCACHE
OPTIONS_FILE_UNSET+=VOD
OPTIONS_FILE_SET+=VTS
OPTIONS_FILE_UNSET+=XSS
OPTIONS_FILE_UNSET+=WEBSOCKIFY
```

The simplest way to install:

```bash
make install
make clean
```

or with pre-install configuration:

```bash
make config-recursive
make install
make clean
```

But if you want to run other tasks:

- remove parameters from the options file:

  ```bash
  make rmconfig
  ```

- recompile NGINX from ports:

  ```bash
  # The following task are not necessery:
  # - edit options file manually
  # - regenerate options file with wizard:
  make config
  # - remove options file:
  make rmconfig
  # after this you might to run pre-install configuration:
  make config-recursive

  make clean
  make reinstall # make deinstall install
  ```

- to disable vulnerabilities (not recommend!):

  ```bash
  make DISABLE_VULNERABILITIES=yes reinstall
  ```

###### Post installation tasks

Include the necessary error pages:

  > You can also define them e.g. in `${NGX_PREFIX}/errors.conf` or other file and attach it as needed in server contexts.

- default location: `${NGX_PREFIX}/html`
  ```
  50x.html  index.html
  ```

Update modules list and include `modules.conf` to your configuration:

```bash
NGX_PREFIX="/usr/local/etc/nginx"
_mod_dir="/usr/local/libexec/nginx"

:>"${NGX_PREFIX}/modules.conf"

for _module in $(ls "${_mod_dir}/") ; do

  echo -en "load_module ${_mod_dir}/$_module;\n" >> "${NGX_PREFIX}/modules.conf"

done
```

Create `logrotate` configuration:

```bash
_logrotate_path="/usr/local/etc/logrotate.d"

cat > "${_logrotate_path}/nginx" << __EOF__
/var/log/nginx/*/*.log {
  daily
  rotate 90
  missingok
  sharedscripts
  compress
  postrotate
    kill -HUP `cat /var/run/nginx.pid`
  endscript
  dateext
}

/var/log/nginx/*.log {
  daily
  rotate 90
  missingok
  sharedscripts
  compress
  postrotate
    kill -HUP `cat /var/run/nginx.pid`
  endscript
  dateext
}
__EOF__
```

Or `newsyslog` configuration:

```bash
cat > "/etc/newsyslog.conf.d/nginx.conf" << __EOF__
/var/log/access.log               644  7     1024 *     JC /var/run/nginx.pid
/var/log/error.log                644  7     1024 *     JC /var/run/nginx.pid
__EOF__
```

Turn on NGINX service:

```bash
if ! grep -q nginx_enable=\"YES\" /etc/rc.conf ; then

  echo -en "nginx_enable=\"YES\"\\n" >> /etc/rc.conf

fi

# or:
sysrc nginx_enable="YES"
```

Show NGINX version and parameters:

```bash
nginx -V
```

Test NGINX configuration:

```bash
nginx -t -c $NGX_CONF
```

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

```
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

wget -c --no-check-certificate -c https://tar.goaccess.io/goaccess-1.3.tar.gz && \
tar xzvfp goaccess-1.3.tar.gz

cd goaccess-1.3

./configure --enable-utf8 --enable-geoip=legacy --with-openssl=<path_to_openssl_sources> --sysconfdir=/etc/

make -j2 && make install

ln -sf /usr/local/bin/goaccess /usr/bin/goaccess
```

  > You can always fetch default configuration from `/usr/local/src/goaccess-<version>/config/goaccess.conf` source tree.

###### Analyse log file and enable all recorded statistics

```bash
_fd="access.log"
goaccess -f "$_fd" -a
```

###### Analyse compressed log file

```bash
_fd="access.log.1.gz"
zcat "$_fd" | goaccess -a -p /etc/goaccess/goaccess.conf
```

###### Analyse log file remotely

```bash
_fd="access.log"
ssh user@remote_host "$_fd" | goaccess -a
```

###### Analyse log file and generate html report

```bash
_fd="access.log"
goaccess -p /etc/goaccess/goaccess.conf -f "$_fd" --log-format=COMBINED -o /var/www/index.html
```

##### Ngxtop

###### Analyse log file

```bash
_fd="access.log"
ngxtop -l "$_fd"
```

###### Analyse log file and print requests with 4xx and 5xx

```bash
_fd="access.log"
ngxtop -l "$_fd" -i 'status >= 400' print request status
```

###### Analyse log file remotely

```bash
_fd="access.log"
ssh user@remote_host tail -f "$_fd" | ngxtop -f combined
```

#### Testing

  > You can change combinations and parameters of these commands.

###### Build OpenSSL 1.0.2-chacha version

OpenSSL [1.0.2-chacha](https://github.com/PeterMosmans/openssl) fork is used as standard OpenSSL distribution for numerous SSL/TLS pentesting tools. It includes default support for ciphers that are deemed insecure, and has extensive starttls support.

See also [Rebase OpenSSL 1.0.2-chacha to use TLS 1.3](https://www.onwebsecurity.com/announcements/rebase-openssl-1-0-2-chacha-to-use-tls-1-3.html).

Set temporary variables:

```bash
export OPENSSL_SRC=/usr/local/src/openssl-1.0.2-chacha
export OPENSSL_DIR=/usr/local/openssl-1.0.2-chacha
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"
```

Create directories:

```bash
for i in "${OPENSSL_SRC}" "${OPENSSL_DIR}" ; do mkdir "$i" ; done
```

Clone repository:

```bash
git clone https://github.com/PeterMosmans/openssl.git "${OPENSSL_SRC}"
```

Build and install:

```bash
cd "${OPENSSL_SRC}"

# Please run this and add as a compiler param:
export __GCC_SSL=("__SIZEOF_INT128__:enable-ec_nistp_64_gcc_128")

for _cc_opt in "${__GCC_SSL[@]}" ; do

    _cc_key=$(echo "$_cc_opt" | cut -d ":" -f1)
    _cc_value=$(echo "$_cc_opt" | cut -d ":" -f2)

  if [[ ! $(gcc -dM -E - </dev/null | grep -q "$_cc_key") ]] ; then

    if [[ -n "$_cc_key" ]] && [[ -n "$_cc_value" ]] ; then

      echo -en "$_cc_value is supported on this machine\n"

      _openssl_gcc+="$_cc_value "

    else

      _openssl_gcc=""

    fi

  fi

done

# Add to compile with debugging symbols:
#   ./config -d ...
if [[ -z "$_openssl_gcc" ]] ; then

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong

else

  ./config --prefix="$OPENSSL_DIR" --openssldir="$OPENSSL_DIR" shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong "$_openssl_gcc"

fi

make depend
make -j2
make install
```

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

###### Testing SSL connection (debug mode)

```bash
echo | openssl s_client -connect <server_name>:<port> -showcerts -tlsextdebug -status
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

###### Testing OCSP Stapling

```bash
openssl s_client -connect example.com:443 -servername example.com -tls1 -tlsextdebug -status
echo | openssl s_client -connect example.com:443 -servername example.com  -status 2> /dev/null | grep -A 17 'OCSP response:'
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

###### Testing SCSV

```bash
_host="example.com"

openssl s_client -connect ${_host}:443 -tlsextdebug -status -fallback_scsv -no_tls1_3
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

# FreeBSD:
pkg install lua51 luajit
cd /usr/ports/devel/lua-luarocks && make install clean

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

  > You can change combinations and parameters of these commands. When carrying out the analysis, remember about [debug log](RULES.md#beginner-use-debug-mode-for-debugging) and [log formats](RULES.md#beginner-use-custom-log-formats-for-debugging).

##### Show information about processes

With `ps`:

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

With `top`:

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

With `ps_mem`:

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

With `pmap`:

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

##### Check segmentation fault messages

```bash
dmesg | grep nginx | grep segfault # | wc -l
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
# - add `grep "string"` to the end to filter by specific string
# - add this to the end for print header:
#   ... | xargs printf '%10s%20s\n%10s%20s\n' "AMOUNT" "IP_ADDRESS"
_fd="access.log"
awk '{print $1}' "$_fd" | sort | uniq -c | sort -nr
```

##### Show the most accessed IP addresses (ip and url)

```bash
# - add `head -n X` to the end to limit the result
# - add `grep "string"` to the end to filter by specific string
# - add this to the end for print header:
#   ... | xargs printf '%10s%20s\t%s\n%10s%20s\t%s\n' "AMOUNT" "IP" "URL"
awk '{print $1 " " $7}' "$_fd" | sort | uniq -c | sort -nr
```

##### Show the most accessed IP addresses (method, code, ip, and url)

```bash
# - add `head -n X` to the end to limit the result
# - add `grep "string"` to the end to filter by specific string
# - add this to the end for print header:
#   ... | xargs printf '%10s%10s%10s%20s\t%s\n%10s%10s%10s%20s\t%s\n' "AMOUNT" "METHOD" "CODE" "IP" "URL"
_fd="access.log"
awk '{print $6 "\" " $9 " " $1 " " $7}' "$_fd" | sort | uniq -c | sort -nr
```

##### Show the top 5 visitors (IP addresses)

```bash
# - add this to the end for print header:
#   ... | xargs printf '%10s%10s%20s\n%10s%10s%20s\n' "NUM" "AMOUNT" "IP_ADDRESS"
_fd="access.log"
cut -d ' ' -f1 "$_fd" | sort | uniq -c | sort -nr | head -5 | nl
```

##### Show the most requested urls

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "URL"
_fd="access.log"
awk -F\" '{print $2}' "$_fd" | awk '{print $2}' | sort | uniq -c | sort -nr
```

##### Show the most requested urls containing 'string'

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "URL"
_fd="access.log"
awk -F\" '($2 ~ "/string") {print $2}' "$_fd" | awk '{print $2}' | sort | uniq -c | sort -nr
```

##### Show the most requested urls with http methods

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s %8s\t%s\n%10s %8s\t%s\n' "AMOUNT" "METHOD" "URL"
_fd="access.log"
awk -F\" '{print $2}' "$_fd" | awk '{print $1 "\t" $2}' | sort | uniq -c | sort -nr
```

##### Show the most accessed response codes

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "HTTP_CODE"
_fd="access.log"
awk '{print $9}' "$_fd" | sort | uniq -c | sort -nr
```

##### Analyse web server log and show only 2xx http codes

```bash
_fd="access.log"
tail -n 100 -f "$_fd" | grep "HTTP/[1-2].[0-1]\" [2]"
```

##### Analyse web server log and show only 5xx http codes

```bash
_fd="access.log"
tail -n 100 -f "$_fd" | grep "HTTP/[1-2].[0-1]\" [5]"
```

##### Show requests which result 502 and sort them by number per requests by url

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "URL"
_fd="access.log"
awk '($9 ~ /502/)' "$_fd" | awk '{print $7}' | sort | uniq -c | sort -nr
```

##### Show requests which result 404 for php files and sort them by number per requests by url

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "URL"
_fd="access.log"
awk '($9 ~ /401/)' "$_fd" | awk -F\" '($2 ~ "/*.php")' | awk '{print $7}' | sort | uniq -c | sort -nr
```

##### Calculating amount of http response codes

```bash
# Not less than 1 minute:
_fd="access.log"
tail -2000 "$_fd" | awk -v date=$(date -d '1 minutes ago' +"%d/%b/%Y:%H:%M") '$4 ~ date' | cut -d '"' -f3 | cut -d ' ' -f2 | sort | uniq -c | sort -nr

# Last 2000 requests from log file:
# - add this to the end for print header:
#   ... | xargs printf '%10s\t%s\n%10s\t%s\n' "AMOUNT" "HTTP_CODE"
_fd="access.log"
tail -2000 "$_fd" | cut -d '"' -f3 | cut -d ' ' -f2 | sort | uniq -c | sort -nr
```

##### Calculating requests per second

```bash
# In real time:
_fd="access.log"
tail -F "$_fd" | pv -lr >/dev/null

# https://serverfault.com/a/641552
tail -F "$_fd" | pv --line-mode --rate --timer --average-rate -b >/dev/null

# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s%24s%18s\n%10s%24s%18s\n' "AMOUNT" "DATE" "IP_ADDRESS"
_fd="access.log"
awk '{print $4}' "$_fd" | uniq -c | sort -nr | tr -d "["
```

##### Calculating requests per second with IP addresses

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s%24s%18s\n%10s%24s%18s\n' "AMOUNT" "DATE" "IP_ADDRESS"
_fd="access.log"
awk '{print $4 " " $1}' "$_fd" | uniq -c | sort -nr | tr -d "["
```

##### Calculating requests per second with IP addresses and urls

```bash
# - add `head -n X` to the end to limit the result
# - add this to the end for print header:
#   ... | xargs printf '%10s%24s%18s\t%s\n%10s%24s%18s\t%s\n' "AMOUNT" "DATE" "IP_ADDRESS" "URL"
_fd="access.log"
awk '{print $4 " " $1 " " $7}' "$_fd" | uniq -c | sort -nr | tr -d "["
```

##### Get entries within last n hours

```bash
_fd="access.log"
awk -v _date=`date -d 'now-6 hours' +[%d/%b/%Y:%H:%M:%S` ' { if ($4 > _date) print $0}' "$_fd"

# date command shows output for specific locale, for prevent this you should set LANG variable:
_fd="access.log"
awk -v _date=$(LANG=en_us.utf-8 date -d 'now-6 hours' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _date) print $0}' "$_fd"

# or:
_fd="access.log"
export LANG=en_us.utf-8
awk -v _date=$(date -d 'now-6 hours' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _date) print $0}' "$_fd"
```

##### Get entries between two timestamps (range of dates)

```bash
# 1)
_fd="access.log"
awk '$4>"[05/Feb/2019:02:10" && $4<"[15/Feb/2019:08:20"' "$_fd"

# 2)
# date command shows output for specific locale, for prevent this you should set LANG variable:
_fd="access.log"
awk -v _dateB=$(LANG=en_us.utf-8 date -d '10:20' +[%d/%b/%Y:%H:%M:%S) -v _dateE=$(LANG=en_us.utf-8 date -d '20:30' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _dateB && $4 < _dateE) print $0}' "$_fd"

# or:
_fd="access.log"
export LANG=en_us.utf-8
awk -v _dateB=$(date -d '10:20' +[%d/%b/%Y:%H:%M:%S) -v _dateE=$(date -d '20:30' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _dateB && $4 < _dateE) print $0}' "$_fd"

# 3)
# date command shows output for specific locale, for prevent this you should set LANG variable:
_fd="access.log"
awk -v _dateB=$(LANG=en_us.utf-8 date -d 'now-12 hours' +[%d/%b/%Y:%H:%M:%S) -v _dateE=$(LANG=en_us.utf-8 date -d 'now-2 hours' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _dateB && $4 < _dateE) print $0}' "$_fd"

# or:
_fd="access.log"
export LANG=en_us.utf-8
awk -v _dateB=$(date -d 'now-12 hours' +[%d/%b/%Y:%H:%M:%S) -v _dateE=$(date -d 'now-2 hours' +[%d/%b/%Y:%H:%M:%S) ' { if ($4 > _dateB && $4 < _dateE) print $0}' "$_fd"
```

##### Get line rates from web server log

```bash
_fd="access.log"
tail -F "$_fd" | pv -N RAW -lc 1>/dev/null
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

```nginx
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

##### Capture HTTP requests/responses in real time, filter by GET, HEAD and save to a file

```bash
httpry -i eth0 -o output.dump -m get,head
```

  * `-m` - monitor only specific HTTP methods
  * `-o` - output txt file, `-b` - output binary file (raw HTTP packets)

##### Check CLOSE_WAIT connections

```bash
netstat -anp | grep CLOSE_WAIT | grep -c nginx
```

See also [this](https://github.com/openresty/openresty/issues/323#issuecomment-352516797) great answer by [agentzh](https://github.com/agentzh):

  > _If your NGINX worker processes' CPU usage is high when you see `CLOSE_WAIT` connections are growing, then you should sample a CPU flamegraph with `perf` or with `systemtap` (like `sample-bt`). If your NGINX worker proesses' CPU is low, then you should sample an off-CPU flamegraph to analyze (using `perf` or using a `systemtap` tool like `sample-bt-off-cpu`). In case of off-CPU blocking, use of tools like `strace` can be helpful as well._

##### Dump a process's memory

  > For more information about analyse core dumps please see [GNU Debugger (gdb) - Core dump backtrace](#core-dump-backtrace).

  > Will make the debugger output easier to understand see [Debugging Symbols](#debugging-symbols).

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

```gdb
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

Or other solution:

```gdb
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

```nginx
error_log   memory:64m debug;
```

Next:

```gdb
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

#### Debugging socket leaks

Typically a resource leak is defined as an erroneous condition of a program when it is allocating more resources than it actually needs.

Debugging socket leaks may produce the following alerts in your error log:

```
2015/12/10 01:36:39 [alert] 27263#27263: *241 open socket #71 left in connection 56
2015/12/10 01:36:39 [alert] 27263#27263: *242 open socket #73 left in connection 61
```

  > Disable third party modules and check your error log, it can be a good solution, added the warnings may not appear after that.

The official documentation say:

  > _This directive is used for debugging. When internal error is detected, e.g. the leak of sockets on restart of working processes, enabling `debug_points` leads to a core file creation (abort) or to stopping of a process (stop) for further analysis using a system debugger. [...] This will result in `abort()` call once NGINX detects leak and core dump._

To debug this you should activates debug points (in the main context):

```nginx
# Set 'abort' value to abort the debug point
# and produce a core dump file whenever there is an internal error:
debug_points abort;
```

That example comes from the official [Debugging - Debugging socket leaks](https://www.nginx.com/resources/wiki/start/topics/tutorials/debugging/#socket-leaks) tutorial:

  > Something like this in `gdb` should be usefull (assuming 456 is connection number from error message from the process which dumped core: `[...] left in connection 456`):

  ```gdb
  set $c = &ngx_cycle->connections[456]
  p $c->log->connection
  p *$c
  set $r = (ngx_http_request_t *) $c->data
  p *$r
  ```

  > In particular, `p $c->log->connection` will print connection number as used in logs. It will be possible to grep debug log for relevant lines, e.g.

  ```bash
  fgrep ' *12345678 ' /var/log/nginx/error_log;
  ```

At the end, look also at these interesting explanations: [Socket leak](https://forum.nginx.org/read.php?29,239511,239511#msg-239511), [[nginx] Fixed socket leak with "return 444" in error_page (ticket #274)](https://forum.nginx.org/read.php?29,281339,281339#msg-281339) and [This is strictly a violation of the TCP specification](https://blog.cloudflare.com/this-is-strictly-a-violation-of-the-tcp-specification/).

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

For more examples please see [Commands](NGINX_BASICS.md#commands) section.

#### Configuration snippets

##### Nginx server header removal

You could use a module like `ngx_headers_more` to disable or replace the server header. However, why compile, test and configure an extra module if it is also possible to change the upstream code with only a few simple lines? No module, not a multitude of code changes. Only one single patch.

This [nginx-remove-server-header.patch](https://gitlab.com/buik/nginx/blob/master/nginx-remove-server-header.patch) will remove NGINX as server header.

##### Custom log formats

```nginx
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
#   - level 0
#   - based on main-level-0 without "$http_referer" "$http_user_agent"
log_format debug-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" '
                '$request_completion';

#   - level 1
#   - based on main-level-0 without "$http_referer" "$http_user_agent"
log_format debug-level-1
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" $request_length '
                '$request_completion $connection $connection_requests';

#   - level 2
#   - based on main-level-0 without "$http_referer" "$http_user_agent"
log_format debug-level-2
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" $request_length '
                '$request_completion $connection $connection_requests '
                '$server_addr $server_port $remote_addr $remote_port';

# Debug log format for SSL:
#   - based on main-level-0
log_format debug-ssl-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent" '
                '$request_time '
                '$ssl_protocol $ssl_cipher';

# Debug log format for GeoIP module (ngx_http_geoip_module):
#   - based on main-level-0
#   - only if you enable ngx_http_geoip2_module and define geoip2 variables
# log_format geoip-level-0
#                 '$remote_addr - $remote_user [$time_local] '
#                 '"$request_method $scheme://$host$request_uri '
#                 '$server_protocol" $status $body_bytes_sent '
#                 '"$http_referer" "$http_user_agent" '
#                 '$request_time '
#                 '"$geoip2_data_country_code $geoip2_data_country_name"';

# The following log format is very useful for debugging connection between proxy and upstream servers:
#   - based on main-level-0
log_format upstream_log
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent" '
                '$request_time '
                'upstream_addr $upstream_addr '
                'upstream_bytes_received $upstream_bytes_received '
                'upstream_cache_status $upstream_cache_status '
                'upstream_connect_time $upstream_connect_time '
                'upstream_header_time $upstream_header_time '
                'upstream_response_length $upstream_response_length '
                'upstream_response_time $upstream_response_time upstream_status $upstream_status ';

# Log only specific error codes:
#   Example:
#     - access_log /var/log/nginx/access.log main if=$error_codes;
map $status $error_codes {

  default   1;
  ~^[23]    0;

}

map $status $error_codes_5xx {

  default   1;
  ~^[234]   0;

}
```

##### Log only 4xx/5xx

```nginx
# 1) File: /etc/nginx/map/logs.conf

# Map module:
map $status $error_codes {

  default   1;
  ~^[23]    0;

}

# 2) Include this file in http context:
include /etc/nginx/map/logs.conf;

# 3) Turn on in a specific context (e.g. location):
server {

  ...

  # Add if condition to access log:
  access_log /var/log/nginx/example.com-access.log combined if=$error_codes;

}
```

##### Restricting access with basic authentication

```bash
# 1) Generate password file with htpasswd command:
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

  }

  location /public/ {

    auth_basic off;

  }

  ...
```

##### Restricting access with client certificate

If the client-side certificate failed to authenticate, NGINX show: `400 No required SSL certificate was sent`.

```nginx
server {

  server_name example.com;

  ssl_client_certificate certs/client-X0.pem;
  ssl_verify_client on;
  ssl_verify_depth 3;
  proxy_set_header ClientDN $ssl_client_s_dn;

  # You can also show specific message to the client:
  location / {

    if ($ssl_client_verify != SUCCESS) {

      return 403;

    }

  }

  ...

}
```

Read also this: [Nginx SSL certificate authentication signed by intermediate CA (chain)](https://stackoverflow.com/questions/8431528/nginx-ssl-certificate-authentication-signed-by-intermediate-ca-chain).

##### Restricting access by geographical location

  > The best explanation and technical reference is [Restricting Access by Geographical Location](https://docs.nginx.com/nginx/admin-guide/security-controls/controlling-access-by-geoip/). Look also at [ngx_http_geoip_module](http://nginx.org/en/docs/http/ngx_http_geoip_module.html).

I also recommend read the following resources:

- [GeoIP discontinuation; Upgrade to GeoIP2 with nginx on CentOS](https://medium.com/@karljohnson/geoip-discontinuation-upgrade-to-geoip2-with-nginxon-centos-c2a3dbcf8fd)
- [Blocking Country and Continent with nginx GeoIP on Ubuntu 18.04](https://guides.wp-bullet.com/blocking-country-and-continent-with-nginx-geoip-on-ubuntu-18-04/)
- [Using NGINX With GeoIP MaxMind Database to Fetch Geolocation Data](https://dzone.com/articles/nginx-with-geoip-maxmind-database-to-fetch-user-ge)

See also [ngx_http_geoip_module](NGINX_BASICS.md#ngx_http_geoip_module) chapter from this handbook.

The NGINX must be compiled with the `ngx_http_geoip_module` or `ngx_http_geoip2_module` to use the GeoIP database. With this module you can blocking/allowing for example:

- region
- city
- country

```nginx
# 1) This allows all countries, except the three countries set to no.

  # Load geoip database to determine the country depending on the client IP address
  # (in a http context):
  geoip_country /usr/share/GeoIP/GeoIP.dat;

  # Define a map:
  map $geoip_country_code $allowed_country {

    default yes;

    AM no;
    BH no;
    GR no;

  }

  # In your location block:
  ...

  location / {

    if ($allowed_country = no) {

      return 444;

    }

    ...

  }

# 2) This blocks all countries, except the three countries set to yes.

  # Load geoip database to determine the country depending on the client IP address
  # (in a http context):
  geoip_country /usr/share/GeoIP/GeoIP.dat;

  # Define a map:
  map $geoip_country_code $allowed_country {

    default no;

    AM yes;
    BH yes;
    GR yes;

  }

  # In your location block:
  ...

  location / {

    if ($allowed_country = no) {

      return 444;

    }

    ...

  }
```

For display GeoIP data in NGINX access log see [Custom log formats](HELPERS.md#custom-log-formats) chapter.

###### GeoIP 2 database

Why should you use GeoIP2 instead of GeoIP Legacy? See [What’s New in GeoIP2](https://dev.maxmind.com/geoip/geoip2/whats-new-in-geoip2/).

GeoLite Legacy databases are discontinued as of January 2, 2019, they are not updated nor any longer available for download. Every user should move to GeoLite2 databases, a more contemporary versions of the GeoLite Legacy geolocation databases which are still available in a free version updated every month.

For support GeoIP2 we have [ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module). It creates variables based on the client IP address, using the precompiled MaxMind GeoIP2 databases, which provide localized name information not present in the original GeoIP databases.

```nginx
# 1) This allows all countries, except the three countries set to no.

  # Tell NGINX about GeoIP2 databases (in http context):
  geoip2 /usr/share/GeoIP/GeoLite2-Country.mmdb {

    auto_reload 5m;
    $geoip2_metadata_country_build metadata build_epoch;
    $geoip2_data_country_code default=US country iso_code;
    $geoip2_data_country_name country names en;

  }

  geoip2 /usr/share/GeoIP/GeoLite2-City.mmdb {

    $geoip2_data_city_name default=London city names en;

  }

  # Define a map:
  map $geoip2_data_country_code $allowed_country {

    default no;

    AM yes;
    BH yes;
    GR yes;

  }

# 2) This allows all countries, except the three countries set to no and get source IP address
#    from X-Forwarded-For header.

  # First of all, you should extract the user IP address:
  map $http_x_forwarded_for $realip {

    ~^(\d+\.\d+\.\d+\.\d+) $1;
    default $remote_addr;

  }

  # You can also set source for the IP address:
  geoip2 /usr/share/GeoIP/GeoLite2-Country.mmdb {

    auto_reload 5m;
    $geoip2_metadata_country_build metadata build_epoch;
    $geoip2_data_country_code default=US source=$realip country iso_code;
    $geoip2_data_country_name source=$realip country names en;

  }

  geoip2 /usr/share/GeoIP/GeoLite2-City.mmdb {

    $geoip2_data_city_name source=$realip city names en;
    $geoip2_data_time_zone source=$realip location time_zone;

  }

# For both examples:

  # Add IP-Country header to confirm that NGINX is fetching all GeoIP information
  # (in a server context):
  more_set_headers "IP-Country: $geoip2_data_country_name";
  # or:
  add_header IP-Country $geoip2_data_country_name;

  # In your location block:
  ...

  location / {

    if ($allowed_country = no) {

      return 403;

    }

    ...

  }
```

##### Dynamic error pages with SSI

Example 1:

1. Create error page template in `/var/www/error_pages/errors.html`:

```html
<!-- Based on: https://blog.adriaan.io/one-nginx-error-page-to-rule-them-all.html -->
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Error</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!--# if expr="$status = 502" -->
      <meta http-equiv="refresh" content="2">
    <!--# endif -->
  </head>
<body>
  <!--# if expr="$status = 502" -->
    <h1>We are updating our website</h1>
    <p>This is only for a few seconds, you will be redirected.</p>
  <!--# else -->
    <h1><!--# echo var="status" default="" --> <!--# echo var="status_text" default="Something goes wrong..." --></h1>
  <!--# endif -->
</body>
</html>
```

or

```html
<html>
<head>
<title><!--# echo var="status" default="" --> <!--# echo var="status_text" default="Something goes wrong..." --></title>
</head>
<body>
<center><h1><!--# echo var="status" default="" --> <!--# echo var="status_text" default="Something goes wrong..." --></h1></center>
</body>
</html>
```

2. Define error codes map in the http context or include it from a file:

```nginx
map $status $status_text {

  default 'Something is wrong';

  400 'Bad Request';
  401 'Unauthorized';
  402 'Payment Required';
  403 'Forbidden';
  404 'Not Found';
  405 'Method Not Allowed';
  406 'Not Acceptable';
  407 'Proxy Authentication Required';
  408 'Request Timeout';
  409 'Conflict';
  410 'Gone';
  411 'Length Required';
  412 'Precondition Failed';
  413 'Payload Too Large';
  414 'URI Too Long';
  415 'Unsupported Media Type';
  416 'Range Not Satisfiable';
  417 'Expectation Failed';
  418 'I\'m a teapot';
  421 'Misdirected Request';
  422 'Unprocessable Entity';
  423 'Locked';
  424 'Failed Dependency';
  426 'Upgrade Required';
  428 'Precondition Required';
  429 'Too Many Requests';
  431 'Request Header Fields Too Large';
  451 'Unavailable For Legal Reasons';
  500 'Internal Server Error';
  501 'Not Implemented';
  502 'Bad Gateway';
  503 'Service Unavailable';
  504 'Gateway Timeout';
  505 'HTTP Version Not Supported';
  506 'Variant Also Negotiates';
  507 'Insufficient Storage';
  508 'Loop Detected';
  510 'Not Extended';
  511 'Network Authentication Required';

}
```

3. Create an `error_page` in your context (e.g. server):

```nginx
server {

  ...

  error_page 400 401 403 404 405 500 501 502 503 /errors.html;

  location = /errors.html {

    ssi on;
    internal;
    root /var/www/error_pages;

  }

}
```

4. Turn on the specific error page:

```nginx
location = /404.html {

  return 404;

}
```

Read also this: [Static error pages generator](https://github.com/trimstray/nginx-admins-handbook#static-error-pages-generator).

##### Blocking/allowing IP addresses

Example 1:

```nginx
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

```nginx
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

```nginx
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

```nginx
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

```nginx
# 1) Turn on in a specific context (e.g. location):
location /check_status {

  if ($http_referer ~ "spam1\.com|spam2\.com|spam3\.com") {

    return 444;

  }

  ...
```

How to test?

```bash
siege -b -r 2 -c 40 -v https://example.com/storage/img/header.jpg -H "Referer: https://spamdomain4.com/"
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

```nginx
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
siege -b -r 2 -c 40 -v https://example.com/storage/img/header.jpg -H "Referer: https://spamdomain4.com/"
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

##### Blocking User-Agent

Example 1:

```nginx
# 1) File: /etc/nginx/limits.conf
map $http_user_agent $invalid_ua {

  default           0;
  ~*scrapyproject   1;
  ~*netcrawler      1;
  ~*nmap            1;
  ~*sqlmap          1;
  ~*slowhttptest    1;
  ~*nikto           1;
  ~*python-requests 1;

}

# 2) Include this file in http context:
include /etc/nginx/limits.conf;

# 3) Turn on in a specific context (e.g. server):
server_name example.com;

  if ($invalid_ua) { return 444; }

  ...
```

##### Limiting User-Agent

Example 1:

```nginx
# 1) File: /etc/nginx/limits.conf
map $http_user_agent $limit_ip_key_by_ua {

  default           "";
  ~*scrapyproject   binary_remote_addr;
  ~*netcrawler      binary_remote_addr;
  ~*nmap            binary_remote_addr;
  ~*sqlmap          binary_remote_addr;
  ~*slowhttptest    binary_remote_addr;
  ~*nikto           binary_remote_addr;
  ~*python-requests binary_remote_addr;

}

limit_req_zone $limit_ip_key_by_ua zone=req_for_remote_addr_by_ua:32k rate=10r/m;

# 2) Include this file in http context:
include /etc/nginx/limits.conf;

# 3) Turn on in a specific context (e.g. server):
server_name example.com;

  limit_req zone=req_for_remote_addr_by_ua burst=2;

  ...
```

##### Limiting the rate of requests with burst mode

```nginx
limit_req_zone $binary_remote_addr zone=req_for_remote_addr:64k rate=10r/m;
```

- key/zone type: `limit_req_zone`
- the unique key for limiter: `$binary_remote_addr`
- zone name: `req_for_remote_addr`
- zone size: `64k` (1024 IP addresses)
- rate is `0,16` request each second or `10` requests per minute (`1` request every `6` second)

Example of use:

```nginx
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

```nginx
limit_req_zone $binary_remote_addr zone=req_for_remote_addr:50m rate=2r/s;
```

- key/zone type: `limit_req_zone`
- the unique key for limiter: `$binary_remote_addr`
- zone name: `req_for_remote_addr`
- zone size: `50m` (800,000 IP addresses)
- rate is `2` request each second or `120` requests per minute (`2` requests every `1` second)

Example of use:

```nginx
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

##### Limiting the rate of requests per IP with geo and map

```nginx
geo $limit_per_ip {

  default         0;
  10.10.10.135    1;

}

map $limit_per_ip $limit_key {

  0 "";
  1 $binary_remote_addr;

}

limit_req_zone $limit_key zone=per_ip:10m rate=20r/m;
```

- key/zone type: `limit_req_zone`
- the unique key for limiter: `$limit_key` (`$binary_remote_addr`)
  - `$limit_per_ip` from geo module
  - match `$limit_per_ip` to `$limit_key` from map module
- zone name: `per_ip`
- zone size: `10m` (160,000 IP addresses)
- rate is `0.3` request each second or `20` requests per minute (`1` request every `3` second)

Example of use:

```nginx
location ~ /stats {

  limit_req zone=per_ip;

  ...
```

##### Limiting the number of connections

```nginx
limit_conn_zone $binary_remote_addr zone=conn_for_remote_addr:1m;
```

- key/zone type: `limit_conn_zone`
- the unique key for limiter: `$binary_remote_addr`
  - limit requests per IP as following
- zone name: `conn_for_remote_addr`
- zone size: `1m` (16,000 IP addresses)

Example of use:

```nginx
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

##### Using trailing slashes

If you have something like:

```nginx
location /api/ {

  proxy_pass http://bck_testing_01;

}
```

And go to `http://example.com/api`, NGINX will automatically redirect you to `http://example.com/api/`.

Even if you don't use one of these directives above, you could always do the redirect manually:

```nginx
location = /api {

  rewrite ^ /api/ permanent;

}
```

Or, if you don't want redirect you could use:

```nginx
location = /api {

  proxy_pass http://bck_testing_01;

}
```

If you want to rewrite/redirect the URL with trailing slash at end you could:

```nginx
# 1. At the http level:

map $request_uri $no_trailing_slash {

  default  1;
  ~.*[^/]$ 0;

}

# 2. At the server level:
server {

  listen       80;
  server_name  example.com;

  location / {

    if ($no_trailing_slash) {

      return 302 $request_uri/;

    }

    proxy_pass              http://192.168.10.50:80;
    proxy_redirect          off;
    server_name_in_redirect off;

   }

}
```

##### Properly redirect all HTTP requests to HTTPS

None of the standard answers are safe to use if at any point you had unsecure HTTP set up and expect user content, have forms, host an API, or have configured any website, tool, application, or utility to speak to your site.

The problem occurs when a `POST` request is made to your server. If the server response with a plain 30x redirect the `POST` content will be lost. To prevent this situation remember about the correct redirect HTTP code for `POST` request ([Redirect POST request with payload to external endpoint](#redirect-post-request-with-payload-to-external-endpoint)).

It is therefore recommended to use the 301 code only as a response for `GET` or `HEAD` methods and to use the 308 Permanent Redirect for `POST` methods instead, as the method change is explicitly prohibited with this status (see [Mozilla Web Docs - 301 Moved Permanently](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/301)).

```nginx
server {

  listen        192.168.200.10:80;
  server_name   example.com;

  if ($request_method = POST) {

    return      307 https://$server_name$request_uri;

  }

  # return      301 https://example.com$request_uri;
  return        301 https://$server_name$request_uri;

  ...

}

server {

  listen        192.168.200.10:443 ssl;
  server_name   example.com;

  # add Strict-Transport-Security to prevent man in the middle attacks:
  add_header    Strict-Transport-Security "max-age=31536000" always;

  ...

}
```

  > Look also at [Enable HTTP Strict Transport Security (from this handbook)](RULES.md#beginner-enable-http-strict-transport-security).

##### Proxy/rewrite and keep the original URL

If you just want to mount several locations from upstreams - you do not need rewrites, just use:

```nginx
location /v1/app1/ {

  proxy_pass http://localhost:9001/;

}
```

But apps should use relative links or account for their absolute location. For more complex url manipulation you can use `break`-rewrites:

```nginx
location /v1/app1/ {

  rewrite ^/v1/app1/(.*) /$1 break;
  proxy_pass http://192.168.252.10:9001/;

}
```

Next, a few control groups:

```nginx
location /api/ {

  rewrite ^ $request_uri;
  rewrite ^/api/(.*) $1 break;
  # If the second rewrite won't match:
  return 400;
  proxy_pass http://192.168.252.10:82/$uri;

}

location /bar/ {

  rewrite ^/bar(/.*) $1 break;
  proxy_pass http://192.168.252.10:82;

}
```

##### Proxy/rewrite and keep the part of original URL

```nginx
location ~ /some/path/(?<section>.+)/index.html {

  proxy_pass http://192.168.252.10/$section/index.html;
  proxy_set_header Host $host;

}
```

Or:

```nginx
location /some/path/ {

  proxy_pass http://192.168.252.10/;
  # Note this slash  -------------^
  proxy_set_header Host $host;

}
```

##### Proxy/rewrite without changing the original URL (in browser)

  > Generally, this is not recommend, because you're changing hostnames. Browser security is tied to it, as is webserver configuration.

  > You can rewrite URLs within same hostname, but changing hostnames requires redirect or using a frame. You can change hostname only if you have the same backends under control.

If you want to get resources from `app1.domain` and the data should comes from `app2.domain/app`:

```nginx
server_name app1.domain;

location / {

  rewrite ^/(.*)$ /app/$1 break;
  proxy_pass http://192.168.252.10:80;  # upstream for app2.domain
  proxy_set_header Host app2.domain;

}
```

Other example:

```nginx
location /site99 {

  rewrite /site99(.*)$ /site99/page$1 break;
  proxy_pass http://tomcat_b9:8000;

}
```

##### Adding and removing the `www` prefix

  > Note that these solutions gets tricky if you use HTTPS, as you must then have a single certificate to cover all of your domain names if you want this to work properly. The best practice of using a separate `server` would still stand.

- `www` to `non-www`:

```nginx
server {

  ...

  server_name www.example.com;

  # $scheme will get the http or https protocol:
  return 301 $scheme://example.com$request_uri;

}
```

You can also do it for multiple `www` to `non-www` (e.g. for subdomains):

```nginx
server {

  ...

  server_name
    "~^www\.(api.example.com)$"
    "~^www\.(public.example.com)$"
    "~^www\.(static.example.com)$";

  return 301 $scheme://$1$request_uri;

}
```

Or:

```nginx
server {

  ...

  server_name ~^www\.(?<domain>(?:example\.org|example\.com|subdomain\.example\.net))$;

  return 301 $scheme://$domain$request_uri;

}
```

This matches all domain names pointed to the server starting with `www.` and redirects to `non-www`:

```nginx
server {

  ...

  server_name ~^www\.(?<domain>.+)$;

  return 301 $scheme://$domain$request_uri;

}
```

These final solutions is generally not considered to be the best practice, however, it still works and does the job. Both removes `www` prefix before any domain.:

```nginx
server {

  ...

  if ($host ~ ^www\.(?<domain>.+)$) {

    return 301 $scheme://$domain$request_uri;

  }

}
```

It is not a recommended if you don't care for the most ultimate performance (uses the `if` condition and regular expression) but in some cases it may be useful:

```nginx
server {

  ...

  if ($host ~* ^www\.(.*)$) {

    rewrite / $scheme://$1 permanent;

  }

}
```

- `non-www` to `www`:

```nginx
server {

  ...

  server_name example.com;

  # $scheme will get the http or https protocol:
  return 301 $scheme://www.example.com$request_uri;

}
```

This matches all domain names pointed to the server starting with whatever but `www.` and redirects to `www.<domain>`:

```nginx
server {

  ...

  server_name ~^(?!www\.)(?<domain>.+)$;

  return 301 $scheme://www.$domain$request_uri;

}
```

The following is very similar to above but uses `if`:

```nginx
server {

  ...

  server_name www.example.com www.example2.com;

  if ($host ~ ^(?!www\.)(?<domain>.+)$) {

    return  301 $scheme://www.$domain$request_uri;

  }

}
```

##### Modify 301/302 response body

By default, NGINX sent small document body for 301 and 302 redirects. [RFC 2616 - 301 Moved Permanently](https://tools.ietf.org/html/rfc2616#section-10.3.2) <sup>[IETF]</sup> and [RFC 2616 - 302 Found](https://tools.ietf.org/html/rfc2616#section-10.3.3) <sup>[IETF]</sup> specifies that the entity bodies should be present.

Here you have an excellent explanation of the problem by [Michael Hampton](https://serverfault.com/users/126632/michael-hampton): [NGINX 301 and 302 serving small nginx document body. Any way to remove this behaviour?](https://serverfault.com/a/423685).

On the other hand, 301/302 bodies never actually contains any locations - all pages contain just an error number and message without any revealing information. So I understand the reasons for deleting the 301/302 body content. Performance can also be an argument, however it depends on what you're optimising for; the difference might be quite substancial for traffic counting, for example; it might also be the tipping point between needing to send an extra packet for the body or not.

However, please note that this change is not RFC compliant:

  > _This word, or the adjective "RECOMMENDED", mean that there may exist valid reasons in particular circumstances to ignore a particular item, but the full implications must be understood and carefully weighed before choosing a different course._

Example 1:

```nginx
server {

  ...

  error_page 301 302 @30x;
  location @30x {

    default_type "";
    return 300;

  }

  location / {

    ...

  }

  ...

}
```

Example 2:

```nginx
server {

  ...

  error_page 301 /redirect;
  location = /redirect {

    internal;
    # We have to return 200 to modify content. If we would use 301 we would modify Location header.
    # Don't worry, HTTP status will be 301:
    return 200 "<h1>301 redirect</h1>";
    # Or without body (200's need to be with a resource in the response):
    # return 204;

  }

  location / {

    ...

    # Redirect has to be enclosed in location:
    return  301 https://$host$request_uri;

  }

  ...

}
```

For more information about `return` directive and `HTTP 200/204` response codes please see [`return` directive](doc/NGINX_BASICS.md#return-directive) from this handbook.

Example 3:

- modify the source code: `src/http/ngx_http_special_response.c` (but I not tested this solution)

##### Redirect POST request with payload to external endpoint

**POST** data is passed in the body of the request, which gets dropped if you do a standard redirect.

Look at this:

| <b>DESCRIPTION</b> | <b>PERMANENT</b> | <b>TEMPORARY</b> |
| :---         | :---         | :---         |
| allows changing the request method from POST to GET | 301 | 302 |
| does not allow changing the request method from POST to GET | 308 | 307 |

You can try with the HTTP status code 307, a RFC compliant browser should repeat the post request. You just need to write a NGINX rewrite rule with HTTP status code 307 or 308:

```nginx
location /api {

  # HTTP 307 only for POST requests:
  if ($request_method = POST) {

    return 307 https://api.example.com$request_uri;

  }

  # You can keep this for non-POST requests:
  rewrite ^ https://api.example.com$request_uri permanent;

  client_max_body_size    10m;

  ...

}
```

##### Route to different backends based on HTTP method

This snippet is helpful if you want to route requests to different backends based on method. For example:

- `POST /v1/orders/` - would go to one backend pool
- `GET /v1/orders/` - would go to another backend pool

If you don't want to mix the two methods in the same backend, for example the reason being that sometimes POST needs to be always fast, while GET involves DB queries and can be slow.

Example 1:

  > In this example users can only see specific resource (`/v1/id`). The rest is hidden for them.

```nginx
# 1) File: /etc/nginx/map_methods.conf
map $request_method $method_dest {

  default '/_get/v1/id';

  GET     '/_get/v1/id';
  POST    '/_post/v1/id';

}

# 2) Include this file in http context:
include /etc/nginx/map_methods.conf;

# 3) Use it in a specific context (e.g. location):
...

server_name example.com;

  # It's only accessible to the clients:
  location /v1/id {

    set $original_uri $uri;
    rewrite ^ $method_dest last;

  }

  # It's not accessible to the clients:
  location /_get/v1/id {

    internal;
    rewrite ^ $original_uri break;

    proxy_pass http://default.example.com-get-80;

  }

  # It's not accessible to the clients:
  location /_post/v1/id {

    internal;
    rewrite ^ $original_uri break;

    proxy_pass http://default.example.com-post-80;

  }

  ...
```

##### Allow multiple cross-domains using the CORS headers

Example 1:

```nginx
location ~* \.(?:ttf|ttc|otf|eot|woff|woff2)$ {

  if ( $http_origin ~* (https?://(.+\.)?(domain1|domain2|domain3)\.(?:me|co|com)$) ) {

    add_header "Access-Control-Allow-Origin" "$http_origin";

  }

}
```

Example 2 (more slightly configuration; for GETs and POSTs):

```nginx
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

```nginx
# Sets a $real_scheme variable whose value is the scheme passed by the load
# balancer in X-Forwarded-Proto (if any), defaulting to $scheme.
# Similar to how the HttpRealIp module treats X-Forwarded-For.
map $http_x_forwarded_proto $real_scheme {

  default $http_x_forwarded_proto;
  ''      $scheme;

}
```

#### Other snippets

###### Recreate base directory

Debian like distributions:

```bash
# Remove even configuration files and records:
apt-get purge nginx nginx-common nginx-full

# Reinstall:
apt-get install nginx

# You can also try using --force-confmiss option of dpkg:
dpkg --force-confmiss -i /var/cache/apt/archives/nginx-common_*.deb
```

###### Create a temporary static backend

Busybox:

```bash
busybox httpd -p $PORT -h $HOME [-c httpd.conf]
```

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

```python
from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl

httpd = HTTPServer(('localhost', 4443), BaseHTTPRequestHandler)

httpd.socket = ssl.wrap_socket (httpd.socket,
        keyfile="path/to/key.pem",
        certfile='path/to/cert.pem', server_side=True)

httpd.serve_forever()
```

Python 2.x:

```python
import BaseHTTPServer, SimpleHTTPServer
import ssl

httpd = BaseHTTPServer.HTTPServer(('localhost', 4443),
        SimpleHTTPServer.SimpleHTTPRequestHandler)

httpd.socket = ssl.wrap_socket (httpd.socket,
        keyfile="path/tp/key.pem",
        certfile='path/to/cert.pem', server_side=True)

httpd.serve_forever()
```

###### Generate password file with `htpasswd` command

```bash
htpasswd -c htpasswd_example.com.conf <username>
```

###### Generate private key without passphrase

```bash
# _len: 2048, 4096
( _fd="private.key" ; _len="2048" ; \
openssl genrsa -out ${_fd} ${_len} )
```

###### Generate private key with passphrase

```bash
# _ciph: des3, aes128, aes256
# _len: 2048, 4096
( _ciph="aes128" ; _fd="private.key" ; _len="2048" ; \
openssl genrsa -${_ciph} -out ${_fd} ${_len} )
```

###### Remove passphrase from private key

```bash
( _fd="private.key" ; _fd_unp="private_unp.key" ; \
openssl rsa -in ${_fd} -out ${_fd_unp} )
```

###### Encrypt existing private key with a passphrase

```bash
# _ciph: des3, aes128, aes256
( _ciph="aes128" ; _fd="private.key" ; _fd_pass="private_pass.key" ; \
openssl rsa -${_ciph} -in ${_fd} -out ${_fd_pass}
```

###### Generate private key and CSR

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; _len="2048" ; \
openssl req -out ${_fd_csr} -new -newkey rsa:${_len} -nodes -keyout ${_fd} )
```

###### Generate CSR

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; \
openssl req -out ${_fd_csr} -new -key ${_fd} )
```

###### Generate CSR (metadata from existing certificate)

  > Where `private.key` is the existing private key. As you can see you do not generate this CSR from your certificate (public key). Also you do not generate the "same" CSR, just a new one to request a new certificate.

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; _fd_crt="cert.crt" ; \
openssl x509 -x509toreq -in ${_fd_crt} -out ${_fd_csr} -signkey ${_fd} )
```

###### Generate CSR with -config param

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; \
openssl req -new -sha256 -key ${_fd} -out ${_fd_csr} \
-config <(
cat << __EOF__
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
__EOF__
))
```

Other values in `[ dn ]`:

```
countryName            = "DE"                     # C=
stateOrProvinceName    = "Hessen"                 # ST=
localityName           = "Keller"                 # L=
postalCode             = "424242"                 # L/postalcode=
postalAddress          = "Keller"                 # L/postaladdress=
streetAddress          = "Crater 1621"            # L/street=
organizationName       = "apfelboymschule"        # O=
organizationalUnitName = "IT Department"          # OU=
commonName             = "example.com"            # CN=
emailAddress           = "webmaster@example.com"  # CN/emailAddress=
```

Example of `oids` (you'll probably also have to make OpenSSL know about the new fields required for EV by adding the following under `[new_oids]`):

```
[req]
...
oid_section         = new_oids

[ new_oids ]
postalCode = 2.5.4.17
streetAddress = 2.5.4.9
```

Full example:

```bash
( _fd="private.key" ; _fd_csr="request.csr" ; \
openssl req -new -sha256 -key ${_fd} -out ${_fd_csr} \
-config <(
cat << __EOF__
[req]
default_bits        = 2048
default_md          = sha256
prompt              = no
distinguished_name  = dn
req_extensions      = req_ext
oid_section         = new_oids

[ new_oids ]
serialNumber = 2.5.4.5
streetAddress = 2.5.4.9
postalCode = 2.5.4.17
businessCategory = 2.5.4.15

[ dn ]
serialNumber=00001111
businessCategory=Private Organization
jurisdictionC=DE
C=DE
ST=Hessen
L=Keller
postalCode=424242
streetAddress=Crater 1621
O=AV Company
OU=IT
CN=example.com

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = example.com
__EOF__
))
```

For more information please look at these great explanations:

- [RFC 5280](https://tools.ietf.org/html/rfc5280)
- [How to create multidomain certificates using config files](https://apfelboymchen.net/gnu/notes/openssl%20multidomain%20with%20config%20files.html)
- [Generate a multi domains certificate using config files](https://gist.github.com/romainnorberg/464758a6620228b977212a3cf20c3e08)
- [Your OpenSSL CSR command is out of date](https://expeditedsecurity.com/blog/openssl-csr-command/)
- [OpenSSL example configuration file](https://www.tbs-certificats.com/openssl-dem-server-cert.cnf)
- [Object Identifiers (OIDs)](https://www.alvestrand.no/objectid/)
- [openssl objects.txt](https://github.com/openssl/openssl/blob/master/crypto/objects/objects.txt)

###### List available EC curves

```bash
openssl ecparam -list_curves
```

###### Print ECDSA private and public keys

```bash
( _fd="private.key" ; \
openssl ec -in ${_fd} -noout -text )

# For x25519 only extracting public key
( _fd="private.key" ; _fd_pub="public.key" ; \
openssl pkey -in ${_fd} -pubout -out ${_fd_pub} )
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

###### Generate private key and CSR (ECC)

```bash
# _curve: prime256v1, secp521r1, secp384r1
( _fd="example.com.key" ; _fd_csr="example.com.csr" ; _curve="prime256v1" ; \
openssl ecparam -out ${_fd} -name ${_curve} -genkey ; \
openssl req -new -key ${_fd} -out ${_fd_csr} -sha256 )
```

###### Generate self-signed certificate

```bash
# _len: 2048, 4096
( _fd="domain.key" ; _fd_out="domain.crt" ; _len="2048" ; _days="365" ; \
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

###### Generate multidomain certificate (Certbot)

```bash
certbot certonly -d example.com -d www.example.com
```

###### Generate wildcard certificate (Certbot)

```bash
certbot certonly --manual --preferred-challenges=dns -d example.com -d *.example.com
```

###### Generate certificate with 4096 bit private key (Certbot)

```bash
certbot certonly -d example.com -d www.example.com --rsa-key-size 4096
```

###### Generate DH public parameters

```bash
( _dh_size="2048" ; \
openssl dhparam -out /etc/nginx/ssl/dhparam_${_dh_size}.pem "$_dh_size" )
```

###### Display DH public parameters

```bash
openssl pkeyparam -in dhparam.pem -text
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

###### Extract certs from p7b

```bash
# PKCS#7 file doesn't include private keys.
( _fd_p7b="cert.p7b" ; _fd_pem="cert.pem" ; \
openssl pkcs7 -inform DER -outform PEM -in ${_fd_p7b} -print_certs > ${_fd_pem})
# or:
openssl pkcs7 -print_certs -in -in ${_fd_p7b} -out ${_fd_pem})
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

###### Verification of the certificate's supported purposes

```bash
( _fd_pem="cert.pem" ; \
openssl x509 -purpose -noout -in ${_fd_pem} )
```

###### Check private key

```bash
( _fd="private.key" ; \
openssl rsa -check -in ${_fd} )
```

###### Verification of the private key

```bash
( _fd="private.key" ; \
openssl rsa -noout -text -in ${_fd} )
```

###### Get public key from private key

```bash
( _fd="private.key" ; _fd_pub="public.key" ; \
openssl rsa -pubout -in ${_fd} -out ${_fd_pub} )
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

###### Check the private key and the certificate are match

```bash
(openssl rsa -noout -modulus -in private.key | openssl md5 ; \
openssl x509 -noout -modulus -in certificate.crt | openssl md5) | uniq
```

###### Check the private key and the CSR are match

```bash
(openssl rsa -noout -modulus -in private.key | openssl md5 ; \
openssl req -noout -modulus -in request.csr | openssl md5) | uniq
```

###### TLSv1.3 and CCM ciphers

  > **:bookmark: [Use only strong ciphers - Hardening - P1](RULES.md#beginner-use-only-strong-ciphers)**

By default, TLS 1.3 don't use the two missing CCM-mode suites. If you want enable them, e.g. in case anything decides to support them in the future you should edit `openssl-1.1.1*/include/openssl/ssl.h` file.

Look for these lines (starting at these in OpenSSL 1.1.1d):

```c
#  if !defined(OPENSSL_NO_CHACHA) && !defined(OPENSSL_NO_POLY1305)
#   define TLS_DEFAULT_CIPHERSUITES "TLS_AES_256_GCM_SHA384:" \
                                    "TLS_CHACHA20_POLY1305_SHA256:" \
                                    "TLS_AES_128_GCM_SHA256"
#  else
#   define TLS_DEFAULT_CIPHERSUITES "TLS_AES_256_GCM_SHA384:" \
                                   "TLS_AES_128_GCM_SHA256"
#  endif
# endif
```

Once you've found them, modify both `#define` instructions to look like this (add `TLS_AES_128_CCM_SHA256` and `TLS_AES_128_CCM_8_SHA256`), and be careful with the colons, quotes, and end-of-line escaping:

```c
# if !defined(OPENSSL_NO_CHACHA) && !defined(OPENSSL_NO_POLY1305)
#  define TLS_DEFAULT_CIPHERSUITES "TLS_AES_128_GCM_SHA256:" \
                                   "TLS_AES_128_CCM_SHA256:" \
                                   "TLS_AES_128_CCM_8_SHA256:" \
                                   "TLS_CHACHA20_POLY1305_SHA256:" \
                                   "TLS_AES_256_GCM_SHA384"
# else

/* We're definitely building with ChaCha20-Poly1305,
   so the "else" won't have any effect. Still... */
#  define TLS_DEFAULT_CIPHERSUITES "TLS_AES_128_GCM_SHA256:" \
                                   "TLS_AES_256_GCM_SHA384"

#endif
```
