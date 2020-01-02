#!/usr/bin/env bash

# The array that store call parameters.
# shellcheck disable=SC2034
__init_params=()
__script_params=("$@")

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

  _ngx_root="/etc/nginx"
  _ngx_conf="/etc/nginx/nginx.conf"

elif [[ "$OSTYPE" == *"bsd"* ]] ; then

  command -v pkg > /dev/null 2>&1      && _DIST_VERSION="bsd"

  # Store the name of the script and directory call.
  readonly _init_name="$(basename "$0")"
  # shellcheck disable=SC2001,SC2005
  readonly _init_directory=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")

  _ngx_root="/usr/local/etc/nginx"
  _ngx_conf="/usr/local/etc/nginx/nginx.conf"

else

  printf '\e['${trgb_err}'m%s\e[m\n' \
         "Unsupported system"
  exit 1

fi

# Set root directory.
readonly _rel="${_init_directory}"

# Directory structure.
# shellcheck disable=SC2154
readonly _dump="/var/dump/nginx"
readonly _dump_fd="${_dump}/nginx.conf.dump"

domain="$1"
config="$2"

if [[ -z "$domain" ]] ; then

  printf "WARNING: Please set domain name.\\n"

  exit 1

fi

if [[ -z "$config" ]] ; then

  printf "%s\\n" \
         "Searching '$domain' in '$_ngx_root' (from disk)"

  # _stdout=$(fgrep "$domain" "$_ngx_root"/* -R | tr -s '[:space:]' | sed 's/:/ -->/g')
  _stdout=$(fgrep -n "$domain" "$_ngx_root"/* -R | tr -s '[:space:]')

  if [[ -n "$_stdout" ]] ; then

    printf "\\n%s\\n\\n" "$_stdout"

  fi

  printf "%s\\n\\n" "Searching '$domain' in server contexts (from a running process)"

  nginx -T -q -c "$_ngx_conf" > "$_dump_fd"

  ${_rel}/server-name-parser.py "$_dump_fd" "$domain"

else

  printf "%s\\n" \
         "Searching '$domain' in '$_ngx_root' (from disk)"

  # _stdout=$(fgrep "$domain" "$_ngx_root"/* -R | tr -s '[:space:]' | sed 's/:/ -->/g')
  _stdout=$(fgrep -n "$domain" "$_ngx_root"/* -R | tr -s '[:space:]')

  if [[ -n "$_stdout" ]] ; then

    printf "\\n%s\\n\\n" "$_stdout"

  fi

  printf "%s\\n\\n" "Searching '$domain' in server contexts (from a running process)"

  ${_rel}/server-name-parser.py "$config" "$domain"

fi

if [[ -e "$_dump_fd" ]] ; then

  rm -fr "$_dump_fd"

fi
