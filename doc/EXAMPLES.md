# Configuration Examples

Go back to the **[⬆ Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[⬆ What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

- **[≡ Configuration Examples](#examples)**
  * [Reverse Proxy](#reverse-proxy)
    * [Installation](#installation)
    * [Configuration](#configuration)
    * [Import configuration](#import-configuration)
    * [Set bind IP address](#set-bind-ip-address)
    * [Set your domain name](#set-your-domain-name)
    * [Regenerate private keys and certs](#regenerate-private-keys-and-certs)
    * [Update modules list](#update-modules-list)
    * [Generating the necessary error pages](#generating-the-necessary-error-pages)
    * [Add new domain](#add-new-domain)
    * [Test your configuration](#test-your-configuration)

  > Remember to make a copy of the current configuration and all files/directories.

This chapter is still work in progress.

## Installation

I used step-by-step tutorial from this handbook [Installing from source](HELPERS.md#installing-from-source).

## Configuration

I used Google Cloud instance with following parameters:

| <b>ITEM</b> | <b>VALUE</b> | <b>COMMENT</b> |
| :---         | :---         | :---         |
| VM | Google Cloud Platform | |
| vCPU | 2x | |
| Memory | 4096MB | |
| HTTP | Varnish on port 80 | |
| HTTPS | NGINX on port 443 | |

## Reverse Proxy

This chapter describes the basic configuration of my proxy server (for [blkcipher.info](https://blkcipher.info) domain).

  > Configuration is based on the [installation from source](HELPERS.md#installing-from-source) chapter. If you go through the installation process step by step you can use the following configuration (minor adjustments may be required).

#### Import configuration

It's very simple - clone the repo, backup your current configuration and perform full directory sync:

```bash
git clone https://github.com/trimstray/nginx-admins-handbook

tar czvfp ~/nginx.etc.tgz /etc/nginx && mv /etc/nginx /etc/nginx.old

rsync -avur lib/nginx/ /etc/nginx/
```

  > If you compiled NGINX from source you should also update/refresh modules. All compiled modules are stored in `/usr/local/src/nginx-${ngx_version}/master/objs` and installed in accordance with the value of the `--modules-path` variable.

#### Set bind IP address

###### Find and replace 192.168.252.2 string in directory and file names

```bash
cd /etc/nginx
find . -depth -not -path '*/\.git*' -name '*192.168.252.2*' -execdir bash -c 'mv -v "$1" "${1//192.168.252.2/xxx.xxx.xxx.xxx}"' _ {} \;
```

###### Find and replace 192.168.252.2 string in configuration files

```bash
cd /etc/nginx
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/192.168.252.2/xxx.xxx.xxx.xxx/g'
```

#### Set your domain name

###### Find and replace blkcipher.info string in directory and file names

```bash
cd /etc/nginx
find . -not -path '*/\.git*' -depth -name '*blkcipher.info*' -execdir bash -c 'mv -v "$1" "${1//blkcipher.info/example.com}"' _ {} \;
```

###### Find and replace blkcipher.info string in configuration files

```bash
cd /etc/nginx
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/blkcipher_info/example_com/g'
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/blkcipher.info/example.com/g'
```

#### Regenerate private keys and certs

###### For localhost

```bash
cd /etc/nginx/master/_server/localhost/certs

# Private key + Self-signed certificate:
( _fd="localhost.key" ; _fd_crt="nginx_localhost_bundle.crt" ; \
openssl req -x509 -newkey rsa:2048 -keyout ${_fd} -out ${_fd_crt} -days 365 -nodes \
-subj "/C=X0/ST=localhost/L=localhost/O=localhost/OU=X00/CN=localhost" )
```

###### For `default_server`

```bash
cd /etc/nginx/master/_server/defaults/certs

# Private key + Self-signed certificate:
( _fd="defaults.key" ; _fd_crt="nginx_defaults_bundle.crt" ; \
openssl req -x509 -newkey rsa:2048 -keyout ${_fd} -out ${_fd_crt} -days 365 -nodes \
-subj "/C=X1/ST=default/L=default/O=default/OU=X11/CN=default_server" )
```

###### For your domain (e.g. Let's Encrypt)

```bash
cd /etc/nginx/master/_server/example.com/certs

# For multidomain:
certbot certonly -d example.com -d www.example.com --rsa-key-size 2048

# For wildcard:
certbot certonly --manual --preferred-challenges=dns -d example.com -d *.example.com --rsa-key-size 2048

# Copy private key and chain:
cp /etc/letsencrypt/live/example.com/fullchain.pem nginx_example.com_bundle.crt
cp /etc/letsencrypt/live/example.com/privkey.pem example.com.key
```

#### Update modules list

Update modules list and include `modules.conf` to your configuration:

```bash
_mod_dir="/etc/nginx/modules"

:>"${_mod_dir}.conf"

for _module in $(ls "${_mod_dir}/") ; do echo -en "load_module\t\t${_mod_dir}/$_module;\n" >> "${_mod_dir}.conf" ; done
```

#### Generating the necessary error pages

  > In the example (`lib/nginx`) error pages are included from `lib/nginx/master/_static/errors.conf` file.

- default location: `/etc/nginx/html`:
  ```
  50x.html  index.html
  ```
- custom location: `/usr/share/www`:
  ```bash
  cd /etc/nginx/snippets/http-error-pages

  ./httpgen

  # You can also sync sites/ directory with /etc/nginx/html:
  #   rsync -var sites/ /etc/nginx/html/
  rsync -var sites/ /usr/share/www/
  ```

#### Add new domain

###### Updated `nginx.conf`

```nginx
# At the end of the file (in 'IPS/DOMAINS' section):
include /etc/nginx/master/_server/domain.com/servers.conf;
include /etc/nginx/master/_server/domain.com/backends.conf;
```

###### Init domain directory

```bash
cd /etc/nginx/master/_server
cp -R example.com domain.com

cd domain.com
find . -not -path '*/\.git*' -depth -name '*example.com*' -execdir bash -c 'mv -v "$1" "${1//example.com/domain.com}"' _ {} \;
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/example_com/domain_com/g'
find . -not -path '*/\.git*' -type f -print0 | xargs -0 sed -i 's/example.com/domain.com/g'
```

#### Create log directories

```bash
mkdir -p /var/log/nginx/localhost
mkdir -p /var/log/nginx/defaults
mkdir -p /var/log/nginx/others
mkdir -p /var/log/nginx/domains/blkcipher.info

chown -R nginx:nginx /var/log/nginx
```

#### Logrotate configuration

```bash
cp /etc/nginx/snippets/logrotate.d/nginx /etc/logrotate.d/
```

#### Test your configuration

```bash
nginx -t -c /etc/nginx/nginx.conf
```
