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

# Standard configuration

- **Listen directives**

    **Rationale:**

    Separate both (80/443) listen directive.

    **Example:**

    ```bash
    # For http:
    server {
      listen                    10.240.20.2:80;
      ...

    # For https:
    server {
      listen                    10.240.20.2:443 ssl;
      ...
    ```

    **External resources:**

    - [How nginx processes a request](https://nginx.org/en/docs/http/request_processing.html)

- **Use http2 instead http**

    **Rationale:**

    ...

    **Example:**

    ```bash
    # For http:
    server {
      listen                    10.240.20.2:80;
      ...

    # For https:
    server {
      listen                    10.240.20.2:443 ssl;
      ...
    ```

    **External resources:**

    - [How nginx processes a request](https://nginx.org/en/docs/http/request_processing.html)

- **Default Server**

    **Rationale:**

    Nginx should prevent processing requests with undefined server names - also traffic on ip address. It also protects against configuration errors and providing incorrect backends.

    **Example:**

    ```bash
    # Place it at the beginning of the configuration file.
    server_name                 default_server;

    location / {
      return                    301 https://badssl.com;
      # or server static file (error page):
      root                      /etc/nginx/error-pages/sites/404;
    }
    ```

    **External resources:**

    - [How nginx processes a request](https://nginx.org/en/docs/http/request_processing.html)

# SSL/TLS

- **Use strong Diffie-Hellman group**

    **Rationale:**

    Default key size in OpenSSL is `1024 bits` - it's vurnelable and breakable. For the best security configuration is `4096 bit` DH Group.

    **Example:**

    ```bash
    # Generate DH Key:
    openssl dhparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

    # Nginx configuration:
    ssl_dhparam                 dhparams_4096.pem;
    ```

    **External resources:**

    - [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
