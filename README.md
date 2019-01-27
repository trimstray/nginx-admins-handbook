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

# Default Server and Listen directive

- **Prevent processing requests with undefined server names**

    **Rationale:**

    IF the request does not contain `Host` header field at all, then nginx will route the request to the default server for this port.

    **Example:**

    ```bash
    # Place it at the beginning of the configuration file.
    server_name                 default_server;

    location / {
      return                    301 https://badssl.com;
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
    ssl_dhparam dhparams_4096.pem;
    ```

    **External resources:**

    - [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
