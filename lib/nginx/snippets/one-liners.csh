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
