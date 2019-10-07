#!/usr/bin/env bash

# shellcheck shell=bash

# Check syntax: shellcheck -s bash -e 1072,1094,1107,2145 -x ngx_installer.conf ngx_installer.sh

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


# Console colors.
trgb_bold="1;1;38"
trgb_red="1;1;31"
trgb_red_x="0;49;91"
trgb_dark="2;2;38"
trgb_light="1;1;36"
trgb_bold_green="1;2;32"
trgb_bold_yellow="1;33;40"
trgb_bold_cyan="1;36;40"
trgb_bground_blue="1;37;44"
trgb_bground_dark="1;37;40"

trgb_task="1;30;47"

trgb_wrn="1;30;43"
trgb_err="1;37;41"

trgb_ttime="1;1;39"


# We check if we are a root user.
if [[ "$EUID" -ne 0 ]] ; then

  printf '\e['${trgb_err}'m%s\e[m\n' \
         "EUID is not equal 0 (no root user)"
  exit 1

fi

# Tasks for specific system version.
if [[ "$OSTYPE" == "linux-gnu" ]] ; then

  command -v yum > /dev/null 2>&1      && _DIST_VERSION="rhel"
  command -v apt-get > /dev/null 2>&1  && _DIST_VERSION="debian"

  # Store the name of the script and directory call.
  readonly _init_name="$(basename "$0")"
  # shellcheck disable=SC2001,SC2005
  readonly _init_directory=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")

  # shellcheck disable=SC2155
  export _vcpu=$(nproc)
  # shellcheck disable=SC2155
  export _pmem=$(awk -F":" '$1~/MemTotal/{print $2}' /proc/meminfo | tr -d ' ')
  # shellcheck disable=SC2155
  export _openssl_gcc=""

  _tput="/usr/bin/tput"

elif [[ "$OSTYPE" == *"bsd"* ]] ; then

  command -v pkg > /dev/null 2>&1      && _DIST_VERSION="bsd"

  # Store the name of the script and directory call.
  readonly _init_name="$(basename "$0")"
  # shellcheck disable=SC2001,SC2005
  readonly _init_directory=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")

  # shellcheck disable=SC2155
  export _vcpu=$(sysctl -n hw.ncpu)
  # shellcheck disable=SC2155
  export _pmem=$((($(sysctl -n hw.physmem) + 512) / 1024))kB
  # shellcheck disable=SC2155
  export _openssl_gcc=""

  pkg install -y ncurses

  _tput="/usr/local/bin/tput"

else

  printf '\e['${trgb_err}'m%s\e[m\n' \
         "Unsupported system"
  exit 1

fi


# Global variables, default values.
readonly _rel="${_init_directory}"
readonly _src="/usr/local/src"
readonly _cfg="${_rel}/ngx_installer.conf"
readonly _var="${_rel}/ngx_installer.vars"

export ngx_distr=""
export ngx_version=""
export _pcre_version=""
export _openssl_version=""

_f_tasks=(\
  "_inst_base_packages" \
  "_init_dirs" \
  "_inst_nginx_dist" \
  "_inst_pcre" \
  "_inst_zlib" \
  "_inst_openssl" \
  "_inst_luajit" \
  "_inst_sregex" \
  "_inst_jemalloc" \
  "_inst_3_modules" \
  "_build_nginx" \
  "_create_user" \
  "_gen_modules" \
  "_init_logrotate" \
  "_init_startup" \
  "_post_tasks" \
  "_test_config" \
)
_f_tasks_tmp=()

# shellcheck disable=SC1090
if [[ -e "${_cfg}" ]] ; then

  source "${_cfg}"

else

  printf '\e['${trgb_err}'m%s %s\e[m\n' \
         "Not found configuration file:" "$_cfg"
  exit 1

fi

if [[ -z "$DEBUG" ]] ; then

  DEBUG=1

else

  if [[ "$DEBUG" -ne "0" ]] && \
     [[ "$DEBUG" -ne "1" ]] ; then

    printf '\e['${trgb_err}'m%s %s %s\e[m\n' \
           "Bad 'DEBUG' param value:" "$DEBUG" "=> [0, 1]"
    exit 1

  fi

fi

if [[ -z "$LATEST_PKGS" ]] ; then

  LATEST_PKGS=0

else

  if [[ "$LATEST_PKGS" -ne "0" ]] && \
     [[ "$LATEST_PKGS" -ne "1" ]] ; then

    printf '\e['${trgb_err}'m%s %s %s\e[m\n' \
           "Bad 'LATEST_PKGS' param value:" "$LATEST_PKGS" "=> [0, 1]"
    exit 1

  fi

fi

if [[ "$PCRE_INST" != "yes" ]] ; then

  if [[ "$PCRE_INST" != "no" ]] ; then

    printf '\e['${trgb_err}'m%s %s %s\e[m\n' \
           "Bad 'PCRE_INST' param value:" "$PCRE_INST" "=> [yes, no]"
    exit 1

  fi

  PCRE_LIBRARY=""
  PCRE_DSYM=""

  for _pkg in "_inst_pcre" ; do

    _f_tasks_tmp=($_pkg)
    # shellcheck disable=SC2128
    _f_tasks=( "${_f_tasks[@]/$_f_tasks_tmp}" )

  done

fi

if [[ "$ZLIB_INST" != "yes" ]] ; then

  if [[ "$ZLIB_INST" != "no" ]] ; then

    printf '\e['${trgb_err}'m%s %s %s\e[m\n' \
           "Bad 'ZLIB_INST' param value:" "$ZLIB_INST" "=> [yes, no]"
    exit 1


  fi

  ZLIB_LIBRARY=""
  ZLIB_DSYM=""

  for _pkg in "_inst_zlib" ; do

    _f_tasks_tmp=($_pkg)
    # shellcheck disable=SC2128
    _f_tasks=( "${_f_tasks[@]/$_f_tasks_tmp}" )

  done

fi

if [[ "$OPENSSL_INST" != "yes" ]] ; then

  if [[ "$OPENSSL_INST" != "no" ]] ; then

    printf '\e['${trgb_err}'m%s %s %s\e[m\n' \
           "Bad 'OPENSSL_INST' param value:" "$OPENSSL_INST" "=> [yes, no]"
    exit 1

  fi

  OPENSSL_LIBRARY=""
  OPENSSL_DSYM=""
  OPENSSL_OPTIONS=""
  __GCC_SSL=""

  for _pkg in "_inst_openssl" ; do

    _f_tasks_tmp=($_pkg)
    # shellcheck disable=SC2128
    _f_tasks=( "${_f_tasks[@]/$_f_tasks_tmp}" )

  done

fi

if [[ "$LUAJIT_INST" != "yes" ]] ; then

  if [[ "$LUAJIT_INST" != "no" ]] ; then

    printf '\e['${trgb_err}'m%s %s %s\e[m\n' \
           "Bad 'LUAJIT_INST' param value:" "$LUAJIT_INST" "=> [yes, no]"
    exit 1

  fi

  LUAJIT_DSYM=""

  for _pkg in "_inst_luajit" ; do

    _f_tasks_tmp=($_pkg)
    # shellcheck disable=SC2128
    _f_tasks=( "${_f_tasks[@]/$_f_tasks_tmp}" )

  done

fi

if [[ "$SREGEX_INST" != "yes" ]] ; then

  if [[ "$SREGEX_INST" != "no" ]] ; then

    printf '\e['${trgb_err}'m%s %s %s\e[m\n' \
           "Bad 'SREGEX_INST' param value:" "$SREGEX_INST" "=> [yes, no]"
    exit 1

  fi

  for _pkg in "_inst_sregex" ; do

    _f_tasks_tmp=($_pkg)
    # shellcheck disable=SC2128
    _f_tasks=( "${_f_tasks[@]/$_f_tasks_tmp}" )

  done

fi

if [[ "$JEMALLOC_INST" != "yes" ]] ; then

  if [[ "$JEMALLOC_INST" != "no" ]] ; then

    printf '\e['${trgb_err}'m%s %s %s\e[m\n' \
           "Bad 'JEMALLOC_INST' param value:" "$JEMALLOC_INST" "=> [yes, no]"
    exit 1

  fi

  for _pkg in "_inst_jemalloc" ; do

    _f_tasks_tmp=($_pkg)
    # shellcheck disable=SC2128
    _f_tasks=( "${_f_tasks[@]/$_f_tasks_tmp}" )

  done

fi

# Default user and group.
if [[ -z "$NGINX_USER" ]] ; then

  NGINX_USER="nginx"

fi

if [[ -z "$NGINX_GROUP" ]] ; then

  NGINX_GROUP="nginx"

fi

if [[ -z "$NGINX_UID" ]] ; then

  NGINX_UID="920"

fi

if [[ -z "$NGINX_GID" ]] ; then

  NGINX_GID="920"

fi

if [[ -z "$NGX_PREFIX" ]] ; then

  NGX_PREFIX="/etc/nginx"

fi

if [[ -z "$NGX_CONF" ]] ; then

  NGX_CONF="${NGX_PREFIX}/nginx.conf"

fi

if [[ "$LATEST_PKGS" -eq 0 ]] ; then

  if [[ -z "$PCRE_LIBRARY" ]] && \
     [[ "$PCRE_INST" == "yes" ]] ; then

    _pcre_version="8.42"

  else

    _pcre_version="$PCRE_LIBRARY"

  fi

  if [[ -z "$OPENSSL_LIBRARY" ]] && \
     [[ "$OPENSSL_INST" == "yes" ]] ; then

    _openssl_version="1.1.1c"

  else

    _openssl_version="$OPENSSL_LIBRARY"

  fi

  if [[ -z "$ZLIB_LIBRARY" ]] && \
     [[ "$ZLIB_INST" == "yes" ]] ; then

    _zlib_str="Cloudflare fork of Zlib"
    ZLIB_LIBRARY="cloudflare"

  else

    if [[ "$ZLIB_LIBRARY" == "cloudflare" ]] ; then

      _zlib_str="Cloudflare fork of Zlib"


    elif [[ "$ZLIB_LIBRARY" == "madler" ]] ; then

      _zlib_str="Original version of Zlib"

    else

      _zlib_str=""
      ZLIB_LIBRARY=""

    fi

  fi

  if [[ -z "$LUAJIT_LIBRARY" ]] && \
     [[ "$LUAJIT_INST" == "yes" ]] ; then

    _luajit_str="OpenResty's branch of LuaJIT 2"
    LUAJIT_LIBRARY="openresty"

  else

    if [[ "$LUAJIT_LIBRARY" == "openresty" ]] ; then

      _luajit_str="OpenResty's branch of LuaJIT 2"

    elif [[ "$LUAJIT_LIBRARY" == "original" ]] ; then

      _luajit_str="Original version of LuaJIT 2"

    else

      _luajit_str=""
      LUAJIT_LIBRARY=""

    fi

  fi

  if [[ "$SREGEX_INST" == "yes" ]] ; then

    # shellcheck disable=SC2034
    _sregex_str="OpenResty's branch of sregex"

  else

    # shellcheck disable=SC2034
    _sregex_str=""

  fi

  if [[ "$JEMALLOC_INST" == "yes" ]] ; then

    # shellcheck disable=SC2034
    _jemalloc_str="Original version of jemalloc"

  else

    # shellcheck disable=SC2034
    _jemalloc_str=""

  fi

else

  if [[ "$PCRE_INST" == "yes" ]] ; then

    # shellcheck disable=SC2034
    _pcre_version=$(curl -skL https://ftp.pcre.org/pub/pcre/ |
                       grep -Eo 'pcre\-[0-9.]+[0-9]' | \
                       sort -V | \
                       tail -n 1| \
                       cut -d '-' -f2-)

  fi

  if [[ "$OPENSSL_INST" == "yes" ]] ; then

    # shellcheck disable=SC2034
    _openssl_version=$(curl -skL https://www.openssl.org/source/ |
                       grep -Eo 'openssl\-[0-9.]+[a-z]?' | \
                       sort -V | \
                       tail -n 1| \
                       cut -d '-' -f2-)

  fi

  if [[ "$ZLIB_INST" == "yes" ]] ; then

    _zlib_str="Cloudflare fork of Zlib"
    ZLIB_LIBRARY="cloudflare"

  fi

  if [[ "$LUAJIT_INST" == "yes" ]] ; then

    # shellcheck disable=SC2034
    _luajit_str="OpenResty's branch of LuaJIT 2"

  else

    # shellcheck disable=SC2034
    _luajit_str=""

  fi

fi

# shellcheck disable=SC1090
if [[ -e "${_var}" ]] ; then

  source "${_var}"

else

  printf '\e['${trgb_err}'m%s %s\e[m\n' \
         "Not found file with variables:" "$_var"
  exit 1

fi

# Global functions.
function _f() {

  local _STATE="0"

  local _cnt="$1"
  local _cmd="$2"

  _x_trgb_rbold="1;4;4;41"
  _x_trgb_gbold="1;4;4;42"

  printf '\n»»»»»»»»» \e['${trgb_bold_yellow}'m%s\e[m\n\n' "from: ${_FUNCTION_ID}() -- INIT COMMAND:"
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
            lua5.1 \
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
            jq \
            git \
            wget \
            logrotate"

  elif [[ "$_DIST_VERSION" == "rhel" ]] ; then

    _f "5" "yum install -y \
            gcc \
            gcc-c++ \
            kernel-devel \
            bison perl \
            perl-devel \
            perl-ExtUtils-Embed \
            lua \
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
            jq \
            git \
            wget \
            logrotate"

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    _f "5" "pkg install -y \
            gcc \
            gmake \
            bison \
            perl5-devel \
            pcre \
            lua51 \
            libxslt \
            libgd \
            libxml2 \
            expat \
            autoconf \
            jq \
            git \
            wget \
            logrotate"

  fi

  return "$_STATE"

}

function _init_dirs() {

  local _FUNCTION_ID="_inst_nginx_dist"
  local _STATE="0"

  if [[ "$ngx_distr" -eq 1 ]] ; then

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "1" "mkdir -p $i"

    done

  elif [[ "$ngx_distr" -eq 2 ]] ; then

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "1" "mkdir -p $i"

    done

  elif [[ "$ngx_distr" -eq 3 ]] ; then

    for i in "$_ngx_base" "$_ngx_master" "$_ngx_modules" ; do

      _f "1" "mkdir -p $i"

    done

  else

    printf '\e['${trgb_err}'m%s\e[m\n' \
           "Unsupported NGINX distribution"
    exit 1

  fi

  return "$_STATE"

}

function _inst_nginx_dist() {

  local _FUNCTION_ID="_inst_nginx_dist"
  local _STATE="0"

  if [[ "$ngx_distr" -eq 1 ]] ; then

    cd "${_ngx_base}" || \
    ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_ngx_base" ; exit 1 )

    _f "5" "wget -c --no-check-certificate https://nginx.org/download/nginx-${ngx_version}.tar.gz"

    _f "1" "tar zxvf nginx-${ngx_version}.tar.gz -C ${_ngx_master} --strip 1"

  elif [[ "$ngx_distr" -eq 2 ]] ; then

    cd "${_ngx_base}" || \
    ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_ngx_base" ; exit 1 )

    _f "5" "wget -c --no-check-certificate https://openresty.org/download/openresty-${ngx_version}.tar.gz"

    _f "1" "tar zxvf openresty-${ngx_version}.tar.gz -C ${_ngx_master} --strip 1"

  elif [[ "$ngx_distr" -eq 3 ]] ; then

    cd "${_ngx_base}" || \
    ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_ngx_base" ; exit 1 )

    _f "5" "git clone --depth 1 https://github.com/alibaba/tengine master"

  else

    printf '\e['${trgb_err}'m%s\e[m\n' \
           "Unsupported NGINX distribution"
    exit 1

  fi

  return "$_STATE"

}

function _inst_pcre() {

  local _FUNCTION_ID="_inst_pcre"
  local _STATE="0"

  cd "$_src" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_src" ; exit 1 )

  _f "5" "wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${_pcre_version}.tar.gz"

  _f "1" "tar xzvf pcre-${_pcre_version}.tar.gz"

  cd "$PCRE_SRC" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$PCRE_SRC" ; exit 1 )

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

    if [[ -n "$__PCRE_DSYM" ]] ; then

      _f "1" "CFLAGS='$__PCRE_DSYM' ./configure"

    else

      _f "1" "./configure"

    fi

    _f "1" "make -j${_vcpu}"
    _f "1" "make install"

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    if [[ -n "$__PCRE_DSYM" ]] ; then

      _f "1" "CFLAGS='$__PCRE_DSYM' ./configure"

    else

      _f "1" "./configure"

    fi

    _f "1" "make -j${_vcpu}"
    _f "1" "make install"

  fi

  _f "1" "ldconfig"

  return "$_STATE"

}

function _inst_zlib() {

  local _FUNCTION_ID="_inst_zlib"
  local _STATE="0"

  cd "$_src" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_src" ; exit 1 )

  _f "5" "git clone --depth 1 https://github.com/${ZLIB_LIBRARY}/zlib"

  cd "$ZLIB_SRC" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$ZLIB_SRC" ; exit 1 )

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

    _f "1" "./configure"

    _f "1" "make -j${_vcpu}"
    _f "1" "make install"

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    _f "1" "./configure"

    _f "1" "gmake -j${_vcpu}"
    _f "1" "gmake install"

  fi

  _f "1" "ldconfig"

  return "$_STATE"

}

function _inst_openssl() {

  local _FUNCTION_ID="_inst_openssl"
  local _STATE="0"

  cd "$_src" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_src" ; exit 1 )

  _f "5" "wget -c --no-check-certificate https://www.openssl.org/source/openssl-${_openssl_version}.tar.gz"

  _f "1" "tar xzvf openssl-${_openssl_version}.tar.gz"

  cd "$OPENSSL_SRC" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$OPENSSL_SRC" ; exit 1 )

  # shellcheck disable=SC2068,SC2207
  export __OPENSSL_PARAMS_T=( $(echo ${__OPENSSL_PARAMS[@]} | tr -d "\\\'"))

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

    _f "1" "./config --prefix=$OPENSSL_DIR --openssldir=$OPENSSL_DIR ${__OPENSSL_PARAMS_T[*]}"

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

    cat > /etc/ld.so.conf.d/openssl.conf << __EOF__
${OPENSSL_DIR}/lib
__EOF__

    echo

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    _f "1" "./config --prefix=$OPENSSL_DIR --openssldir=$OPENSSL_DIR ${__OPENSSL_PARAMS_T[*]}"

    if ! grep -q "DEFAULT_VERSIONS+=ssl=openssl" /etc/make.conf ; then

      _f "1" "echo -en DEFAULT_VERSIONS+=ssl=openssl\n >> /etc/make.conf"

    fi

    _f "1" "make -j${_vcpu}"
    _f "1" "make install"

  fi

  if [[ -e "/usr/bin/openssl" ]] ; then

    _openssl_version=$(openssl version | awk '{print $2}')
    _openssl_date=$(date '+%Y%m%d%H%M%S')
    _openssl_str="openssl-${_openssl_version}-${_openssl_date}"

    _f "1" "mv /usr/bin/openssl /usr/bin/${_openssl_str}"

    echo

    _f "1" "ln -sf ${OPENSSL_DIR}/bin/openssl /usr/bin/openssl"

    echo

  fi

  for i in libssl.so.1.1 libcrypto.so.1.1 ; do

    _f "1" "ln -sf ${ngx_src}/openssl-${openssl_version}/${i} /usr/lib/"

  done

  _f "1" "ldconfig"

  return "$_STATE"

}

function _inst_luajit() {

  local _FUNCTION_ID="_inst_luajit"
  local _STATE="0"

  cd "$_src" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_src" ; exit 1 )

  if [[ "$LUAJIT_LIBRARY" == "openresty" ]] ; then

    _f "5" "git clone --depth 1 https://github.com/openresty/luajit2 luajit2"

  else

    _f "5" "git clone http://luajit.org/git/luajit-2.0.git luajit2"

  fi

  cd "$LUAJIT_SRC" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$LUAJIT_SRC" ; exit 1 )

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

    if [[ -n "$__LUAJIT_DSYM" ]] ; then

      _f "1" "CFLAGS='-g' make"

    else

      _f "1" "make"

    fi

    _f "1" "make install"

    for i in libluajit-5.1.so libluajit-5.1.so.2 liblua.so libluajit.so ; do

      if [[ "$LUAJIT_LIBRARY" == "openresty" ]] ; then

        _f "1" "ln -sf /usr/local/lib/libluajit-5.1.so.2.1.0 ${LUAJIT_LIB}/${i}"

      elif [[ "$LUAJIT_LIBRARY" == "original" ]] ; then

        _f "1" "ln -sf /usr/local/lib/libluajit-5.1.so.2.0.5 ${LUAJIT_LIB}/${i}"

      fi

    done

    # _f "1" "ln -sf /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 ${LUAJIT_LIB}/liblua.so"

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    # cd "/usr/ports/lang/luajit" || \
    cd "$LUAJIT_SRC" || \
    ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$LUAJIT_SRC" ; exit 1 )

    # _f "1" "make deinstall"

    if [[ -n "$__LUAJIT_DSYM" ]] ; then

      _f "1" "CFLAGS='$__LUAJIT_DSYM' gmake"

    else

      _f "1" "gmake"

    fi

    _f "1" "gmake install"

    # On FreeBSD you should set them manually or use the following instructions:
    for i in libluajit-5.1.so libluajit-5.1.so.2 ; do

      if [[ "$LUAJIT_LIBRARY" == "openresty" ]] ; then

        _f "1" "ln -sf /usr/local/lib/libluajit-5.1.so.2.1.0 ${LUAJIT_LIB}/${i}"

      elif [[ "$LUAJIT_LIBRARY" == "original" ]] ; then

        _f "1" "ln -sf /usr/local/lib/libluajit-5.1.so.2.0.5 ${LUAJIT_LIB}/${i}"

      fi

    done

  fi

  _f "1" "ldconfig"

  return "$_STATE"

}

function _inst_sregex() {

  local _FUNCTION_ID="_inst_sregex"
  local _STATE="0"

  cd "$_src" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_src" ; exit 1 )

  _f "5" "git clone --depth 1 https://github.com/openresty/sregex"

  cd "${_src}/sregex" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "${_src}/sregex" ; exit 1 )

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

    _f "1" "make"
    _f "1" "make install"

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    _f "1" "gmake"
    _f "1" "gmake install"

  fi

  _f "1" "ldconfig"

  return "$_STATE"

}

function _inst_jemalloc() {

  local _FUNCTION_ID="_inst_jemalloc"
  local _STATE="0"

  cd "$_src" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_src" ; exit 1 )

  export JEMALLOC_SRC="${_src}/jemalloc"

  _f "5" "git clone --depth 1 https://github.com/jemalloc/jemalloc"

  cd "$JEMALLOC_SRC" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$JEMALLOC_SRC" ; exit 1 )

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

    _f "1" "./autogen.sh"

    _f "1" "make"
    _f "1" "make install"

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    _f "1" "./autogen.sh"

    _f "1" "gmake"
    _f "1" "gmake install"

  fi

  _f "1" "ldconfig"

  return "$_STATE"

}

function _inst_3_modules() {

  local _FUNCTION_ID="_inst_3_modules"
  local _STATE="0"

  cd "$_ngx_modules" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_ngx_modules" ; exit 1 )

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
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "${_ngx_modules}/ngx_brotli" ; exit 1 )

  _f "1" "git submodule update --init"

  cd "$_ngx_modules" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_ngx_modules" ; exit 1 )

  _f "5" "git clone --depth 1 https://github.com/alibaba/tengine"

  _f "5" "git clone --depth 1 https://github.com/nbs-system/naxsi"

  return "$_STATE"

}

function _build_nginx() {

  local _FUNCTION_ID="_build_nginx"
  local _STATE="0"

  cd "${_ngx_master}" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_ngx_master" ; exit 1 )

  if [[ "$_ngx_distr" -eq 1 ]] ; then

    _f "1" "./configure \
            ${__BUILD_PARAMS[@]} \
            --with-openssl-opt=${__OPENSSL_PARAMS[@]} \
            --with-cc-opt=${__CC_PARAMS[@]} \
            --with-ld-opt=${__LD_PARAMS[@]}"

  elif [[ "$_ngx_distr" -eq 2 ]] ; then

    _f "1" "./configure \
            ${__BUILD_PARAMS[@]} \
            --with-openssl-opt=${__OPENSSL_PARAMS[@]} \
            --with-cc-opt=${__CC_PARAMS[@]} \
            --with-ld-opt=${__LD_PARAMS[@]}"

  elif [[ "$_ngx_distr" -eq 3 ]] ; then

    _f "1" "./configure \
            ${__BUILD_PARAMS[@]} \
            --with-openssl-opt=${__OPENSSL_PARAMS[@]} \
            --with-cc-opt=${__CC_PARAMS[@]} \
            --with-ld-opt=${__LD_PARAMS[@]}"

  fi

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

    _f "1" "make -j${_vcpu}"
    _f "1" "make install"

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    _f "1" "gmake -j${_vcpu}"
    _f "1" "gmake install"

  fi

  _f "1" "ldconfig"

  return "$_STATE"

}

function _create_user() {

  local _FUNCTION_ID="_create_user"
  local _STATE="0"

  cd "$_src" || \
  ( printf '\e['${trgb_err}'m%s %s\e[m\n' "directory not exist:" "$_src" ; _exit_ 1 )

  id nginx >/dev/null 2>&1 ; _id_state="$?"

  if [[ "$_id_state" -ne 0 ]] ; then

    if [[ "$_DIST_VERSION" == "debian" ]] ; then

      if ! grep -q $NGINX_GROUP /etc/group ; then

        _f "1" "groupadd -r -g $NGINX_GID $NGINX_GROUP"

      fi

      _f "1" "adduser --system --home /non-existent --no-create-home --shell /usr/sbin/nologin --disabled-login --disabled-password --gecos \'nginx user\' --uid $NGINX_UID --group $NGINX_GROUP $NGINX_USER"

    elif [[ "$_DIST_VERSION" == "rhel" ]] ; then

      if ! grep -q $NGINX_GROUP /etc/group ; then

        _f "1" "groupadd -r -g $NGINX_GID $NGINX_GROUP"

      fi

      _f "1" "useradd --system --home-dir /non-existent --no-create-home --shell /usr/sbin/nologin --comment \'nginx user\' --uid $NGINX_UID --gid $NGINX_GROUP $NGINX_USER"

      _f "1" "passwd -l $NGINX_USER"

    elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

      if ! grep -q $NGINX_GROUP /etc/group ; then

        _f "1" "pw group add $NGINX_GROUP -g $NGINX_GID"

      fi

      _f "1" "pw user add -d /non-existent -n $NGINX_USER -u $NGINX_UID -g $NGINX_GROUP -s /usr/sbin/nologin -c \'nginx user\' -w no"

    fi

  else

    _f "1" "false"

  fi

  return "$_STATE"

}

function _gen_modules() {

  local _FUNCTION_ID="_gen_modules"
  local _STATE="0"

  _f "1" "true"

  _mod_dir="${NGX_PREFIX}/modules"

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

  _f "1" "true"

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

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

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    _logrotate_path="/etc/newsyslog.conf.d"

    cat > "${_logrotate_path}/nginx.conf" << __EOF__
/var/log/access.log               644  7     1024 *     JC /var/run/nginx.pid
/var/log/error.log                644  7     1024 *     JC /var/run/nginx.pid
__EOF__

  fi

  return "$_STATE"

}

function _init_startup() {

  local _FUNCTION_ID="_init_startup"
  local _STATE="0"

  if [[ "$OSTYPE" == "linux-gnu" ]] ; then

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

  elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

    if ! grep -q nginx_enable=\"YES\" /etc/rc.conf ; then

      echo -en "nginx_enable=\"YES\"\\n" >> /etc/rc.conf

    fi

  fi

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
    _f "1" "chown -R ${NGINX_USER}:${NGINX_GROUP} $i"

  done

  return "$_STATE"

}

function _test_config() {

  local _FUNCTION_ID="_test_config"
  local _STATE="0"

  echo

  _f "1" "nginx -V"

  echo

  _f "1" "nginx -t -c $NGX_CONF"

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
  $_tput cup "$_t_rst" "$_c_rst"

  printf "\\e[${_t_bar}m%s\\e[m" \
         "┌─────────────────────────────────────────────────────────────────┐"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  $_tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"
  $_tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  $_tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  printf "%s\\e[1;31m%s\\e[m \\e[2;32m%s\\e[m \\e[1;37m%s\\e[m" \
         "          " \
         "Φ"  \
         "ngx_installer.sh" \
         "(NGINX/OpenResty/Tengine)"

  $_tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  $_tput cup "$_t_rst" "$_c_rst"; printf "\\e[${_t_bar}m%s\\e[m" "│"
  $_tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  $_tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  printf "%s\\e[1;37m%s\\e[m \\e[2;37m%s\\e[m" \
         "   " \
         "Project:"  \
         "https://github.com/trimstray/nginx-admins-handbook"

  $_tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  $_tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"
  $_tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  $_tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  printf "%s\\e[0;36m%s\\e[m" \
         "           " \
         "Debian · Ubuntu · RHEL · CentOS · FreeBSD"

  $_tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  $_tput cup "$_t_rst" "$_c_rst" ; printf "\\e[${_t_bar}m%s\\e[m" "│"
  $_tput cup "$_t_rst" $((_t_sst + _c_rst)) ; printf "\\e[${_t_bar}m%s\\e[m" "│"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 1))
  $_tput cup "$_t_rst" "$_c_rst" ;

  printf "\\e[${_t_bar}m%s\\e[m" \
         "└─────────────────────────────────────────────────────────────────┘"

  # ----------------------------------------------------------------------------

  _t_rst=$((_t_rst + 2))
  $_tput cup "$_t_rst" "$_c_rst"

  printf '\n  \e['${trgb_bold_cyan}'m%s\e[m\n' "Press CTRL + C to terminate the autoinstaller."

  printf '\n  \e['${trgb_bold_yellow}'m%s\e[m\n' "Please set correct date, time/NTP, and timezone before starting."

  printf '\n  \e['${trgb_bground_blue}'m %s \e[m\n\n' "Set NGINX flavour"

  printf '  \e['${trgb_bground_dark}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "1" "NGINX" "https://www.nginx.com/"
  printf '  \e['${trgb_bground_dark}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "2" "OpenResty" "https://openresty.org/"
  printf '  \e['${trgb_bground_dark}'m %s \e[m - \e['${trgb_bold}'m%s\e[m (\e['${trgb_dark}'m%s\e[m)\n' "3" "The Tengine Web Server" "https://tengine.taobao.org/"

  printf '  \n\e['${trgb_light}'m%s\e[m ' ">>"
  read -r ngx_distr

  _ngx_distr=$(echo "$ngx_distr" | tr -d '[:alpha:]' | cut -c1)

  if [[ -z "$_ngx_distr" ]] ; then

    printf '\n\e['${trgb_err}'m%s\e[m\n\n' "incorrect value => [1-3]"
    exit 1

  else

    if [[ "$_ngx_distr" -ne 1 ]] && \
       [[ "$_ngx_distr" -ne 2 ]] && \
       [[ "$_ngx_distr" -ne 3 ]] ; then

      printf '\n\e['${trgb_err}'m%s\e[m\n\n' "incorrect value => [1-3]"
      exit 1

    fi

  fi

  printf '\n  \e['${trgb_bground_blue}'m %s \e[m\n\n' "Set version of source package"

  if [[ "$LATEST_PKGS" -eq 0 ]] ; then

    if [[ "$_ngx_distr" -eq 1 ]] ; then

      printf '  Default for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "NGINX" "$NGINX_DEF_VER"
      printf '   - for more please see: \e['${trgb_dark}'m%s\e[m\n' "https://nginx.org/download"
      printf '   - examples of versions: \e['${trgb_dark}'m%s\e[m\n' "1.17.4, 1.16.0, 1.15.8, 1.15.2, 1.14.0, 1.13.5"
      printf '   - %s\n' "press any key to set default"

      _ngx_distr_str="NGINX"

    elif [[ "$_ngx_distr" -eq 2 ]] ; then

      printf '  Default for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "OpenResty" "$OPENRESTY_DEF_VER"
      printf '   - for more please see: \e['${trgb_dark}'m%s\e[m\n' "https://openresty.org/download"
      printf '   - examples of versions: \e['${trgb_dark}'m%s\e[m\n' "1.15.8.2, 1.15.8.1, 1.13.6.2, 1.13.6.1, 1.11.2.4"
      printf '   - %s\n' "press any key to set default"

      _ngx_distr_str="OpenResty"

    elif [[ "$_ngx_distr" -eq 3 ]] ; then

      printf '  Default for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "Tengine" "$TENGINE_DEF_VER"
      printf '   - for more please see: \e['${trgb_dark}'m%s\e[m\n' "https://tengine.taobao.org/download.html"
      printf '   - examples of versions: \e['${trgb_dark}'m%s\e[m\n' "2.3.2, 2.3.0, 2.2.3, 2.2.0, 2.1.2, 2.0.1"
      printf '   - %s\n' "press any key to set default"

      _ngx_distr_str="Tengine"

    fi

    printf '  \n\e['${trgb_light}'m%s\e[m ' ">>"
    read -r ngx_version

  else

    if [[ "$_ngx_distr" -eq 1 ]] ; then

      ngx_version=$(timeout 15 curl -ksL https://nginx.org/download/ | \
                    grep -Eo 'nginx\-[0-9.]+[123456789]\.[0-9]+' | \
                    sort -V | \
                    tail -n 1 | \
                    cut -d '-' -f2-)

      _ngx_distr_str="NGINX"

    elif [[ "$_ngx_distr" -eq 2 ]] ; then

      ngx_version=$(timeout 15 curl -ksL https://openresty.org/en/download.html | \
                    grep -Eo 'openresty\-[0-9.]+[123456789]\.[0-9]+\.[0-9]+' | \
                    sort -V | \
                    tail -n 1 | \
                    cut -d '-' -f2-)

      _ngx_distr_str="OpenResty"

    elif [[ "$_ngx_distr" -eq 3 ]] ; then

      ngx_version=$(timeout 15 curl -ksL https://tengine.taobao.org/download.html | \
                    grep -Eo 'Tengine\-[0-9.]+[123456789]\.[0-9]+' | \
                    sort -V | \
                    tail -n 1 | \
                    cut -d '-' -f2-)

      _ngx_distr_str="Tengine"

    fi

    printf '  Latest for \e['${trgb_bold}'m%s\e[m: \e['${trgb_bold_green}'m%s\e[m\n' "$_ngx_distr_str" "$ngx_version"

  fi

  if [[ "$_ngx_distr" -eq 1 ]] ; then

    if [[ -z "$ngx_version" ]] ; then

      if [[ -z "$NGINX_DEF_VER" ]] ; then

        ngx_version="1.16.0"

      else

        ngx_version="$NGINX_DEF_VER"

      fi

    fi

    _ngx_src="/usr/local/src"
    _ngx_base="${_ngx_src}/nginx-${ngx_version}"
    _ngx_master="${_ngx_base}/master"
    _ngx_modules="${_ngx_base}/modules"

    if [[ -z "$OPENSSL_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # OPENSSL_OPTIONS="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong"
      OPENSSL_OPTIONS=""

    fi

    if [[ -z "$NGINX_COMPILER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # NGINX_COMPILER_OPTIONS="-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf"
      NGINX_COMPILER_OPTIONS=""

    fi

    COMPILER_OPTIONS="$NGINX_COMPILER_OPTIONS"

    if [[ -z "$NGINX_LINKER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # NGINX_LINKER_OPTIONS="-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib"
      NGINX_LINKER_OPTIONS=""

    fi

    LINKER_OPTIONS="$NGINX_LINKER_OPTIONS"

    if [[ "$OSTYPE" == "linux-gnu" ]] ; then

      # shellcheck disable=SC2068
      __BUILD_PARAMS=$(eval echo ${NGINX_BUILD_PARAMS[@]})

    elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

      # Add/remove modules:
      for _mod in "--with-http_geoip_module" \
                  "--with-google_perftools_module" \
                  "--add-module=\${_ngx_modules}/tengine/modules/ngx_backtrace_module" ; do

        NGINX_BUILD_PARAMS_HELPER=($_mod)
        # shellcheck disable=SC2128
        NGINX_BUILD_PARAMS=( "${NGINX_BUILD_PARAMS[@]/$NGINX_BUILD_PARAMS_HELPER}" )

        # shellcheck disable=SC2068
        __BUILD_PARAMS=$(eval echo ${NGINX_BUILD_PARAMS[@]})

      done

    fi

  elif [[ "$_ngx_distr" -eq 2 ]] ; then

    if [[ -z "$ngx_version" ]] ; then

      if [[ -z "$OPENRESTY_DEF_VER" ]] ; then

        ngx_version="1.15.8.1"

      else

        ngx_version="$OPENRESTY_DEF_VER"

      fi

    fi

    _ngx_src="/usr/local/src"
    _ngx_base="${_ngx_src}/openresty-${ngx_version}"
    _ngx_master="${_ngx_base}/master"
    _ngx_modules="${_ngx_base}/modules"

    if [[ -z "$OPENSSL_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # OPENSSL_OPTIONS="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong"
      OPENSSL_OPTIONS=""

    fi

    if [[ -z "$OPENRESTY_COMPILER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # OPENRESTY_COMPILER_OPTIONS="-I/usr/local/include -m64 -march=native -DTCP_FASTOPEN=23 -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -gsplit-dwarf"
      OPENRESTY_COMPILER_OPTIONS=""

    fi

    COMPILER_OPTIONS="$OPENRESTY_COMPILER_OPTIONS"

    if [[ -z "$OPENRESTY_LINKER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # OPENRESTY_LINKER_OPTIONS="-L/usr/local/lib -ljemalloc -Wl,-lpcre -Wl,-z,relro -Wl,-rpath,/usr/local/lib"
      OPENRESTY_LINKER_OPTIONS=""

    fi

    LINKER_OPTIONS="$OPENRESTY_LINKER_OPTIONS"

    if [[ "$OSTYPE" == "linux-gnu" ]] ; then

      # shellcheck disable=SC2068
      __BUILD_PARAMS=$(eval echo ${OPENRESTY_BUILD_PARAMS[@]})

    elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

      # Add/remove modules:
      for _mod in "--with-stream_geoip_module" \
                  "--with-http_geoip_module" \
                  "--with-google_perftools_module" \
                  "--add-module=\${_ngx_modules}/tengine/modules/ngx_backtrace_module" ; do

        OPENRESTY_BUILD_PARAMS_HELPER=($_mod)
        # shellcheck disable=SC2128
        OPENRESTY_BUILD_PARAMS=( "${OPENRESTY_BUILD_PARAMS[@]/$OPENRESTY_BUILD_PARAMS_HELPER}" )

        # shellcheck disable=SC2068
        __BUILD_PARAMS=$(eval echo ${OPENRESTY_BUILD_PARAMS[@]})

      done

    fi

  elif [[ "$_ngx_distr" -eq 3 ]] ; then

    if [[ -z "$ngx_version" ]] ; then

      if [[ -z "$TENGINE_DEF_VER" ]] ; then

        ngx_version="2.3.0"

      else

        ngx_version="$TENGINE_DEF_VER"

      fi

    fi

    _ngx_src="/usr/local/src"
    _ngx_base="${_ngx_src}/tengine-${ngx_version}"
    _ngx_master="${_ngx_base}/master"
    _ngx_modules="${_ngx_base}/modules"

    if [[ -z "$OPENSSL_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # OPENSSL_OPTIONS="shared zlib no-ssl3 no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong"
      OPENSSL_OPTIONS=""

    fi

    if [[ -z "$TENGINE_COMPILER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # TENGINE_COMPILER_OPTIONS="-I/usr/local/include -I${OPENSSL_INC} -I${LUAJIT_INC} -I${JEMALLOC_SRC} -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC"
      TENGINE_COMPILER_OPTIONS=""

    fi

    COMPILER_OPTIONS="$TENGINE_COMPILER_OPTIONS"

    if [[ -z "$TENGINE_LINKER_OPTIONS" ]] ; then

      # shellcheck disable=SC2178
      # TENGINE_LINKER_OPTIONS="-Wl,-E -L/usr/local/lib -ljemalloc -lpcre -Wl,-rpath,/usr/local/lib/,-z,relro -Wl,-z,now -pie"
      TENGINE_LINKER_OPTIONS=""

    fi

    LINKER_OPTIONS="$TENGINE_LINKER_OPTIONS"

    if [[ "$OSTYPE" == "linux-gnu" ]] ; then

      # shellcheck disable=SC2068
      __BUILD_PARAMS=$(eval echo ${TENGINE_BUILD_PARAMS[@]})

    elif [[ "$_DIST_VERSION" == "bsd" ]] ; then

      # Add/remove modules:
      for _mod in "--with-stream_geoip_module" \
                  "--with-http_geoip_module" \
                  "--with-google_perftools_module" \
                  "--add-module=\${_ngx_master}/modules/ngx_backtrace_module" ; do

        TENGINE_BUILD_PARAMS_HELPER=($_mod)
        # shellcheck disable=SC2128
        TENGINE_BUILD_PARAMS=( "${TENGINE_BUILD_PARAMS[@]/$TENGINE_BUILD_PARAMS_HELPER}" )

        # shellcheck disable=SC2068
        __BUILD_PARAMS=$(eval echo ${TENGINE_BUILD_PARAMS[@]})

      done

    fi

  fi

  if [[ -z "$LUAJIT_INC" ]] ; then

    if [[ "$LUAJIT_LIBRARY" == "openresty" ]] ; then

      export LUAJIT_INC="/usr/local/include/luajit-2.1"

    elif [[ "$LUAJIT_LIBRARY" == "original" ]] ; then

      export LUAJIT_INC="/usr/local/include/luajit-2.0"

    fi

  fi

  # shellcheck disable=SC2153
  __ZLIB_DSYM="$ZLIB_DSYM"
  # shellcheck disable=SC2153
  __PCRE_DSYM="$PCRE_DSYM"
  # shellcheck disable=SC2153
  __LUAJIT_DSYM="$LUAJIT_DSYM"
  # shellcheck disable=SC2153
  __OPENSSL_DSYM="$OPENSSL_DSYM"
  # shellcheck disable=SC2153
  __NGINX_DSYM="$NGINX_DSYM"

  if [[ -n "$OPENSSL_OPTIONS" ]] ; then

    if [[ -n "$__OPENSSL_DSYM" ]] ; then

      OPENSSL_OPTIONS="${OPENSSL_OPTIONS} ${__OPENSSL_DSYM}"

    else

      OPENSSL_OPTIONS="${OPENSSL_OPTIONS}"

    fi

  else

    if [[ -n "$__OPENSSL_DSYM" ]] ; then

      # OPENSSL_OPTIONS="${__OPENSSL_DSYM}"
      OPENSSL_OPTIONS=""

    else

      OPENSSL_OPTIONS=""

    fi

  fi

  # shellcheck disable=SC2178
  export __OPENSSL_PARAMS=("\'${OPENSSL_OPTIONS}\'")

  if [[ "${#__GCC_SSL[@]}" -ne 0 ]] ; then

    if [[ "$OSTYPE" == "linux-gnu" ]] ; then

      # shellcheck disable=SC2178
      __OPENSSL_PARAMS=("\'${OPENSSL_OPTIONS} ${_openssl_gcc}\'")

    fi

  fi

  if [[ -n "$COMPILER_OPTIONS" ]] ; then

    if [[ -n "$__NGINX_DSYM" ]] ; then

      COMPILER_OPTIONS="${COMPILER_OPTIONS} ${__NGINX_DSYM}"

    else

      COMPILER_OPTIONS="${COMPILER_OPTIONS}"

    fi

  else

    if [[ -n "$__NGINX_DSYM" ]] ; then

      COMPILER_OPTIONS=""

    else

      COMPILER_OPTIONS=""

    fi

  fi

  # shellcheck disable=SC2178
  export __CC_PARAMS=("\'${COMPILER_OPTIONS}\'")
  # shellcheck disable=SC2178
  export __LD_PARAMS=("\'${LINKER_OPTIONS}\'")

  printf "%s" ""

  printf '\n             \e['${trgb_bold}'m%s\e[m\n' "SYSTEM"
  printf '            os type : \e['${trgb_dark}'m%s\e[m\n' "$OSTYPE"
  printf '       distribution : \e['${trgb_dark}'m%s\e[m\n' "${_DIST_VERSION} like"
  printf '         vcpu cores : \e['${trgb_dark}'m%s\e[m\n' "$_vcpu"
  printf '       total memory : \e['${trgb_dark}'m%s\e[m\n' "$_pmem"

  printf '\n              \e['${trgb_bold}'m%s\e[m\n' "PATHS"
  printf '        config file : \e['${trgb_dark}'m%s\e[m\n' "$_cfg"
  printf '          vars file : \e['${trgb_dark}'m%s\e[m\n' "$_var"
  printf '     init directory : \e['${trgb_dark}'m%s\e[m\n' "$_init_directory"
  printf '   source directory : \e['${trgb_dark}'m%s\e[m\n' "$_src"
  printf '    nginx directory : \e['${trgb_dark}'m%s\e[m\n' "$_ngx_master"
  printf '  modules directory : \e['${trgb_dark}'m%s\e[m\n' "$_ngx_modules"

  printf '\n           \e['${trgb_bold}'m%s\e[m\n' "PACKAGES"
  printf '    package version : \e['${trgb_dark}'m%s, %s\e[m\n' "$_ngx_distr_str" "$ngx_version"
  printf '       pcre version : \e['${trgb_dark}'m%s\e[m\n' "$_pcre_version"
  printf '    openssl version : \e['${trgb_dark}'m%s\e[m\n' "$_openssl_version"
  printf '       zlib version : \e['${trgb_dark}'m%s\e[m\n' "$_zlib_str"
  printf '     luajit version : \e['${trgb_dark}'m%s\e[m\n' "$_luajit_str"
  printf '     sregex version : \e['${trgb_dark}'m%s\e[m\n' "$_sregex_str"
  printf '   jemalloc version : \e['${trgb_dark}'m%s\e[m\n' "$_jemalloc_str"

  printf '\n          \e['${trgb_bold}'m%s\e[m\n' "LIBRARIES"
  printf '        pcre enable : \e['${trgb_dark}'m%s\e[m\n' "$PCRE_INST"
  printf '        zlib enable : \e['${trgb_dark}'m%s\e[m\n' "$ZLIB_INST"
  printf '     openssl enable : \e['${trgb_dark}'m%s\e[m\n' "$OPENSSL_INST"
  printf '      luajit enable : \e['${trgb_dark}'m%s\e[m\n' "$LUAJIT_INST"
  printf '      sregex enable : \e['${trgb_dark}'m%s\e[m\n' "$SREGEX_INST"
  printf '    jemalloc enable : \e['${trgb_dark}'m%s\e[m\n' "$JEMALLOC_INST"
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

  printf '\n  \e['${trgb_bold}'m%s\e[m\n' "COMPILER & LINKER"
  printf '          MAKEFLAGS : \e['${trgb_dark}'m%s\e[m\n' "-j${_vcpu}"
  printf '       __NGINX_DSYM : \e['${trgb_dark}'m%s\e[m\n' "${__NGINX_DSYM}"
  printf '     __OPENSSL_DSYM : \e['${trgb_dark}'m%s\e[m\n' "${__OPENSSL_DSYM}"
  printf '        __PCRE_DSYM : \e['${trgb_dark}'m%s\e[m\n' "${__PCRE_DSYM}"
  printf '        __ZLIB_DSYM : \e['${trgb_dark}'m%s\e[m\n' "${__ZLIB_DSYM}"
  printf '      __LUAJIT_DSYM : \e['${trgb_dark}'m%s\e[m\n' "${__LUAJIT_DSYM}"
  printf '   __OPENSSL_PARAMS : \e['${trgb_dark}'m%s\e[m\n' "${__OPENSSL_PARAMS[@]}" | tr -d "\\\'"
  printf '        __CC_PARAMS : \e['${trgb_dark}'m%s\e[m\n' "${__CC_PARAMS[@]}" | tr -d "\\\'"
  printf '        __LD_PARAMS : \e['${trgb_dark}'m%s\e[m\n' "${__LD_PARAMS[@]}" | tr -d "\\\'"
  printf '     __BUILD_PARAMS : \e['${trgb_dark}'m%s\e[m\n\n' "${__BUILD_PARAMS[@]}"

  printf '\e['${trgb_bold_yellow}'m%s\e[m\n\e['${trgb_bold_yellow}'m%s\e[m\n\n' \
         "You should set the correct values of variables for disabled packages." \
         "For this, please check 'LIBRARIES' summary and lib/ngx_installer.vars file."

  printf '\e['${trgb_light}'m%s\e[m ' "(press any key to init) >>"
  read -r

  ################################# USER SPACE #################################
  # ````````````````````````````````````````````````````````````````````````````
  # Put here all your variable declarations, function calls
  # and all the other code blocks.

  if [[ "$NGX_PROMPT" -eq 0 ]] ; then

    _begtime=$(date +%s)

  fi

  local _iter="1"

  # for _i in "${_f_tasks[@]:${_TASK_EXIT}}" ; do
  for _i in "${_f_tasks[@]}" ; do

    # _key_id=$(echo "$_i" | awk -v FS="(:|:)" '{print $1}')
    # _key_task=$(echo "$_i" | awk -v FS="(:|:)" '{print $2}')
    _key_task="$_i"

    printf '\n\e['${trgb_task}'m%s %s\e[m\n' "TASK" "{ id:${_iter}, function:${_key_task} }"

    $_key_task

    _iter=$((_iter + 1))

  done

  _f "1" "ldconfig"

  if [[ "$NGX_PROMPT" -eq 0 ]] ; then

    # Counting the execution time.
    _endtime=$(date +%s)
    _totaltime=$((_endtime - _begtime))

    # Print time header.
    printf '\n\e[m\e['${trgb_ttime}'mTOTAL EXECUTION TIME: %dh:%dm:%ds\e[m\n\n' \
            $((_totaltime/3600)) $((_totaltime%3600/60)) $((_totaltime%60))

  fi

  # ````````````````````````````````````````````````````````````````````````````

  return "$_STATE"

}


# We pass arguments to the __main__ function.
# It is required if you want to run on arguments type $1, $2, ...
__main__ "${__script_params[@]}"

exit 0
