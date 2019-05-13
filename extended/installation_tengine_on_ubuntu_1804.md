#### Table of Contents

* [Installation Tengine on Ubuntu 18.04](#installation-tengine-on-ubuntu-1804)
  * [Pre installation tasks](#pre-installation-tasks)
  * [Install or build dependencies](#install-or-build-dependencies)
  * [Get Tengine sources](#get-tengine-sources)
  * [Download 3rd party modules](#download-3rd-party-modules)
  * [Build Tengine](#build-tengine)
  * [Post installation tasks](#post-installation-tasks)

#### Installation Tengine on Ubuntu 18.04

  > _Tengine is a web server originated by Taobao, the largest e-commerce website in Asia. It is based on the NGINX HTTP server and has many advanced features. There’s a lot of features in Tengine that do not (yet) exist in NGINX._

- Official github repository: [Tengine](https://github.com/alibaba/tengine)
- Official documentation: [Tengine Documentation](https://tengine.taobao.org/documentation.html)

Generally, Tengine is a great solution, including many patches, improvements, additional modules, and most importantly it is very actively maintained.

The build and installation process is very similar to [installation from source](https://github.com/trimstray/nginx-admins-handbook#installation-from-source) for NGINX. However, I will only specify the most important changes.

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

  > Not all modules from [this](https://github.com/trimstray/nginx-admins-handbook#download-3rd-party-modules) section working properly with Tengine (e.g. `ndk_http_module` and other dependent on it).

```bash
cd /usr/local/src/tengine/modules/

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

If you use NAXSI:

```bash
cd /usr/local/src/nginx-${ngx_version}/modules/

git clone --depth 1 https://github.com/nbs-system/naxsi
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
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/nginx-module-vts \
            --add-module=/usr/local/src/nginx-${ngx_version}/modules/ngx_brotli \
            --add-dynamic-module=/usr/local/src/tengine/modules/echo-nginx-module \
            --add-dynamic-module=/usr/local/src/tengine/modules/headers-more-nginx-module \
            --add-dynamic-module=/usr/local/src/tengine/modules/replace-filter-nginx-module \
            --add-dynamic-module=/usr/local/src/tengine/modules/delay-module \
            --add-dynamic-module=/usr/local/src/nginx-${ngx_version}/modules/naxsi/naxsi_src

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

  > Check all post installation tasks from [post installation tasks - NGINX](https://github.com/trimstray/nginx-admins-handbook/blob/master/extended/installation_nginx_on_ubuntu_1804.md#post-installation-tasks) section.
