<div align="center">
  <h1><code>Nginx Hardening Reference</code></h1>
</div>

<br>

<p align="center">
  <a href="https://github.com/trimstray/nginx-hardening-reference/tree/master">
    <img src="https://img.shields.io/badge/Branch-master-green.svg?longCache=true"
        alt="Branch">
  </a>
  <a href="https://github.com/trimstray/nginx-hardening-reference/pulls">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?longCache=true"
        alt="Pull Requests">
  </a>
  <a href="http://www.gnu.org/licenses/">
    <img src="https://img.shields.io/badge/License-GNU-blue.svg?longCache=true"
        alt="License">
  </a>
</p>

<div align="center">
  <sub>Created by
  <a href="https://twitter.com/trimstray">trimstray</a> and
  <a href="https://github.com/trimstray/nginx-hardening-reference/graphs/contributors">
    contributors
  </a>
</div>

<br>

****

# Protect traffic on IP address

## Rationale

## Configuration

```bash
server {

  listen                        <public_ip_addr>:80;

  add_header                    Allow "GET, POST, HEAD" always;

  if ( $request_method !~ ^(GET|POST|HEAD)$ ) {

    return 405;

  }

  server_name                   default_server;

  location / {
      return                    301 https://badssl.com;
  }

  access_log                    /var/log/nginx/defaults/access.log main;
  error_log                     /var/log/nginx/defaults/error.log crit;

}

server {

  listen                        <public_ip_addr>:443 ssl;

  ssl_certificate               /etc/nginx/certs/nginx_defaults_bundle.crt;
  ssl_certificate_key           /etc/nginx/certs/defaults.key;

  add_header                    Allow "GET, POST, HEAD" always;

  if ( $request_method !~ ^(GET|POST|HEAD)$ ) {

    return 405;

  }

  server_name                   default_server;

  location / {
      return                    301 https://badssl.com;
  }

  access_log                    /var/log/nginx/defaults/access.log main;
  error_log                     /var/log/nginx/defaults/error.log crit;

}
```

# SSL/TLS

- **Diffie-Hellman Key**

    **Rationale:**

    Default key size in OpenSSL is `1024 bits` - it's vurnelable and breakable. For the best security configuration is `4096 bit` DH Group.

    **Example:**

    ```bash
    # Generate DH Key:
    openssl dhparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

    # Nginx configuration:
    ssl_dhparam dhparams_4096.pem;
    ```

    **External resources:**

    - [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
