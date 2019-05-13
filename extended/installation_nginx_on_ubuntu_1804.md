#### Table of Contents

* [Installation Nginx on Ubuntu 18.04](#installation-nginx-on-ubuntu-1804)
  * [Pre installation tasks](#pre-installation-tasks)
  * [Install or build dependencies](#install-or-build-dependencies)
  * [Get Nginx sources](#get-nginx-sources)
  * [Download 3rd party modules](#download-3rd-party-modules)
  * [Build Nginx](#build-nginx)
  * [Post installation tasks](#post-installation-tasks)

#### Installation Nginx on Ubuntu 18.04

###### Pre installation tasks

Set the NGINX version (I use stable release):

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
https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng \
https://github.com/vozlt/nginx-module-vts \
https://github.com/google/ngx_brotli ; do

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

If you use NAXSI:

```bash
cd /usr/local/src/nginx-${ngx_version}/modules/

git clone --depth 1 https://github.com/nbs-system/naxsi
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
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/nginx-module-vts \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/ngx_brotli \
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
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/delay-module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/naxsi/naxsi_src

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

Enable NGINX service:

```bash
systemctl enable nginx
```

Test NGINX configuration:

```bash
nginx -t -c /etc/nginx/nginx.conf
```
