#!/usr/bin/env bash

### BEG SCRIPT INFO
#
# Header:
#
#         fname : "autoinstaller.sh"
#         cdate : "22.05.2019"
#        author : "Michał Żurawski <trimstray@gmail.com>"
#      tab_size : "2"
#     soft_tabs : "yes"
#
# Description:
#
#   See README.md file for more information.
#
# License:
#
#   htrace.sh, Copyright (C) 2018  Michał Żurawski
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.
#
### END SCRIPT INFO

# The array that store call parameters.
# shellcheck disable=SC2034
__init_params=()
__script_params=("$@")

# Tasks for specific system version.
if [[ "$OSTYPE" == "linux-gnu" ]] ; then

  which yum > /dev/null 2>&1      && _DIST_VERSION="rhel"
  which apt-get > /dev/null 2>&1  && _DIST_VERSION="debian"

  # Store the name of the script and directory call.
  readonly _init_name="$(basename "$0")"
  # shellcheck disable=SC2001,SC2005
  readonly _init_directory=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")

else

  printf "Unsupported GNU/Linux distribution.\n"
  exit 1

fi

readonly _rel="${_init_directory}"
readonly _src="/usr/local/src"

_pcre_version="8.42"
_openssl_version="1.1.1b"

export ngx_distr=""
export ngx_version=""

trgb_bold="1;1;38"
trgb_red="1;1;31"
trgb_dark="2;2;38"
trgb_light="1;1;36"
trgb_bold_green="1;2;32"
trgb_bground_yellow="7;30;43"
trgb_bground_blue="1;1;1;44"

function _f() {

  local _FUNCTION_ID="_f"
  local _STATE="0"

  local _cmd="$1"

  _x_trgb_rbold="1;4;4;41"
  _x_trgb_gbold="1;4;4;42"

  printf '\n»»» \e['${trgb_red}'m%s\e[m\n\n\e['${trgb_dark}'m%s\e[m\n\n»»»\n\n' "command" "$_cmd"

  # printf '=%.0s' {1..48}

  if [[ "$NGX_PROMPT" -eq 1 ]] || \
     [[ -z "$NGX_PROMPT" ]] ; then

    _rstate=0

    while [[ "$_rstate" -eq 0 ]] ; do

      printf '\e['${trgb_light}'m%s\e[m ' "(press 'YES' to run) >>"
      read _pcmd

      if [[ "$_pcmd" != "YES" ]] ; then

        _rstate=0

      else

        _rstate=1

      fi

    done

  fi

  $_cmd

  # _output_cmd=$($_cmd)

  # if [[ -z "$_output_cmd" ]] ; then
  #
  #  echo -en "${_output_cmd}"
  #
  # else
  #
  #   echo -en "\n${_output_cmd}\n"
  #
  # fi

  if [[ "$?" -ne 0 ]] ; then

    printf '\n\e['${_x_trgb_rbold}'m %s \e[m\n' "**STOP** from: $_FUNCTION_ID -- COMMAND:"

    printf "\e['${trgb_dark}'m%s\e[m\n" "$_cmd"

    exit 1

  else

    # printf '\e['${_x_trgb_gbold}'m %s \e[m\n' "**OK** -- ($_FUNCTION_ID)"
    true

  fi

  return "$_STATE"

}

function _inst_base_packages() {

  local _FUNCTION_ID="_inst_base_packages"
  local _STATE="0"

  if [[ "$_DIST_VERSION" == "debian" ]] ; then

    _f "apt-get install -y \
            gcc \
            make \
            build-essential \
            linux-headers-$(uname -r) \
            bison \
            perl \
            libperl-dev \
            libphp-embed \
            libxslt-dev \
            libgd-dev \
            libgeoip-dev \
            libxml2-dev \
            libexpat-dev \
            libgoogle-perftools-dev \
            libgoogle-perftools4 \
            autoconf \
            jq"

  elif [[ "$_DIST_VERSION" == "rhel" ]] ; then

    _f "yum install -y \
        gcc \
        gcc-c++ \
        kernel-devel \
        bison perl \
        perl-devel \
        perl-ExtUtils-Embed \
        libxslt \
        libxslt-devel \
        gd \
        gd-devel \
        GeoIP-devel \
        libxml2-devel \
        expat-devel \
        gperftools-devel \
        cpio \
        gettext-devel \
        autoconf \
        jq"

  fi

  return "$_STATE"

}

function _inst_nginx_distribution() {

  local _FUNCTION_ID="_inst_nginx_distribution"
  local _STATE="0"

  if [[ "$ngx_distr" -eq 1 ]] ; then

    _ngx_base="${_src}/nginx-${ngx_version}"
    _ngx_master="${_src}/nginx-${ngx_version}/master"
    _ngx_modules="${_src}/nginx-${ngx_version}/modules"

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "mkdir -p $i"

    done

    cd "$_ngx_base"

    _f "wget -c --no-check-certificate https://nginx.org/download/nginx-${ngx_version}.tar.gz"

    _f "tar zxvf nginx-${ngx_version}.tar.gz -C $_ngx_master --strip 1"

  elif [[ "$ngx_distr" -eq 2 ]] ; then

    _ngx_base="${_src}/openresty-${ngx_version}"
    _ngx_master="${_src}/openresty-${ngx_version}/master"
    _ngx_modules="${_src}/openresty-${ngx_version}/modules"

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "mkdir -p $i"

    done

    cd "$_ngx_base"

    _f "wget -c --no-check-certificate https://openresty.org/download/openresty-${ngx_version}.tar.gz"

    _f "tar zxvf openresty-${ngx_version}.tar.gz -C $_ngx_master --strip 1"

  elif [[ "$ngx_distr" -eq 3 ]] ; then

    _ngx_base="${_src}/tengine"
    _ngx_master="${_src}/tengine/master"
    _ngx_modules="${_src}/tengine/modules"

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "mkdir -p $i"

    done

    cd "$_ngx_base"

    _f "git clone --depth 1 https://github.com/alibaba/tengine $_ngx_master"

  else

    printf "Unsupported NGINX distribution.\n"
    exit 1

  fi

  return "$_STATE"

}

function _inst_pcre() {

  local _FUNCTION_ID="_inst_pcre"
  local _STATE="0"

  cd "$_src"

  _f "wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${_pcre_version}.tar.gz"

  _f "tar xzvf pcre-${_pcre_version}.tar.gz"

  cd "${_src}/pcre-${_pcre_version}"

  _f "./configure"

  _f "make -j2"
  _f "make install"

  export PCRE_LIB=/usr/local/lib
  export PCRE_INC=/usr/local/include
  export PCRE_DIRECTORY="/usr/local/src/pcre-${_pcre_version}"

  return "$_STATE"

}

function _inst_zlib() {

  local _FUNCTION_ID="_inst_zlib"
  local _STATE="0"

  cd "$_src"

  _f "git clone --depth 1 https://github.com/cloudflare/zlib"

  cd "${_src}/zlib"

  _f "./configure"

  _f "make -j2"
  _f "make install"

  export ZLIB_LIB=/usr/local/lib
  export ZLIB_INC=/usr/local/include
  export ZLIB_DIRECTORY="/usr/local/src/zlib"

  return "$_STATE"

}

function _inst_openssl() {

  local _FUNCTION_ID="_inst_openssl"
  local _STATE="0"

  cd "$_src"

  _f "wget -c --no-check-certificate https://www.openssl.org/source/openssl-${_openssl_version}.tar.gz"

  _f "tar xzvf openssl-${_openssl_version}.tar.gz"

  cd "${_src}/openssl-$_openssl_version"

  _f "./config --prefix=/usr/local/openssl-${_openssl_version} --openssldir=/usr/local/openssl-${_openssl_version} shared zlib no-ssl3 no-weak-ssl-ciphers"

  _f "make -j2"
  _f "make install"

  export OPENSSL_LIB=/usr/local/openssl-${_openssl_version}/lib
  export OPENSSL_INC=/usr/local/openssl-${_openssl_version}/include
  export OPENSSL_DIRECTORY="/usr/local/src/openssl-${_openssl_version}"

  _f "cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=/usr/local/openssl-${_openssl_version}/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/openssl-${_openssl_version}/lib:${LD_LIBRARY_PATH}
__EOF__"

_f "chmod +x /etc/profile.d/openssl.sh"
_f "source /etc/profile.d/openssl.sh"

_f "mv /usr/bin/openssl /usr/bin/openssl-old"
_f "ln -s /usr/local/openssl-${_openssl_version}/bin/openssl /usr/bin/openssl"

_f "cat > /etc/ld.so.conf.d/openssl.conf << __EOF__
/usr/local/openssl-${_openssl_version}/lib
__EOF__"

  return "$_STATE"

}

function _inst_luajit() {

  local _FUNCTION_ID="_inst_luajit"
  local _STATE="0"

  cd "$_src"

  _f "git clone --depth 1 https://github.com/openresty/luajit2"

  cd "${_src}/luajit2"

  _f "./configure"

  _f "make"
  _f "make install"

  export LUA_LIB=/usr/local/lib/
  export LUA_INC=/usr/local/include/luajit-2.1/

  return "$_STATE"

}

function _inst_sregex() {

  local _FUNCTION_ID="_inst_sregex"
  local _STATE="0"

  cd "$_src"

  _f "git clone --depth 1 https://github.com/openresty/sregex"

  cd "${_src}/sregex"

  _f "./configure"

  _f "make"
  _f "make install"

  return "$_STATE"

}

function _inst_jemalloc() {

  local _FUNCTION_ID="_inst_jemalloc"
  local _STATE="0"

  cd "$_src"

  _f "git clone --depth 1 https://github.com/jemalloc/jemalloc"

  cd "${_src}/sregex"

  _f "./autogen.sh"

  _f "make"
  _f "make install"

  export JEMALLOC_DIRECTORY="/usr/local/src/jemalloc"

  return "$_STATE"

}

function _inst_3_modules() {

  local _FUNCTION_ID="_inst_3_modules"
  local _STATE="0"

  cd "$_ngx_modules"

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

    _f "git clone --depth 1 $i"

  done

  _f "wget -c --no-check-certificate http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz"

  _f "mkdir -p delay-module"

  _f "tar xzvf delay-module.tar.gz -C delay-module --strip 1"

  cd "${_ngx_modules}/ngx_brotli"
  _f "git submodule update --init"

  cd "$_ngx_modules"

  _f "git clone --depth 1 https://github.com/alibaba/tengine"

  _f "git clone --depth 1 https://github.com/nbs-system/naxsi"

  return "$_STATE"

}

function _build_nginx() {

  local _FUNCTION_ID="_build_nginx"
  local _STATE="0"

  cd "$_ngx_master" ; _f "$?"

  if [[ "$ngx_distr" -eq 1 ]] ; then

    _f "./configure --prefix=/etc/nginx \
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
                --with-openssl=${OPENSSL_DIRECTORY} \
                --with-openssl-opt=no-weak-ssl-ciphers \
                --with-openssl-opt=no-ssl3 \
                --with-pcre=${PCRE_DIRECTORY} \
                --with-pcre-jit \
                --with-zlib=${ZLIB_DIRECTORY} \
                --without-http-cache \
                --without-http_memcached_module \
                --without-mail_pop3_module \
                --without-mail_imap_module \
                --without-mail_smtp_module \
                --without-http_fastcgi_module \
                --without-http_scgi_module \
                --without-http_uwsgi_module \
                --add-module=${_ngx_modules}/ngx_devel_kit \
                --add-module=${_ngx_modules}/encrypted-session-nginx-module \
                --add-module=${_ngx_modules}/nginx-access-plus/src/c \
                --add-module=${_ngx_modules}/ngx_http_substitutions_filter_module \
                --add-module=${_ngx_modules}/nginx-sticky-module-ng \
                --add-module=${_ngx_modules}/nginx-module-vts \
                --add-module=${_ngx_modules}/ngx_brotli \
                --add-module=${_ngx_modules}/tengine/modules/ngx_backtrace_module \
                --add-module=${_ngx_modules}/tengine/modules/ngx_debug_pool \
                --add-module=${_ngx_modules}/tengine/modules/ngx_debug_timer \
                --add-module=${_ngx_modules}/tengine/modules/ngx_http_upstream_check_module \
                --add-module=${_ngx_modules}/tengine/modules/ngx_http_footer_filter_module \
                --add-dynamic-module=${_ngx_modules}/lua-nginx-module \
                --add-dynamic-module=${_ngx_modules}/set-misc-nginx-module \
                --add-dynamic-module=${_ngx_modules}/echo-nginx-module \
                --add-dynamic-module=${_ngx_modules}/headers-more-nginx-module \
                --add-dynamic-module=${_ngx_modules}/replace-filter-nginx-module \
                --add-dynamic-module=${_ngx_modules}/array-var-nginx-module \
                --add-dynamic-module=${_ngx_modules}/nginx-module-sysguard \
                --add-dynamic-module=${_ngx_modules}/delay-module \
                --add-dynamic-module=${_ngx_modules}/naxsi/naxsi_src \
                --with-cc-opt='-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -g -O3 -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf' \
                --with-ld-opt='-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib'"

  elif [[ "$ngx_distr" -eq 2 ]] ; then

    _f "./configure --prefix=/etc/nginx \
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
                --with-openssl=${OPENSSL_DIRECTORY} \
                --with-openssl-opt=no-weak-ssl-ciphers \
                --with-openssl-opt=no-ssl3 \
                --with-pcre=${PCRE_DIRECTORY} \
                --with-pcre-jit \
                --with-zlib=${ZLIB_DIRECTORY} \
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
                --add-module=${_ngx_modules}/nginx-access-plus/src/c \
                --add-module=${_ngx_modules}/ngx_http_substitutions_filter_module \
                --add-module=${_ngx_modules}/nginx-module-vts \
                --add-module=${_ngx_modules}/ngx_brotli \
                --add-module=${_ngx_modules}/tengine/modules/ngx_backtrace_module \
                --add-module=${_ngx_modules}/tengine/modules/ngx_debug_pool \
                --add-module=${_ngx_modules}/tengine/modules/ngx_debug_timer \
                --add-module=${_ngx_modules}/tengine/modules/ngx_http_upstream_check_module \
                --add-module=${_ngx_modules}/tengine/modules/ngx_http_footer_filter_module \
                --add-dynamic-module=${_ngx_modules}/replace-filter-nginx-module \
                --add-dynamic-module=${_ngx_modules}/nginx-module-sysguard \
                --add-dynamic-module=${_ngx_modules}/delay-module \
                --add-dynamic-module=${_ngx_modules}/naxsi/naxsi_src \
                --with-cc-opt='-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -g -O3 -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf' \
                --with-ld-opt='-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib'"

  elif [[ "$ngx_distr" -eq 3 ]] ; then

    _f "./configure --prefix=/etc/nginx \
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
                --with-openssl=${OPENSSL_DIRECTORY} \
                --with-openssl-opt=no-weak-ssl-ciphers \
                --with-openssl-opt=no-ssl3 \
                --with-pcre=${PCRE_DIRECTORY} \
                --with-pcre-jit \
                --with-jemalloc=${JEMALLOC_DIRECTORY} \
                --without-http-cache \
                --without-http_memcached_module \
                --without-mail_pop3_module \
                --without-mail_imap_module \
                --without-mail_smtp_module \
                --without-http_fastcgi_module \
                --without-http_scgi_module \
                --without-http_uwsgi_module \
                --add-module=${_ngx_modules}/nginx-access-plus/src/c \
                --add-module=${_ngx_modules}/ngx_http_substitutions_filter_module \
                --add-module=${_ngx_modules}/nginx-module-vts \
                --add-module=${_ngx_modules}/ngx_brotli \
                --add-dynamic-module=${_ngx_modules}/echo-nginx-module \
                --add-dynamic-module=${_ngx_modules}/headers-more-nginx-module \
                --add-dynamic-module=${_ngx_modules}/replace-filter-nginx-module \
                --add-dynamic-module=${_ngx_modules}/delay-module \
                --add-dynamic-module=${_ngx_modules}/naxsi/naxsi_src \
                --with-cc-opt='-I/usr/local/include -I/usr/local/openssl-${_openssl_version}/include -I/usr/local/include/luajit-2.1/ -I/usr/local/include/jemalloc -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' \
                --with-ld-opt='-Wl,-E -L/usr/local/lib -ljemalloc -lpcre -Wl,-rpath,/usr/local/lib/,-z,relro -Wl,-z,now -pie'"

  fi

  _f "make -j2"
  _f "make install"

  _f "ldconfig"

  return "$_STATE"

}

function _create_user() {

  local _FUNCTION_ID="_create_user"
  local _STATE="0"

  if [[ "$_DIST_VERSION" == "rhel" ]] ; then

    _f "adduser --system --home /non-existent --no-create-home --shell /usr/sbin/nologin --disabled-login --disabled-password --gecos 'nginx user' --group nginx"

  elif [[ "$_DIST_VERSION" == "debian" ]] ; then

    _f "groupadd -r -g 920 nginx"

    _f "adduser --system --home-dir /non-existent --no-create-home --shell /usr/sbin/nologin --uid 920 --gid nginx nginx"

    _f "passwd -l nginx"

  fi

  return "$_STATE"

}

function _gen_modules() {

  local _FUNCTION_ID="_gen_modules"
  local _STATE="0"

  _mod_dir="/etc/nginx/modules"

  :>"${_mod_dir}.conf"

  for _module in $(ls "${_mod_dir}/") ; do

    echo -en "load_module\t\t${_mod_dir}/$_module;\n" >> "${_mod_dir}.conf"

  done

  return "$_STATE"

}

function _init_logrotate() {

  local _FUNCTION_ID="_init_logrotate"
  local _STATE="0"

  _f "cat > /etc/logrotate.d/nginx << __EOF__
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
__EOF__"

  return "$_STATE"

}

function _init_systemd() {

  local _FUNCTION_ID="_init_systemd"
  local _STATE="0"

  _f "cat > /lib/systemd/system/nginx.service << __EOF__
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
__EOF__"

  _f "systemctl daemon-reload"
  _f "systemctl enable nginx"

  return "$_STATE"

}

function __main__() {

  local _FUNCTION_ID="__main__"
  local _STATE="0"

  printf '\n× \e['${trgb_bground_yellow}'m%s\e[m\n\n' "Set NGINX distribution"

  printf '  \e['${trgb_bground_blue}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "1" "NGINX" "https://www.nginx.com/"
  printf '  \e['${trgb_bground_blue}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "2" "OpenResty" "https://openresty.org/"
  printf '  \e['${trgb_bground_blue}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "3" "The Tengine Web Server" "https://tengine.taobao.org/"

  printf '  \n\e['${trgb_light}'m%s\e[m ' ">>"
  read ngx_distr

  printf '\n× \e['${trgb_bground_yellow}'m%s\e[m\n\n' "Set version of source package"

  if [[ "$ngx_distr" -eq 1 ]] ; then

    printf '  Default for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "NGINX" "1.16.0"

  elif [[ "$ngx_distr" -eq 2 ]] ; then

    printf '  Default for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "OpenResty" "1.15.8.1"

  fi

  printf '  \n\e['${trgb_light}'m%s\e[m ' ">>"
  read ngx_version

  _inst_base_packages
  _inst_nginx_distribution

  _inst_pcre
  _inst_zlib
  _inst_openssl
  _inst_luajit
  _inst_sregex
  _inst_jemalloc

  ldconfig

  _inst_3_modules

  _build_nginx

  cd "$_src"

  _create_user
  _gen_modules
  _init_logrotate
  _init_systemd

  nginx -v
  nginx -t -c /etc/nginx/nginx.conf

  return "$_STATE"

}

# We pass arguments to the __main__ function.
# It is required if you want to run on arguments type $1, $2, ...
__main__ "${__script_params[@]}"

_exit_ "0"
