#!/usr/bin/env bash

_repo="/usr/local/etc/nginx"
_rcpt=""

cd "$_repo" || exit 1

# _untracked_files=$(git ls-files --others --exclude-standard)
_untracked_files=$(git -c color.status=false status --untracked-files=all --short)

if [[ -z "$_untracked_files" ]] ; then

  printf "%s\\n" "Not found untracked_files"

else

  _untracked_msg=$(echo "$_untracked_files" | awk '{print "   " $0}')

  _msg="
Found untracked files inside /usr/local/etc/nginx directory:

$_untracked_msg

To resolve:

 > git add .
 > git commit -m \"short message or task ID\"
 > git push origin master

Last time user logged:

$(last | head -n 10 | column -t)
"

  if [[ -n "$_rcpt" ]] ; then

    printf "%s" "$_msg" | mail -s "!!! NGINX CONFIG UNTRACKED FILES !!!" "$_rcpt"

  fi

fi
