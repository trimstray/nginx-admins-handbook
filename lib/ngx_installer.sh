#!/usr/bin/env bash

# shellcheck shell=bash

# shellcheck -s bash -e 1072,1094,1107,2145 -x ngx_installer.conf ngx_installer.sh

### BEG SCRIPT INFO
#
# Header:
#
#         fname : "ngx_installer.sh"
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
#   ngx_installer.sh, Copyright (C) 2018  Michał Żurawski
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

  printf "Unsupported GNU/Linux distribution.\\n"
  exit 1

fi

# We check if we are a root user.
if [[ "$EUID" -ne 0 ]] ; then

  printf "EUID is not equal 0 (no root user)\\n"
  exit 1

fi


# Global variables.
readonly _rel="${_init_directory}"
readonly _src="/usr/local/src"
readonly _cfg="${_rel}/ngx_installer.conf"

trgb_bold="1;1;38"
trgb_red="1;1;31"
trgb_red_x="0;49;91"
trgb_dark="2;2;38"
trgb_light="1;1;36"
trgb_bold_green="1;2;32"
trgb_bground_blue="1;37;44"
trgb_bground_dark="1;37;40"

# shellcheck disable=SC2155
export _vcpu=$(nproc)
# shellcheck disable=SC2155
export _pmem=$(awk -F":" '$1~/MemTotal/{print $2}' /proc/meminfo | tr -d ' ')
# shellcheck disable=SC2155
export _openssl_gcc=""

# shellcheck disable=SC1090
if [[ -e "${_cfg}" ]] ; then

  source "${_cfg}"

else

  printf "Not found configuration file: %s\\n" "$_cfg"
  exit 1

fi

if [[ "$LATEST_PKGS" -eq 0 ]] ; then

  if [[ -z "$PCRE_LIBRARY" ]] ; then

    export _pcre_version="8.42"

  else

    export _pcre_version="$PCRE_LIBRARY"

  fi

  if [[ -z "$OPENSSL_LIBRARY" ]] ; then

    export _openssl_version="1.1.1b"

  else

    export _openssl_version="$OPENSSL_LIBRARY"

  fi

else

  # shellcheck disable=SC2034
  export _pcre_version=$(curl -sL https://ftp.pcre.org/pub/pcre/ |
                         grep -Eo 'pcre\-[0-9.]+[0-9]' | \
                         sort -V | \
                         tail -n 1| \
                         cut -d '-' -f2-)

  # shellcheck disable=SC2034
  export _openssl_version=$(curl -sL https://www.openssl.org/source/ |
                         grep -Eo 'openssl\-[0-9.]+[a-z]?' | \
                         sort -V | \
                         tail -n 1| \
                         cut -d '-' -f2-)

fi

export ngx_distr=""
export ngx_version=""

export PCRE_SRC="${_src}/pcre-${_pcre_version}"
export PCRE_LIB="/usr/local/lib"
export PCRE_INC="/usr/local/include"

export ZLIB_SRC="${_src}/zlib"
export ZLIB_LIB="/usr/local/lib"
export ZLIB_INC="/usr/local/include"

export OPENSSL_SRC="${_src}/openssl-${_openssl_version}"
export OPENSSL_DIR="/usr/local/openssl-${_openssl_version}"
export OPENSSL_LIB="${OPENSSL_DIR}/lib"
export OPENSSL_INC="${OPENSSL_DIR}/include"

export LUAJIT_SRC="${_src}/luajit2"
export LUAJIT_LIB="/usr/local/lib"
export LUAJIT_INC="/usr/local/include/luajit-2.1"


# Global functions.
function _f() {

  local _STATE="0"

  local _cnt="$1"
  local _cmd="$2"

  _x_trgb_rbold="1;4;4;41"
  _x_trgb_gbold="1;4;4;42"

  printf '\n»»»»»»»»» \e['${trgb_bold}'m%s\e[m\n\n' "from: ${_FUNCTION_ID}() -- INIT COMMAND:"
  printf '\e['${trgb_dark}'m%s\e[m\n\n' "$_cmd"

  # printf '=%.0s' {1..48}

  if [[ "$NGX_PROMPT" -eq 1 ]] || \
     [[ -z "$NGX_PROMPT" ]] ; then

    _rstate=0

    while [[ "$_rstate" -eq 0 ]] ; do

      printf '\e['${trgb_light}'m%s\e[m ' "(press 'YES' to run) >>"
      read -r _pcmd

      if [[ "$_pcmd" != "YES" ]] ; then

        _rstate=0

      else

        _rstate=1

      fi

    done

  fi

  for _cl in $(seq 1 "$_cnt") ; do

    # Init command:
    if [[ "$DEBUG" -eq 1 ]] ; then

      bash -xc "eval $_cmd"

    else

      bash -c "eval $_cmd"

    fi

    _cstate="$?"

    if [[ "$_cstate" -eq 0 ]] ; then

      break

    else

      if [[ "$_cnt" -ne 1 ]] ; then

        printf '\n > \e['${trgb_red}'m%s\e[m: %s\n' "command failed, reinit" "$_cl"

      fi

    fi

  done

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

  if [[ "$_cstate" -ne 0 ]] ; then

    printf '\n\e['${_x_trgb_rbold}'m %s \e[m\n' "**STOP** from: ${_FUNCTION_ID}() -- COMMAND:"

    # printf '\e['${trgb_dark}'m%s\e[m\n' "$_cmd"
    printf "\n%s\n" "$_cmd"

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

    _f "5" "apt-get install -y \
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

    _f "5" "yum install -y \
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

function _inst_nginx_dist() {

  local _FUNCTION_ID="_inst_nginx_dist"
  local _STATE="0"

  if [[ "$ngx_distr" -eq 1 ]] ; then

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "1" "mkdir -p $i"

    done

    cd "${_ngx_base}" || \
    ( printf "directory not exist: %s\\n" "$_ngx_base" ; exit 1 )

    _f "5" "wget -c --no-check-certificate https://nginx.org/download/nginx-${ngx_version}.tar.gz"

    _f "1" "tar zxvf nginx-${ngx_version}.tar.gz -C ${_ngx_master} --strip 1"

  elif [[ "$ngx_distr" -eq 2 ]] ; then

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "1" "mkdir -p $i"

    done

    cd "${_ngx_base}" || \
    ( printf "directory not exist: %s\\n" "$_ngx_base" ; exit 1 )

    _f "5" "wget -c --no-check-certificate https://openresty.org/download/openresty-${ngx_version}.tar.gz"

    _f "1" "tar zxvf openresty-${ngx_version}.tar.gz -C ${_ngx_master} --strip 1"

  elif [[ "$ngx_distr" -eq 3 ]] ; then

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "1" "mkdir -p $i"

    done

    cd "${_ngx_base}" || \
    ( printf "directory not exist: %s\\n" "$_ngx_base" ; exit 1 )

    _f "5" "git clone --depth 1 https://github.com/alibaba/tengine"

  else

    printf "Unsupported NGINX distribution.\\n"
    exit 1

  fi

  return "$_STATE"

}

function _inst_pcre() {

  local _FUNCTION_ID="_inst_pcre"
  local _STATE="0"

  cd "$_src" || \
  ( printf "directory not exist: %s\\n" "$_src" ; exit 1 )

  _f "5" "wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${_pcre_version}.tar.gz"

  _f "1" "tar xzvf pcre-${_pcre_version}.tar.gz"

  cd "$PCRE_SRC" || \
  ( printf "directory not exist: %s\\n" "$PCRE_SRC" ; exit 1 )

  _f "1" "./configure"

  _f "1" "make -j${_vcpu}"
  _f "1" "make install"

  return "$_STATE"

}

function _inst_zlib() {

  local _FUNCTION_ID="_inst_zlib"
  local _STATE="0"

  cd "$_src" || \
  ( printf "directory not exist: %s\\n" "$_src" ; exit 1 )

  _f "5" "git clone --depth 1 https://github.com/cloudflare/zlib"

  cd "$ZLIB_SRC" || \
  ( printf "directory not exist: %s\\n" "$ZLIB_SRC" ; exit 1 )

  _f "1" "./configure"

  _f "1" "make -j${_vcpu}"
  _f "1" "make install"

  return "$_STATE"

}

function _inst_openssl() {

  local _FUNCTION_ID="_inst_openssl"
  local _STATE="0"

  cd "$_src" || \
  ( printf "directory not exist: %s\\n" "$_src" ; exit 1 )

  _f "5" "wget -c --no-check-certificate https://www.openssl.org/source/openssl-${_openssl_version}.tar.gz"

  _f "1" "tar xzvf openssl-${_openssl_version}.tar.gz"

  cd "$OPENSSL_SRC" || \
  ( printf "directory not exist: %s\\n" "$OPENSSL_SRC" ; exit 1 )

  _f "1" "./config --prefix=$OPENSSL_DIR --openssldir=$OPENSSL_DIR shared zlib no-ssl3 no-weak-ssl-ciphers"

  _f "1" "make -j${_vcpu}"
  _f "1" "make install"

  # Setup PATH environment variables:
  cat > /etc/profile.d/openssl.sh << __EOF__
#!/bin/sh
export PATH=${OPENSSL_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${OPENSSL_DIR}/lib:${LD_LIBRARY_PATH}
__EOF__

  echo

  _f "1" "chmod +x /etc/profile.d/openssl.sh"
  _f "1" "source /etc/profile.d/openssl.sh"

  echo

  _f "1" "mv /usr/bin/openssl /usr/bin/openssl-old"

  echo

  _f "1" "ln -s ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl"

  echo

  cat > /etc/ld.so.conf.d/openssl.conf << __EOF__
${OPENSSL_DIR}/lib
__EOF__

  echo

  return "$_STATE"

}

function _inst_luajit() {

  local _FUNCTION_ID="_inst_luajit"
  local _STATE="0"

  cd "$_src" || \
  ( printf "directory not exist: %s\\n" "$_src" ; exit 1 )

  _f "5" "git clone --depth 1 https://github.com/openresty/luajit2"

  cd "$LUAJIT_SRC" || \
  ( printf "directory not exist: %s\\n" "$LUAJIT_SRC" ; exit 1 )

  _f "1" "make"
  _f "1" "make install"

  _f "1" "ln -s /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 /usr/local/lib/liblua.so"

  return "$_STATE"

}

function _inst_sregex() {

  local _FUNCTION_ID="_inst_sregex"
  local _STATE="0"

  cd "$_src" || \
  ( printf "directory not exist: %s\\n" "$_src" ; exit 1 )

  _f "5" "git clone --depth 1 https://github.com/openresty/sregex"

  cd "${_src}/sregex" || \
  ( printf "directory not exist: %s\\n" "${_src}/sregex" ; exit 1 )

  _f "1" "make"
  _f "1" "make install"

  return "$_STATE"

}

function _inst_jemalloc() {

  local _FUNCTION_ID="_inst_jemalloc"
  local _STATE="0"

  cd "$_src" || \
  ( printf "directory not exist: %s\\n" "$_src" ; exit 1 )

  export JEMALLOC_SRC="${_src}/jemalloc"

  _f "5" "git clone --depth 1 https://github.com/jemalloc/jemalloc"

  cd "$JEMALLOC_SRC" || \
  ( printf "directory not exist: %s\\n" "$JEMALLOC_SRC" ; exit 1 )

  _f "1" "./autogen.sh"

  _f "1" "make"
  _f "1" "make install"

  return "$_STATE"

}

function _inst_3_modules() {

  local _FUNCTION_ID="_inst_3_modules"
  local _STATE="0"

  cd "$_ngx_modules" || \
  ( printf "directory not exist: %s\\n" "$_ngx_modules" ; exit 1 )

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

    _f "5" "git clone --depth 1 $i"

  done

  _f "5" "wget -c --no-check-certificate http://mdounin.ru/hg/ngx_http_delay_module/archive/tip.tar.gz -O delay-module.tar.gz"

  _f "1" "mkdir -p delay-module"

  _f "1" "tar xzvf delay-module.tar.gz -C delay-module --strip 1"

  cd "${_ngx_modules}/ngx_brotli" || \
  ( printf "directory not exist: %s\\n" "${_ngx_modules}/ngx_brotli" ; exit 1 )

  _f "1" "git submodule update --init"

  cd "$_ngx_modules" || \
  ( printf "directory not exist: %s\\n" "$_ngx_modules" ; exit 1 )

  _f "5" "git clone --depth 1 https://github.com/alibaba/tengine"

  _f "5" "git clone --depth 1 https://github.com/nbs-system/naxsi"

  return "$_STATE"

}

function _build_nginx() {

  local _FUNCTION_ID="_build_nginx"
  local _STATE="0"

  cd "${_ngx_master}" || \
  ( printf "directory not exist: %s\\n" "$_ngx_master" ; exit 1 )

  if [[ "$ngx_distr" -eq 1 ]] ; then

    _f "1" "./configure --prefix=/etc/nginx \
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
            --with-openssl-opt=${__OPENSSL_PARAMS[@]} \
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
            --with-cc-opt=${__CC_PARAMS[@]} \
            --with-ld-opt=${__LD_PARAMS[@]}"

  elif [[ "$ngx_distr" -eq 2 ]] ; then

    _f "1" "./configure --prefix=/etc/nginx \
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
            --with-openssl-opt=${__OPENSSL_PARAMS[@]} \
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
            --with-cc-opt=${__CC_PARAMS[@]} \
            --with-ld-opt=${__LD_PARAMS[@]}"

  elif [[ "$ngx_distr" -eq 3 ]] ; then

    _f "1" "./configure --prefix=/etc/nginx \
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
            --with-openssl=${OPENSSL_SRC} \
            --with-openssl-opt=${__OPENSSL_PARAMS[@]} \
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
            --add-module=${_ngx_modules}/nginx-access-plus/src/c \
            --add-module=${_ngx_modules}/ngx_http_substitutions_filter_module \
            --add-module=${_ngx_modules}/nginx-module-vts \
            --add-module=${_ngx_modules}/ngx_brotli \
            --add-dynamic-module=${_ngx_modules}/echo-nginx-module \
            --add-dynamic-module=${_ngx_modules}/headers-more-nginx-module \
            --add-dynamic-module=${_ngx_modules}/replace-filter-nginx-module \
            --add-dynamic-module=${_ngx_modules}/delay-module \
            --add-dynamic-module=${_ngx_modules}/naxsi/naxsi_src \
            --with-cc-opt=${__CC_PARAMS[@]} \
            --with-ld-opt=${__LD_PARAMS[@]}"

  fi

  _f "1" "make -j${_vcpu}"
  _f "1" "make install"

  return "$_STATE"

}

function _create_user() {

  local _FUNCTION_ID="_create_user"
  local _STATE="0"

  if [[ "$_DIST_VERSION" == "debian" ]] ; then

    _f "1" "adduser --system --home /non-existent --no-create-home --shell /usr/sbin/nologin --disabled-login --disabled-password --gecos \'nginx user\' --group nginx"

  elif [[ "$_DIST_VERSION" == "rhel" ]] ; then

    _f "1" "groupadd -r -g 920 nginx"

    _f "1" "useradd --system --home-dir /non-existent --no-create-home --shell /usr/sbin/nologin --uid 920 --gid nginx nginx"

    _f "1" "passwd -l nginx"

  fi

  return "$_STATE"

}

function _gen_modules() {

  local _FUNCTION_ID="_gen_modules"
  local _STATE="0"

  _mod_dir="/etc/nginx/modules"

  :>"${_mod_dir}.conf"

  # shellcheck disable=SC2045
  for _module in $(ls "${_mod_dir}/") ; do

    echo -en "load_module\t\t${_mod_dir}/$_module;\n" >> "${_mod_dir}.conf"

  done

  return "$_STATE"

}

function _init_logrotate() {

  local _FUNCTION_ID="_init_logrotate"
  local _STATE="0"

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

  return "$_STATE"

}

function _init_systemd() {

  local _FUNCTION_ID="_init_systemd"
  local _STATE="0"

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

  _f "1" "systemctl daemon-reload"
  _f "1" "systemctl enable nginx"

  return "$_STATE"

}

function _post_tasks() {

  local _FUNCTION_ID="_post_tasks"
  local _STATE="0"

  for i in \
    /var/www \
    /var/log/nginx \
    /var/cache/nginx ; do

    _f "1" "mkdir -p $i"
    _f "1" "chown -R nginx:nginx $i"

  done

  return "$_STATE"

}


function _test_config() {

  local _FUNCTION_ID="_test_config"
  local _STATE="0"

  echo

  _f "1" "nginx -v"

  echo

  _f "1" "nginx -t -c /etc/nginx/nginx.conf"

  return "$_STATE"

}

function __main__() {

  local _FUNCTION_ID="__main__"
  local _STATE="0"

  clear

  _t_rst="0"
  _c_rst="6"

  _t_sst="66"

  _t_bar="2;39"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst"

  printf "\\e[${_t_bar}m%s\\e[m" \
         "┌─────────────────────────────────────────────────────────────────┐"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"
  tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  printf "%s\\e[1;31m%s\\e[m \\e[2;32m%s\\e[m \\e[1;37m%s\\e[m" \
         "          " \
         "Φ"  \
         "ngx_installer.sh" \
         "(NGINX/OpenResty/Tengine)"

  tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst"; printf "\\e[${_t_bar}m%s\\e[m" "│"
  tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  printf "%s\\e[1;37m%s\\e[m \\e[2;37m%s\\e[m" \
         "   " \
         "Project:"  \
         "https://github.com/trimstray/nginx-admins-handbook"

  tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"
  tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  printf "%s\\e[0;36m%s\\e[m" \
         "               " \
         "Debian - Ubuntu - RHEL - CentOS"

  tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"
  tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  tput cup "$_t_rst" "$_c_rst" ;

  printf "\\e[${_t_bar}m%s\\e[m" \
         "└─────────────────────────────────────────────────────────────────┘"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 2))
  tput cup "$_t_rst" "$_c_rst"

  printf '\n  \e['${trgb_bground_blue}'m%s\e[m\n\n' "Set NGINX flavour"

  printf '  \e['${trgb_bground_dark}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "1" "NGINX" "https://www.nginx.com/"
  printf '  \e['${trgb_bground_dark}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "2" "OpenResty" "https://openresty.org/"
  printf '  \e['${trgb_bground_dark}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "3" "The Tengine Web Server" "https://tengine.taobao.org/"

  printf '  \n\e['${trgb_light}'m%s\e[m ' ">>"
  read -r ngx_distr

  _ngx_distr=$(echo "$ngx_distr" | tr -d '[:alpha:]' | cut -c1)

  if [[ -z "$_ngx_distr" ]] ; then

    printf "\\nincorrect value => [1-3]\n"
    exit 1

  else

    if [[ "$_ngx_distr" -ne 1 ]] && \
       [[ "$_ngx_distr" -ne 2 ]] && \
       [[ "$_ngx_distr" -ne 3 ]] ; then

      printf "\\nincorrect value => [1-3]\n"
      exit 1

    fi

  fi

  printf '\n  \e['${trgb_bground_blue}'m%s\e[m\n\n' "Set version of source package"

  if [[ "$LATEST_PKGS" -eq 0 ]] ; then

    if [[ "$_ngx_distr" -eq 1 ]] ; then

      printf '  Default for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "NGINX" "1.16.0"
      printf '   - for more please see: \e['${trgb_dark}'m%s\e[m\n' "https://nginx.org/download"
      printf '   - examples of versions: \e['${trgb_dark}'m%s\e[m\n' "1.17.0, 1.16.0, 1.15.8, 1.15.2, 1.14.0, 1.13.5"

      _ngx_distr_str="NGINX"

    elif [[ "$_ngx_distr" -eq 2 ]] ; then

      printf '  Default for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "OpenResty" "1.15.8.1"
      printf '   - for more please see: \e['${trgb_dark}'m%s\e[m\n' "https://openresty.org/download"
      printf '   - examples of versions: \e['${trgb_dark}'m%s\e[m\n' "1.15.8.1, 1.13.6.2, 1.13.6.1, 1.11.2.4"

      _ngx_distr_str="OpenResty"

    elif [[ "$_ngx_distr" -eq 3 ]] ; then

      printf '  Default for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "Tengine" "2.3.0"
      printf '   - for more please see: \e['${trgb_dark}'m%s\e[m\n' "https://tengine.taobao.org/download.html"
      printf '   - examples of versions: \e['${trgb_dark}'m%s\e[m\n' "2.3.0, 2.2.3, 2.2.0, 2.1.2, 2.0.1"

      _ngx_distr_str="Tengine"

    fi

    printf '  \n\e['${trgb_light}'m%s\e[m ' ">>"
    read -r ngx_version

  else

    if [[ "$_ngx_distr" -eq 1 ]] ; then

      ngx_version=$(curl -sL https://nginx.org/download/ | \
                    grep -Eo 'nginx\-[0-9.]+[123456789]\.[0-9]+' | \
                    sort -V | \
                    tail -n 1 | \
                    cut -d '-' -f2-)

      _ngx_distr_str="NGINX"

    elif [[ "$_ngx_distr" -eq 2 ]] ; then

      ngx_version=$(curl -sL https://openresty.org/en/download.html | \
                    grep -Eo 'nginx\-[0-9.]+[123456789]\.[0-9]+\.[0-9]+' | \
                    sort -V | \
                    tail -n 1 | \
                    cut -d '-' -f2-)

      _ngx_distr_str="OpenResty"

    elif [[ "$_ngx_distr" -eq 3 ]] ; then

      ngx_version=$(curl -sL https://tengine.taobao.org/download.html | \
                    grep -Eo 'nginx\-[0-9.]+[123456789]\.[0-9]+' | \
                    sort -V | \
                    tail -n 1 | \
                    cut -d '-' -f2-)

      _ngx_distr_str="Tengine"

    fi

    printf '  Latest for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "$_ngx_distr_str" "$ngx_version"

  fi

  if [[ "$_ngx_distr" -eq 1 ]] ; then

    if [[ -z "$ngx_version" ]] ; then ngx_version="1.16.0" ; fi

    _ngx_src="/usr/local/src"
    _ngx_base="${_ngx_src}/nginx-${ngx_version}"
    _ngx_master="${_ngx_base}/master"
    _ngx_modules="${_ngx_base}/modules"

    if [[ -z "$OPENSSL_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      OPENSSL_OPTIONS="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong"

    fi

    if [[ -z "$COMPILER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      COMPILER_OPTIONS="-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -g -O3 -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf"

    fi

    if [[ -z "$LINKER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      LINKER_OPTIONS="-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib"

    fi

  elif [[ "$_ngx_distr" -eq 2 ]] ; then

    if [[ -z "$ngx_version" ]] ; then ngx_version="1.15.8.1" ; fi

    _ngx_src="/usr/local/src"
    _ngx_base="${_ngx_src}/openresty-${ngx_version}"
    _ngx_master="${_ngx_base}/master"
    _ngx_modules="${_ngx_base}/modules"

    if [[ -z "$OPENSSL_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      OPENSSL_OPTIONS="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong"

    fi

    if [[ -z "$COMPILER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      COMPILER_OPTIONS="-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -g -O3 -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf"

    fi

    if [[ -z "$LINKER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      LINKER_OPTIONS="-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib"

    fi

  elif [[ "$_ngx_distr" -eq 3 ]] ; then

    if [[ -z "$ngx_version" ]] ; then ngx_version="2.3.0" ; fi

    _ngx_src="/usr/local/src"
    _ngx_base="${_ngx_src}/tengine-${ngx_version}"
    _ngx_master="${_ngx_base}/master"
    _ngx_modules="${_ngx_base}/modules"

    if [[ -z "$OPENSSL_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      OPENSSL_OPTIONS="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong"

    fi

    if [[ -z "$COMPILER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      COMPILER_OPTIONS="-I/usr/local/include -I${OPENSSL_INC} -I${LUAJIT_INC} -I${JEMALLOC_SRC} -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC"

    fi

    if [[ -z "$LINKER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      LINKER_OPTIONS="-Wl,-E -L/usr/local/lib -ljemalloc -lpcre -Wl,-rpath,/usr/local/lib/,-z,relro -Wl,-z,now -pie"

    fi

  fi

  if [[ "${#__GCC_SSL[@]}" -eq 0 ]] ; then

    # shellcheck disable=SC2178
    export __OPENSSL_PARAMS=("\'${OPENSSL_OPTIONS}\'")

  else

    # shellcheck disable=SC2178
    export __OPENSSL_PARAMS=("\'${OPENSSL_OPTIONS} ${_openssl_gcc}\'")

  fi

  # shellcheck disable=SC2178
  export __CC_PARAMS=("\'${COMPILER_OPTIONS}\'")
  # shellcheck disable=SC2178
  export __LD_PARAMS=("\'${LINKER_OPTIONS}\'")

  printf '\n            os type : \e['${trgb_dark}'m%s\e[m\n' "$OSTYPE"
  printf '       distribution : \e['${trgb_dark}'m%s\e[m\n' "${_DIST_VERSION} like"
  printf '         vcpu cores : \e['${trgb_dark}'m%s\e[m\n' "$_vcpu"
  printf '       total memory : \e['${trgb_dark}'m%s\e[m\n' "$_pmem"
  printf '        config file : \e['${trgb_dark}'m%s\e[m\n' "$_cfg"
  printf '     init directory : \e['${trgb_dark}'m%s\e[m\n' "$_init_directory"
  printf '   source directory : \e['${trgb_dark}'m%s\e[m\n' "$_src"
  printf '    nginx directory : \e['${trgb_dark}'m%s\e[m\n' "$_ngx_master"
  printf '  modules directory : \e['${trgb_dark}'m%s\e[m\n' "$_ngx_modules"
  printf '    package version : \e['${trgb_dark}'m%s, %s\e[m\n' "$_ngx_distr_str" "$ngx_version"
  printf '       pcre version : \e['${trgb_dark}'m%s\e[m\n' "$_pcre_version"
  printf '    openssl version : \e['${trgb_dark}'m%s\e[m\n' "$_openssl_version"
  printf '       zlib version : \e['${trgb_dark}'m%s\e[m\n' "Cloudflare fork of zlib"
  printf '     luajit version : \e['${trgb_dark}'m%s\e[m\n' "OpenResty's branch of LuaJIT 2"
  printf '           PCRE_SRC : \e['${trgb_dark}'m%s\e[m\n' "$PCRE_SRC"
  printf '           PCRE_LIB : \e['${trgb_dark}'m%s\e[m\n' "$PCRE_LIB"
  printf '           PCRE_INC : \e['${trgb_dark}'m%s\e[m\n' "$PCRE_INC"
  printf '           ZLIB_SRC : \e['${trgb_dark}'m%s\e[m\n' "$ZLIB_SRC"
  printf '           ZLIB_LIB : \e['${trgb_dark}'m%s\e[m\n' "$ZLIB_LIB"
  printf '           ZLIB_INC : \e['${trgb_dark}'m%s\e[m\n' "$ZLIB_INC"
  printf '        OPENSSL_SRC : \e['${trgb_dark}'m%s\e[m\n' "$OPENSSL_SRC"
  printf '        OPENSSL_DIR : \e['${trgb_dark}'m%s\e[m\n' "$OPENSSL_DIR"
  printf '        OPENSSL_LIB : \e['${trgb_dark}'m%s\e[m\n' "$OPENSSL_LIB"
  printf '        OPENSSL_INC : \e['${trgb_dark}'m%s\e[m\n' "$OPENSSL_INC"
  printf '         LUAJIT_SRC : \e['${trgb_dark}'m%s\e[m\n' "$LUAJIT_SRC"
  printf '         LUAJIT_LIB : \e['${trgb_dark}'m%s\e[m\n' "$LUAJIT_LIB"
  printf '         LUAJIT_INC : \e['${trgb_dark}'m%s\e[m\n' "$LUAJIT_INC"
  printf '          MAKEFLAGS : \e['${trgb_dark}'m%s\e[m\n' "-j${_vcpu}"
  printf '   __OPENSSL_PARAMS : \e['${trgb_dark}'m%s\e[m\n' "${__OPENSSL_PARAMS[@]}" | tr -d "\\\'"
  printf '        __CC_PARAMS : \e['${trgb_dark}'m%s\e[m\n' "${__CC_PARAMS[@]}" | tr -d "\\\'"
  printf '        __LD_PARAMS : \e['${trgb_dark}'m%s\e[m\n\n' "${__LD_PARAMS[@]}" | tr -d "\\\'"

  printf '\e['${trgb_light}'m%s\e[m ' "(press any key to init) >>"
  read -r

  ################################# USER SPACE #################################
  # ````````````````````````````````````````````````````````````````````````````
  # Put here all your variable declarations, function calls
  # and all the other code blocks.

  _inst_base_packages
  _inst_nginx_dist

  _inst_pcre
  _inst_zlib
  _inst_openssl
  _inst_luajit
  _inst_sregex
  _inst_jemalloc

  ldconfig

  _inst_3_modules

  _build_nginx

  ldconfig

  cd "$_src" || \
  ( printf "directory not exist: %s\\n" "$_src" ; exit 1 )

  _create_user
  _gen_modules
  _init_logrotate
  _init_systemd

  _post_tasks
  _test_config

  # ````````````````````````````````````````````````````````````````````````````

  return "$_STATE"

}


# We pass arguments to the __main__ function.
# It is required if you want to run on arguments type $1, $2, ...
__main__ "${__script_params[@]}"

exit 0
