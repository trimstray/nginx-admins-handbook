### GNU/LINUX
alias ng.status systemctl status nginx
alias ng.reload systemctl reload nginx
alias ng.restart systemctl restart nginx
alias ng.test '/usr/sbin/nginx -t -c /etc/nginx/nginx.conf'
alias ng.dump '/usr/sbin/nginx -T -c /etc/nginx/nginx.conf'

alias CD_NGX_ROOT 'cd /etc/nginx && ls -lh'
alias CD_NGX_LOGS 'cd /var/log/nginx && ls -lh'
alias CD_NGX_ACME 'cd /var/www/acme/.well-known/acme-challenge && ls -lh'

### BSD
alias ng.status /usr/local/etc/rc.d/nginx status
alias ng.reload /usr/local/etc/rc.d/nginx reload
alias ng.restart /usr/local/etc/rc.d/nginx restart
alias ng.test '/usr/local/sbin/nginx -t -c /usr/local/etc/nginx/nginx.conf'
alias ng.dump '/usr/local/sbin/nginx -T -c /usr/local/etc/nginx/nginx.conf'

alias CD_NGX_ROOT 'cd /usr/local/etc/nginx && ls -lh'
alias CD_NGX_LOGS 'cd /var/log/nginx && ls -lh'
alias CD_NGX_ACME 'cd /var/www/acme/.well-known/acme-challenge && ls -lh'

### GIT
alias git.log 'git log --oneline --decorate --graph --all'
alias git.commit 'git add . && git commit -m "uncommited changes"'
alias git.sync 'git pull origin master && git fetch --all && git fetch --prune --tags'
alias git.push 'git push origin master && git push origin --tags --force'
alias git.force 'git push origin master --force && git push origin --tags --force'
alias git.remote 'git remote update && git status -uno && git show-branch *master'
alias git.reset 'git add . && git reset --hard HEAD'

### OTHER
alias http.server 'python3 -m http.server 8080 --bind 127.0.0.1'
