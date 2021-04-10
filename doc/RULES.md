# Base Rules

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

  > :pushpin:&nbsp; These are the basic set of rules to keep NGINX in good condition.

- **[≡ Base Rules (16)](#base-rules)**
  * [Organising Nginx configuration](#beginner-organising-nginx-configuration)
  * [Format, prettify and indent your Nginx code](#beginner-format-prettify-and-indent-your-nginx-code)
  * [Use reload option to change configurations on the fly](#beginner-use-reload-option-to-change-configurations-on-the-fly)
  * [Separate listen directives for 80 and 443 ports](#beginner-separate-listen-directives-for-80-and-443-ports)
  * [Define the listen directives with address:port pair](#beginner-define-the-listen-directives-with-addressport-pair)
  * [Prevent processing requests with undefined server names](#beginner-prevent-processing-requests-with-undefined-server-names)
  * [Never use a hostname in a listen or upstream directives](#beginner-never-use-a-hostname-in-a-listen-or-upstream-directives)
  * [Set the HTTP headers with add_header and proxy_*_header directives properly](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)
  * [Use only one SSL config for the listen directive](#beginner-use-only-one-ssl-config-for-the-listen-directive)
  * [Use geo/map modules instead of allow/deny](#beginner-use-geomap-modules-instead-of-allowdeny)
  * [Map all the things...](#beginner-map-all-the-things)
  * [Set global root directory for unmatched locations](#beginner-set-global-root-directory-for-unmatched-locations)
  * [Use return directive for URL redirection (301, 302)](#beginner-use-return-directive-for-url-redirection-301-302)
  * [Configure log rotation policy](#beginner-configure-log-rotation-policy)
  * [Use simple custom error pages](#beginner-use-simple-custom-error-pages)
  * [Don't duplicate index directive, use it only in the http block](#beginner-dont-duplicate-index-directive-use-it-only-in-the-http-block)
- **[Debugging](#debugging)**
- **[Performance](#performance)**
- **[Hardening](#hardening)**
- **[Reverse Proxy](#reverse-proxy)**
- **[Load Balancing](#load-balancing)**
- **[Others](#others)**

#### :beginner: Organising Nginx configuration

###### Rationale

  > When your NGINX configuration grow, the need for organising your configuration will also grow. Well organised code is:
  >
  > - easier to understand
  > - easier to maintain
  > - easier to work with

  > Use `include` directive to move and to split common server settings into multiple files and to attach your specific code to global config or contexts. This helps in organizing code into logical components. Inclusions are processed recursively, that is, an include file can further have include statements.

  > Work out your own directory structure (from the top-level directory to the lowest) and apply it when working with NGINX. Think about it carefully and figure out what's going to be best for you and the easiest to maintain.

  > I always try to keep multiple directories in a root of configuration tree. These directories stores all configuration files which are attached to the main file (e.g. `nginx.conf`) and, if necessary, mostly to the files which has `server` directives.

  > I prefer the following structure:
  >
  > - `html` - for default static files, e.g. global 5xx error page
  > - `master` - for main configuration, e.g. acls, listen directives, and domains
  >   - `_acls` - for access control lists, e.g. geo or map modules
  >   - `_basic` - for rate limiting rules, redirect maps, or proxy params
  >   - `_listen` - for all listen directives; also stores SSL configuration
  >   - `_server` - for domains configuration; also stores all backends definitions
  > - `modules` - for modules which are dynamically loading into NGINX
  > - `snippets` - for NGINX aliases, configuration templates

###### Example

```nginx
# In https.conf for example:
listen 10.240.20.2:443 ssl;

ssl_certificate /etc/nginx/master/_server/example.com/certs/nginx_example.com_bundle.crt;
ssl_certificate_key /etc/nginx/master/_server/example.com/certs/example.com.key;

...

# Include 'https.conf' to the server section:
server {

  include /etc/nginx/master/_listen/10.240.20.2/https.conf;

  # And other external files:
  include /etc/nginx/master/_static/errors.conf;
  include /etc/nginx/master/_server/_helpers/global.conf;

  server_name example.com www.example.com;

  ...
```

###### External resources

- [How I Manage Nginx Config](https://tylergaw.com/articles/how-i-manage-nginx-config/)
- [Organize your data and code](https://kbroman.org/steps2rr/pages/organize.html)
- [How to keep your R projects organized](https://richpauloo.github.io/2018-10-17-How-to-keep-your-R-projects-organized/)

#### :beginner: Format, prettify and indent your Nginx code

###### Rationale

  > Work with unreadable configuration files is terrible. If syntax is not very clear and readable, it makes your eyes sore, and you suffers from headaches.

  > When your code is formatted, it is significantly easier to maintain, debug, optimise, and can be read and understood in a short amount of time. You should eliminate code style violations from your NGINX configuration files.

  > Spaces, tabs, and new line characters are not part of the NGINX configuration. They are not interpreted by the NGINX engine, but they help to make the configuration more readable.

  > Choose your formatter style and setup a common config for it. Some rules are universal, but in my view, the most important thing is to keep a consistent NGINX code style throughout your code base:
  >
  > - use whitespaces and blank lines to arrange and separate code blocks
  > - tabs vs spaces - more important to be consistent throughout your code than to use any specific type
  >   - tabs are consistent, customizable and allow mistakes to be more noticeable (unless you are a 4 space kind of guy)
  >   - a space is always one column, use it if you want your beautiful work to appear right for everyone
  > - use comments to explain why things are done not what is done
  > - use meaningful naming conventions
  > - simple is better than complex but complex is better than complicated

  > Some would say that NGINX's files are written in their own language so we should not overdo it with above rules. I think, it is worth sticking to the general (programming) rules and make your and other NGINX adminstrators life easier.

###### Example

Not recommended code style:

```nginx
http {
  include    nginx/proxy.conf;
  include    /etc/nginx/fastcgi.conf;
  index    index.html index.htm index.php;

  default_type application/octet-stream;
  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log   logs/access.log    main;
  sendfile on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts

  ...
```

Recommended code style:

```nginx
http {

  # Attach global rules:
  include         /etc/nginx/proxy.conf;
  include         /etc/nginx/fastcgi.conf;

  index           index.html index.htm index.php;

  default_type    application/octet-stream;

  # Standard log format:
  log_format      main '$remote_addr - $remote_user [$time_local]  $status '
                       '"$request" $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';

  access_log      /var/log/nginx/access.log main;

  sendfile        on;
  tcp_nopush      on;

  # This seems to be required for some vhosts:
  server_names_hash_bucket_size 128;

  ...
```

###### External resources

- [Programming style](https://en.wikipedia.org/wiki/Programming_style)
- [Toward Developing Good Programming Style](https://www2.cs.arizona.edu/~mccann/style_c.html)
- [Death to the Space Infidels!](https://blog.codinghorror.com/death-to-the-space-infidels/)
- [Tabs versus Spaces: An Eternal Holy War](https://www.jwz.org/doc/tabs-vs-spaces.html)
- [nginx-config-formatter](https://github.com/1connect/nginx-config-formatter)
- [Format and beautify nginx config files](https://github.com/vasilevich/nginxbeautifier)

#### :beginner: Use `reload` option to change configurations on the fly

###### Rationale

  > Use the `reload` option to achieve a graceful reload of the configuration without stopping the server and dropping any packets. This function of the master process allows to rolls back the changes and continues to work with stable and old working configuration.

  > This ability of NGINX is very critical in a high-uptime and dynamic environments for keeping the load balancer or standalone server online.

  > Master process checks the syntax validity of the new configuration and tries to apply all changes. If this procedure has been accomplished, the master process create new worker processes and sends shutdown messages to old. Old workers stops accepting new connections after received a shut down signal but current requests are still processing. After that, the old workers exit.

  > When you restart the NGINX service you might encounter situation in which NGINX will stop, and won't start back again, because of syntax error. Reload method is safer than restarting because before old process will be terminated, new configuration file is parsed and whole process is aborted if there are any problems with it.

  > To stop processes with waiting for the worker processes to finish serving current requests use `nginx -s quit` command. It's better than `nginx -s stop` for fast shutdown.

  From NGINX documentation:

  > _In order for NGINX to re-read the configuration file, a `HUP` signal should be sent to the master process. The master process first checks the syntax validity, then tries to apply new configuration, that is, to open log files and new listen sockets. If this fails, it rolls back changes and continues to work with old configuration. If this succeeds, it starts new worker processes, and sends messages to old worker processes requesting them to shut down gracefully. Old worker processes close listen sockets and continue to service old clients. After all clients are serviced, old worker processes are shut down._

###### Example

```bash
# 1)
systemctl reload nginx

# 2)
service nginx reload

# 3)
/etc/init.d/nginx reload

# 4)
/usr/sbin/nginx -s reload

# 5)
kill -HUP $(cat /var/run/nginx.pid)
# or
kill -HUP $(pgrep -f "nginx: master")

# 6)
/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
```

###### External resources

- [Changing Configuration](https://nginx.org/en/docs/control.html#reconfiguration)
- [Commands (from this handbook)](NGINX_BASICS.md#commands)

#### :beginner: Separate `listen` directives for 80 and 443 ports

###### Rationale

  > If you served HTTP and HTTPS with the exact same config (a single server that handles both HTTP and HTTPS requests) NGINX is intelligent enough to ignore the SSL directives if loaded over port 80.

  > I don't like duplicating the rules, but separate `listen` directives is certainly to help you maintain and modify your configuration. I always split the configuration if I want to redirect from HTTP to HTTPS (or www to non-www,  and vice versa). For me, the right way is to define a separate server context in any such cases.

  > It's also useful if you pin multiple domains to one IP address. This allows you to attach one `listen` directive (e.g. if you keep it in the configuration file) to multiple domains configurations.

  > It may also be necessary to hardcode the domains if you're using HTTPS, because you have to know upfront which certificates you'll be providing.

  > You should also use `return` directive for redirect from HTTP to HTTPS (to hardcode everything, and not use regular expressions at all).

###### Example

```nginx
# For HTTP:
server {

  listen 10.240.20.2:80;

  # If you need redirect to HTTPS:
  return 301 https://example.com$request_uri;

  ...

}

# For HTTPS:
server {

  listen 10.240.20.2:443 ssl;

  ...

}
```

###### External resources

- [Understanding the Nginx Configuration File Structure and Configuration Contexts](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)
- [Configuring HTTPS servers](http://nginx.org/en/docs/http/configuring_https_servers.html)
- [Force all connections over TLS - Hardening - P1 (from this handbook)](#beginner-force-all-connections-over-tls)

#### :beginner: Define the `listen` directives with `address:port` pair

###### Rationale

  > NGINX translates all incomplete `listen` directives by substituting missing values with their default values.

  > And what's more, will only evaluate the `server_name` directive when it needs to distinguish between server blocks that match to the same level in the `listen` directive.

  > Set IP address and port number to prevents soft mistakes which may be difficult to debug. In addition, no IP means bind to all IPs on your system, this can cause a lot of problems and it's bad practice because it is recommended to only configure the minimum network access for services.

###### Example

```nginx
# Client side:
$ curl -Iks http://api.random.com

# Server side:
server {

  # This block will be processed:
  listen 192.168.252.10; # --> 192.168.252.10:80

  ...

}

server {

  listen 80; # --> *:80 --> 0.0.0.0:80
  server_name api.random.com;

  ...

}
```

###### External resources

- [Nginx HTTP Core Module - Listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen)
- [Understanding different values for nginx 'listen' directive](https://serverfault.com/questions/875140/understanding-different-values-for-nginx-listen-directive)

#### :beginner: Prevent processing requests with undefined server names

###### Rationale

  > It protects against configuration errors, e.g. traffic forwarding to incorrect backends, bypassing filters like an ACLs or WAFs. The problem is easily solved by creating a default dummy vhost (with `default_server` directive) that catches all requests with unrecognized `Host` headers.

  > As we know, the `Host` header tells the server which virtual host to use (if set up). You can even have the same virtual host using several aliases (= domains and wildcard-domains). This header can also be modified, so for security and cleanness reasons it's a good practice to deny requests without host or with hosts not configured in any vhost. According to this, NGINX should prevent processing requests with undefined server names (also on IP address).

  > If none of the `listen` directives have the `default_server` parameter then the first server with the `address:port` pair will be the default server for this pair (it means that the NGINX always has a default server).

  > If someone makes a request using an IP address instead of a server name, the `Host` request header field will contain the IP address and the request can be handled using the IP address as the server name.

  > The server name `_` is not required in modern versions of NGINX (so you can put anything there). In fact, the `default_server` does not need a `server_name` statement because it match anything that the other server blocks does not explicitly match.

  > If a server with a matching `listen` and `server_name` cannot be found, NGINX will use the default server. If your configurations are spread across multiple files, there evaluation order will be ambiguous, so you need to mark the default server explicitly.

  > NGINX uses `Host` header for `server_name` matching but it does not use TLS SNI. This means that NGINX must be able to accept SSL connection, which boils down to having certificate/key. The cert/key can be any, e.g. self-signed.

  > There is a simple procedure for all non defined server names:
  >
  > - one `server` block, with...
  > - complete `listen` directive, with...
  > - `default_server` parameter, with...
  > - only one `server_name` (but not required) definition, and...
  > - preventively I add it at the beginning of the configuration (attach it to the file `nginx.conf`)

  > Also good point is `return 444;` (most commonly used to deny malicious or malformed requests) for default server name because this will close the connection (which will kill the connection without sending any headers so return nothing) and log it internally, for any domain that isn't defined in NGINX. In addition, I would implement rate limiting rule.

###### Example

```nginx
# Place it at the beginning of the configuration file to prevent mistakes:
server {

  # For ssl option remember about SSL parameters (private key, certs, cipher suites, etc.);
  # add default_server to your listen directive in the server that you want to act as the default:
  listen 10.240.20.2:443 default_server ssl;

  # We catch:
  #   - invalid domain names
  #   - requests without the "Host" header
  #   - and all others (also due to the above setting; like "--" or "!@#")
  #   - default_server in server_name directive is not required
  #     I add this for a better understanding and I think it's an unwritten standard
  # ...but you should know that it's irrelevant, really, you can put in everything there.
  server_name _ "" default_server;

  limit_req zone=per_ip_5r_s;

  ...

  # Close (hang up) connection without response:
  return 444;

  # We can also serve:
  # location / {
  #
  #   static file (error page):
  #     root /etc/nginx/error-pages/404;
  #   or redirect:
  #     return 301 https://badssl.com;
  #
  # }

  # Remember to log all actions (set up access and error log):
  access_log /var/log/nginx/default-access.log main;
  error_log /var/log/nginx/default-error.log warn;

}

server {

  listen 10.240.20.2:443 ssl;

  server_name example.com;

  ...

}

server {

  listen 10.240.20.2:443 ssl;

  server_name domain.org;

  ...

}
```

###### External resources

- [Server names](https://nginx.org/en/docs/http/server_names.html)
- [How processes a request](https://nginx.org/en/docs/http/request_processing.html)
- [nginx: how to specify a default server](https://blog.gahooa.com/2013/08/21/nginx-how-to-specify-a-default-server/)

#### :beginner: Never use a hostname in a `listen` or `upstream` directives

###### Rationale

  > Generaly, uses of hostnames in a `listen` or `upstream` directives is a bad practice. In the worst case NGINX won't be able to bind to the desired TCP socket which will prevent NGINX from starting at all.

  > The best and safer way is to know the IP address that needs to be bound to and use that address instead of the hostname. This also prevents NGINX from needing to look up the address and removes dependencies on external and internal resolvers.

  > Uses of `$hostname` (the machine’s hostname) variable in the `server_name` directive is also example of bad practice (it's similar to use hostname label).

  > I believe it is also necessary to set IP address and port number pair to prevents soft mistakes which may be difficult to debug.

###### Example

Not recommended configuration:

```nginx
upstream bk_01 {

  server http://x-9s-web01-prod.int:8080;

}

server {

  listen rev-proxy-prod:80;

  ...

  location / {

    # It's OK, bk_01 is the internal name:
    proxy_pass http://bk_01;

    ...

  }

  location /api {

    proxy_pass http://x-9s-web01-prod-api.int:80;

    ...

  }

  ...

}
```

Recommended configuration:

```nginx
upstream bk_01 {

  server http://192.168.252.200:8080;

}

server {

  listen 10.10.100.20:80;

  ...

  location / {

    # It's OK, bk_01 is the internal name:
    proxy_pass http://bk_01;

    ...

  }

  location /api {

    proxy_pass http://192.168.253.10:80;

    ...

  }

  ...

}
```

###### External resources

- [Using a Hostname to Resolve Addresses](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#using-a-hostname-to-resolve-addresses)
- [Define the listen directives with address:port pair - Base Rules - P1 (from this handbook)](#beginner-define-the-listen-directives-with-addressport-pair)

#### :beginner: Set the HTTP headers with `add_header` and `proxy_*_header` directives properly

###### Rationale

  > The `add_header` directive works in the `if`, `location`, `server`, and `http` scopes. The `proxy_*_header` directives works in the `location`, `server`, and `http` scopes. These directives are inherited from the previous level if and only if there are no `add_header` or `proxy_*_header` directives defined on the current level.

  > If you use them in multiple contexts only the lowest occurrences are used. So, if you specify it in the `server` and `location` contexts (even if you hide different header by setting with the same directive and value) only the one of them in the `location` block are used. To prevent this situation, you should define a common config snippet and only include it in each individual `location` where you want these headers to be sent. It is the most predictable solution.

  > In my opinion, also interesting solution is use an include file with your global headers and add it to the `http` context (however, then you duplicate the rules unnecessarily). Next, you should also set up other include file with your server/domain specific configuration (but always with your global headers! You have to repeat it in the lowest contexts) and add it to the `server/location` contexts. However, it is a little more complicated and does not guarantee consistency in any way.

  > There are additional solutions to this, such as using an alternative module ([headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module)) to define specific headers in `server` or `location` blocks. It does not affect the above directives.

  That is [great explanation](https://www.keycdn.com/support/nginx-add_header) of the problem:

  > _Therefore, let’s say you have an http block and have specified the `add_header` directive within that block. Then, within the http block you have 2 server blocks - one for HTTP and one for HTTPs._
  >
  > _Let’s say we don’t include an `add_header` directive within the HTTP server block, however we do include an additional `add_header` within the HTTPs server block. In this scenario, the `add_header` directive defined in the http block will only be inherited by the HTTP server block as it does not have any `add_header` directive defined on the current level. On the other hand, the HTTPS server block will not inherit the `add_header` directive defined in the http block._

###### Example

Not recommended configuration:

```nginx
http {

  # In this context:
  # set:
  #   - 'FooX barX' (add_header)
  #   - 'Host $host' (proxy_set_header)
  #   - 'X-Real-IP $remote_addr' (proxy_set_header)
  #   - 'X-Forwarded-For $proxy_add_x_forwarded_for' (proxy_set_header)
  #   - 'X-Powered-By' (proxy_hide_header)

  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_hide_header X-Powered-By;

  add_header FooX barX;

  ...

  server {

    server_name example.com;

    # In this context:
    # set:
    #   - 'FooY barY' (add_header)
    #   - 'Host $host' (proxy_set_header)
    #   - 'X-Real-IP $remote_addr' (proxy_set_header)
    #   - 'X-Forwarded-For $proxy_add_x_forwarded_for' (proxy_set_header)
    #   - 'X-Powered-By' (proxy_hide_header)
    # not set:
    #   - 'FooX barX' (add_header)

    add_header FooY barY;

    ...

    location / {

      # In this context:
      # set:
      #   - 'Foo bar' (add_header)
      #   - 'Host $host' (proxy_set_header)
      #   - 'X-Real-IP $remote_addr' (proxy_set_header)
      #   - 'X-Forwarded-For $proxy_add_x_forwarded_for' (proxy_set_header)
      #   - 'X-Powered-By' (proxy_hide_header)
      #   - headers from ngx_headers_global.conf
      # not set:
      #   - 'FooX barX' (add_header)
      #   - 'FooY barY' (add_header)

      include /etc/nginx/ngx_headers_global.conf;
      add_header Foo bar;

      ...

    }

    location /api {

      # In this context:
      # set:
      #   - 'FooY barY' (add_header)
      #   - 'Host $host' (proxy_set_header)
      #   - 'X-Real-IP $remote_addr' (proxy_set_header)
      #   - 'X-Forwarded-For $proxy_add_x_forwarded_for' (proxy_set_header)
      #   - 'X-Powered-By' (proxy_hide_header)
      # not set:
      #   - 'FooX barX' (add_header)

      ...

    }

  }

  server {

    server_name a.example.com;

    # In this context:
    # set:
    #   - 'FooY barY' (add_header)
    #   - 'Host $host' (proxy_set_header)
    #   - 'X-Real-IP $remote_addr' (proxy_set_header)
    #   - 'X-Powered-By' (proxy_hide_header)
    # not set:
    #   - 'FooX barX' (add_header)
    #   - 'X-Forwarded-For $proxy_add_x_forwarded_for' (proxy_set_header)

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_hide_header X-Powered-By;

    add_header FooY barY;

    ...

    location / {

      # In this context:
      # set:
      #   - 'FooY barY' (add_header)
      #   - 'X-Powered-By' (proxy_hide_header)
      #   - 'Accept-Encoding ""' (proxy_set_header)
      # not set:
      #   - 'FooX barX' (add_header)
      #   - 'Host $host' (proxy_set_header)
      #   - 'X-Real-IP $remote_addr' (proxy_set_header)
      #   - 'X-Forwarded-For $proxy_add_x_forwarded_for' (proxy_set_header)

      proxy_set_header Accept-Encoding "";

      ...

    }

  }

}
```

Most recommended configuration:

```nginx
# Store it in a file, e.g. proxy_headers.conf:
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_hide_header X-Powered-By;

http {

  server {

    server_name example.com;

    ...

    location / {

      include /etc/nginx/proxy_headers.conf;
      include /etc/nginx/ngx_headers_global.conf;
      add_header Foo bar;

      ...

    }

    location /api {

      include /etc/nginx/proxy_headers.conf;
      include /etc/nginx/ngx_headers_global.conf;
      add_header Foo bar;

      more_set_headers 'FooY: barY';

      ...

    }

  }

  server {

    server_name a.example.com;

    ...

    location / {

      include /etc/nginx/proxy_headers.conf;
      include /etc/nginx/ngx_headers_global.conf;
      add_header Foo bar;
      add_header FooX barX;

      ...

    }

  }

  server {

    server_name b.example.com;

    ...

    location / {

      include /etc/nginx/proxy_headers.conf;
      include /etc/nginx/ngx_headers_global.conf;
      add_header Foo bar;

      ...

    }

  }

}
```

###### External resources

- [Module ngx_http_headers_module - add_header](http://nginx.org/en/docs/http/ngx_http_headers_module.html#add_header)
- [Managing request headers](https://www.nginx.com/resources/wiki/start/topics/examples/headers_management/)
- [Nginx add_header configuration pitfall](https://blog.g3rt.nl/nginx-add_header-pitfall.html)
- [Be very careful with your add_header in Nginx! You might make your site insecure](https://www.peterbe.com/plog/be-very-careful-with-your-add_header-in-nginx)

#### :beginner: Use only one SSL config for the `listen` directive

###### Rationale

  > For me, this rule making it easier to debug and maintain. It also prevents multiple TLS configurations on the same listening address.

  > You should use one SSL config for sharing a single IP address between several HTTPS configurations (e.g. protocols, ciphers, curves). It's to prevent mistakes and configuration mismatch.

  > Using a common TLS configuration (stored in one file and added using the include directive) for all `server` contexts prevents strange behaviors. I think no better cure for a possible configuration clutter.

  > Remember that regardless of SSL parameters you are able to use multiple SSL certificates on the same `listen` directive (IP address). Also some of the TLS parameters may be different.

  > Also remember about configuration for default server. It's important because if none of the listen directives have the `default_server` parameter then the first server in your configuration will be default server. Therefore you should use only one SSL setup for several server names on the same IP address.

###### Example

```nginx
# Store it in a file, e.g. https.conf:
ssl_protocols TLSv1.2;
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305";

ssl_prefer_server_ciphers off;

ssl_ecdh_curve secp521r1:secp384r1;

...

# Include this file to the server context (attach domain-a.com for specific listen directive):
server {

  listen 192.168.252.10:443 default_server ssl http2;

  include /etc/nginx/https.conf;

  server_name domain-a.com;

  ssl_certificate domain-a.com.crt;
  ssl_certificate_key domain-a.com.key;

  ...

}

# Include this file to the server context (attach domain-b.com for specific listen directive):
server {

  listen 192.168.252.10:443 ssl;

  include /etc/nginx/https.conf;

  server_name domain-b.com;

  ssl_certificate domain-b.com.crt;
  ssl_certificate_key domain-b.com.key;

  ...

}
```

###### External resources

- [Nginx one ip and multiple ssl certificates](https://serverfault.com/questions/766831/nginx-one-ip-and-multiple-ssl-certificates)
- [Configuring HTTPS servers](http://nginx.org/en/docs/http/configuring_https_servers.html)

#### :beginner: Use `geo/map` modules instead of `allow/deny`

###### Rationale

  > Use `map` or `geo` modules (one of them) to prevent users abusing your servers. This allows to create variables with values depending on the client IP address.

  > Since variables are evaluated only when used, the mere existence of even a large number of declared e.g. `geo` variables does not cause any extra costs for request processing.

  > These directives provides the perfect way to block invalid visitors e.g. with `ngx_http_geoip_module`. For example, `geo` module is great for conditionally allow or deny IP.

  > `geo` module (watch out: don't mistake this module for the GeoIP) builds in-memory radix tree when loading configs. This is the same data structure as used in routing, and lookups are really fast.

  > I use both modules for a large lists but these directives may require the use of several `if` conditions. For me, `allow/deny` directives are better solution (more plain) for simple lists.

###### Example

```nginx
# Map module:
map $remote_addr $globals_internal_map_acl {

  # Status code:
  #  - 0 = false
  #  - 1 = true
  default 0;

  ### INTERNAL ###
  10.255.10.0/24 1;
  10.255.20.0/24 1;
  10.255.30.0/24 1;
  192.168.0.0/16 1;

}

# Geo module:
geo $globals_internal_geo_acl {

  # Status code:
  #  - 0 = false
  #  - 1 = true
  default 0;

  ### INTERNAL ###
  10.255.10.0/24 1;
  10.255.20.0/24 1;
  10.255.30.0/24 1;
  192.168.0.0/16 1;

}
```

Take a look also at the example below (`allow/deny` vs `geo + if` statement):

```nginx
# allow/deny:
location /internal {

  include acls/internal.conf;
  allow 192.168.240.0/24;
  deny all;

  ...

# vs geo/map:
location /internal {

  if ($globals_internal_map_acl) {
    set $pass 1;
  }

  if ($pass = 1) {
    proxy_pass http://localhost:80;
  }

  if ($pass != 1) {
    return 403;
  }

  ...

}
```

###### External resources

- [Nginx Basic Configuration (Geo Ban)](https://www.axivo.com/resources/nginx-basic-configuration.3/update?update=27)
- [What is the best way to redirect 57,000 URLs on nginx?](https://serverfault.com/questions/879534/what-is-the-best-way-to-redirect-57-000-urls-on-nginx)
- [How Radix trees made blocking IPs 5000 times faster](https://blog.sqreen.com/demystifying-radix-trees/)
- [Compressing Radix Trees Without (Too Many) Tears](https://medium.com/basecs/compressing-radix-trees-without-too-many-tears-a2e658adb9a0)
- [Blocking/allowing IP addresses (from this handbook)](HELPERS.md#blockingallowing-ip-addresses)
- [allow and deny (from this handbook)](NGINX_BASICS.md#allow-and-deny)
- [ngx_http_geoip_module (from this handbook)](NGINX_BASICS.md#ngx-http-geoip-module)

#### :beginner: Map all the things...

###### Rationale

  > Manage a large number of redirects with maps and use them to customise your key-value pairs. If you are ever faced with using an if during a request, you should check to see if you can use a `map` instead.

  > The `map` directive maps strings, so it is possible to represent e.g. `192.168.144.0/24` as a regular expression and continue to use the `map` directive.

  > Map module provides a more elegant solution for clearly parsing a big list of regexes, e.g. User-Agents, Referrers.

  > You can also use `include` directive for your maps so your config files would look pretty and can be used in many places in your configuration.

###### Example

```nginx
# Define in an external file (e.g. maps/http_user_agent.conf):
map $http_user_agent $device_redirect {

  default "desktop";

  ~(?i)ip(hone|od) "mobile";
  ~(?i)android.*(mobile|mini) "mobile";
  ~Mobile.+Firefox "mobile";
  ~^HTC "mobile";
  ~Fennec "mobile";
  ~IEMobile "mobile";
  ~BB10 "mobile";
  ~SymbianOS.*AppleWebKit "mobile";
  ~Opera\sMobi "mobile";

}

# Include to the server context:
include maps/http_user_agent.conf;

# And turn on in a specific context (e.g. location):
if ($device_redirect = "mobile") {

  return 301 https://m.example.com$request_uri;

}
```

###### External resources

- [Module ngx_http_map_module](http://nginx.org/en/docs/http/ngx_http_map_module.html)
- [Cool Nginx feature of the week](https://www.ignoredbydinosaurs.com/posts/236-cool-nginx-feature-of-the-week)

#### :beginner: Set global root directory for unmatched locations

###### Rationale

  > Set global `root` inside server directive for requests. It specifies the root directory for undefined locations.

  > If you define `root` in a `location` block it will only be available in that `location`. This almost always leads to duplication of either `root` directives of file paths, neither of which is good.

  > If you define it in the `server` block it is always inherited by the `location` blocks so it will always be available in the `$document_root` variable, thus avoiding the duplication of file paths.

  From official documentation:

  > _If you add a `root` to every location block then a location block that isn’t matched will have no `root`. Therefore, it is important that a `root` directive occur prior to your location blocks, which can then override this directive if they need to._

###### Example

```nginx
server {

  server_name example.com;

  # It's important:
  root /var/www/example.com/public;

  location / {

    ...

  }

  location /api {

    ...

  }

  location /static {

    root /var/www/example.com/static;

    ...

  }

}
```

###### External resources

- [Nginx Pitfalls: Root inside location block](http://wiki.nginx.org/Pitfalls#Root_inside_Location_Block)

#### :beginner: Use `return` directive for URL redirection (301, 302)

###### Rationale

  > It's a simple rule. You should use server blocks and `return` statements as they're way faster than evaluating RegEx.

  > It is simpler and faster because NGINX stops processing the request (and doesn't have to process a regular expressions). More than that, you can specify a code in the 3xx series.

  > If you have a scenario where you need to validate the URL with a regex or need to capture elements in the original URL (that are obviously not in a corresponding NGINX variable), then you should use `rewrite`.

###### Example

```nginx
server {

  listen 192.168.252.10:80;

  ...

  server_name www.example.com;

  return 301 https://example.com$request_uri;

  # Other examples:
  # return 301 https://$host$request_uri;
  # return 301 $scheme://$host$request_uri;

}

server {

  ...

  server_name example.com;

  return 301 $scheme://www.example.com$request_uri;

}
```

###### External resources

- [Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)
- [How to do an Nginx redirect](https://bjornjohansen.no/nginx-redirect)
- [rewrite vs return (from this handbook)](NGINX_BASICS.md#rewrite-vs-return)
- [Adding and removing the www prefix (from this handbook)](HELPERS.md#adding-and-removing-the-www-prefix)
- [Avoid checks server_name with if directive - Performance - P2 (from this handbook)](#beginner-avoid-checks-server_name-with-if-directive)
- [Use return directive instead of rewrite for redirects - Performance - P2 (from this handbook)](#beginner-use-return-directive-instead-of-rewrite-for-redirects)

#### :beginner: Configure log rotation policy

###### Rationale

  > Log files gives you feedback about the activity and performance of the server as well as any problems that may be occurring. They are records details about requests and NGINX internals. Unfortunately, logs use more disk space.

  > You should define a process which periodically archiving the current log file and starting a new one, renames and optionally compresses the current log files, delete old log files, and force the logging system to begin using new log files.

  > I think the best tool for this is a `logrotate`. I use it everywhere if I want to manage logs automatically, and for a good night's sleep also. It is a simple program to rotate logs, uses crontab to work. It's scheduled work, not a daemon, so no need to reload its configuration.

###### Example

- for manually rotation:

  ```bash
  # Check manually (all log files):
  logrotate -dv /etc/logrotate.conf

  # Check manually with force rotation (specific log file):
  logrotate -dv --force /etc/logrotate.d/nginx
  ```

- for automate rotation:

  ```bash
  # GNU/Linux distributions:
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
      # test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`
      invoke-rc.d nginx reload >/dev/null 2>&1
    endscript
  }

  /var/log/nginx/localhost/*.log {
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
      # test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`
      invoke-rc.d nginx reload >/dev/null 2>&1
    endscript
  }

  /var/log/nginx/domains/example.com/*.log {
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
      # test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`
      invoke-rc.d nginx reload >/dev/null 2>&1
    endscript
  }
  __EOF__
  ```

  ```bash
  # BSD systems:
  cat > /usr/local/etc/logrotate.d/nginx << __EOF__
  /var/log/nginx/*.log {
    daily
    rotate 14
    missingok
    sharedscripts
    compress
    postrotate
      kill -HUP `cat /var/run/nginx.pid`
    endscript
    dateext
  }
  /var/log/nginx/*/*.log {
    daily
    rotate 14
    missingok
    sharedscripts
    compress
    postrotate
      kill -HUP `cat /var/run/nginx.pid`
    endscript
    dateext
  }
  __EOF__
  ```

###### External resources

- [Understanding logrotate utility](https://support.rackspace.com/how-to/understanding-logrotate-utility/)
- [Rotating Linux Log Files - Part 2: Logrotate](http://www.ducea.com/2006/06/06/rotating-linux-log-files-part-2-logrotate/)
- [Managing Logs with Logrotate](https://serversforhackers.com/c/managing-logs-with-logrotate)
- [nginx and Logrotate](https://drumcoder.co.uk/blog/2012/feb/03/nginx-and-logrotate/)
- [nginx log rotation](https://wincent.com/wiki/nginx_log_rotation)

#### :beginner: Use simple custom error pages

###### Rationale

  > Default error pages in NGINX are simple but it reveals version information and returns the "nginx" string, which leads to information leakage vulnerability.

  > Information about the technologies used and the software versions are extremely valuable information. These details allow the identification and exploitation of known software weaknesses published in publicly available vulnerability databases.

  > The best option is to generate pages for each HTTP code or use SSI and `map` modules to create dynamic error pages.

  > You can setup a custom error page for every location block in your `nginx.conf`, or a global error page for the site as a whole. You can also append standard error codes together to have a single page for several types of errors.

  > Be careful with the syntax! You should drop the `=` out of the `error_page` directive because with this, `error_page 404 = /404.html;` return the `404.html` page with a status code of 200 (`=` has relayed that to this page) so you should set `error_page 404 /404.html;` and you'll get the original error code returned.

  > You should also remember about HTTP request smuggling attacks (see [more](https://bertjwregeer.keybase.pub/2019-12-10%20-%20error_page%20request%20smuggling.pdf)):
  > - `error_page 401 https://example.org/;` - this handler is vulnerable, allowing an attacker to smuggle a request and potentially gain access to resources/information
  > - `error_page 404 /404.html;` + `error_page 404 @404;` - are not vulnerable

  > To generate custom error pages you can use [HTTP Static Error Pages Generator](https://github.com/trimstray/nginx-admins-handbook/tree/master/lib/nginx/snippets/http-error-pages#http-static-error-pages-generator).

###### Example

Create error page templates:

```bash
cat >> /usr/share/nginx/html/404.html << __EOF__
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
</body>
</html>
__EOF__

# Just an example, I know it is stupid...
cat >> /usr/share/nginx/html/50x.html << __EOF__
<html>
<head><title>server error</title></head>
<body>
<center><h1>server error</h1></center>
</body>
</html>
__EOF__
```

Set them on the NGINX side:

```nginx
error_page 404 /404.html;
error_page 500 502 503 504 /50x.html;

location = /404.html {

  root /usr/share/nginx/html;
  internal;

}

location = /custom_50x.html {

  root /usr/share/nginx/html;
  internal;

}
```

###### External resources

- [error_page from ngx_http_core_module](http://nginx.org/en/docs/http/ngx_http_core_module.html#error_page)
- [src/http/ngx_http_special_response.c](https://github.com/nginx/nginx/blob/release-1.17.6/src/http/ngx_http_special_response.c)
- [HTTP Status Codes](https://httpstatuses.com/)
- [One NGINX error page to rule them all](https://blog.adriaan.io/one-nginx-error-page-to-rule-them-all.html)
- [NGINX - Custom Error Pages. A Decent Title Not Found](https://blog.swakes.co.uk/nginx-custom-error-pages/)
- [Dynamic error pages with SSI (from this handbook)](HELPERS.md#dynamic-error-pages-with-ssi)

#### :beginner: Don't duplicate `index` directive, use it only in the http block

###### Rationale

  > Use the `index` directive one time. It only needs to occur in your `http` context and it will be inherited below.

  > I think we should be careful about duplicating the same rules. But, of course, rules duplication is sometimes okay or not necessarily a great evil.

###### Example

Not recommended configuration:

```nginx
http {

  ...

  index index.php index.htm index.html;

  server {

    server_name www.example.com;

    location / {

      index index.php index.html index.$geo.html;

      ...

    }

  }

  server {

    server_name www.example.com;

    location / {

      index index.php index.htm index.html;

      ...

    }

    location /data {

      index index.php;

      ...

    }

    ...

}
```

Recommended configuration:

```nginx
http {

  ...

  index index.php index.htm index.html index.$geo.html;

  server {

    server_name www.example.com;

    location / {

      ...

    }

  }

  server {

    server_name www.example.com;

    location / {

      ...

    }

    location /data {

      ...

    }

    ...

}
```

###### External resources

- [Pitfalls and Common Mistakes - Multiple Index Directives](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#multiple-index-directives)

# Debugging

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

  > :pushpin:&nbsp; NGINX has many methods for troubleshooting issues. In this chapter I will present a few ways to deal with them.

- **[Base Rules](#base-rules)**
- **[≡ Debugging (5)](#debugging)**
  * [Use custom log formats](#beginner-use-custom-log-formats)
  * [Use debug mode to track down unexpected behaviour](#beginner-use-debug-mode-to-track-down-unexpected-behaviour)
  * [Improve debugging by disable daemon, master process, and all workers except one](#beginner-improve-debugging-by-disable-daemon-master-process-and-all-workers-except-one)
  * [Use core dumps to figure out why NGINX keep crashing](#beginner-use-core-dumps-to-figure-out-why-nginx-keep-crashing)
  * [Use mirror module to copy requests to another backend](#beginner-use-mirror-module-to-copy-requests-to-another-backend)
- **[Performance](#performance)**
- **[Hardening](#hardening)**
- **[Reverse Proxy](#reverse-proxy)**
- **[Load Balancing](#load-balancing)**
- **[Others](#others)**

#### :beginner: Use custom log formats

###### Rationale

  > Anything you can access as a variable in NGINX config, you can log, including non-standard HTTP headers, etc. so it's a simple way to create your own log format for specific situations.

  > This is extremely helpful for debugging specific `location` directives.

  > I also use custom log formats for analyze of the users traffic profiles (e.g. SSL/TLS version, ciphers, and many more).

###### Example

```nginx
# Default main log format from nginx repository:
log_format main
                '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for"';

# Extended main log format:
log_format main-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent" '
                '$request_time';

# Debug log formats:
#   - level 0
#   - based on main-level-0 without "$http_referer" "$http_user_agent"
log_format debug-level-0
                '$remote_addr - $remote_user [$time_local] '
                '"$request_method $scheme://$host$request_uri '
                '$server_protocol" $status $body_bytes_sent '
                '$request_id $pid $msec $request_time '
                '$upstream_connect_time $upstream_header_time '
                '$upstream_response_time "$request_filename" '
                '$request_completion';
```

###### External resources

- [Module ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html)
- [Nginx: Custom access log format and error levels](https://fabianlee.org/2017/02/14/nginx-custom-access-log-format-and-error-levels/)
- [nginx: Log complete request/response with all headers?](https://serverfault.com/questions/636790/nginx-log-complete-request-response-with-all-headers)
- [Custom log formats (from this handbook)](HELPERS.md#custom-log-formats)

#### :beginner: Use debug mode to track down unexpected behaviour

###### Rationale

  > It will probably return more details than you want, but that can sometimes be a lifesaver (however, log file growing rapidly on a very high-traffic sites).

  > Generally, the `error_log` directive is specified in the `main` context but you can specified inside a particular `server` or a `location` block, the global settings will be overridden and such `error_log` directive will set its own path to the log file and the level of logging.

  > It is possible to enable the debugging log for a particular IP address or a range of IP addresses (see examples).

  > The alternative method of storing the debug log is keep it in the memory (to a cyclic memory buffer). The memory buffer on the debug level does not have significant impact on performance even under high load.

  > If you want to logging of `ngx_http_rewrite_module` (at the `notice` level) you should enable `rewrite_log on;` in a `http`, `server`, or `location` contexts.

  > Words of caution:
  >
  >   - never leave debug logging to a file on in production
  >   - don't forget to revert debug-level for `error_log` on a very high traffic sites
  >   - absolutely use log rotation policy

  A while ago, I found this interesting comment:

  > _`notice` is much better than `debug` as the error level for debugging rewrites because it will skip a lot of low-level irrelevant debug info (e.g. SSL or gzip details; 50+ lines per request)._

###### Example

- Debugging log to a file:

  ```nginx
  # Turn on in a specific context, e.g.:
  #   - global    - for global logging
  #   - http      - for http and all locations logging
  #   - location  - for specific location
  error_log /var/log/nginx/error-debug.log debug;
  ```

- Debugging log to memory:

  ```nginx
  error_log memory:32m debug;
  ```

  > You can read more about that in the [Show debug log in memory](HELPERS.md#show-debug-log-in-memory) chapter.

- Debugging log for selected client connections:

  ```nginx
  events {

    # Other connections will use logging level set by the error_log directive.
    debug_connection 192.168.252.15/32;
    debug_connection 10.10.10.0/24;

  }
  ```

- Debugging log for each server:

  ```nginx
  error_log /var/log/nginx/debug.log debug;

  ...

  http {

    server {

      # To enable debugging:
      error_log /var/log/nginx/example.com/example.com-debug.log debug;
      # To disable debugging:
      error_log /var/log/nginx/example.com/example.com-debug.log;

      ...

    }

  }
  ```

###### External resources

- [Debugging NGINX](https://docs.nginx.com/nginx/admin-guide/monitoring/debugging/)
- [A debugging log](https://nginx.org/en/docs/debugging_log.html)
- [A little note to all nginx admins there - debug log](https://www.reddit.com/r/sysadmin/comments/7bofyp/a_little_note_to_all_nginx_admins_there/)
- [Error log severity levels (from this hadnbook)](NGINX_BASICS.md#error-log-severity-levels)

#### :beginner: Improve debugging by disable daemon, master process, and all workers except one

###### Rationale

  > These directives with following values are mainly used during development and debugging, e.g. while testing a bug/feature.

  > For example, `daemon off;` and `master_process off;` lets me test configurations rapidly.

  > For normal production the NGINX server will start in the background (`daemon on;`). In this way NGINX and other services are running and talking to each other. One server runs many services.

  > In a development or debugging environment (you should never run NGINX in production with this), using `master_process off;`, I usually run NGINX in the foreground without the master process and press `^C` (`SIGINT`) to terminated it simply.

  > `worker_processes 1;` is also very useful because can reduce number of worker processes and the data they generate, so that is pretty comfortable for us to debug.

###### Example

```nginx
# Update configuration file (in a global context):
daemon off
master_process off;
worker_processes 1;

# Or run NGINX from shell (oneliner):
/usr/sbin/nginx -t -g 'daemon off; master_process off; worker_processes 1;'
```

###### External resources

- [Core functionality](https://nginx.org/en/docs/ngx_core_module.html)

#### :beginner: Use core dumps to figure out why NGINX keep crashing

###### Rationale

  > A core dump is basically a snapshot of the memory when the program crashed.

  > NGINX is a very stable daemon but sometimes it can happen that there is a unique termination of the running NGINX process. You should always enable core dumps when your NGINX instance receive an unexpected error or when it crashed.

  > It ensures two important directives that should be enabled if you want the memory dumps to be saved, however, in order to properly handle memory dumps, there are a few things to do. For fully information about it see [Dump a process's memory (from this handbook)](HELPERS.md#dump-a-processs-memory) chapter.

  > Also keep in mind other debugging and troubleshooting tools such as `eBPF`, `ftrace`, `perf trace` or `strace` (note: `strace` pausing the target process for each syscall so that the debugger can read state, and doing this twice: when the syscall begins, and when it ends, so can bring down your production environment) on the worker process for syscall tracing like a `read/readv/write/writev/close/shutdown`.

###### Example

```nginx
worker_rlimit_core 500m;
worker_rlimit_nofile 65535;
working_directory /var/dump/nginx;
```

###### External resources

- [Debugging - Core dump](https://www.nginx.com/resources/wiki/start/topics/tutorials/debugging/#core-dump)
- [Debugging (from this handbook)](HELPERS.md#debugging)
- [Dump a process's memory (from this handbook)](HELPERS.md#dump-a-processs-memory)
- [Debugging socket leaks (from this handbook)](HELPERS.md#debugging-socket-leaks)
- [Debugging Symbols (from this handbook)](HELPERS.md#debugging-symbols)

#### :beginner: Use mirror module to copy requests to another backend

###### Rationale

  > Traffic mirroring is very useful to:
  >
  >   - analyzing and debugging the original request
  >   - pre-production tests (handle real production traffic)
  >   - logging of requests for security analysis and content inspection
  >   - traffic troubleshooting (diagnose errors)
  >   - copying real traffic to a test envrionment without considerable changes to the production system

  > Mirroring itself doesn’t affect original requests (only requests are analyzed, responses are not analyzed). And what's more, errors in the mirror backend don’t affect the main backend.

  If you use mirroring, keep in mind:

  > _Delayed processing of the next request is a known side-effect of how mirroring is implemented in NGINX, and this is unlikely to change. The point was to make sure this was actually the case._
  >
  > _Usually a mirror subrequest does not affect the main request. However there are two issues with mirroring:_
  >
  >   - _the next request on the same connection will not be processed until all mirror subrequests finish. Try disabling keepalive for the primary location and see if it helps_
  >
  >   - _if you use `sendfile` and `tcp_nopush`, it's possible that the response is not pushed properly because of a mirror subrequest, which may result in a delay. Turn off `sendfile` and see if it helps_

###### Example

```nginx
location / {

  log_subrequest on;

  mirror /backend-mirror;
  mirror_request_body on;

  proxy_pass http://bk_web01;

  # Indicates whether the header fields of the original request
  # and original request body are passed to the proxied server:
  proxy_pass_request_headers on;
  proxy_pass_request_body on;

  # Uncomment if you have problems with latency:
  # keepalive_timeout 0;

}

location = /backend-mirror {

  internal;
  proxy_pass http://bk_web01_debug$request_uri;

  # Pass the headers that will be sent to the mirrored backend:
  proxy_set_header M-Server-Port $server_port;
  proxy_set_header M-Server-Addr $server_addr;
  proxy_set_header M-Host $host; # or $http_host for <host:port>
  proxy_set_header M-Real-IP $remote_addr;
  proxy_set_header M-Request-ID $request_id;
  proxy_set_header M-Original-URI $request_uri;

}
```

###### External resources

- [Module ngx_http_mirror_module](http://nginx.org/en/docs/http/ngx_http_mirror_module.html)
- [nginx mirroring tips and tricks](https://alex.dzyoba.com/blog/nginx-mirror/)

# Performance

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

  > :pushpin:&nbsp; NGINX is a insanely fast, but you can adjust a few things to make sure it's as fast as possible for your use case.

- **[Base Rules](#base-rules)**
- **[Debugging](#debugging)**
- **[≡ Performance (13)](#performance)**
  * [Adjust worker processes](#beginner-adjust-worker-processes)
  * [Use HTTP/2](#beginner-use-http2)
  * [Maintaining SSL sessions](#beginner-maintaining-ssl-sessions)
  * [Enable OCSP Stapling](#beginner-enable-ocsp-stapling)
  * [Use exact names in a server_name directive if possible](#beginner-use-exact-names-in-a-server_name-directive-if-possible)
  * [Avoid checks server_name with if directive](#beginner-avoid-checks-server_name-with-if-directive)
  * [Use $request_uri to avoid using regular expressions](#beginner-use-request_uri-to-avoid-using-regular-expressions)
  * [Use try_files directive to ensure a file exists](#beginner-use-try_files-directive-to-ensure-a-file-exists)
  * [Use return directive instead of rewrite for redirects](#beginner-use-return-directive-instead-of-rewrite-for-redirects)
  * [Enable PCRE JIT to speed up processing of regular expressions](#beginner-enable-pcre-jit-to-speed-up-processing-of-regular-expressions)
  * [Activate the cache for connections to upstream servers](#beginner-activate-the-cache-for-connections-to-upstream-servers)
  * [Make an exact location match to speed up the selection process](#beginner-make-an-exact-location-match-to-speed-up-the-selection-process)
  * [Use limit_conn to improve limiting the download speed](#beginner-use-limit_conn-to-improve-limiting-the-download-speed)
- **[Hardening](#hardening)**
- **[Reverse Proxy](#reverse-proxy)**
- **[Load Balancing](#load-balancing)**
- **[Others](#others)**

#### :beginner: Adjust worker processes

###### Rationale

  > The `worker_processes` directive is the sturdy spine of life for NGINX. This directive is responsible for letting our virtual server know many workers to spawn once it has become bound to the proper IP and port(s) and its value is helpful in CPU-intensive work.

  > The safest setting is to use the number of cores by passing `auto`. You can adjust this value to maximum throughput under high concurrency. The value should be changed to an optimal value depending on the number of cores available, disks, network subsystem, server load, and so on.

  > How many worker processes do you need? Do some multiple load testing. Hit the app hard and see what happens with only one. Then add some more to it and hit it again. At some point you'll reach a point of truly saturating the server resources. That's when you know you have the right balance.

  > In my opinion, for high load proxy servers (also standalone servers) interesting value is `ALL_CORES - 1` (or more) because if you're running NGINX with other critical services on the same server, you're just going to thrash the CPUs with all the context switching required to manage all of those processes.

  > Rule of thumb: If much time is spent blocked on I/O, worker processes should be increased further.

  > Increasing the number of worker processes is a great way to overcome a single CPU core bottleneck, but may opens a whole [new set of problems](https://blog.cloudflare.com/the-sad-state-of-linux-socket-balancing/).

  Official NGINX documentation say:

  > _When one is in doubt, setting it to the number of available CPU cores would be a good start (the value "auto" will try to autodetect it). [...] running one worker process per CPU core - makes the most efficient use of hardware resources._

###### Example

```nginx
# The safest and recommend way:
worker_processes auto;

# Alternative:
# VCPU = 4 , expr $(nproc --all) - 1, grep "processor" /proc/cpuinfo | wc -l
worker_processes 3;
```

###### External resources

- [Nginx Core Module - worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes)
- [Processes (from this handbook)](NGINX_BASICS.md#processes)

#### :beginner: Use HTTP/2

###### Rationale

  > HTTP/2 will make our applications faster, simpler, and more robust. The primary goals for HTTP/2 are to reduce latency by enabling full request and response multiplexing, minimise protocol overhead via efficient compression of HTTP header fields, and add support for request prioritisation and server push. HTTP/2 has also a extremely large [blacklist](https://http2.github.io/http2-spec/#BadCipherSuites) of old and insecure ciphers.

  > `http2` directive configures the port to accept HTTP/2 connections. This doesn't mean it accepts only HTTP/2 connections. HTTP/2 is backwards-compatible with HTTP/1.1, so it would be possible to ignore it completely and everything will continue to work as before because if the client that does not support HTTP/2 will never ask the server for an HTTP/2 communication upgrade: the communication between them will be fully HTTP1/1.

  > HTTP/2 multiplexes many requests within a single TCP connection. Typically, a single TCP connection is established to a server when HTTP/2 is in use.

  > You should also enable the `ssl` parameter (but NGINX can also be configured to accept HTTP/2 connections without SSL), required because browsers do not support HTTP/2 without encryption (the h2 specification, allows to use HTTP/2 over an unsecure `http://` scheme, but browsers have not implemented this (and most do not plan to)). Note that accepting HTTP/2 connections over TLS requires the "Application-Layer Protocol Negotiation" (ALPN) TLS extension support.

  > Obviously, there is no pleasure without pain. HTTP/2 is more secure than HTTP/1.1, however, there are serious vulnerabilities detected in the HTTP/2 protocol. For more information please see [HTTP/2 can shut you down!](https://www.secpod.com/blog/http2-dos-vulnerabilities/), [On the recent HTTP/2 DoS attacks](https://blog.cloudflare.com/on-the-recent-http-2-dos-attacks/), and [HTTP/2: In-depth analysis of the top four flaws of the next generation web protocol](https://www.imperva.com/docs/Imperva_HII_HTTP2.pdf) <sup>[pdf]</sup>.

  > Let's not forget about backwards-compatible with HTTP/1.1, also when it comes to security. Many of the vulnerabilities for HTTP/1.1 may be present in HTTP/2.

  > To test your server with [RFC 7540](https://tools.ietf.org/html/rfc7540) <sup>[IETF]</sup> (HTTP/2) and [RFC 7541](https://tools.ietf.org/html/rfc7541) <sup>[IETF]</sup> (HPACK) use [h2spec](https://github.com/summerwind/h2spec) tool.

###### Example

```nginx
server {

  listen 10.240.20.2:443 ssl http2;

  ...
```

###### External resources

- [RFC 7540 - HTTP/2](https://tools.ietf.org/html/rfc7540) <sup>[IETF]</sup>
- [RFC 7540 - HTTP/2: Security Considerations](https://tools.ietf.org/html/rfc7540#section-10) <sup>[IETF]</sup>
- [Introduction to HTTP/2](https://developers.google.com/web/fundamentals/performance/http2/)
- [What is HTTP/2 - The Ultimate Guide](https://kinsta.com/learn/what-is-http2/)
- [The HTTP/2 Protocol: Its Pros & Cons and How to Start Using It](https://www.upwork.com/hiring/development/the-http2-protocol-its-pros-cons-and-how-to-start-using-it/)
- [HTTP/2 Compatibility with old Browsers and Servers](http://qnimate.com/http2-compatibility-with-old-browsers-and-servers/)
- [HTTP 2 protocol – it is faster, but is it also safer?](https://research.securitum.com/http-2-protocol-it-is-faster-but-is-it-also-safer/)
- [HTTP/2 Denial of Service Advisory](https://github.com/Netflix/security-bulletins/blob/master/advisories/third-party/2019-002.md)
- [HTTP/2, Brute! Then fall, server. Admin! Ops! The server is dead](https://www.theregister.co.uk/2019/08/14/http2_flaw_server/)
- [HTTP Headers (from this handbook)](HTTP_BASICS.md#http-headers)

#### :beginner: Maintaining SSL sessions

###### Rationale

  > Default, "built-in" session cache is not optimal as it can be used by only one worker process and can cause memory fragmentation.

  > Enabling session caching with `ssl_session_cache` directive helps to reduce NGINX server CPU load. This also improves performance from the clients’ perspective because it eliminates the need for a new (and time-consuming) SSL handshake to be conducted each time a request is made. What's more, it is much better to use shared cache.

  > When using `ssl_session_cache`, the performance of keep-alive connections over SSL might be enormously increased. 10M value of this is a good starting point (1MB shared cache can hold approximately 4,000 sessions). With `shared` a cache shared between all worker processes (a cache with the same name can be used in several virtual servers).

  > For TLSv1.2, the [RFC 5246 - Resuming Sessions](https://tools.ietf.org/html/rfc5246#appendix-F.1.4) recommends that sessions are not kept alive for more than 24 hours (it is the maximum time). Generally, TLS sessions cannot be resumed unless both the client and server agree and should force a full handshake if either party suspects that the session may have been compromised, or that certificates may have expired or been revoked. But a while ago, I found `ssl_session_timeout` with less time (e.g. 15 minutes) for prevent abused by advertisers like Google and Facebook, I don't know, I guess it makes sense.

  On the other hand, [RFC 5077 - Ticket Lifetime](https://tools.ietf.org/html/rfc5077#section-5.6) says:

  > _The ticket lifetime may be longer than the 24-hour lifetime recommended in [RFC4346](https://tools.ietf.org/html/rfc4346). TLS clients may be given a hint of the lifetime of the ticket. Since the lifetime of a ticket may be unspecified, a client has its own local policy that determines when it discards tickets._

  > Most servers do not purge sessions or ticket keys, thus increasing the risk that a server compromise would leak data from previous (and future) connections.

  > [Vincent Bernat](https://vincent.bernat.ch/en) written great [tool](https://github.com/vincentbernat/rfc5077/blob/master/rfc5077-client.c) for testing session resume with and without tickets.

  [Ivan Ristić](https://twitter.com/ivanristic) (Founder of Hardenize) say:

  > _Session resumption either creates a large server-side cache that can be broken into or, with tickets, kills forward secrecy. So you have to balance performance (you don't want your users to use full handshakes on every connection) and security (you don't want to compromise it too much). Different projects dictate different settings. [...] One reason not to use a very large cache (just because you can) is that popular implementations don't actually delete any records from there; even the expired sessions are still in the cache and can be recovered. The only way to really delete is to overwrite them with a new session. [...] These days I'd probably reduce the maximum session duration to 4 hours, down from 24 hours currently in my book. But that's largely based on a gut feeling that 4 hours is enough for you to reap the performance benefits, and using a shorter lifetime is always better._

  [Ilya Grigorik](https://www.igvita.com/) (Web performance engineer at Google) say about SSL buffers:

  > _1400 bytes (actually, it should probably be even a bit lower) is the recommended setting for interactive traffic where you want to avoid any unnecessary delays due to packet loss/jitter of fragments of the TLS record. However, packing each TLS record into dedicated packet does add some framing overhead and you probably want larger record sizes if you're streaming larger (and less latency sensitive) data. 4K is an in between value that's "reasonable" but not great for either case. For smaller records, we should also reserve space for various TCP options (timestamps, SACKs. up to 40 bytes), and account for TLS record overhead (another 20-60 bytes on average, depending on the negotiated ciphersuite). All in all: 1500 - 40 (IP) - 20 (TCP) - 40 (TCP options) - TLS overhead (60-100) ~= 1300 bytes. If you inspect records emitted by Google servers, you'll see that they carry ~1300 bytes of application data due to the math above._

  The other recommendation (it seems to me that the authors are Leif Hedstrom, Thomas Jackson, Brian Geffon) is to use the below values:

  > - smaller TLS record size: MTU/MSS (1500) minus the TCP (20 bytes) and IP (40 bytes) overheads: 1500 - 40 - 20 = 1440 bytes<br>
  > - larger TLS record size: maximum TLS record size which is 16383 (2^14 - 1)

###### Example

```nginx
ssl_session_cache shared:NGX_SSL_CACHE:10m;
ssl_session_timeout 4h;
ssl_session_tickets off;
ssl_buffer_size 1400;
```

###### External resources

- [SSL Session (cache)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache)
- [Speeding up TLS: enabling session reuse](https://vincent.bernat.ch/en/blog/2011-ssl-session-reuse-rfc5077)
- [SSL Session Caching (in nginx)](https://www.hezmatt.org/~mpalmer/blog/2011/06/28/ssl-session-caching-in-nginx.html)
- [ssl_session_cache in Nginx and the ab benchmark](https://www.peterbe.com/plog/ssl_session_cache-ab)
- [Improving OpenSSL Performance](https://software.intel.com/en-us/articles/improving-openssl-performance)

#### :beginner: Enable OCSP Stapling

###### Rationale

  > Unlike OCSP, in the OCSP Stapling mechanism the user's browser does not contact the issuer of the certificate, but does it at regular intervals by the application server.

  > OCSP Stapling extension is configured for better performance (is designed to reduce the cost of an OCSP validation; improves browser communication performance with the application server and allows to retrieve information about the validity of the certificate at the time of accessing the application) and user privacy is still maintained. OCSP Stapling is an optimization, and nothing breaks if it doesn't work.

  > The use of the OCSP without the implementation of the OCSP Stapling extension is associated with an increased risk of losing user privacy, as well as an increased risk of negative impact on the availability of applications due to the inability to verify the validity of the certificate.

  > OCSP Stapling defines OCSP response in TLS Certificate Status Request ([RFC 6066 - Certificate Status Request](https://tools.ietf.org/html/rfc6066#section-8)) extension ("stapling"). In this case, server sends the OCSP response as part of TLS extension, hence the client need not have to check it on OCSP URL (saves revocation checking time for client).

  > NGINX provides several options to keep in mind. For example: it generate list from the file of certificates pointed to by `ssl_trusted_certificate` (the list of these certificates will not be sent to clients). You need to send this list or switch off `ssl_verify_client`. This step is optional when the full certificate chain (only Intermediate certs, without Root CA, and also must not include the site certificate) was already provided with the `ssl_certificate` statement. In case just the certificate is being used (not the parts of your CA), then `ssl_trusted_certificate` is needed.

  > I found on the web that both type of chains (RootCA + Intermediate certs or only Intermediate certs) will work as the `ssl_trusted_certificate` for the purpose of OCSP verification. The root is not recommended and not needed in `ssl_certificate`. If you use Let’s Encrypt you don't need to add the RootCA (to `ssl_trusted_certificate`) because the OCSP response is signed by the intermediate certificate itself. I think, that the safest way is to include all corresponding Root and Intermediate CA certificates in `ssl_trusted_certificate`.

  > I always use the most stable DNS resolver like Google's `8.8.8.8`, Quad9’s `9.9.9.9`, CloudFlare's `1.1.1.1`, or OpenDNS's `208.67.222.222` (of course you can use resolving domains internally and externally with Bind9 or whatever else). If `resolver` line isn't added or your NGINX will not have an external access, the resolver defaults to the server's DNS default.

  > You should know, that too short resolver timeout (default of 30 seconds) can be another reason for OCSP Stapling to fail (temporarily). If the NGINX `resolver_timeout` directive is set to very low values (< 5 seconds), log messages like this can appear: `"[...] ssl_stapling" ignored, host not found in OCSP responder [...]`.

  > Also bear in mind that NGINX lazy-loads OCSP responses. So, the first request will not have a stapled response, but subsequent requests will. This is, because NGINX will not prefetch OCSP responses at server startup (or after reload).

  Important information from NGINX documentation:

  > _For the OCSP stapling to work, the certificate of the server certificate issuer should be known. If the `ssl_certificate` file does not contain intermediate certificates, the certificate of the server certificate issuer should be present in the `ssl_trusted_certificate` file._

  > _To prevent DNS spoofing (`resolver`), it is recommended configuring DNS servers in a properly secured trusted local network._

###### Example

```nginx
# Turn on OCSP Stapling:
ssl_stapling on;

# Enable the server to check OCSP:
ssl_stapling_verify on;

# Point to a trusted CA (the company that signed our CSR) certificate chain
# (Intermediate certificates in that order from top to bottom) file, but only,
# if NGINX can not find the top level certificates from ssl_certificate:
ssl_trusted_certificate /etc/nginx/ssl/inter-CA-chain.pem

# For a resolution of the OCSP responder hostname, set resolvers and their cache time:
resolver 1.1.1.1 8.8.8.8 valid=300s;
resolver_timeout 5s;
```

To test OCSP Stapling:

```bash
openssl s_client -connect example.com:443 -servername example.com -tlsextdebug -status
echo | openssl s_client -connect example.com:443 -servername example.com -status 2> /dev/null | grep -A 17 'OCSP response:'
```

###### External resources

- [RFC 2560 - X.509 Internet Public Key Infrastructure Online Certificate Status Protocol - OCSP](https://tools.ietf.org/html/rfc2560)
- [OCSP Stapling on nginx](https://raymii.org/s/tutorials/OCSP_Stapling_on_nginx.html)
- [OCSP Stapling: Performance](https://www.tunetheweb.com/performance/ocsp-stapling/)
- [OCSP Stapling; SSL with added speed and privacy](https://scotthelme.co.uk/ocsp-stapling-speeding-up-ssl/)
- [High-reliability OCSP stapling and why it matters](https://blog.cloudflare.com/high-reliability-ocsp-stapling/)
- [OCSP Stapling: How CloudFlare Just Made SSL 30% Faster](https://blog.cloudflare.com/ocsp-stapling-how-cloudflare-just-made-ssl-30/)
- [Is the web ready for OCSP Must-Staple?](https://blog.apnic.net/2019/01/15/is-the-web-ready-for-ocsp-must-staple/)
- [The case for "OCSP Must-Staple"](https://www.grc.com/revocation/ocsp-must-staple.htm)
- [Page Load Optimization: OCSP Stapling](https://www.ssl.com/article/page-load-optimization-ocsp-stapling/)
- [ImperialViolet - No, don't enable revocation checking](https://www.imperialviolet.org/2014/04/19/revchecking.html)
- [The Problem with OCSP Stapling and Must Staple and why Certificate Revocation is still broken](https://blog.hboeck.de/archives/886-The-Problem-with-OCSP-Stapling-and-Must-Staple-and-why-Certificate-Revocation-is-still-broken.html)
- [Damn it, nginx! stapling is busted](https://blog.crashed.org/nginx-stapling-busted/)
- [Priming the OCSP cache in Nginx](https://unmitigatedrisk.com/?p=241)
- [How to make OCSP stapling on nginx work](https://matthiasadler.info/blog/ocsp-stapling-on-nginx-with-comodo-ssl/)
- [HAProxy OCSP stapling](https://icicimov.github.io/blog/server/HAProxy-OCSP-stapling/)
- [DNS Resolvers Performance compared: CloudFlare x Google x Quad9 x OpenDNS](https://medium.com/@nykolas.z/dns-resolvers-performance-compared-cloudflare-x-google-x-quad9-x-opendns-149e803734e5)
- [OCSP Validation with OpenSSL](https://akshayranganath.github.io/OCSP-Validation-With-Openssl/)

#### :beginner: Use exact names in a `server_name` directive if possible

###### Rationale

  > Exact names, wildcard names starting with an asterisk, and wildcard names ending with an asterisk are stored in three hash tables bound to the listen ports.

  > The exact names hash table is searched first. So if the most frequently requested names of a server are `example.com` and `www.example.com`, it is more efficient to define them explicitly.

  > If the exact name is not found, the hash table with wildcard names starting with an asterisk is searched. If the name is not found there, the hash table with wildcard names ending with an asterisk is searched. Searching wildcard names hash table is slower than searching exact names hash table because names are searched by domain parts.

  >  When searching for a virtual server by name, if name matches more than one of the specified variants, e.g. both wildcard name and regular expression match, the first matching variant will be chosen, in the following order of precedence:
  >
  > - exact name
  > - longest wildcard name starting with an asterisk, e.g. `*.example.org`
  > - longest wildcard name ending with an asterisk, e.g. `mail.*`
  > - first matching regular expression (in order of appearance in a configuration file)

  > Regular expressions are tested sequentially and therefore are the slowest method and are non-scalable. For these reasons, it is better to use exact names where possible.

  From official documentation:

  > _A wildcard name may contain an asterisk only on the name’s start or end, and only on a dot border. The names `www.*.example.org` and `w*.example.org` are invalid. [...] A special wildcard name in the form `.example.org` can be used to match both the exact name `example.org` and the wildcard name `*.example.org`._

  > _The name `*.example.org` matches not only `www.example.org` but `www.sub.example.org` as well._

  > _To use a regular expression, the server name must start with the tilde character. [...] otherwise it will be treated as an exact name, or if the expression contains an asterisk, as a wildcard name (and most likely as an invalid one). Do not forget to set `^` and `$` anchors. They are not required syntactically, but logically. Also note that domain name dots should be escaped with a backslash. A regular expression containing the characters `{` and `}` should be quoted._

###### Example

Not recommended configuration:

```nginx
server {

  listen 192.168.252.10:80;

  # From official documentation: "Searching wildcard names hash table is slower than searching exact names
  # hash table because names are searched by domain parts. Note that the special wildcard form
  # '.example.org' is stored in a wildcard names hash table and not in an exact names hash table.":
  server_name .example.org;

  ...

}
```

Recommended configuration:

```nginx
# It is more efficient to define them explicitly:
server {

  listen 192.168.252.10:80;

  # .example.org = *.example.org
  server_name example.org www.example.org *.example.org;

  ...

}
```

###### External resources

- [Server names](https://nginx.org/en/docs/http/server_names.html)
- [Server Naming Conventions and Best Practices](https://blog.serverdensity.com/server-naming-conventions-and-best-practices/)
- [Server/Device Naming](https://www.vita.virginia.gov/media/vitavirginiagov/it-governance/ea/pdf/Server-Device-Naming-Technical-Brief.pdf) <sup>[pdf]</sup>
- [Handle incoming connections (from this handbook)](NGINX_BASICS.md#handle-incoming-connections)

#### :beginner: Avoid checks `server_name` with `if` directive

###### Rationale

  > When NGINX receives a request no matter what is the subdomain being requested, be it `www.example.com` or just the plain `example.com` this `if` directive is always evaluated. Since you’re requesting NGINX to check for the `Host` header for every request. It might be extremely inefficient.

  > Instead use two server directives like the example below. This approach decreases NGINX processing requirements.

  > The problem is not just the `$server_name` directive. Keep in mind also other variables, e.g. `$scheme`. In some cases (but not always), it is better to add an additional block directive than to use the `if`.

  On the other hand, official documentation say:

  > _Directive if has problems when used in location context, in some cases it doesn’t do what you expect but something completely different instead. In some cases it even segfaults. It’s generally a good idea to avoid it if possible._

###### Example

Not recommended configuration:

```nginx
server {

  server_name example.com www.example.com;

  if ($host = www.example.com) {

    return 301 https://example.com$request_uri;

  }

  server_name example.com;

  ...

}
```

Recommended configuration:

```nginx
server {

    listen 192.168.252.10:80;

    server_name www.example.com;

    return 301 $scheme://example.com$request_uri;

    # If you force your web traffic to use HTTPS:
    # return 301 https://example.com$request_uri;

    ...

}

server {

    listen 192.168.252.10:80;

    server_name example.com;

    ...

}
```

###### External resources

- [If Is Evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/)
- [if, break, and set (from this handbook)](NGINX_BASICS.md#if-break-and-set)

#### :beginner: Use `$request_uri` to avoid using regular expressions

###### Rationale

  > With built-in `$request_uri` we can effectively avoid doing any capturing or matching at all. By default, the regex is costly and will slow down the performance.

  > This rule is addressing passing the URL unchanged to a new host, sure return is more efficient just passing through the existing URI.

  > The value of `$request_uri` is always the original URI (full original request URI with arguments) as received from the client and is not subject to any normalisations compared to the `$uri` directive.

  > Use `$request_uri` in a map directive, if you need to match the URI and its query string.

  > An unconsidered use the `$request_uri` can lead to many strange behaviors. For example, using `$request_uri` in the wrong place can cause URL encoded characters to become doubly encoded. So the most of the time you would use `$uri`, because it is normalised.

  I think the best explanation comes from the official documentation:

  > _Don’t feel bad here, it’s easy to get confused with regular expressions. In fact, it’s so easy to do that we should make an effort to keep them neat and clean._

###### Example

Not recommended configuration:

```nginx
# 1)
rewrite ^/(.*)$ https://example.com/$1 permanent;

# 2)
rewrite ^ https://example.com$request_uri permanent;
```

Recommended configuration:

```nginx
return 301 https://example.com$request_uri;
```

###### External resources

- [Pitfalls and Common Mistakes - Taxing Rewrites](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#taxing-rewrites)
- [Module ngx_http_proxy_module - proxy_pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)
- [uri vs request_uri (from this handbook)](NGINX_BASICS.md#uri-vs-request_uri)

#### :beginner: Use `try_files` directive to ensure a file exists

###### Rationale

  > `try_files` is definitely a very useful thing. You can use `try_files` directive to check a file exists in a specified order.

  > You should use `try_files` instead of `if` directive. It's definitely better way than using `if` for this action because `if` directive is extremely inefficient since it is evaluated every time for every request.

  > The advantage of using `try_files` is that the behavior switches immediately with one command. I think the code is more readable also.

  > `try_files` allows you:
  >
  > - to check if the file exists from a predefined list
  > - to check if the file exists from a specified directory
  > - to use an internal redirect if none of the files are found

###### Example

Not recommended configuration:

```nginx
server {

  ...

  root /var/www/example.com;

  location /images {

    if (-f $request_filename) {

      expires 30d;
      break;

    }

  ...

}
```

Recommended configuration:

```nginx
server {

  ...

  root /var/www/example.com;

  location /images {

    try_files $uri =404;

  ...

}
```

###### External resources

- [Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)
- [Pitfalls and Common Mistakes](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/)
- [Serving Static Content](https://docs.nginx.com/nginx/admin-guide/web-server/serving-static-content/)
- [Serve files with nginx conditionally](http://www.lazutkin.com/blog/2014/02/23/serve-files-with-nginx-conditionally/)
- [try_files directive (from this hadnbook)](NGINX_BASICS.md#try_files-directive)

#### :beginner: Use `return` directive instead of `rewrite` for redirects

###### Rationale

  > For me, ability to rewrite URLs in NGINX is an extremely powerful and important feature. Technically, you can use both options but in my opinion you should use `server` blocks and `return` statements as they are way simpler and faster than evaluating RegEx e.g. via `location` blocks.

  > NGINX has to process and start a search. `return` directive stops processing (it directly stops execution) and returns the specified code to a client. This is preferred in any context.

  > If you have a scenario where you need to validate the URL with a regex or need to capture elements in the original URL (that are obviously not in a corresponding NGINX variable), then you should use `rewrite`.

###### Example

Not recommended configuration:

```nginx
server {

  ...

  location / {

    try_files $uri $uri/ =404;

    rewrite ^/(.*)$ https://example.com/$1 permanent;

  }

  ...

}
```

Recommended configuration:

```nginx
server {

  ...

  location / {

    try_files $uri $uri/ =404;

    return 301 https://example.com$request_uri;

  }

  ...

}
```

###### External resources

- [NGINX - rewrite vs redirect](http://think-devops.com/blogs/nginx-rewrite-redirect.html)
- [If Is Evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/)
- [rewrite vs return (from this handbook)](NGINX_BASICS.md#rewrite-vs-return)
- [Use return directive for URL redirection (301, 302) - Base Rules - P2 (from this handbook)](#beginner-use-return-directive-for-url-redirection-301-302)

#### :beginner: Enable PCRE JIT to speed up processing of regular expressions

###### Rationale

  > Enables the use of JIT for regular expressions to speed-up their processing. Specifically, checking rules can be time-consuming, especially complex regular expression (regex) conditions.

  > By compiling NGINX with the PCRE library, you can perform complex manipulations with your `location` blocks and use the powerful `rewrite` directives.

  > PCRE JIT rule-matching engine can speed up processing of regular expressions significantly. NGINX with `pcre_jit` is magnitudes faster than without it. This option can improve performance, however, in some cases `pcre_jit` may have a negative effect. So, before enabling it, I recommend you to read this great document: [PCRE Performance Project](https://zherczeg.github.io/sljit/pcre.html).

  > If you’ll try to use `pcre_jit on;` without JIT available, or if NGINX was compiled with JIT available, but currently loaded PCRE library does not support JIT, will warn you during configuration parsing.

  > The `--with-pcre-jit` is only needed when you compile PCRE library using NGNIX configure (`./configure --with-pcre=`). When using a system PCRE library whether or not JIT is supported depends on how the library was compiled.

  > If you don't pass `--with-pcre-jit`, the NGINX configure scripts are smart enough to detect and enable it automatically. See [here](http://hg.nginx.org/nginx/file/abd40ce603fa/auto/lib/pcre/conf). So, if your PCRE library is recent enough, a simple `./configure` with no switches will compile NGINX with `pcre_jit` enabled.

  From NGINX documentation:

  > _The JIT is available in PCRE libraries starting from version 8.20 built with the `--enable-jit` configuration parameter. When the PCRE library is built with nginx (`--with-pcre=`), the JIT support is enabled via the `--with-pcre-jit` configuration parameter._

###### Example

```nginx
# In global context:
pcre_jit on;
```

###### External resources

- [Core functionality - pcre jit](https://nginx.org/en/docs/ngx_core_module.html#pcre_jit)
- [Performance comparison of regular expression engines](https://nasciiboy.land/raptorVSworld/)
- [Building OpenResty with PCRE JIT](https://www.cryptobells.com/building-openresty-with-pcre-jit/)

#### :beginner: Activate the cache for connections to upstream servers

###### Rationale

  > The idea behind keepalive is to address the latency of establishing TCP connections over high-latency networks. This connection cache is useful in situations where NGINX has to constantly maintain a certain number of open connections to an upstream server.

  > Keep-Alive connections can have a major impact on performance by reducing the CPU and network overhead needed to open and close connections. With HTTP keepalive enabled in NGINX upstream servers reduces latency thus improves performance and it reduces the possibility that the NGINX runs out of ephemeral ports.

  > This can greatly reduce the number of new TCP connections, as NGINX can now reuse its existing connections (`keepalive`) per upstream.

  > If your upstream server supports Keep-Alive in its config, NGINX will now reuse existing TCP connections without creating new ones. This can greatly reduce the number of sockets in `TIME_WAIT` TCP connections on a busy servers (less work for OS to establish new connections, less packets on a network).

  > Keep-Alive connections are only supported as of HTTP/1.1.

###### Example

```nginx
# Upstream context:
upstream backend {

  # Sets the maximum number of idle keepalive connections to upstream servers
  # that are preserved in the cache of each worker process.
  keepalive 16;

}

# Server/location contexts:
server {

  ...

  location / {

    # By default only talks HTTP/1 to the upstream,
    # keepalive is only enabled in HTTP/1.1:
    proxy_http_version 1.1;

    # Remove the Connection header if the client sends it,
    # it could be "close" to close a keepalive connection:
    proxy_set_header Connection "";

    ...

  }

}
```

###### External resources

- [NGINX keeps sending requests to offline upstream](https://serverfault.com/a/883019)
- [HTTP Keep-Alive connections (from this handbook)](NGINX_BASICS.md#http-keep-alive-connections)

#### :beginner: Make an exact location match to speed up the selection process

###### Rationale

  > Exact location matches are often used to speed up the selection process by immediately ending the execution of the algorithm.

  > Regexes when present take precedence over simple URI matching and can add significant computational overhead depending on their complexity.

  > Using the `=` modifier it is possible to define an exact match of URI and location. It is very fast to process and save a significant amount of CPU cycles.

  > If an exact match is found, the search terminates. For example, if a `/` request happens frequently, defining `location = /` will speed up the processing of these requests, as search terminates right after the first comparison. Such a location cannot obviously contain nested locations.

###### Example

```nginx
# Matches the query / only and stops searching:
location = / {

  ...

}

# Matches the query /v9 only and stops searching:
location = /v9 {

  ...

}

...

# Matches any query due to the fact that all queries begin at /,
# but regular expressions and any longer conventional blocks will be matched at first place:
location / {

  ...

}
```

###### External resources

- [Untangling the nginx location block matching algorithm](https://artfulrobot.uk/blog/untangling-nginx-location-block-matching-algorithm)

#### :beginner: Use `limit_conn` to improve limiting the download speed

###### Rationale

  > NGINX provides two directives to limiting download speed:
  >   - `limit_rate_after` - sets the amount of data transferred before the `limit_rate` directive takes effect
  >   - `limit_rate` - allows you to limit the transfer rate of individual client connections (past exceeding `limit_rate_after`)

  > This solution limits NGINX download speed per connection, so, if one user opens multiple e.g. video files, it will be able to download `X * the number of times` he connected to the video files.

  > To prevent this situation use `limit_conn_zone` and `limit_conn` directives.

###### Example

```nginx
# Create limit connection zone:
limit_conn_zone $binary_remote_addr zone=conn_for_remote_addr:1m;

# Add rules to limiting the download speed:
limit_rate_after 1m;  # run at maximum speed for the first 1 megabyte
limit_rate 250k;      # and set rate limit after 1 megabyte

# Enable queue:
location /videos {

  # Max amount of data by one client: 10 megabytes (limit_rate_after * 10)
  limit_conn conn_for_remote_addr 10;

  ...
```

###### External resources

- [How to Limit Nginx download Speed](https://www.scalescale.com/tips/nginx/how-to-limit-nginx-download-speed/)

# Hardening

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

  > :pushpin:&nbsp; In this chapter I will talk about some of the NGINX hardening approaches and security standards.

- **[Base Rules](#base-rules)**
- **[Debugging](#debugging)**
- **[Performance](#performance)**
- **[≡ Hardening (31)](#hardening)**
  * [Always keep NGINX up-to-date](#beginner-always-keep-nginx-up-to-date)
  * [Run as an unprivileged user](#beginner-run-as-an-unprivileged-user)
  * [Disable unnecessary modules](#beginner-disable-unnecessary-modules)
  * [Protect sensitive resources](#beginner-protect-sensitive-resources)
  * [Take care about your ACL rules](#beginner-take-care-about-your-acl-rules)
  * [Hide Nginx version number](#beginner-hide-nginx-version-number)
  * [Hide Nginx server signature](#beginner-hide-nginx-server-signature)
  * [Hide upstream proxy headers](#beginner-hide-upstream-proxy-headers)
  * [Remove support for legacy and risky HTTP request headers](#beginner-remove-support-for-legacy-and-risky-http-request-headers)
  * [Use only the latest supported OpenSSL version](#beginner-use-only-the-latest-supported-openssl-version)
  * [Force all connections over TLS](#beginner-force-all-connections-over-tls)
  * [Use min. 2048-bit for RSA and 256-bit for ECC](#beginner-use-min-2048-bit-for-rsa-and-256-bit-for-ecc)
  * [Keep only TLS 1.3 and TLS 1.2](#beginner-keep-only-tls-13-and-tls-12)
  * [Use only strong ciphers](#beginner-use-only-strong-ciphers)
  * [Use more secure ECDH Curve](#beginner-use-more-secure-ecdh-curve)
  * [Use strong Key Exchange with Perfect Forward Secrecy](#beginner-use-strong-key-exchange-with-perfect-forward-secrecy)
  * [Prevent Replay Attacks on Zero Round-Trip Time](#beginner-prevent-replay-attacks-on-zero-round-trip-time)
  * [Defend against the BEAST attack](#beginner-defend-against-the-beast-attack)
  * [Mitigation of CRIME/BREACH attacks](#beginner-mitigation-of-crimebreach-attacks)
  * [Enable HTTP Strict Transport Security](#beginner-enable-http-strict-transport-security)
  * [Reduce XSS risks (Content-Security-Policy)](#beginner-reduce-xss-risks-content-security-policy)
  * [Control the behaviour of the Referer header (Referrer-Policy)](#beginner-control-the-behaviour-of-the-referer-header-referrer-policy)
  * [Provide clickjacking protection (X-Frame-Options)](#beginner-provide-clickjacking-protection-x-frame-options)
  * [Prevent some categories of XSS attacks (X-XSS-Protection)](#beginner-prevent-some-categories-of-xss-attacks-x-xss-protection)
  * [Prevent Sniff Mimetype middleware (X-Content-Type-Options)](#beginner-prevent-sniff-mimetype-middleware-x-content-type-options)
  * [Deny the use of browser features (Feature-Policy)](#beginner-deny-the-use-of-browser-features-feature-policy)
  * [Reject unsafe HTTP methods](#beginner-reject-unsafe-http-methods)
  * [Prevent caching of sensitive data](#beginner-prevent-caching-of-sensitive-data)
  * [Limit concurrent connections](#beginner-limit-concurrent-connections)
  * [Control Buffer Overflow attacks](#beginner-control-buffer-overflow-attacks)
  * [Mitigating Slow HTTP DoS attacks (Closing Slow Connections)](#beginner-mitigating-slow-http-dos-attacks-closing-slow-connections)
- **[Reverse Proxy](#reverse-proxy)**
- **[Load Balancing](#load-balancing)**
- **[Others](#others)**

#### :beginner: Always keep NGINX up-to-date

###### Rationale

  > NGINX is a very secure and stable but vulnerabilities in the main binary itself do pop up from time to time. It's the main reason for keep NGINX up-to-date as hard as you can.

  > When planning the NGINX update/upgrade process, the best way is simply to install the newly released version. But for me, the most common way to handle NGINX updates is to wait a few weeks after the stable release (and reading community comments of all possible and identified issues after the release of the new NGINX version).

  > Most modern GNU/Linux distros will not push the latest version of NGINX into their default package lists so maybe you should consider install it from sources.

  > Before update/upgrade NGINX remember about:
  >   - do it on the testing environment in the first place
  >   - make sure to make a backup of your current configuration before updating

###### Example

```bash
# RedHat/CentOS
yum install <pkgname>

# Debian/Ubuntu
apt-get install <pkgname>

# FreeBSD/OpenBSD
pkg -f install <pkgname>
```

###### External resources

- [Installing from prebuilt packages (from this handbook)](HELPERS.md#installing-from-prebuilt-packages)
- [Installing from source (from this handbook)](HELPERS.md#installing-from-source)

#### :beginner: Run as an unprivileged user

###### Rationale

  > It is an important general principle that programs have the minimal amount of privileges necessary to do its job. That way, if the program is broken, its damage is limited.

  > There is no real difference in security just by changing the process owner name. On the other hand, in security, the principle of least privilege states that an entity should be given no more permission than necessary to accomplish its goals within a given system. This way only master process runs as root.

  > NGINX meets these requirements and it is the default behaviour, but remember to check it.

  From [Secure Programming HOWTO - 7.4. Minimize Privileges](https://dwheeler.com/secure-programs/3.71/Secure-Programs-HOWTO/minimize-privileges.html) article:

  > _The most extreme example is to simply not write a secure program at all - if this can be done, it usually should be. For example, don't make your program `setuid` or `setgid` if you can; just make it an ordinary program, and require the administrator to log in as such before running it._

###### Example

```bash
# Edit/check nginx.conf:
user nginx;   # or 'www' for example; if group is omitted,
              # a group whose name equals that of user is used

# Check/set owner and group for root directory:
chown -R root:root /etc/nginx

# Set owner and group for app directory:
chown -R nginx:nginx /var/www/example.com
```

###### External resources

- [Why does nginx starts process as root?](https://unix.stackexchange.com/questions/134301/why-does-nginx-starts-process-as-root)
- [How and why Linux daemons drop privileges](https://linux-audit.com/how-and-why-linux-daemons-drop-privileges/)
- [POS36-C. Observe correct revocation order while relinquishing privileges](https://wiki.sei.cmu.edu/confluence/display/c/POS36-C.+Observe+correct+revocation+order+while+relinquishing+privileges)

#### :beginner: Disable unnecessary modules

###### Rationale

  > It is recommended to disable any modules which are not required as this will minimise the risk of any potential attacks by limiting the operations allowed by the web server. I also recommend only compiling and running signed and tested modules on you production environments.

  > Disable unneeded modules in order to reduce the memory utilized and improve performance. Modules that are not needed just make loading times longer.

  > The best way to unload unused modules is use the `configure` option during installation. If you have static linking a shared module you should re-compile NGINX.

  Use only high quality modules and remember about that:

  > _Unfortunately, many third‑party modules use blocking calls, and users (and sometimes even the developers of the modules) aren’t aware of the drawbacks. Blocking operations can ruin NGINX performance and must be avoided at all costs._

###### Example

```nginx
# 1a) Check which modules can be turn on or off while compiling:
./configure --help | less

# 1b) Turn off during installation:
./configure --without-http_autoindex_module

# 2) Comment modules in the configuration file e.g. modules.conf:
# load_module   /usr/share/nginx/modules/ndk_http_module.so;
# load_module   /usr/share/nginx/modules/ngx_http_auth_pam_module.so;
# load_module   /usr/share/nginx/modules/ngx_http_cache_purge_module.so;
# load_module   /usr/share/nginx/modules/ngx_http_dav_ext_module.so;
load_module     /usr/share/nginx/modules/ngx_http_echo_module.so;
# load_module   /usr/share/nginx/modules/ngx_http_fancyindex_module.so;
load_module     /usr/share/nginx/modules/ngx_http_geoip_module.so;
load_module     /usr/share/nginx/modules/ngx_http_headers_more_filter_module.so;
# load_module   /usr/share/nginx/modules/ngx_http_image_filter_module.so;
# load_module   /usr/share/nginx/modules/ngx_http_lua_module.so;
load_module     /usr/share/nginx/modules/ngx_http_perl_module.so;
# load_module   /usr/share/nginx/modules/ngx_mail_module.so;
# load_module   /usr/share/nginx/modules/ngx_nchan_module.so;
# load_module   /usr/share/nginx/modules/ngx_stream_module.so;
```

###### External resources

- [NGINX 3rd Party Modules](https://www.nginx.com/resources/wiki/modules/)
- [nginx-modules](https://github.com/nginx-modules)
- [Emiller’s Guide To Nginx Module Development](https://www.evanmiller.org/nginx-modules-guide.html)

#### :beginner: Protect sensitive resources

###### Rationale

  > Hidden directories and files should never be web accessible - sometimes critical data are published during application deploy. If you use control version system you should defninitely drop the access (by giving less information to attackers) to the critical hidden directories/files like a `.git` or `.svn` to prevent expose source code of your application.

  > Sensitive resources contains items that abusers can use to fully recreate the source code used by the site and look for bugs, vulnerabilities, and exposed passwords.

  As for the denying method:

  > In my opinion, a return 403 according to the [RFC 2616 - 403 Forbidden](https://tools.ietf.org/html/rfc2616#section-10.4.4) <sup>[IETF]</sup> suggests (or even a 404, for purposes of no information disclosure) is less error prone if you know the resource should under no circumstances be accessed via http, even if "authorized" in a general context.

  Note also:

  > If you use locations with regular expressions, NGINX applies them in the order of their appearance in the configuration file. You can also use the `^~` modifier which makes the prefix location block take precedence over any regular expression location block at the same level.

  > NGINX process request in phases. `return` directive is from rewrite module, and `deny` is from access module. Rewrite module is processed in `NGX_HTTP_REWRITE_PHASE` phase (for `return` in `location` context), the access module is processed in `NGX_HTTP_ACCESS_PHASE` phase, rewrite phase (where `return` belongs) happens before access phase (where `deny` works), thus `return` stops request processing and returns 301 in rewrite phase.

  > `deny all` will have the same consequence but leaves the possibilities of slip-ups. The issue is illustrated in [this](https://serverfault.com/questions/748320/protecting-a-location-by-ip-while-applying-basic-auth-everywhere-else/748373#748373) answer, suggesting not using the `satisfy` + `allow` + `deny` at `server { ... }` level because of inheritance.

  > On the other hand, according to the NGINX documentation: _The `ngx_http_access_module` module allows limiting access to certain client addresses._ More specifically, you can't restrict access to another module (`return` is more used when you want to return other codes, not block access).

###### Example

Not recommended configuration:

```nginx
if ($request_uri ~ "/\.git") {

  return 403;

}
```

Recommended configuration:

```nginx
# 1) Catch only file names (without file extensions):
# Example: /foo/bar/.git but not /foo/bar/file.git
location ~ /\.git {

  return 403;

}

# 2) Catch file names and file extensions:
# Example: /foo/bar/.git and /foo/bar/file.git
location ~* ^.*(\.(?:git|svn|htaccess))$ {

  deny all;

}
```

Most recommended configuration:

```nginx
# Catch all . directories/files excepted .well-known (without file extensions):
# Example: /foo/bar/.git but not /foo/bar/file.git
location ~ /\.(?!well-known\/) {

  deny all;
  access_log /var/log/nginx/hidden-files-access.log main;
  error_log /var/log/nginx/hidden-files-error.log warn;

}
```

Look also at files with the following extensions:

```nginx
# Think also about the following rule (I haven't tested this but looks interesting). It comes from:
#   - https://github.com/h5bp/server-configs-nginx/blob/master/h5bp/location/security_file_access.conf
location ~* (?:#.*#|\.(?:bak|conf|dist|fla|in[ci]|log|orig|psd|sh|sql|sw[op])|~)$ {

  deny all;

}
#   - https://github.com/getgrav/grav/issues/1625
location ~ /(LICENSE\.txt|composer\.lock|composer\.json|nginx\.conf|web\.config|htaccess\.txt|\.htaccess) {

  deny all;

}

# Deny running scripts inside core system directories:
#   - https://github.com/getgrav/grav/issues/1625
location ~* /(system|vendor)/.*\.(txt|xml|md|html|yaml|yml|php|pl|py|cgi|twig|sh|bat)$ {

  return 418;

}

# Deny running scripts inside user directory:
#   - https://github.com/getgrav/grav/issues/1625
location ~* /user/.*\.(txt|md|yaml|yml|php|pl|py|cgi|twig|sh|bat)$ {

  return 418;

}
```

Based on the above (tested, I use this):

```nginx
# Catch file names and file extensions:
# Example: /foo/bar/.git and /foo/bar/file.git
location ~* ^.*(\.(?:git|svn|hg|bak|bckp|save|old|orig|original|test|conf|cfg|dist|in[ci]|log|sql|mdb|sw[op]|htaccess|php#|php~|php_bak|aspx?|tpl|sh|bash|bin|exe|dll|jsp|out|cache|))$ {

  # Use also rate limiting:
  # in server context: limit_req_zone $binary_remote_addr zone=per_ip_5r_s:5m rate=5r/s;
  limit_req zone=per_ip_5r_s;

  deny all;
  access_log /var/log/nginx/restricted-files-access.log main;
  access_log /var/log/nginx/restricted-files-error.log main;

}
```

###### External resources

- [Hidden directories and files as a source of sensitive information about web application](https://github.com/bl4de/research/tree/master/hidden_directories_leaks)
- [1% of CMS-Powered Sites Expose Their Database Passwords](https://feross.org/cmsploit/)
- [RFC 5785 - Defining Well-Known Uniform Resource Identifiers (URIs)](https://tools.ietf.org/html/rfc5785) <sup>[IETF]</sup>

#### :beginner: Take care about your ACL rules

###### Rationale

  > When planning for access control, consider several access options. NGINX provides `ngx_http_access_module`, `ngx_http_geo_module`, `ngx_http_map_module` or `ngx_http_auth_basic_module` modules for allow and deny permissions. Each of them secure sensitive files and directories.

  > You should always test your rules:
  >
  >   - check all used directives and their occurrence/priorites at all [levels of request processing](NGINX_BASICS.md#request-processing-stages)
  >   - send testing requests to validate allowing or denying users access to web resources (also from external/blacklisted IP)
  >   - send testing requests to check and verify HTTP response codes for all protected resources (see: [response codes decision diagram](https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/http_decision_diagram.png))
  >   - less is more, you should minimize any user’s access to the critical resources
  >   - add only really required IP addresses and check their owner in the whois database
  >   - regularly audit your access control rules to ensure they are current

  > If you use `*ACCESS_PHASE` (e.g. `allow/deny` directives) remember that NGINX process request in phases, and `rewrite` phase (where `return` belongs) goes before `access` phase (where `deny` works). See [Allow and deny](NGINX_BASICS.md#allow-and-deny) chapter to learn more. It's important because this may break your security layers.

  > However, it is not recommended to use `if` statements but use of regular expressions may be a bit more flexible (for more information see [this](NGINX_BASICS.md#if-break-and-set)).

###### Example

- [Restricting access with basic authentication](HELPERS.md#restricting-access-with-basic-authentication)
- [Restricting access with client certificate](HELPERS.md#restricting-access-with-client-certificate)
- [Restricting access by geographical location](HELPERS.md#restricting-access-by-geographical-location)
- [Blocking/allowing IP addresses](HELPERS.md#blockingallowing-ip-addresses)
- [Limiting referrer spam](HELPERS.md#limiting-referrer-spam)
- [Limiting the rate of requests with burst mode](HELPERS.md#limiting-the-rate-of-requests-with-burst-mode)
- [Limiting the rate of requests with burst mode and nodelay](HELPERS.md#limiting-the-rate-of-requests-with-burst-mode-and-nodelay)
- [Limiting the rate of requests per IP with geo and map](HELPERS.md#limiting-the-rate-of-requests-per-ip-with-geo-and-map)
- [Limiting the number of connections](HELPERS.md#limiting-the-number-of-connections)

###### External resources

- [Fastly - About ACLs](https://docs.fastly.com/en/guides/about-acls)
- [Restrict allowed HTTP methods in Nginx](https://bjornjohansen.no/restrict-allowed-http-methods-in-nginx)
- [Allow and deny (from this handbook)](NGINX_BASICS.md#allow-and-deny)
- [Protect sensitive resources - Hardening - P1 (from this handbook)](#beginner-protect-sensitive-resources)

#### :beginner: Hide Nginx version number

###### Rationale

  > Disclosing the version of NGINX running can be undesirable, particularly in environments sensitive to information disclosure. NGINX shows the version number by default in error pages and in the headers of HTTP responses.

  > This information can be used as a starting point for attackers who know of specific vulnerabilities associated with specific versions and might help gain a greater understanding of the systems in use and potentially develop further attacks targeted at the specific version of NGINX. For example, Shodan provides a widely used database of this info. It's far more efficient to just try the vulnerability on all random servers than asking them.

  > Hiding your version information will not stop an attack from happening, but it will make you less of a target if attackers are looking for a specific version of hardware or software. I take the data broadcast by the HTTP server as a personal information.

  > Security by obscurity doesn't mean you're safe, but it does slow people down sometimes, and that's exactly what's needed for day zero vulnerabilities.

  Look also at the most excellent comment about this (by [specializt](https://serverfault.com/users/67666/specializt)):

  > _Disregarding important security factors like "no version numbers" and probably even "no server vendor name" entirely is just ... a beginners mistake. Of course security through obscurity does nothing for your security itself but it sure as hell will at least protect against the most mundane, simplistic attack vectors - security through obscurity is a necessary step, it may be the first one and should never be the last security measurement -skipping it completely is a very bad mistake, even the most secure webservers can be cracked if a version-specific attack vector is known._

###### Example

```nginx
# This disables emitting NGINX version on error pages and in the "Server" response header field:
server_tokens off;
```

###### External resources

- [Remove Version from Server Header Banner in nginx](https://geekflare.com/remove-server-header-banner-nginx/)
- [Reduce or remove server headers](https://www.tunetheweb.com/security/http-security-headers/server-header/)
- [Fingerprint Web Server (OTG-INFO-002)](https://www.owasp.org/index.php/Fingerprint_Web_Server_(OTG-INFO-002))

#### :beginner: Hide Nginx server signature

###### Rationale

  > The `Server` response-header field contains information about the software used by the origin server to handle the request. This string is used by places like Alexa and Netcraft to collect statistics about how many and of what type of web server are live on the Internet.

  > One of the easiest first steps to undertake, is to prevent the web server from showing its used software and technologies via the `Server` header. Certainly, there are several reasons why do you want to change the server header. It could be security, it could be redundant systems, load balancers etc. The attacker collects all available information about the application and its environment. Information about the technologies used and the software versions are extremely valuable information.

  > And in my opinion, there is no real reason or need to show this much information about your server. It is easy to look up particular vulnerabilities once you know the version number. However, it's not information you need to give out, so I am generally in favour of removing it, where this can be accomplished with minimal effort.

  > You should compile NGINX from sources with `ngx_headers_more` to used `more_set_headers` directive or use a [nginx-remove-server-header.patch](https://gitlab.com/buik/nginx/blob/master/nginx-remove-server-header.patch).

  Maybe it's a very restrictive approach but the guidelines from [RFC 2616 - Personal Information](https://tools.ietf.org/html/rfc2616#section-15.1) are always very helpful to me:

  > _History shows that errors in this area often create serious security and/or privacy problems and generate highly adverse publicity for the implementor's company. [...] Like any generic data transfer protocol, HTTP cannot regulate the content of the data that is transferred, nor is there any a priori method of determining the sensitivity of any particular piece of information within the context of any given request. Therefore, applications SHOULD supply as much control over this information as possible to the provider of that information. Four header fields are worth special mention in this context: `Server`, `Via`, `Referer` and `From`._

  The Official Apache Documentation (yep, it's not a joke, in my opinion that's an interesting point of view) say:

  > _Setting ServerTokens to less than minimal is not recommended because it makes it more difficult to debug interoperational problems. Also note that disabling the Server: header does nothing at all to make your server more secure. The idea of "security through obscurity" is a myth and leads to a false sense of safety._

###### Example

Recommended configuration:

```nginx
http {

  more_set_headers "Server: Unknown"; # or whatever else, e.g. 'WOULDN'T YOU LIKE TO KNOW!'

  ...
```

Most recommended configuration:

```nginx
http {

  more_clear_headers 'Server';

  ...
```

You can also use Lua module:

```nginx
http {

  header_filter_by_lua_block {
    ngx.header["Server"] = nil
  }

  ...
```

###### External resources

- [Shhh... don’t let your response headers talk too loudly](https://www.troyhunt.com/shhh-dont-let-your-response-headers/)
- [How to change (hide) the Nginx Server Signature?](https://stackoverflow.com/questions/24594971/how-to-changehide-the-nginx-server-signature)
- [Configuring Your Web Server to Not Disclose Its Identity](https://www.acunetix.com/blog/articles/configure-web-server-disclose-identity/)

#### :beginner: Hide upstream proxy headers

###### Rationale

  > Securing a server goes far beyond not showing what's running but I think less is more is better.

  > When NGINX is used to proxy requests to an upstream server (such as a PHP-FPM instance), it can be beneficial to hide certain headers sent in the upstream response (e.g. the version of PHP running).

  > You should use `proxy_hide_header` (or Lua module) to hide/remove headers from upstream servers returned to your NGINX reverse proxy (and consequently to the client).

###### Example

```nginx
# Hide some standard response headers:
proxy_hide_header X-Powered-By;
proxy_hide_header X-AspNetMvc-Version;
proxy_hide_header X-AspNet-Version;
proxy_hide_header X-Drupal-Cache;

# Hide some Amazon S3 specific response headers:
proxy_hide_header X-Amz-Id-2;
proxy_hide_header X-Amz-Request-Id;

# Hide other risky response headers:
proxy_hide_header X-Runtime;
```

###### External resources

- [Remove insecure http headers](https://veggiespam.com/headers/)
- [CRLF Injection and HTTP Response Splitting Vulnerability](https://www.netsparker.com/blog/web-security/crlf-http-header/)
- [HTTP Response Splitting](https://owasp.org/www-community/attacks/HTTP_Response_Splitting)
- [HTTP response header injection](https://portswigger.net/kb/issues/00200200_http-response-header-injection)
- [X-Runtime header related attacks](https://stackoverflow.com/questions/38584331/x-runtime-header-related-attacks)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Remove support for legacy and risky HTTP request headers

###### Rationale

  > In my opinion, support of these headers is not a vulnerability itself, but more like misconfiguration which in some circumstances could lead to a vulnerability.

  > It is good manners to definitely remove (or stripping/normalizing of their values) support for risky HTTP request headers. None of them never should get to your application or go through a proxy server without not factor the contents of them.

  > The ability to use of the `X-Original-URL` or `X-Rewrite-URL` can have serious consequences. These headers allows a user to access one URL but have your app (e.g. uses PHP/Symfony) return a different one which can bypass restrictions on higher level caches and web servers, for example, also if you set a deny rule (`deny all; return 403;`) on the proxy for location such as `/admin`.

  > If one or more of your backends uses the contents of the `X-Host`, `X-Forwarded-Host`, `X-Forwarded-Server`, `X-Rewrite-Url` or `X-Original-Url` HTTP request headers to decide which of your users (or which security domain) it sends an HTTP response, you may be impacted by this class of vulnerability. If you passes these headers to your backend an attacker could potentially cause to store a response with arbitrary content inserted to a victim’s cache.

  Look at the following explanation taken from [PortSwigger Research - Practical Web Cache Poisoning](https://portswigger.net/research/practical-web-cache-poisoning):

  > _This revealed the headers `X-Original-URL` and `X-Rewrite-URL` which override the request's path. I first noticed them affecting targets running Drupal, and digging through Drupal's code revealed that the support for this header comes from the popular PHP framework Symfony, which in turn took the code from Zend. The end result is that a huge number of PHP applications unwittingly support these headers. Before we try using these headers for cache poisoning, I should point out they're also great for bypassing WAFs and security rules [...]_

###### Example

```nginx
# Remove risky request headers (the safest method):
proxy_set_header X-Original-URL "";
proxy_set_header X-Rewrite-URL "";
proxy_set_header X-Forwarded-Server "";
proxy_set_header X-Forwarded-Host "";
proxy_set_header X-Host "";

# Or consider setting the vulnerable headers to a known-safe value:
proxy_set_header X-Original-URL $request_uri;
proxy_set_header X-Rewrite-URL $original_uri;
proxy_set_header X-Forwarded-Host $host;
```

###### External resources

- [CVE-2018-14773: Remove support for legacy and risky HTTP request headers](https://symfony.com/blog/cve-2018-14773-remove-support-for-legacy-and-risky-http-headers)
- [Local File Inclusion Vulnerability in Concrete5 version 5.7.3.1](https://hackerone.com/reports/59665)
- [PortSwigger Research - Practical Web Cache Poisoning](https://portswigger.net/research/practical-web-cache-poisoning)
- [Passing headers to the backend (from this handbook)](NGINX_BASICS.md#passing-headers-to-the-backend)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Use only the latest supported OpenSSL version

###### Rationale

  > Before start see [Release Strategy Policies](https://www.openssl.org/policies/releasestrat.html) and [Changelog](https://www.openssl.org/news/changelog.html) on the OpenSSL website. Criteria for choosing OpenSSL version can vary and it depends all on your use.

  > The latest versions of the major OpenSSL library are (may be changed):
  >
  >   - the next version of OpenSSL will be 3.0.0
  >   - version 1.1.1 will be supported until 2023-09-11 (LTS)
  >     - last minor version: 1.1.1d (September 10, 2019)
  >   - version 1.1.0 will be supported until 2019-09-11
  >     - last minor version: 1.1.0k (May 28, 2018)
  >   - version 1.0.2 will be supported until 2019-12-31 (LTS)
  >     - last minor version: 1.0.2s (May 28, 2018)
  >   - any other versions are no longer supported

  > In my opinion, the only safe way is based on the up-to-date, still supported and production-ready version of the OpenSSL. And what's more, I recommend to hang on to the latest versions (e.g. 1.1.1 or 1.1.1d at this moment). So, make sure your OpenSSL library is updated to the latest available version and encourage your clients to also use updated OpenSSL and software working with it.

  > You should know one thing before start using OpenSSL 1.1.1: it has a different API than the current 1.0.2 so that's not just a simple flick of the switch. NGINX started supporting TLS 1.3 with the release of version 1.13.0, but when the OpenSSL devs released OpenSSL 1.1.1, that NGINX had support for the brand new protocol version.

  > If your repositories system does not have the newest OpenSSL, you can do the [compilation](https://github.com/trimstray/nginx-admins-handbook#installing-from-source) process (see OpenSSL sub-section).

  > I also recommend track the [OpenSSL Vulnerabilities](https://www.openssl.org/news/vulnerabilities.html) official newsletter, if you want to know a security bugs and issues fixed in OpenSSL.

###### External resources

- [OpenSSL Official Website](https://www.openssl.org/)
- [OpenSSL Official Blog](https://www.openssl.org/blog/)
- [OpenSSL Official Newslog](https://www.openssl.org/news/newslog.html)

#### :beginner: Force all connections over TLS

###### Rationale

  > TLS provides two main services. For one, it validates the identity of the server that the user is connecting to for the user. It also protects the transmission of sensitive information from the user to the server.

  > In my opinion you should always use HTTPS instead of HTTP (use HTTP only for redirection to HTTPS) to protect your website, even if it doesn’t handle sensitive communications and don’t have any mixed content. The application can have many sensitive places that should be protected.

  > Always put login page, registration forms, all subsequent authenticated pages, contact forms, and payment details forms in HTTPS to prevent sniffing and injection (attacker can inject code into an unencrypted HTTP transmission, so it always increases the risk to alter the content, even if someone only reads non-critical content. See [Man-in-the-browser attack](https://owasp.org/www-community/attacks/Man-in-the-browser_attack)). Them must be accessed only over TLS to ensure your traffic is secure.

  > If page is available over TLS, it must be composed completely of content which is transmitted over TLS. Requesting subresources using the insecure HTTP protocol weakens the security of the entire page and HTTPS protocol. Modern browsers should blocked or report all active mixed content delivered via HTTP on pages by default.

  > Also remember to implement the [HTTP Strict Transport Security (HSTS)](#beginner-enable-http-strict-transport-security) and ensure proper configuration of TLS (protocol version, cipher suites, right certificate chain, and other).

  > We have currently the first free and open CA - [Let's Encrypt](https://letsencrypt.org/) - so generating and implementing certificates has never been so easy. It was created to provide free and easy-to-use TLS and SSL certificates.

###### Example

- force all traffic to use TLS:

  ```nginx
  server {

    listen 10.240.20.2:80;

    server_name example.com;

    return 301 https://$host$request_uri;

  }

  server {

    listen 10.240.20.2:443 ssl;

    server_name example.com;

    ...

  }
  ```

- force login page to use TLS:

  ```nginx
  server {

    listen 10.240.20.2:80;

    server_name example.com;

    ...

    location ^~ /login {

      return 301 https://example.com$request_uri;

    }

  }
  ```

###### External resources

- [Does My Site Need HTTPS?](https://doesmysiteneedhttps.com/)
- [HTTP vs HTTPS Test](https://www.httpvshttps.com/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
- [Should we force user to HTTPS on website?](https://security.stackexchange.com/questions/23646/should-we-force-user-to-https-on-website)
- [Force a user to HTTPS](https://security.stackexchange.com/questions/137542/force-a-user-to-https)
- [The Security Impact of HTTPS Interception](https://jhalderm.com/pub/papers/interception-ndss17.pdf) <sup>[pdf]</sup>
- [HTTPS with self-signed certificate vs HTTP (from this handbook)](#https-with-self-signed-certificate-vs-http)
- [Enable HTTP Strict Transport Security - Hardening - P1 (from this handbook)](#beginner-enable-http-strict-transport-security)

#### :beginner: Use min. 2048-bit for `RSA` and 256-bit for `ECC`

###### Rationale

  > SSL certificates most commonly use `RSA` keys and the recommended size of these keys keeps increasing to maintain sufficient cryptographic strength. An alternative to `RSA` is `ECC`. The `ECC` (and `ECDSA`) is probably better for most purposes, but not for everything. Both key types share the same important property of being asymmetric algorithms (one key for encrypting and one key for decrypting). NGINX supports dual certificates, so you can get the leaner, meaner `ECC` certificates but still let visitors to browse your site with standard certificates.

  > The truth is (if we talk about `RSA`), the industry/community are split on this topic. I am in the "_use 2048, because 4096 gives us almost nothing, while costing us quite a lot_" camp myself.

  > Advisories recommend 2048-bit for `RSA` (or 256-bit for `ECC`) keys at the moment. Security experts are projecting that 2048 bits will be sufficient for commercial use until around the year 2030 (as per [NIST](https://www.keylength.com/en/4/)). US National Security Agency (NSA) requires all Top Secret files and documents to be encrypted with 384-bit `ECC` keys (7680-bit `RSA` key). Also, due to security reason, the latest [CA/Browser forum - Baseline Requirements](https://cabforum.org/wp-content/uploads/CA-Browser-Forum-BR-1.6.7.pdf) <sup>[pdf]</sup> forum and IST advises to use 2048-bit RSA key for subscriber certificates/keys. Next, current recommendations ([NIST SP 800-57-2](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt2r1.pdf) <sup>[pdf]</sup>) are now 2048 or 3072 bits, depending on interoperability requirements. On the other hand, the latest version of [FIPS-186-5 (Draft)](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-5-draft.pdf) <sup>[pdf]</sup> specifies the use of a modulus whose bit length is an even integer and greater than or equal to 2048 bits (old FIPS-186-4 say the U.S. Federal Government generate (and use) digital signatures with 1024, 2048, or 3072 bit key lengths).

  > Next, OpenSSL use a [2048 bit key by default](https://github.com/openssl/openssl/commit/44e0c2bae4bfd87d770480902618dbccde84fd81). Recommendations of the European Payments Council ([EPC342-08 v8.0](https://www.europeanpaymentscouncil.eu/sites/default/files/kb/file/2019-01/EPC342-08%20v8.0%20Guidelines%20on%20cryptographic%20algorithms%20usage%20and%20key%20management.pdf) <sup>[pdf]</sup>) say you should avoid using 1024-bit RSA keys and 160-bit ECC keys for new applications unless for short term low value protection (e.g. ephemeral authentication for single devices). EPC also recommend to use at least 2048-bit RSA or 224-bit ECC for medium term (e.g. 10 year) protection. They classify `SHA-1`, `RSA` moduli with 1024 bits, `ECC` keys of 160 bits as suitable for legacy use (but I no longer believe `SHA-1` is suitable for legacy use).

  > Generally there is no compelling reason to choose 4096 bit keys for `RSA` over 2048 provided you use sane expiration intervals (e.g. not greater than 6-12 months for 2048-bit key and certificate) to give an attacker less time to crack the key and to reduce the chances of someone exploiting any vulnerabilities that may occur if your key is compromised, but it's not necessary for the certificate's security per se for now. The security levels for RSA are based on the strongest known attacks against RSA compared to amount of processing that would be needed to break symmetric encryption algorithms. For me, we should more concerned about our private keys getting stolen in a server compromise and when technological progress makes our key vulnerable to attacks.

  > A 256-bit `ECC` key can be stronger than a 2048-bit classical key. If you use `ECDSA` the recommended key size changes according to usage, see [NIST 800-57-3 - Application-Specific Key Management Guidance (page 12, table 2-1)](https://nvlpubs.nist.gov/nistpubs/specialpublications/nist.sp.800-57pt3r1.pdf) <sup>[pdf]</sup>. While it is true that a longer key provides better security, doubling the length of the `RSA` key from 2048 to 4096, the increase in bits of security is only 18, a mere 16% (the time to sign a message increases by 7x, and the time to verify a signature increases by more than 3x in some cases). Moreover, besides requiring more storage, longer keys also translate into increased CPU usage.

  > `ECC` is more better than `RSA` in terms of key length. But the main issues are implementation. I think, `RSA` is more easy to implement than `ECC`. `ECDSA` keys (contain an `ECC` public keys) are recommended over `RSA` because offers same level of security with smaller keys contrasted with non-`ECC` cryptography. `ECC` keys are better than `RSA & DSA` keys in that the `ECC` algorithm is harder to break (less vulnerable). In my opinion, `ECC` is suitable for environments with lots of constrained (limited storage or data processing resources), e.g. cellular phones, PDAs, and generally for embedded systems. Of course, `RSA` keys are very fast, provides very simple encryption and verification, and are easier to implement than `ECC`.

  > Longer `RSA` keys take more time to generate and require more CPU and power when used for encrypting and decrypting, also the SSL handshake at the start of each connection will be slower. It also has a small impact on the client side (e.g. browsers). When using `curve25519`, `ECC` is considered more secure. It is fast and immune to a variety of side-channel attacks by design. `RSA` is no less secure though in practical terms, and is also considered unbreakable by modern technology.

  > The real advantage of using a 4096-bit key nowadays is future proofing. If you want to get **A+ with 100%s on SSL Lab** (for Key Exchange) you should definitely use 4096 bit private keys. That's the main (and the only one for me) reason why you should use them.

  > Use OpenSSL's `speed` command to benchmark the two types and compare results, e.g. `openssl speed rsa2048 rsa4096`, `openssl speed rsa` or `openssl speed ecdsa`. Remember, however, in OpenSSL speed tests you see difference on block cipher speed, while in real life most CPU time is spent on asymmetric algorithms during SSL handshake. On the other hand, modern processors are capable of executing at least 1k of RSA 1024-bit signs per second on a single core, so this isn't usually an issue.

  The "SSL/TLS Deployment Best Practices" book say:

  > _The cryptographic handshake, which is used to establish secure connections, is an operation whose cost is highly influenced by private key size. Using a key that is too short is insecure, but using a key that is too long will result in "too much" security and slow operation. For most web sites, using RSA keys stronger than 2048 bits and ECDSA keys stronger than 256 bits is a waste of CPU power and might impair user experience. Similarly, there is little benefit to increasing the strength of the ephemeral key exchange beyond 2048 bits for DHE and 256 bits for ECDHE._

  Konstantin Ryabitsev (Reddit):

  > _Generally speaking, if we ever find ourselves in a world where 2048-bit keys are no longer good enough, it won't be because of improvements in brute-force capabilities of current computers, but because RSA will be made obsolete as a technology due to revolutionary computing advances. If that ever happens, 3072 or 4096 bits won't make much of a difference anyway. This is why anything above 2048 bits is generally regarded as a sort of feel-good hedging theatre._

  **My recommendation:**

  > Use 256-bit for `ECDSA` or 2048-bit key instead of 4096-bit for `RSA` at this moment.

###### Example

```bash
### Example (RSA):
( _fd="example.com.key" ; _len="2048" ; openssl genrsa -out ${_fd} ${_len} )

# Let's Encrypt:
certbot certonly -d example.com -d www.example.com --rsa-key-size 2048

### Example (ECC):
# _curve: prime256v1, secp521r1, secp384r1
( _fd="example.com.key" ; _fd_csr="example.com.csr" ; _curve="prime256v1" ; \
openssl ecparam -out ${_fd} -name ${_curve} -genkey ; \
openssl req -new -key ${_fd} -out ${_fd_csr} -sha256 )

# Let's Encrypt (from above):
certbot --csr ${_fd_csr} -[other-args]
```

For `x25519`:

```bash
( _fd="private.key" ; _curve="x25519" ; \
openssl genpkey -algorithm ${_curve} -out ${_fd} )
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

```bash
( _fd="example.com.key" ; _len="2048" ; openssl genrsa -out ${_fd} ${_len} )

# Let's Encrypt:
certbot certonly -d example.com -d www.example.com
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>90%</b>

###### External resources

- [Key Management Guidelines by NIST](https://csrc.nist.gov/Projects/Key-Management/Key-Management-Guidelines) <sup>[NIST]</sup>
- [Recommendation for Transitioning the Use of Cryptographic Algorithms and Key Lengths](https://csrc.nist.gov/publications/detail/sp/800-131a/archive/2011-01-13) <sup>[NIST]</sup>
- [NIST SP 800-52 Rev. 2](https://csrc.nist.gov/publications/detail/sp/800-52/rev-2/final) <sup>[NIST]</sup>
- [NIST SP 800-57 Part 1 Rev. 3](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-3/archive/2012-07-10) <sup>[NIST]</sup>
- [FIPS PUB 186-4 - Digital Signature Standard (DSS)](http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf) <sup>[NIST, pdf]</sup>
- [Cryptographic Key Length Recommendations](https://www.keylength.com/)
- [Key Lengths - Contribution to The Handbook of Information Security](https://infoscience.epfl.ch/record/164539/files/NPDF-32.pdf) <sup>[pdf]</sup>
- [NIST - Key Management](https://csrc.nist.gov/Projects/Key-Management/publications) <sup>[NIST]</sup>
- [CA/Browser Forum Baseline Requirements](https://cabforum.org/baseline-requirements-documents/)
- [Mozilla Guidelines - Key Management](https://infosec.mozilla.org/guidelines/key_management.html)
- [So you're making an RSA key for an HTTPS certificate. What key size do you use?](https://certsimple.com/blog/measuring-ssl-rsa-keys)
- [RSA Key Sizes: 2048 or 4096 bits?](https://danielpocock.com/rsa-key-sizes-2048-or-4096-bits/)
- [Create a self-signed ECC certificate](https://msol.io/blog/tech/create-a-self-signed-ecc-certificate/)
- [ECDSA: Elliptic Curve Signatures](https://cryptobook.nakov.com/digital-signatures/ecdsa-sign-verify-messages)
- [Elliptic Curve Cryptography Explained](https://fangpenlin.com/posts/2019/10/07/elliptic-curve-cryptography-explained/)
- [You should be using ECC for your SSL/TLS certificates](https://www.thesslstore.com/blog/you-should-be-using-ecc-for-your-ssl-tls-certificates/)
- [Comparing ECC vs RSA](https://www.linkedin.com/pulse/comparing-ecc-vs-rsa-ott-sarv)
- [Comparison And Evaluation Of Digital Signature Schemes Employed In Ndn Network](https://arxiv.org/pdf/1508.00184.pdf) <sup>[pdf]</sup>
- [HTTPS Performance, 2048-bit vs 4096-bit](https://blog.nytsoi.net/2015/11/02/nginx-https-performance)
- [RSA and ECDSA hybrid Nginx setup with LetsEncrypt certificates](https://hackernoon.com/rsa-and-ecdsa-hybrid-nginx-setup-with-letsencrypt-certificates-ee422695d7d3)
- [Why ninety-day lifetimes for certificates?](https://letsencrypt.org/2015/11/09/why-90-days.html)
- [SSL Certificate Validity Will Be Limited to One Year by Apple’s Safari Browser](https://www.thesslstore.com/blog/ssl-certificate-validity-will-be-limited-to-one-year-by-apples-safari-browser/)
- [Certificate lifetime capped to 1 year from Sep 2020](https://scotthelme.co.uk/certificate-lifetime-capped-to-1-year-from-sep-2020/)
- [Why some cryptographic keys are much smaller than others](https://blog.cloudflare.com/why-are-some-keys-small/)
- [Bit security level](https://xtendo.org/bit_security_level)
- [RSA key lengths](https://www.javamex.com/tutorials/cryptography/rsa_key_length.shtml)

#### :beginner: Keep only TLS 1.3 and TLS 1.2

###### Rationale

  > It is recommended to enable TLS 1.2/1.3 and fully disable SSLv2, SSLv3, TLS 1.0 and TLS 1.1 that have protocol weaknesses and uses older cipher suites (do not provide any modern ciper modes) which we really shouldn’t be using anymore. TLS 1.2 is currently the most used version of TLS and has made several improvements in security compared to TLS 1.1. The vast majority of sites do support TLSv1.2 but there are still some out there that don't (what's more, it is still not all clients are compatible with every version of TLS). The TLS 1.3 protocol is the latest and more robust TLS protocol version and should be used where possible (and where don't need backward compatibility). The biggest benefit to dropping TLS 1.0 and 1.1 is that modern AEAD ciphers are only supported by TLS 1.2 and above.

  > TLS 1.0 and TLS 1.1 should not be used (see [Deprecating TLSv1.0 and TLSv1.1](https://tools.ietf.org/id/draft-moriarty-tls-oldversions-diediedie-00.html) <sup>[IETF]</sup>) and were superseded by TLS 1.2, which has now itself been superseded by TLS 1.3 (must be included by January 1, 2024). They are also actively being deprecated in accordance with guidance from government agencies (e.g. [NIST Special Publication (SP) 800-52 Revision 2](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-52r2.pdf) <sup>[pdf]</sup>) and industry consortia such as the Payment Card Industry Association ([PCI-TLS - Migrating from SSL and Early TLS (Information Suplement)](https://www.pcisecuritystandards.org/documents/Migrating-from-SSL-Early-TLS-Info-Supp-v1_1.pdf) <sup>[pdf]</sup>). For example, in March of 2020, [Firefox will disable support for TLS 1.0 and TLS 1.1](https://blog.mozilla.org/security/2018/10/15/removing-old-versions-of-tls/).

  > Sticking with TLS 1.0 is a very bad idea and pretty unsafe. Can be [POODLEd](https://en.wikipedia.org/wiki/POODLE), [BEASTed](https://en.wikipedia.org/wiki/Transport_Layer_Security#BEAST_attack) and otherwise [padding-Oracled](https://en.wikipedia.org/wiki/Padding_oracle_attack) as well. Lots of other CVE (see [TLS Security 6: Examples of TLS Vulnerabilities and Attacks](https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/)) weaknesses still apply which cannot be fixed unless by switching TLS 1.0 off. Sticking with TLS 1.1 is only a bad compromise though it is halfway free from TLS 1.0 problems. On the other hand, sometimes their use is still required in practice (to support older clients). There are many other security risks caused by sticking to TLS 1.0 or 1.1, so I strongly recommend everyone updates their clients, services and devices to support min. TLS 1.2.

  > Removing backward SSL/TLS version is often the only way to prevent downgrade attacks. Google has proposed an extension to SSL/TLS named `TLS_FALLBACK_SCSV` (it should be supported by your OpenSSL library) that seeks to prevent forced SSL/TLS downgrades (the extension was adopted as [RFC 7507](https://tools.ietf.org/html/rfc7507) in April 2015). Upgrading alone is not sufficient. You must disable SSLv2 and SSLv3 - so if your server does not allow SSLv3 (or v2) connections it is not needed (as those downgraded connections would not work). Technically `TLS_FALLBACK_SCSV` is still useful with SSL disabled, because it helps avoid the connection being downgraded to TLS<1.2. To test this extension, read [this](https://dwradcliffe.com/2014/10/16/testing-tls-fallback.html) great tutorial.

  > TLS 1.2 and TLS 1.3 are both without security issues (TLSv1.2 only once the certain conditions have been fulfilled, e.g. disable `CBC` ciphers). Only these versions provides modern cryptographic algorithms and adds TLS extensions and cipher suites. TLS 1.2 improves cipher suites that reduce reliance on block ciphers that have been exploited by attacks like BEAST and the aforementioned POODLE. TLS 1.3 is a new TLS version that will power a faster and more secure web for the next few years. What's more, TLS 1.3 comes without a ton of stuff (was removed): renegotiation, compression, and many legacy algorithms: `DSA`, `RC4`, `SHA1`, `MD5`, and `CBC` ciphers. Additionally, as already mentioned, TLS 1.0 and TLS 1.1 protocols will be removed from browsers at the beginning of 2020.

  > TLS 1.2 does require careful configuration to ensure obsolete cipher suites with identified vulnerabilities are not used in conjunction with it. TLS 1.3 removes the need to make these decisions and doesn't require any particular configuration, as all of the ciphers are secure, and by default OpenSSL only enables `GCM` and `Chacha20/Poly1305` for TLSv1.3, without enabling `CCM`. TLS 1.3 version also improves TLS 1.2 security, privace and performance issues.

  > Before enabling specific protocol version, you should check which ciphers are supported by the protocol. So, if you turn on TLS 1.2, remember about [the correct (and strong)](#beginner-use-only-strong-ciphers) ciphers to handle them. Otherwise, they will not be anyway works without supported ciphers (no TLS handshake will succeed).

  > I think the best way to deploy secure configuration is: enable TLS 1.2 (as a minimum version; is safe enough) without any `CBC` ciphers (`ChaCha20+Poly1305` or `AES/GCM` should be preferred over `CBC` (cf. BEAST), howewer, for me using `CBC` ciphers is not a vulnerability in and out of itself, Zombie POODLE, etc. are the vulnerabilities) and/or TLS 1.3 which is safer because of its handling improvement and the exclusion of everything that went obsolete since TLS 1.2 came up. So, making TLS 1.2 your "minimum protocol level" is the solid choice and an industry best practice (all of industry standards like PCI-DSS, HIPAA, NIST, strongly suggest the use of TLS 1.2 than TLS 1.1/1.0).

  > TLS 1.2 is probably insufficient for legacy client support. The NIST guidelines are not applicable to all use cases, and you should always analyze your user base before deciding which protocols to support or drop (for example, by adding variables responsible for TLS versions and ciphers to the log format). It's important to remember that not every client supports the latest and greatest that TLS has to offer.

  > If you told NGINX to use TLS 1.3, it will use TLS 1.3 only where is available. NGINX supports TLS 1.3 since version 1.13.0 (released in April 2017), when built against OpenSSL 1.1.1 or more.

  > For TLS 1.3, think about using [`ssl_early_data`](#beginner-prevent-replay-attacks-on-zero-round-trip-time) to allow TLS 1.3 0-RTT handshakes.

  **My recommendation:**

  > Use only [TLSv1.3 and TLSv1.2](#keep-only-tls1.2-tls13).

###### Example

TLS 1.3 + 1.2:

```nginx
ssl_protocols TLSv1.3 TLSv1.2;
```

TLS 1.2:

```nginx
ssl_protocols TLSv1.2;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

TLS 1.3 + 1.2 + 1.1:

```nginx
ssl_protocols TLSv1.3 TLSv1.2 TLSv1.1;
```

TLS 1.2 + 1.1:

```nginx
ssl_protocols TLSv1.2 TLSv1.1;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>95%</b>

###### External resources

- [The Transport Layer Security (TLS) Protocol Version 1.2](https://www.ietf.org/rfc/rfc5246.txt) <sup>[IETF]</sup>
- [The Transport Layer Security (TLS) Protocol Version 1.3](https://tools.ietf.org/html/draft-ietf-tls-tls13-18) <sup>[IETF]</sup>
- [Transport Layer Security Protocol: Documentation & Implementations](https://tlswg.org/)
- [TLS1.2 - Every byte explained and reproduced](https://tls12.ulfheim.net/)
- [TLS1.3 - Every byte explained and reproduced](https://tls13.ulfheim.net/)
- [TLS1.3 - OpenSSLWiki](https://wiki.openssl.org/index.php/TLS1.3)
- [TLS v1.2 handshake overview](https://medium.com/@ethicalevil/tls-handshake-protocol-overview-a39e8eee2cf5)
- [An Overview of TLS 1.3 - Faster and More Secure](https://kinsta.com/blog/tls-1-3/)
- [A Detailed Look at RFC 8446 (a.k.a. TLS 1.3)](https://blog.cloudflare.com/rfc-8446-aka-tls-1-3/)
- [Differences between TLS 1.2 and TLS 1.3](https://www.wolfssl.com/differences-between-tls-1-2-and-tls-1-3/)
- [TLS 1.3 in a nutshell](https://assured.se/2018/08/29/tls-1-3-in-a-nut-shell/)
- [TLS 1.3 is here to stay](https://www.ssl.com/article/tls-1-3-is-here-to-stay/)
- [TLS 1.3: Everything you need to know](https://securityboulevard.com/2019/07/tls-1-3-everything-you-need-to-know/)
- [TLS 1.3: better for individuals - harder for enterprises](https://www.ncsc.gov.uk/blog-post/tls-13-better-individuals-harder-enterprises)
- [How to enable TLS 1.3 on Nginx](https://ma.ttias.be/enable-tls-1-3-nginx/)
- [How to deploy modern TLS in 2019?](https://blog.probely.com/how-to-deploy-modern-tls-in-2018-1b9a9cafc454)
- [Deploying TLS 1.3: the great, the good and the bad](https://media.ccc.de/v/33c3-8348-deploying_tls_1_3_the_great_the_good_and_the_bad)
- [Why TLS 1.3 isn't in browsers yet](https://blog.cloudflare.com/why-tls-1-3-isnt-in-browsers-yet/)
- [Downgrade Attack on TLS 1.3 and Vulnerabilities in Major TLS Libraries](https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2019/february/downgrade-attack-on-tls-1.3-and-vulnerabilities-in-major-tls-libraries/)
- [How does TLS 1.3 protect against downgrade attacks?](https://blog.gypsyengineer.com/en/security/how-does-tls-1-3-protect-against-downgrade-attacks.html)
- [Phase two of our TLS 1.0 and 1.1 deprecation plan](https://www.fastly.com/blog/phase-two-our-tls-10-and-11-deprecation-plan)
- [Deprecating TLSv1.0 and TLSv1.1 (IETF)](https://tools.ietf.org/id/draft-moriarty-tls-oldversions-diediedie-00.html) <sup>[IETF]</sup>
- [Deprecating TLS 1.0 and 1.1 - Enhancing Security for Everyone](https://www.keycdn.com/blog/deprecating-tls-1-0-and-1-1)
- [End of Life for TLS 1.0/1.1](https://support.umbrella.com/hc/en-us/articles/360033350851-End-of-Life-for-TLS-1-0-1-1-)
- [Legacy TLS is on the way out: Start deprecating TLSv1.0 and TLSv1.1 now](https://scotthelme.co.uk/legacy-tls-is-on-the-way-out/)
- [TLS/SSL Explained – Examples of a TLS Vulnerability and Attack, Final Part](https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/)
- [A Challenging but Feasible Blockwise-Adaptive Chosen-Plaintext Attack on SSL](https://eprint.iacr.org/2006/136)
- [TLS/SSL hardening and compatibility Report 2011](http://www.g-sec.lu/sslharden/SSL_comp_report2011.pdf) <sup>[pdf]</sup>
- [This POODLE bites: exploiting the SSL 3.0 fallback](https://security.googleblog.com/2014/10/this-poodle-bites-exploiting-ssl-30.html)
- [New Tricks For Defeating SSL In Practice](https://www.blackhat.com/presentations/bh-dc-09/Marlinspike/BlackHat-DC-09-Marlinspike-Defeating-SSL.pdf) <sup>[pdf]</sup>
- [Are You Ready for 30 June 2018? Saying Goodbye to SSL/early TLS](https://blog.pcisecuritystandards.org/are-you-ready-for-30-june-2018-sayin-goodbye-to-ssl-early-tls)
- [What Happens After 30 June 2018? New Guidance on Use of SSL/Early TLS](https://blog.pcisecuritystandards.org/what-happens-after-30-june-2018-new-guidance-on-use-of-ssl/early-tls-)
- [Mozilla Security Blog - Removing Old Versions of TLS](https://blog.mozilla.org/security/2018/10/15/removing-old-versions-of-tls/)
- [Google - Modernizing Transport Security](https://security.googleblog.com/2018/10/modernizing-transport-security.html)
- [These truly are the end times for TLS 1.0, 1.1](https://www.theregister.co.uk/2020/02/10/tls_10_11_firefox_complete_eradication/)
- [Who's quit TLS 1.0?](https://who-quit-tls10.com/)
- [Recommended Cloudflare SSL configurations for PCI compliance](https://support.cloudflare.com/hc/en-us/articles/205043158-PCI-compliance-and-Cloudflare-SSL#h_8d214b26-c3e5-4632-8056-d2ccd08790dd)
- [Cloudflare SSL cipher, browser, and protocol support](https://support.cloudflare.com/hc/en-us/articles/203041594-Cloudflare-SSL-cipher-browser-and-protocol-support)
- [SSL and TLS Deployment Best Practices](https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices)
- [What level of SSL or TLS is required for HIPAA compliance?](https://luxsci.com/blog/level-ssl-tls-required-hipaa.html)
- [AEAD Ciphers - shadowsocks](https://shadowsocks.org/en/spec/AEAD-Ciphers.html)
- [Building a faster and more secure web with TCP Fast Open, TLS False Start, and TLS 1.3](https://blogs.windows.com/msedgedev/2016/06/15/building-a-faster-and-more-secure-web-with-tcp-fast-open-tls-false-start-and-tls-1-3/)
- [SSL Labs Grade Change for TLS 1.0 and TLS 1.1 Protocols](https://blog.qualys.com/ssllabs/2018/11/19/grade-change-for-tls-1-0-and-tls-1-1-protocols)
- [ImperialViolet - TLS 1.3 and Proxies](https://www.imperialviolet.org/2018/03/10/tls13.html)
- [How Netflix brings safer and faster streaming experiences to the living room on crowded networks using TLS 1.3](https://netflixtechblog.com/how-netflix-brings-safer-and-faster-streaming-experience-to-the-living-room-on-crowded-networks-78b8de7f758c)
- [TLS versions (from this handbook)](#tls-versions)
- [Defend against the BEAST attack - Hardening - P1 (from this handbook)](#beginner-defend-against-the-beast-attack)

#### :beginner: Use only strong ciphers

###### Rationale

  > This parameter changes more often than others, the recommended configuration for today may be out of date tomorrow. In my opinion, having a well-considered and up-to-date list of highly secure cipher suites is important for high security SSL/TLS communication. In case of doubt, you should follow [Mozilla Security/Server Side TLS](https://wiki.mozilla.org/Security/Server_Side_TLS) (it's really great source; all Mozilla websites and deployments should follow the recommendations from this document).

  > To check ciphers supported by OpenSSL on your server: `openssl ciphers -s -v`, `openssl ciphers -s -v ECDHE` or `openssl ciphers -s -v DHE`.

  > Without careful cipher suite selection (TLS 1.3 does it for you!), you risk negotiating to a weak (less secure and don't get ahead of the latest vulnerabilities; see [this](https://ciphersuite.info/page/faq/)) cipher suite that may be compromised. If another party doesn't support a cipher suite that's up to your standards, and you highly value security on that connection, you shouldn't allow your system to operate with lower-quality cipher suites.

  > For more security use only strong and not vulnerable cipher suites. Place `ECDHE+AESGCM` (according to [Alexa Top 1 Million Security Analysis](https://crawler.ninja/), over 92.8% websites using encryption prefer to use `ECDHE` based ciphers) and `DHE` suites at the top of your list (also if you are concerned about performance, prioritize `ECDHE-ECDSA` and `ECDHE-RSA` over `DHE`; Chrome is going to prioritize `ECDHE`-based ciphers over `DHE`-based ciphers). `DHE` is generally slow and in TLS 1.2 and below is vulnerable to weak groups (less than 2048-bit at this moment). And what's more, not specified any restrictions on the groups to use. These issues don't impact `ECDHE` which is why it's generally preferred today.

  > The order is important because `ECDHE` suites are faster, you want to use them whenever clients supports them. Ephemeral `DHE/ECDHE` are recommended and support Perfect Forward Secrecy (a method that does not have the vulnerability to the type of replay attack that other solutions could introduce if a highly secure cipher suite is not supported). `ECDHE-ECDSA` is about the same as `RSA` in performance, but much more secure. `ECDHE` with `RSA` is slower, but still much more secure than alone `RSA`.

  > For backward compatibility software components think about less restrictive ciphers. Not only that you have to enable at least one special `AES128` cipher for HTTP/2 support regarding to [RFC 7540 - TLS 1.2 Cipher Suites](https://tools.ietf.org/html/rfc7540#section-9.2.2) <sup>[IETF]</sup>, you also have to allow `prime256` elliptic curves which reduces the score for key exchange by another 10% even if a secure server preferred order is set.

  > Servers either use the client's most preferable ciphersuite or their own. Most servers use their own preference. Disabling `DHE` removes forward security, but results in substantially faster handshake times. I think, so long as you only control one side of the conversation, it would be ridiculous to restrict your system to only supporting one cipher suite (it would cut off too many clients and too much traffic). On the other hand, look at what [David Benjamin](https://davidben.net/) (from Chrome networking) said about it: _Servers should also disable `DHE` ciphers. Even if `ECDHE` is preferred, merely supporting a weak group leaves `DHE`-capable clients vulnerable._

  > Also modern cipher suites (e.g. from Mozilla recommendations) suffers from compatibility troubles mainly because drops `SHA-1` (see what Google said about it in 2014: [Gradually sunsetting SHA-1](https://security.googleblog.com/2014/09/gradually-sunsetting-sha-1.html)). But be careful if you want to use ciphers with `HMAC-SHA-1`, because them has been proven to be vulnerable to collision attacks as of 2017 (see [this](https://shattered.io/)). While this does not affect its usage as a `MAC`, safer alternatives such as `SHA-256`, or `SHA-3` should be considered. There's a perfectly good [explanation](https://crypto.stackexchange.com/a/26518) why.

  > If you want to get **A+ with 100%s on SSL Lab** (for Cipher Strength) you should definitely disable `128-bit` (that's the main reason why you should not use them) and `CBC` cipher suites which have had many weaknesses.

  > In my opinion `128-bit` symmetric encryption doesn’t less secure. Moreover, there are about 30% faster and still secure. For example TLS 1.3 use `TLS_AES_128_GCM_SHA256 (0x1301)` (for TLS-compliant applications).

  > You should disable `CHACHA20_POLY1305` (e.g. `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256` and `TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256`) to comply with HIPAA and [NIST SP 800-38D](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf) <sup>[pdf]</sup> (Mozilla and Cloudflare uses them, IETF also recommend to use these cipher suites) guidelines and `CBC` ciphersuites to comply with PCI DSS, HIPAA, and NIST guidelines. However, it is strange to me (getting rid of `CHACHA20_POLY1305`) and I have not found a rational explanation for why we should do it. `ChaCha20` is simpler than `AES` and currently be quite a lot faster encryption algorithm if no `AES` hardware acceleration is available (in practice `AES` is often implemented in hardware which gives it an advantage). What's more, speed and security is probably the reason for Google to already support `ChaCha20 + Poly1305/AES` in Chrome.

  > Mozilla recommends leaving the default ciphers for TLSv1.3 and not explicitly enabling them in the configuration (TLSv1.3 doesn't require any particular changes). This is one of the changes: we need to know is that the cipher suites are fixed unless an application explicitly defines TLS 1.3 cipher suites. Thus, all of your TLSv1.3 connections will use `AES-256-GCM`, `ChaCha20`, then `AES-128-GCM`, in that order. I also recommend relying on OpenSSL because for TLS 1.3 the cipher suites are fixed so setting them will not affect (you will automatically use those three ciphers).

  > By default, OpenSSL 1.1.1* with TLSv1.3 disable `TLS_AES_128_CCM_SHA256` and `TLS_AES_128_CCM_8_SHA256` ciphers. In my opinion, `ChaCha20+Poly1305` or `AES/GCM` are very efficient in the most cases. On modern processors, the common `AES-GCM` cipher and mode are sped up by dedicated hardware, making that algorithm's implementation faster than anything by a wide margin. On older or cheaper processors that lack that feature, though, the `ChaCha20` cipher runs faster than `AES-GCM`, as was the `ChaCha20` designers' intention.

  > For TLS 1.2 you should consider disable weak ciphers without forward secrecy like ciphers with `CBC` algorithm. The `CBC` mode is vulnerable to plain-text attacks with TLS 1.0, SSL 3.0 and lower. However a real fix is implemented with TLS 1.2 in which the `GCM` mode was introduced and which is not vulnerable to the BEAST attack. Using them also reduces the final grade because they don't use ephemeral keys. In my opinion you should use ciphers with `AEAD` (TLS 1.3 supports only these suites) encryption because they don't have any known weaknesses.

  > There are vulnerabilities like Zombie POODLE, GOLDENDOODLE, 0-Length OpenSSL and Sleeping POODLE which were published for websites that use `CBC` (Cipher Block Chaining) block cipher modes. These vulnerabilities are applicable only if the server uses TLS 1.0, TLS 1.1 or TLS 1.2 with `CBC` cipher modes. Look at [Zombie POODLE, GOLDENDOODLE, & How TLSv1.3 Can Save Us All](https://i.blackhat.com/asia-19/Fri-March-29/bh-asia-Young-Zombie-Poodle-Goldendoodle-and-How-TLSv13-Can-Save-Us-All.pdf) <sup>[pdf]</sup> presentation from Black Hat Asia 2019. TLS 1.0 and TLS 1.1 may be affected by vulnerabilities such as [FREAK, POODLE, BEAST, and CRIME](https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/).

  > And yet, interestingly, Craig Young, a computer security researcher for Tripwire's Vulnerability and Exposure Research Team, found vulnerabilities in SSL 3.0's successor, TLS 1.2, that allow for attacks akin to POODLE due to TLS 1.2's continued support for a long-outdated cryptographic method: cipher block-chaining (`CBC`). The flaws allow man-in-the-middle (MitM) attacks on a user's encrypted Web sessions.

  > I recommend to disable TLS cipher modes that use `RSA` encryption (all ciphers that start with `TLS_RSA_WITH_*`) because they are really vulnerable to [ROBOT](https://robotattack.org/) attack. Instead, you should add support for cipher suites that use `ECDHE` or `DHE` (to be compliant to [NIST SP 800-56B](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-56Br2.pdf) <sup>[pdf]</sup>) for key transport. If your server is configured to support ciphers known as static key ciphers, you should know that hese ciphers don't support "Forward Secrecy". In the new specification for HTTP/2, these ciphers have been blacklisted. Not all servers that support `RSA` key exchange are vulnerable, but it is recommended to disable `RSA` key exchange ciphers as it does not support forward secrecy. On the other hand, `TLS_ECDHE_RSA` ciphers may be OK, because `RSA` is not doing the key transport in this case. TLS 1.3 doesn’t use `RSA` key exchanges because they’re not forward secret.

  > You should also absolutely disable weak ciphers regardless of the TLS version do you use, like those with `DSS`, `DSA`, `DES/3DES`, `RC4`, `MD5`, `SHA1`, `null`, anon in the name.

  > We have a nice online tool for testing compatibility cipher suites with user agents: [CryptCheck](https://tls.imirhil.fr/suite). I think it will be very helpful for you.

  > If in doubt, use one of the recommended Mozilla kits (see below), check also [Supported cipher suites](https://tls.imirhil.fr/ciphers) and [User agent compatibility](https://tls.imirhil.fr/suite).

  Look at this great explanation about weak ciphers by [Keith Shaw](https://github.com/keithws):

  > _Weak does not mean insecure. [...] A cipher usually gets marked as weak because there is some fundamental design flaw that makes it difficult to implement securely._

  At the end, some interesting statistics [Logjam: the latest TLS vulnerability explained](https://blog.cloudflare.com/logjam-the-latest-tls-vulnerability-explained/):

  > _94% of the TLS connections to CloudFlare customer sites uses `ECDHE` (more precisely 90% of them being `ECDHE-RSA-AES` of some sort and 10% `ECDHE-RSA-CHACHA20-POLY1305`) and provides Forward Secrecy. The rest use static `RSA` (5.5% with `AES`, 0.6% with `3DES`)._

  **My recommendation:**

  > Use only [TLSv1.3 and TLSv1.2](#keep-only-tls1.2-tls13) with below cipher suites (remember about min. `2048-bit` DH params for `DHE` with TLSv1.2):
  ```nginx
  ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256";
  ```

###### Example

Cipher suites for TLSv1.3:

```nginx
# - it's only example because for TLS 1.3 the cipher suites are fixed so setting them will not affect
# - if you have no explicit cipher suites configuration then you will automatically use those three and will be able to negotiate TLSv1.3
# - I recommend not setting ciphers for TLSv1.3 in NGINX
ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384";
```

Cipher suites for TLSv1.2:

```nginx
# Without DHE, only ECDHE:
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384";
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

Cipher suites for TLSv1.3:

```nginx
# - it's only example because for TLS 1.3 the cipher suites are fixed so setting them will not affect
# - if you have no explicit cipher suites configuration then you will automatically use those three and will be able to negotiate TLSv1.3
# - I recommend not setting ciphers for TLSv1.3 in NGINX
ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384:TLS13-AES-128-GCM-SHA256";
```

Cipher suites for TLSv1.2:

```nginx
# 1)
# With DHE (remember about min. 2048-bit DH params for DHE!):
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256";

# 2)
# Without DHE, only ECDHE (DH params are not required):
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256";

# 3)
# With DHE (remember about min. 2048-bit DH params for DHE!):
ssl_ciphers "EECDH+CHACHA20:EDH+AESGCM:AES256+EECDH:AES256+EDH";
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>90%</b>

This will also give a baseline for comparison with [Mozilla SSL Configuration Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/):

- Modern profile, OpenSSL 1.1.1 (and variants) for TLSv1.3

```nginx
# However, Mozilla does not enable them in the configuration:
#   - for TLS 1.3 the cipher suites are fixed unless an application explicitly defines them
# ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384:TLS13-AES-128-GCM-SHA256";
```

- Modern profile, OpenSSL 1.1.1 (and variants) for TLSv1.2 + TLSv1.3

```nginx
# However, Mozilla does not enable them in the configuration:
#   - for TLS 1.3 the cipher suites are fixed unless an application explicitly defines them
# ssl_ciphers "TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-256-GCM-SHA384:TLS13-AES-128-GCM-SHA256";
ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
```

- Intermediate profile, OpenSSL 1.1.0b + 1.1.1 (and variants) for TLSv1.2

```nginx
ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
```

There is also recommended ciphers for HIPAA and TLS v1.2+:

```nginx
ssl_ciphers "TLS13-AES-256-GCM-SHA384:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-CCM:DHE-RSA-AES128-CCM:DHE-RSA-AES256-CCM8:DHE-RSA-AES128-CCM8:DH-RSA-AES256-GCM-SHA384:DH-RSA-AES128-GCM-SHA256:ECDH-RSA-AES256-GCM-SHA384:ECDH-RSA-AES128-GCM-SHA256";
```

<details>
<summary><b>Scan results for each cipher suite (TLSv1.2 offered)</b></summary>

###### My recommendation

- Cipher suites:

```nginx
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256";
```

- DH: **2048-bit**

- SSL Labs scores:

  - Certificate: **100%**
  - Protocol Support: **100%**
  - Key Exchange: **90%**
  - Cipher Strength: **90%**

- SSLLabs suites in server-preferred order:

```
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (0xc030)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xcca8)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (0xc02f)   ECDH x25519 (eq. 3072 bits RSA)   FS 128
TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (0x9f)   DH 2048 bits   FS  256
TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xccaa)   DH 2048 bits   FS  256
TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 (0x9e)   DH 2048 bits   FS  128
```

- SSLLabs 'Handshake Simulation' errors:

```
IE 11 / Win Phone 8.1  R  Server sent fatal alert: handshake_failure
Safari 6 / iOS 6.0.1  Server sent fatal alert: handshake_failure
Safari 7 / iOS 7.1  R Server sent fatal alert: handshake_failure
Safari 7 / OS X 10.9  R Server sent fatal alert: handshake_failure
Safari 8 / iOS 8.4  R Server sent fatal alert: handshake_failure
Safari 8 / OS X 10.10  R  Server sent fatal alert: handshake_failure
```

- testssl.sh:

```
› SSLv2
› SSLv3
› TLS 1
› TLS 1.1
› TLS 1.2
›  xc030   ECDHE-RSA-AES256-GCM-SHA384       ECDH 521   AESGCM      256      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
›  x9f     DHE-RSA-AES256-GCM-SHA384         DH 2048    AESGCM      256      TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
›  xcca8   ECDHE-RSA-CHACHA20-POLY1305       ECDH 253   ChaCha20    256      TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
›  xccaa   DHE-RSA-CHACHA20-POLY1305         DH 2048    ChaCha20    256      TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256
›  xc02f   ECDHE-RSA-AES128-GCM-SHA256       ECDH 521   AESGCM      128      TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
›  x9e     DHE-RSA-AES128-GCM-SHA256         DH 2048    AESGCM      128      TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
```

###### SSLLabs 100%

- Cipher suites:

```nginx
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384";
```

- DH: **not used**

- SSL Labs scores:

  - Certificate: **100%**
  - Protocol Support: **100%**
  - Key Exchange: **90%**
  - Cipher Strength: **100%**

- SSLLabs suites in server-preferred order:

```
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (0xc030)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xcca8)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
```

- SSLLabs 'Handshake Simulation' errors:

```
Android 5.0.0 Server sent fatal alert: handshake_failure
Android 6.0 Server sent fatal alert: handshake_failure
Firefox 31.3.0 ESR / Win 7  Server sent fatal alert: handshake_failure
IE 11 / Win 7  R  Server sent fatal alert: handshake_failure
IE 11 / Win 8.1  R  Server sent fatal alert: handshake_failure
IE 11 / Win Phone 8.1  R  Server sent fatal alert: handshake_failure
IE 11 / Win Phone 8.1 Update  R Server sent fatal alert: handshake_failure
Safari 6 / iOS 6.0.1  Server sent fatal alert: handshake_failure
Safari 7 / iOS 7.1  R Server sent fatal alert: handshake_failure
Safari 7 / OS X 10.9  R Server sent fatal alert: handshake_failure
Safari 8 / iOS 8.4  R Server sent fatal alert: handshake_failure
Safari 8 / OS X 10.10  R  Server sent fatal alert: handshake_failure
```

- testssl.sh:

```
› SSLv2
› SSLv3
› TLS 1
› TLS 1.1
› TLS 1.2
›  xc030   ECDHE-RSA-AES256-GCM-SHA384       ECDH 521   AESGCM      256      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
›  xcca8   ECDHE-RSA-CHACHA20-POLY1305       ECDH 253   ChaCha20    256      TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
```

###### SSLLabs 90% (1)

- Cipher suites:

```nginx
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256";
```

- DH: **2048-bit**

- SSL Labs scores:

  - Certificate: **100%**
  - Protocol Support: **100%**
  - Key Exchange: **90%**
  - Cipher Strength: **90%**

- SSLLabs suites in server-preferred order:

```
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (0xc030)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (0x9f)   DH 2048 bits   FS  256
TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xcca8)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xccaa)   DH 2048 bits   FS  256
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (0xc02f)   ECDH x25519 (eq. 3072 bits RSA)   FS 128
TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 (0x9e)   DH 2048 bits   FS  128
```

- SSLLabs 'Handshake Simulation' errors:

```
IE 11 / Win Phone 8.1  R  Server sent fatal alert: handshake_failure
Safari 6 / iOS 6.0.1  Server sent fatal alert: handshake_failure
Safari 7 / iOS 7.1  R Server sent fatal alert: handshake_failure
Safari 7 / OS X 10.9  R Server sent fatal alert: handshake_failure
Safari 8 / iOS 8.4  R Server sent fatal alert: handshake_failure
Safari 8 / OS X 10.10  R  Server sent fatal alert: handshake_failure
```

- testssl.sh:

```
› SSLv2
› SSLv3
› TLS 1
› TLS 1.1
› TLS 1.2
›  xc030   ECDHE-RSA-AES256-GCM-SHA384       ECDH 521   AESGCM      256      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
›  x9f     DHE-RSA-AES256-GCM-SHA384         DH 2048    AESGCM      256      TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
›  xcca8   ECDHE-RSA-CHACHA20-POLY1305       ECDH 253   ChaCha20    256      TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
›  xccaa   DHE-RSA-CHACHA20-POLY1305         DH 2048    ChaCha20    256      TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256
›  xc02f   ECDHE-RSA-AES128-GCM-SHA256       ECDH 521   AESGCM      128      TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
›  x9e     DHE-RSA-AES128-GCM-SHA256         DH 2048    AESGCM      128      TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
```

###### SSLLabs 90% (2)

- Cipher suites:

```nginx
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256";
```

- DH: **not used**

- SSL Labs scores:

  - Certificate: **100%**
  - Protocol Support: **100%**
  - Key Exchange: **90%**
  - Cipher Strength: **90%**

- SSLLabs suites in server-preferred order:

```
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (0xc030)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xcca8)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (0xc02f)   ECDH x25519 (eq. 3072 bits RSA)   FS 128
TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 (0xc028)   ECDH x25519 (eq. 3072 bits RSA)   FS   WEAK  256
TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 (0xc027)   ECDH x25519 (eq. 3072 bits RSA)   FS   WEAK  128
```

- SSLLabs 'Handshake Simulation' errors:

```
No errors
```

- testssl.sh:

```
› SSLv2
› SSLv3
› TLS 1
› TLS 1.1
› TLS 1.2
›  xc030   ECDHE-RSA-AES256-GCM-SHA384       ECDH 521   AESGCM      256      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
›  xc028   ECDHE-RSA-AES256-SHA384           ECDH 521   AES         256      TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
›  xcca8   ECDHE-RSA-CHACHA20-POLY1305       ECDH 253   ChaCha20    256      TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
›  xc02f   ECDHE-RSA-AES128-GCM-SHA256       ECDH 521   AESGCM      128      TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
›  xc027   ECDHE-RSA-AES128-SHA256           ECDH 521   AES         128      TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
```

###### SSLLabs 90% (3)

- Cipher suites:

```nginx
ssl_ciphers "EECDH+CHACHA20:EDH+AESGCM:AES256+EECDH:AES256+EDH";
```

- DH: **2048-bit**

- SSL Labs scores:

  - Certificate: **100%**
  - Protocol Support: **100%**
  - Key Exchange: **90%**
  - Cipher Strength: **90%**

- SSLLabs suites in server-preferred order:

```
TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xcca8)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (0x9f)   DH 2048 bits   FS  256
TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 (0x9e)   DH 2048 bits   FS  128
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (0xc030)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 (0xc028)   ECDH x25519 (eq. 3072 bits RSA)   FS   WEAK  256
TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (0xc014)   ECDH x25519 (eq. 3072 bits RSA)   FS   WEAK 256
TLS_DHE_RSA_WITH_AES_256_CCM_8 (0xc0a3)   DH 2048 bits   FS 256
TLS_DHE_RSA_WITH_AES_256_CCM (0xc09f)   DH 2048 bits   FS 256
TLS_DHE_RSA_WITH_AES_256_CBC_SHA256 (0x6b)   DH 2048 bits   FS   WEAK 256
TLS_DHE_RSA_WITH_AES_256_CBC_SHA (0x39)   DH 2048 bits   FS   WEAK  256
```

- SSLLabs 'Handshake Simulation' errors:

```
No errors.
```

- testssl.sh:

```
› SSLv2
› SSLv3
› TLS 1
› TLS 1.1
› TLS 1.2
›  xc030   ECDHE-RSA-AES256-GCM-SHA384       ECDH 521   AESGCM      256      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
›  xc028   ECDHE-RSA-AES256-SHA384           ECDH 521   AES         256      TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
›  xc014   ECDHE-RSA-AES256-SHA              ECDH 521   AES         256      TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
›  x9f     DHE-RSA-AES256-GCM-SHA384         DH 2048    AESGCM      256      TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
›  xcca8   ECDHE-RSA-CHACHA20-POLY1305       ECDH 253   ChaCha20    256      TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
›  xc0a3   DHE-RSA-AES256-CCM8               DH 2048    AESCCM8     256      TLS_DHE_RSA_WITH_AES_256_CCM_8
›  xc09f   DHE-RSA-AES256-CCM                DH 2048    AESCCM      256      TLS_DHE_RSA_WITH_AES_256_CCM
›  x6b     DHE-RSA-AES256-SHA256             DH 2048    AES         256      TLS_DHE_RSA_WITH_AES_256_CBC_SHA256
›  x39     DHE-RSA-AES256-SHA                DH 2048    AES         256      TLS_DHE_RSA_WITH_AES_256_CBC_SHA
›  x9e     DHE-RSA-AES128-GCM-SHA256         DH 2048    AESGCM      128      TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
```

###### Mozilla modern profile

- Cipher suites:

```nginx
ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
```

- DH: **2048-bit**

- SSL Labs scores:

  - Certificate: **100%**
  - Protocol Support: **100%**
  - Key Exchange: **90%**
  - Cipher Strength: **90%**

- SSLLabs suites in server-preferred order:

```
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (0xc02f)   ECDH x25519 (eq. 3072 bits RSA)   FS 128
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (0xc030)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (0xcca8)   ECDH x25519 (eq. 3072 bits RSA)   FS 256
TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 (0x9e)   DH 2048 bits   FS  128
TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (0x9f)   DH 2048 bits   FS  256
```

- SSLLabs 'Handshake Simulation' errors:

```
IE 11 / Win Phone 8.1  R  Server sent fatal alert: handshake_failure
Safari 6 / iOS 6.0.1  Server sent fatal alert: handshake_failure
Safari 7 / iOS 7.1  R Server sent fatal alert: handshake_failure
Safari 7 / OS X 10.9  R Server sent fatal alert: handshake_failure
Safari 8 / iOS 8.4  R Server sent fatal alert: handshake_failure
Safari 8 / OS X 10.10  R  Server sent fatal alert: handshake_failure
```

- testssl.sh:

```
› SSLv2
› SSLv3
› TLS 1
› TLS 1.1
› TLS 1.2
›  xc030   ECDHE-RSA-AES256-GCM-SHA384       ECDH 521   AESGCM      256      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
›  x9f     DHE-RSA-AES256-GCM-SHA384         DH 2048    AESGCM      256      TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
›  xcca8   ECDHE-RSA-CHACHA20-POLY1305       ECDH 253   ChaCha20    256      TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
›  xc02f   ECDHE-RSA-AES128-GCM-SHA256       ECDH 521   AESGCM      128      TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
›  x9e     DHE-RSA-AES128-GCM-SHA256         DH 2048    AESGCM      128      TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
```

</details>

<details>
<summary><b>Scan results for each cipher suite (TLSv1.3 offered)</b></summary>

###### Mozilla modern profile (My recommendation)

- Cipher suites: **not set**

- DH: **2048-bit**

- SSL Labs scores:

  - Certificate: **100%**
  - Protocol Support: **100%**
  - Key Exchange: **90%**
  - Cipher Strength: **90%**

- SSLLabs suites in server-preferred order:

```
TLS_AES_256_GCM_SHA384 (0x1302)   ECDH x25519 (eq. 3072 bits RSA)   FS  256
TLS_CHACHA20_POLY1305_SHA256 (0x1303)   ECDH x25519 (eq. 3072 bits RSA)   FS  256
TLS_AES_128_GCM_SHA256 (0x1301)   ECDH x25519 (eq. 3072 bits RSA)   FS  128
```

- SSLLabs 'Handshake Simulation' errors:

```
Chrome 69 / Win 7  R  Server sent fatal alert: protocol_version
Firefox 62 / Win 7  R Server sent fatal alert: protocol_version
OpenSSL 1.1.0k  R Server sent fatal alert: protocol_version
```

- testssl.sh:

```
› SSLv2
› SSLv3
› TLS 1
› TLS 1.1
› TLS 1.2
› TLS 1.3
›  x1302   TLS_AES_256_GCM_SHA384            ECDH 253   AESGCM      256      TLS_AES_256_GCM_SHA384
›  x1303   TLS_CHACHA20_POLY1305_SHA256      ECDH 253   ChaCha20    256      TLS_CHACHA20_POLY1305_SHA256
›  x1301   TLS_AES_128_GCM_SHA256            ECDH 253   AESGCM      128      TLS_AES_128_GCM_SHA256
```

</details>

###### External resources

- [RFC 7525 - TLS Recommendations](https://tools.ietf.org/html/rfc7525) <sup>[IETF]</sup>
- [TLS Cipher Suites](https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-4) <sup>[IANA]</sup>
- [SEC 1: Elliptic Curve Cryptography](http://www.secg.org/sec1-v2.pdf) <sup>[pdf]</sup>
- [TLS Cipher Suite Search](https://ciphersuite.info/)
- [Elliptic Curve Cryptography: a gentle introduction](https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/)
- [SSL/TLS: How to choose your cipher suite](https://technology.amis.nl/2017/07/04/ssltls-choose-cipher-suite/)
- [HTTP/2 and ECDSA Cipher Suites](https://sparanoid.com/note/http2-and-ecdsa-cipher-suites/)
- [TLS 1.3 (with AEAD) and TLS 1.2 cipher suites demystified: how to pick your ciphers wisely](https://www.cloudinsidr.com/content/tls-1-3-and-tls-1-2-cipher-suites-demystified-how-to-pick-your-ciphers-wisely/)
- [Which SSL/TLS Protocol Versions and Cipher Suites Should I Use?](https://www.securityevaluators.com/ssl-tls-protocol-versions-cipher-suites-use/)
- [Recommendations for a cipher string by OWASP](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/TLS_Cipher_String_Cheat_Sheet.md)
- [Recommendations for TLS/SSL Cipher Hardening by Acunetix](https://www.acunetix.com/blog/articles/tls-ssl-cipher-hardening/)
- [Mozilla’s Modern compatibility suite](https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility)
- [Cloudflare SSL cipher, browser, and protocol support](https://support.cloudflare.com/hc/en-us/articles/203041594-Cloudflare-SSL-cipher-browser-and-protocol-support)
- [TLS & Perfect Forward Secrecy](https://vincent.bernat.ch/en/blog/2011-ssl-perfect-forward-secrecy)
- [Why use Ephemeral Diffie-Hellman](https://tls.mbed.org/kb/cryptography/ephemeral-diffie-hellman)
- [Cipher Suite Breakdown](https://blogs.technet.microsoft.com/askpfeplat/2017/12/26/cipher-suite-breakdown/)
- [Zombie POODLE and GOLDENDOODLE Vulnerabilities](https://blog.qualys.com/technology/2019/04/22/zombie-poodle-and-goldendoodle-vulnerabilities)
- [SSL Labs Grading Update: Forward Secrecy, Authenticated Encryption and ROBOT](https://blog.qualys.com/ssllabs/2018/02/02/forward-secrecy-authenticated-encryption-and-robot-grading-update)
- [Logjam: the latest TLS vulnerability explained](https://blog.cloudflare.com/logjam-the-latest-tls-vulnerability-explained/)
- [The CBC Padding Oracle Problem](https://eklitzke.org/the-cbc-padding-oracle-problem)
- [Goodbye TLS_RSA](https://lightshipsec.com/goodbye-tls_rsa/)
- [ImperialViolet - TLS Symmetric Crypto](https://www.imperialviolet.org/2014/02/27/tlssymmetriccrypto.html)
- [IETF drops RSA key transport from TLS 1.3](https://www.theinquirer.net/inquirer/news/2343117/ietf-drops-rsa-key-transport-from-ssl)
- [Why TLS 1.3 is a Huge Improvement](https://securityboulevard.com/2018/12/why-tls-1-3-is-a-huge-improvement/)
- [Overview of TLS v1.3 - What’s new, what’s removed and what’s changed?](https://owasp.org/www-chapter-london/assets/slides/OWASPLondon20180125_TLSv1.3_Andy_Brodie.pdf) <sup>[pdf]</sup>
- [OpenSSL IANA Mapping](https://testssl.sh/openssl-iana.mapping.html)
- [Testing for Weak SSL/TLS Ciphers, Insufficient Transport Layer Protection (OTG-CRYPST-001)](https://www.owasp.org/index.php/Testing_for_Weak_SSL/TLS_Ciphers,_Insufficient_Transport_Layer_Protection_(OTG-CRYPST-001))
- [Bypassing Web-Application Firewalls by abusing SSL/TLS](https://0x09al.github.io/waf/bypass/ssl/2018/07/02/web-application-firewall-bypass.html)
- [What level of SSL or TLS is required for HIPAA compliance?](https://luxsci.com/blog/level-ssl-tls-required-hipaa.html)
- [Cryptographic Right Answers](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html)
- [ImperialViolet - ChaCha20 and Poly1305 for TLS](https://www.imperialviolet.org/2013/10/07/chacha20.html)
- [Do the ChaCha: better mobile performance with cryptography](https://blog.cloudflare.com/do-the-chacha-better-mobile-performance-with-cryptography/)
- [AES Is Great … But We Need A Fall-back: Meet ChaCha and Poly1305](https://medium.com/asecuritysite-when-bob-met-alice/aes-is-great-but-we-need-a-fall-back-meet-chacha-and-poly1305-76ee0ee61895)
- [There’s never magic, but plenty of butterfly effects](https://docs.microsoft.com/en-us/archive/blogs/ieinternals/theres-never-magic-but-plenty-of-butterfly-effects)
- [Cipher suites (from this handbook)](SSL_TLS_BASICS.md#cipher-suites)

#### :beginner: Use more secure ECDH Curve

###### Rationale

  > Keep an eye also on this: _Secure implementations of the standard curves are theoretically possible but very hard._

  > In my opinion your main source of knowledge should be [The SafeCurves web site](https://safecurves.cr.yp.to/). This site reports security assessments of various specific curves.

  > For a SSL server certificate, an "elliptic curve" certificate will be used only with digital signatures (`ECDSA` algorithm). NGINX provides directive to specifies a curve for `ECDHE` ciphers (`ssl_ecdh_curve`).

  > `x25519` is a more secure (also with SafeCurves requirements) but slightly less compatible option. I think to maximise interoperability with existing browsers and servers, stick to `P-256` (`prime256v1`) and `P-384` (`secp384r1`) curves. Of course there's tons of different opinions about them.

  > NSA Suite B says that NSA uses curves `P-256` and `P-384` (in OpenSSL, they are designated as, respectively, `prime256v1` and `secp384r1`). There is nothing wrong with `P-521`, except that it is, in practice, useless. Arguably, `P-384` is also useless, because the more efficient `P-256` curve already provides security that cannot be broken through accumulation of computing power.

  > Bernstein and Lange believe that the NIST curves are not optimal and there are better (more secure) curves that work just as fast, e.g. `x25519`.

  > The SafeCurves say:
  >   - `NIST P-224`, `NIST P-256` and `NIST P-384` are **UNSAFE**

  > From the curves described here only `x25519` is a curve meets all SafeCurves requirements.

  > I think you can use `P-256` to minimise trouble. If you feel that your manhood is threatened by using a 256-bit curve where a 384-bit curve is available, then use `P-384`: it will increases your computational and network costs.

  > If you use TLS 1.3 you should enable `prime256v1` signature algorithm. Without this SSL Lab reports `TLS_AES_128_GCM_SHA256 (0x1301)` signature as weak.

  > If you do not set `ssl_ecdh_curve`, then NGINX will use its default settings, e.g. Chrome will prefer `x25519`, but it is **not recommended** because you can not control default settings (seems to be `P-256`) from the NGINX.

  > Explicitly set `ssl_ecdh_curve X25519:prime256v1:secp521r1:secp384r1;` **decreases the Key Exchange SSL Labs rating**.

  > Definitely do not use the `secp112r1`, `secp112r2`, `secp128r1`, `secp128r2`, `secp160k1`, `secp160r1`, `secp160r2`, `secp192k1` curves. They have a too small size for security application according to NIST recommendation.

  **My recommendation:**

  > Use only [TLSv1.3 and TLSv1.2](#keep-only-tls1.2-tls13) and [only strong ciphers](#use-only-strong-ciphers) with the following curves:
  ```nginx
  ssl_ecdh_curve X25519:secp521r1:secp384r1:prime256v1;
  ```

###### Example

Curves for TLS 1.2:

```nginx
ssl_ecdh_curve secp521r1:secp384r1:prime256v1;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

```nginx
# Alternative (this one doesn’t affect compatibility, by the way; it’s just a question of the preferred order).

# This setup downgrade Key Exchange score but is recommended for TLS 1.2 + TLS 1.3:
ssl_ecdh_curve X25519:secp521r1:secp384r1:prime256v1;
```

###### External resources

- [Elliptic Curves for Security](https://tools.ietf.org/html/rfc7748) <sup>[IETF]</sup>
- [Standards for Efficient Cryptography Group](http://www.secg.org/)
- [SafeCurves: choosing safe curves for elliptic-curve cryptography](https://safecurves.cr.yp.to/)
- [A note on high-security general-purpose elliptic curves](https://eprint.iacr.org/2013/647)
- [P-521 is pretty nice prime](https://blog.cr.yp.to/20140323-ecdsa.html)
- [Safe ECC curves for HTTPS are coming sooner than you think](https://certsimple.com/blog/safe-curves-and-openssl)
- [Cryptographic Key Length Recommendations](https://www.keylength.com/)
- [Testing for Weak SSL/TLS Ciphers, Insufficient Transport Layer Protection (OTG-CRYPST-001)](https://www.owasp.org/index.php/Testing_for_Weak_SSL/TLS_Ciphers,_Insufficient_Transport_Layer_Protection_(OTG-CRYPST-001))
- [Elliptic Curve performance: NIST vs Brainpool](https://tls.mbed.org/kb/cryptography/elliptic-curve-performance-nist-vs-brainpool)
- [Which elliptic curve should I use?](https://security.stackexchange.com/questions/78621/which-elliptic-curve-should-i-use/91562)
- [Elliptic Curve Cryptography for those who are afraid of maths](http://www.lapsedordinary.net/files/ECC_BSidesLDN_2015.pdf) <sup>[pdf]</sup>
- [Security dangers of the NIST curves](http://cr.yp.to/talks/2013.05.31/slides-dan+tanja-20130531-4x3.pdf) <sup>[pdf]</sup>
- [How to design an elliptic-curve signature system](http://blog.cr.yp.to/20140323-ecdsa.html)
- [Win10 Crypto Vulnerability: Cheating in Elliptic Curve Billiards 2](https://medium.com/zengo/win10-crypto-vulnerability-cheating-in-elliptic-curve-billiards-2-69b45f2dcab6)

#### :beginner: Use strong Key Exchange with Perfect Forward Secrecy

###### Rationale

  > These parameters determine how the OpenSSL library performs Diffie-Hellman (DH) key exchange (DH requires some set-up parameters to begin with which are generated with `openssl dhparam ...` and set in `ssl_dhparam` directive). From a mathematical point of view, they include a field prime `p` and a generator `g`. A larger `p` will make it more difficult to find a common and secret key `K`, protecting against passive attacks.

  > To use a signature based authentication you need some kind of DH exchange (fixed or ephemeral/temporary), to exchange the session key. If you use `DHE` ciphers but you do not specify these parameters, NGINX will use the default Ephemeral Diffie-Hellman paramaters to define how performs the Diffie-Hellman (DH) key-exchange. In older versions, NGINX used a weak key (by default: `1024 bit`) that gets lower scores.

  > You should always use the Elliptic Curve Diffie Hellman Ephemeral (`ECDHE`) and if you want to retain support for older customers also `DHE`. Due to increasing concern about pervasive surveillance, key exchanges that provide Forward Secrecy are recommended, see for example [RFC 7525 - Forward Secrecy](https://tools.ietf.org/html/rfc7525#section-6.3) <sup>[IETF]</sup>.

  > Make sure your OpenSSL library is updated to the latest available version and encourage your clients to also use updated software. Updated browsers discard low and vulnerable DH parameters (below 768/1024 bits).

  > For greater compatibility but still for security in key exchange, you should prefer the latter E (ephemeral) over the former E (EC). There is recommended configuration: `ECDHE` > `DHE` (with unique keys at least 2048 bits long) > `ECDH`. With this if the initial handshake fails, another handshake will be initiated using `DHE`.

  > `DHE` is slower than `ECDHE`. If you are concerned about performance, prioritize `ECDHE-ECDSA` or `ECDHE-RSA` over `DHE`. OWASP estimates that the TLS handshake with `DHE` hinders the CPU by a factor of 2.4 compared to `ECDHE`.

  > Diffie-Hellman requires some set-up parameters to begin with. Parameters from `ssl_dhparam` (which are generated with `openssl dhparam ...`) define how OpenSSL performs the Diffie-Hellman (DH) key-exchange. They include a field prime `p` and a generator `g`.

  > The purpose of the availability to customize these parameter is to allow everyone to use own parameters for this, and most importantly, finding such prime numbers is really computationally intensive and you can't afford them with every connection, so they are pre-calculated (set up from the HTTP server). In the case of NGINX, we set them using the ssl_dhparam directive. However, using custom parameters will make the server non-compliant with [FIPS](https://csrc.nist.gov/News/2018/NIST-Publishes-Updates-to-SP-800-56A-and-800-56C) requirements: _The publication approves the use of specific safe-prime groups of domain parameters for the finite field DH and MQV schemes, in addition to the previously approved domain parameter sets._ See also approved [TLS groups for FFC key agreement](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-56Ar3.pdf) (table 26, page 133) <sup>[NIST, pdf]</pdf>.

  > You can use custom parameters to prevent being affected from the Logjam attack (both the client and the server need to be vulnerable in order for the attack to succeed because the server must accept to sign small `DHE_EXPORT` parameters, and the client must accept them as valid `DHE` parameters).

  > Modern clients prefer `ECDHE` instead other variants and if your NGINX accepts this preference then the handshake will not use the DH param at all since it will not do a `DHE` key exchange but an `ECDHE` key exchange. Thus, if no plain `DH/DHE` ciphers are configured at your server but only Eliptic curve DH (e.g. `ECDHE`) then you don't need to set your own `ssl_dhparam` directive. Enabling `DHE` requires us to take care of our DH primes (a.k.a. `dhparams`) and to trust in `DHE` - in newer versions, NGINX does it for us.

  > Elliptic curve Diffie-Hellman is a modified Diffie-Hellman exchange which uses Elliptic curve cryptography instead of the traditional RSA-style large primes. So, while I'm not sure what parameters it may need (if any), I don't think it needs the kind you're generating (`ECDH` is based on curves, not primes, so I don't think the traditional DH params will do you any good).

  > Cipher suites using `DHE` key exchange in OpenSSL require `tmp_DH` parameters, which the `ssl_dhparam` directive provides. The same is true for `DH_anon` key exchange, but in practice nobody uses those. The OpenSSL wiki page for Diffie Hellman Parameters it says: _To use perfect forward secrecy cipher suites, you must set up Diffie-Hellman parameters (on the server side)._ Look also at [SSL_CTX_set_tmp_dh_callback](https://www.openssl.org/docs/man1.0.2/man3/SSL_CTX_set_tmp_dh.html).

  > If you use `ECDH/ECDHE` key exchange please see [Use more secure ECDH Curve](#beginner-use-more-secure-ecdh-curve) rule.

  > In older versions of OpenSSL, if no key size is specified, default key size was `512/1024 bits` - it was vulnerable and breakable. For the best security configuration use your own DH Group (min. `2048 bit`) or use known safe ones pre-defined DH groups (it's recommended; the pre-defined DH groups `ffdhe2048`, `ffdhe3072` or `ffdhe4096` recommended by the IETF in [RFC 7919 - Supported Groups Registry](https://tools.ietf.org/html/rfc7919#appendix-A) <sup>[IETF]</sup>, compliant with NIST and FIPS. They are audited and may be more resistant to attacks than ones randomly generated. Example of pre-defined groups:
  >
  >  - [ffdhe2048](https://ssl-config.mozilla.org/ffdhe2048.txt)
  >  - [ffdhe4096](https://ssl-config.mozilla.org/ffdhe4096.txt)

  > The `2048 bit` is generally expected to be safe and is already very far into the "cannot break it zone". However, years ago people expected 1024 bit to be safe so if you are after long term resistance you would go up to `4096 bit` (for both RSA keys and DH parameters). It's also important if you want to get 100% on Key Exchange of the SSL Labs test.

  > TLS clients should also reject static Diffie-Hellman - it's describe in [this](https://tools.ietf.org/id/draft-dkg-tls-reject-static-dh-00.html) draft.

  > You should remember that the `4096 bit` modulus will make DH computations slower and won’t actually improve security.

  There is [good explanation](https://security.stackexchange.com/questions/47204/dh-parameters-recommended-size/47207#47207) about DH parameters recommended size:

  > _Current recommendations from various bodies (including NIST) call for a `2048-bit` modulus for DH. Known DH-breaking algorithms would have a cost so ludicrously high that they could not be run to completion with known Earth-based technology. See this site for pointers on that subject._

  > _You don't want to overdo the size because the computational usage cost rises relatively sharply with prime size (somewhere between quadratic and cubic, depending on some implementation details) but a `2048-bit` DH ought to be fine (a basic low-end PC can do several hundreds of `2048-bit` DH per second)._

  Look also at this answer by [Matt Palmer](https://www.hezmatt.org/~mpalmer/blog/):

  > _Indeed, characterising `2048 bit` DH parameters as "weak as hell" is quite misleading. There are no known feasible cryptographic attacks against arbitrary strong 2048 bit DH groups. To protect against future disclosure of a session key due to breaking DH, sure, you want your DH parameters to be as long as is practical, but since `1024 bit` DH is only just getting feasible, `2048 bits` should be OK for most purposes for a while yet._

  Take a look at this interesting answer comes from [Guide to Deploying Diffie-Hellman for TLS](https://weakdh.org/sysadmin.html):

  > _2. Deploy (Ephemeral) Elliptic-Curve Diffie-Hellman (ECDHE). Elliptic-Curve Diffie-Hellman (ECDH) key exchange avoids all known feasible cryptanalytic attacks, and modern web browsers now prefer ECDHE over the original, finite field, Diffie-Hellman. The discrete log algorithms we used to attack standard Diffie-Hellman groups do not gain as strong of an advantage from precomputation, and individual servers do not need to generate unique elliptic curves._

  **My recommendation:**

  > If you use only TLS 1.3 - `ssl_dhparam` is not required (not used). Also, if you use `ECDHE/ECDH` - `ssl_dhparam` is not required (not used). If you use `DHE/DH` - `ssl_dhparam` with DH parameters is required (min. `2048 bit`). By default no parameters are set, and therefore `DHE` ciphers will not be used.

###### Example

To set DH params:

```nginx
# curl https://ssl-config.mozilla.org/ffdhe2048.txt --output ffdhe2048.pem
ssl_dhparam ffdhe2048.pem;
```

To generate DH params:

```bash
# To generate a DH parameters:
openssl dhparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

# To produce "DSA-like" DH parameters:
openssl dhparam -dsaparam -out /etc/nginx/ssl/dhparam_4096.pem 4096

# Use the pre-defined DH groups:
curl https://ssl-config.mozilla.org/ffdhe4096.txt > /etc/nginx/ssl/ffdhe4096.pem

# NGINX configuration only for DH/DHE:
ssl_dhparam /etc/nginx/ssl/dhparams_4096.pem;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>100%</b>

```bash
# To generate a DH parameters:
openssl dhparam -out /etc/nginx/ssl/dhparam_2048.pem 2048

# To produce "DSA-like" DH parameters:
openssl dhparam -dsaparam -out /etc/nginx/ssl/dhparam_2048.pem 2048

# Use the pre-defined DH groups:
curl https://ssl-config.mozilla.org/ffdhe2048.txt > /etc/nginx/ssl/ffdhe2048.pem

# NGINX configuration only for DH/DHE:
ssl_dhparam /etc/nginx/ssl/dhparam_2048.pem;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>90%</b>

###### External resources

- [Guide to Deploying Diffie-Hellman for TLS](https://weakdh.org/sysadmin.html)
- [Imperfect Forward Secrecy: How Diffie-Hellman Fails in Practice](https://weakdh.org/imperfect-forward-secrecy-ccs15.pdf) <sup>[pdf]</sup>
- [Weak Diffie-Hellman and the Logjam Attack](https://weakdh.org/)
- [Logjam: the latest TLS vulnerability explained](https://blog.cloudflare.com/logjam-the-latest-tls-vulnerability-explained/)
- [Pre-defined DHE groups](https://github.com/mozilla/ssl-config-generator/tree/master/docs)
- [Why is Mozilla recommending predefined DHE groups?](https://security.stackexchange.com/questions/149811/why-is-mozilla-recommending-predefined-dhe-groups)
- [Instructs OpenSSL to produce "DSA-like" DH parameters](https://security.stackexchange.com/questions/95178/diffie-hellman-parameters-still-calculating-after-24-hours/95184#95184)
- [OpenSSL generate different types of self signed certificate](https://security.stackexchange.com/questions/44251/openssl-generate-different-types-of-self-signed-certificate)
- [Public Diffie-Hellman Parameter Service/Tool](https://2ton.com.au/dhtool/)
- [Vincent Bernat's SSL/TLS & Perfect Forward Secrecy](http://vincent.bernat.im/en/blog/2011-ssl-perfect-forward-secrecy.html)
- [What's the purpose of DH Parameters?](https://security.stackexchange.com/questions/94390/whats-the-purpose-of-dh-parameters)
- [RSA and ECDSA performance](https://securitypitfalls.wordpress.com/2014/10/06/rsa-and-ecdsa-performance/)
- [SSL/TLS: How to choose your cipher suite](https://technology.amis.nl/2017/07/04/ssltls-choose-cipher-suite/)
- [Diffie-Hellman and its TLS/SSL usage](https://security.stackexchange.com/questions/41205/diffie-hellman-and-its-tls-ssl-usage)
- [Google Plans to Deprecate DHE Cipher Suites](https://www.digicert.com/blog/google-plans-to-deprecate-dhe-cipher-suites/)
- [Downgrade Attacks](https://tlseminar.github.io/downgrade-attacks/)
- [Diffie-Hellman key exchange (from this handbook)](SSL_TLS_BASICS.md#diffie-hellman-key-exchange)

#### :beginner: Prevent Replay Attacks on Zero Round-Trip Time

###### Rationale

  > This rules is only important for TLS 1.3. By default enabling TLS 1.3 will not enable 0-RTT support. After all, you should be fully aware of all the potential exposure factors and related risks with the use of this option.

  > 0-RTT Handshakes is part of the replacement of TLS Session Resumption and was inspired by the QUIC Protocol.

  > 0-RTT creates a significant security risk. With 0-RTT, a threat actor can intercept an encrypted client message and resend it to the server, tricking the server into improperly extending trust to the threat actor and thus potentially granting the threat actor access to sensitive data.

  > On the other hand, including 0-RTT (Zero Round Trip Time Resumption) results in a significant increase in efficiency and connection times. TLS 1.3 has a faster handshake that completes in 1-RTT. Additionally, it has a particular session resumption mode where, under certain conditions, it is possible to send data to the server on the first flight (0-RTT).

  > For example, Cloudflare only supports 0-RTT for [GET requests with no query parameters](https://new.blog.cloudflare.com/introducing-0-rtt/) in an attempt to limit the attack surface. Moreover, in order to improve identify connection resumption attempts, they relay this information to the origin by adding an extra header to 0-RTT requests. This header uniquely identifies the request, so if one gets repeated, the origin will know it's a replay attack (the application needs to track values received from that and reject duplicates on non-idempotent endpoints).

  > To protect against such attacks at the application layer, the `$ssl_early_data` variable should be used. You'll also need to ensure that the `Early-Data` header is passed to your application. `$ssl_early_data` returns 1 if TLS 1.3 early data is used and the handshake is not complete.

  > However, as part of the upgrade, you should disable 0-RTT until you can audit your application for this class of vulnerability.

  > In order to send early-data, client and server [must support PSK exchange mode](https://tools.ietf.org/html/rfc8446#section-2.3) <sup>[IETF]</sup> (session cookies).

  > In addition, I would like to recommend [this](https://news.ycombinator.com/item?id=16667036) great discussion about TLS 1.3 and 0-RTT.

  If you are unsure to enable 0-RTT, look what Cloudflare say about it:

  > _Generally speaking, 0-RTT is safe for most web sites and applications. If your web application does strange things and you’re concerned about its replay safety, consider not using 0-RTT until you can be certain that there are no negative effects. [...] TLS 1.3 is a big step forward for web performance and security. By combining TLS 1.3 with 0-RTT, the performance gains are even more dramatic._

###### Example

Test 0-RTT with OpenSSL:

```bash
# 1)
_host="example.com"

cat > req.in << __EOF__
HEAD / HTTP/1.1
Host: $_host
Connection: close
__EOF__
# or:
# echo -e "GET / HTTP/1.1\r\nHost: $_host\r\nConnection: close\r\n\r\n" > req.in

openssl s_client -connect ${_host}:443 -tls1_3 -sess_out session.pem -ign_eof < req.in
openssl s_client -connect ${_host}:443 -tls1_3 -sess_in session.pem -early_data req.in

# 2)
python -m sslyze --early_data "$_host"
```

Enable 0-RTT with `$ssl_early_data` variable:

```nginx
server {

  ...

  ssl_protocols TLSv1.2 TLSv1.3;
  # To enable 0-RTT (TLS 1.3):
  ssl_early_data on;

  location / {

    proxy_pass http://backend_x20;
    # It protect against such attacks at the application layer:
    proxy_set_header Early-Data $ssl_early_data;

  }

  ...

}
```

###### External resources

- [Security Review of TLS1.3 0-RTT](https://github.com/tlswg/tls13-spec/issues/1001)
- [Introducing Zero Round Trip Time Resumption (0-RTT)](https://new.blog.cloudflare.com/introducing-0-rtt/)
- [What Application Developers Need To Know About TLS Early Data (0RTT)](https://blog.trailofbits.com/2019/03/25/what-application-developers-need-to-know-about-tls-early-data-0rtt/)
- [Zero round trip time resumption (0-RTT)](https://www.riklewis.com/2019/08/zero-round-trip-time-resumption-0-rtt/)
- [Session Resumption Protocols and Efficient Forward Security for TLS 1.3 0-RTT](https://eprint.iacr.org/2019/228)
- [Replay Attacks on Zero Round-Trip Time: The Case of the TLS 1.3 Handshake Candidates](https://eprint.iacr.org/2017/082.pdf) <sup>[pdf]</sup>
- [0-RTT and Anti-Replay](https://tools.ietf.org/html/rfc8446#section-8) <sup>[IETF]</sup>
- [Using Early Data in HTTP (2017)](https://tools.ietf.org/id/draft-thomson-http-replay-00.html_) <sup>[IETF]</sup>
- [Using Early Data in HTTP (2018)](https://tools.ietf.org/html/draft-ietf-httpbis-replay-04) <sup>[IETF]</sup>
- [0-RTT Handshakes](https://ldapwiki.com/wiki/0-RTT%20Handshakes)

#### :beginner: Defend against the BEAST attack

###### Rationale

  > Generally the BEAST attack relies on a weakness in the way `CBC` mode is used in SSL/TLS (TLSv1.0 and earlier).

  > More specifically, to successfully perform the BEAST attack, there are some conditions which needs to be met:
  >
  >   - vulnerable version of SSL must be used using a block cipher (`CBC` in particular)
  >   - JavaScript or a Java applet injection - should be in the same origin of the web site
  >   - data sniffing of the network connection must be possible

  > To prevent possible use BEAST attacks you should enable server-side protection, which causes the server ciphers should be preferred over the client ciphers, and completely excluded TLS 1.0 from your protocol stack.

  > When `ssl_prefer_server_ciphers` is set to on, the web server owner can control which ciphers are available.

  > The reason why this control was preferred is old and insecure ciphers that were available in SSL, and TLS v1.0 and TLS v1.1 because when the server supports old TLS versions and `ssl_prefer_server_ciphers` is off, an adversary can interfere with the handshake and force the connection to use weak ciphers, therefore allowing decrypting of the connection.

  > The preferred setting in modern setups is `ssl_prefer_server_ciphers off,` because then the client device can choose his preferred encryption method based on the hardware capabilities of the client device. As such, we let the client choose the most performant cipher suite for their hardware configuration.

###### Example

```nginx
# In TLSv1.0 and TLSv1.1
ssl_prefer_server_ciphers on;

# In TLSv1.2 and TLSv1.3
ssl_prefer_server_ciphers off;
```

###### External resources

- [Here Come The ⊕ Ninjas](https://bug665814.bmoattachments.org/attachment.cgi?id=540839) <sup>[pdf]</sup>
- [An Illustrated Guide to the BEAST Attack](https://commandlinefanatic.com/cgi-bin/showarticle.cgi?article=art027)
- [How the BEAST Attack Works](https://www.netsparker.com/blog/web-security/how-the-beast-attack-works/)
- [Is BEAST still a threat?](https://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html)
- [SSL/TLS attacks: Part 1 – BEAST Attack](https://niiconsulting.com/checkmate/2013/12/ssltls-attacks-part-1-beast-attack/)
- [Beat the BEAST with TLS 1.1/1.2 and More](https://blogs.cisco.com/security/beat-the-beast-with-tls) <sup>[not found]</sup>
- [Duong and Rizzo's paper on the BEAST attack)](https://images.techhive.com/downloads/idge/imported/article/ifw/2011/09/26/beast_duong_rizzo.pdf) <sup>[pdf]</sup>
- [ImperialViolet - Real World Crypto 2013](https://www.imperialviolet.org/2013/01/13/rwc03.html)
- [Use only strong ciphers - Hardening - P1 (from this handbook)](#beginner-use-only-strong-ciphers)

#### :beginner: Mitigation of CRIME/BREACH attacks

###### Rationale

  > Disable HTTP compression or compress only zero sensitive content. Furthermore, you shouldn't use HTTP compression on private responses when using TLS.

  > By default, the `gzip` compression modules are installed but not enabled in the NGINX.

  > You should probably never use TLS compression. Some user agents (at least Chrome) will disable it anyways. Disabling SSL/TLS compression stops the attack very effectively (libraries like OpenSSL built with compression disabled using `no-comp` configuration option). A deployment of HTTP/2 over TLS 1.2 must disable TLS compression (please see [RFC 7540 - Use of TLS Features](https://tools.ietf.org/html/rfc7540#section-9.2) <sup>[IETF]</sup>).

  > CRIME exploits SSL/TLS compression which is disabled since NGINX 1.3.2. BREACH exploits only HTTP compression.

  > Some attacks are possible (e.g. the real BREACH attack is a complicated and this only applies if specific information is returned in the HTTP responses) because of gzip (HTTP compression not TLS compression) being enabled on SSL requests.

  > Compression is not the only requirement for the attack to be done so using it does not mean that the attack will succeed. Generally you should consider whether having an accidental performance drop on HTTPS sites is better than HTTPS sites being accidentally vulnerable.

  > In most cases, the best action is moving to TLS 1.3﻿ or disable gzip for SSL (in older TLS versions than 1.3) but some of resources explain that is not a decent option to solving this. Mitigation is mostly on an application level, however common mitigation is to add data of random length to any responses containing sensitive data (it's default behaviour of TLSv1.3 - [5.4. Record Padding](https://tools.ietf.org/html/draft-ietf-tls-tls13-21#section-5.4) <sup>[IETF]</sup>). For more information look at [nginx-length-hiding-filter-module](https://github.com/nulab/nginx-length-hiding-filter-module). This filter module provides functionality to append randomly generated HTML comment to the end of response body to hide correct response length and make it difficult for attackers to guess secure token.

  > I would gonna to prioritise security over performance but compression can be (I think) okay to HTTP compress publicly available static content like css or js and HTML content with zero sensitive info (like an "About Us" page).

###### Example

```nginx
# Disable dynamic HTTP compression:
gzip off;

# Enable dynamic HTTP compression for specific location context:
location ^~ /assets/ {

  gzip on;

  ...

}
```

###### External resources

- [Is HTTP compression safe?](https://security.stackexchange.com/questions/20406/is-http-compression-safe)
- [HTTP compression continues to put encrypted communications at risk](https://www.pcworld.com/article/3051675/http-compression-continues-to-put-encrypted-communications-at-risk.html)
- [SSL/TLS attacks: Part 2 – CRIME Attack](http://niiconsulting.com/checkmate/2013/12/ssltls-attacks-part-2-crime-attack/)
- [How BREACH works (as I understand it)](https://security.stackexchange.com/questions/172581/to-avoid-breach-can-we-use-gzip-on-non-token-responses/172646#172646)
- [Defending against the BREACH Attack](https://blog.qualys.com/ssllabs/2013/08/07/defending-against-the-breach-attack)
- [To avoid BREACH, can we use gzip on non-token responses?](https://security.stackexchange.com/questions/172581/to-avoid-breach-can-we-use-gzip-on-non-token-responses)
- [Brotli compression algorithm and BREACH attack](https://security.stackexchange.com/questions/172188/brotli-compression-algorithm-and-breach-attack/197535#197535)
- [Don't Worry About BREACH](https://blog.ircmaxell.com/2013/08/dont-worry-about-breach.html)
- [The current state of the BREACH attack](https://www.sjoerdlangkemper.nl/2016/11/07/current-state-of-breach-attack/)
- [Module ngx_http_gzip_static_module](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html)
- [Offline Compression with Nginx](https://theartofmachinery.com/2016/06/06/nginx_gzip_static.html)
- [ImperialViolet - Real World Crypto 2013](https://www.imperialviolet.org/2013/01/13/rwc03.html)

#### :beginner: Enable HTTP Strict Transport Security

###### Rationale

  > Generally HSTS is a way for websites to tell browsers that the connection should only ever be encrypted. This prevents MITM attacks, downgrade attacks, sending plain text cookies and session ids. The correct implementation of HSTS is an additional security mechanism in accordance with the principle of multilayer security (defense in depth).

  > This header is great for performance because it instructs the browser to do the HTTP to HTTPS redirection client-side, without ever touching the network.

  > The header indicates for how long a browser should unconditionally refuse to take part in unsecured HTTP connection for a specific domain.

  > When a browser knows that a domain has enabled HSTS, it does two things:
  >
  > - always uses an `https://` connection, even when clicking on an `http://` link or after typing a domain into the location bar without specifying a protocol
  > - removes the ability for users to click through warnings about invalid certificates

  > The HSTS header needs to be set inside the HTTP block with the `ssl` listen statement or you risk sending Strict-Transport-Security headers over HTTP sites you may also have configured on the server. Additionally, you should use `return 301` for the HTTP server block to be redirected to HTTPS.

  > Ideally, you should always use `includeSubdomains` with HSTS. This will provide robust security for the main hostname as well as all subdomains. The issue here is that (without `includeSubdomains`) a man in the middle attacker can create arbitrary subdomains and use them inject cookies into your application. In some cases, even leakage might occur. The drawback of `includeSubdomains`, of course, is that you will have to deploy all subdomains over SSL.

  > There are a few simple best practices for HSTS (from [The Importance of a Proper HTTP Strict Transport Security Implementation on Your Web Server](https://blog.qualys.com/securitylabs/2016/03/28/the-importance-of-a-proper-http-strict-transport-security-implementation-on-your-web-server)):
  >
  > - The strongest protection is to ensure that all requested resources use only TLS with a well-formed HSTS header. Qualys recommends providing an HSTS header on all HTTPS resources in the target domain
  >
  > - It is advisable to assign the `max-age` directive’s value to be greater than `10368000` seconds (120 days) and ideally to `31536000` (one year). Websites should aim to ramp up the `max-age` value to ensure heightened security for a long duration for the current domain and/or subdomains
  >
  > - [RFC 6797 - The Need for includeSubDomains](https://tools.ietf.org/html/rfc6797) <sup>[IETF]</sup>, advocates that a web application must aim to add the `includeSubDomain` directive in the policy definition whenever possible. The directive’s presence ensures the HSTS policy is applied to the domain of the issuing host and all of its subdomains, e.g. `example.com` and `www.example.com`
  >
  > - The application should never send an HSTS header over a plaintext HTTP header, as doing so makes the connection vulnerable to SSL stripping attacks
  >
  > - It is not recommended to provide an HSTS policy via the `http-equiv` attribute of a meta tag. According to [RFC 6797](https://tools.ietf.org/html/rfc6797) <sup>[IETF]</sup>, user agents don’t heed `http-equiv="Strict-Transport-Security"` attribute on `<meta>` elements on the received content

  > To meet the [HSTS preload list](https://hstspreload.org/) standard a root domain needs to return a `strict-transport-security` header that includes both the `includeSubDomains` and `preload` directives and has a minimum `max-age` of one year. Your site must also serve a valid SSL certificate on the root domain and all subdomains, as well as redirect all HTTP requests to HTTPS on the same host.

  > You had better be pretty sure that your website is indeed all HTTPS before you turn this on because HSTS adds complexity to your rollback strategy. Google recommend enabling HSTS this way:
  >
  >   1) Roll out your HTTPS pages without HSTS first
  >   2) Start sending HSTS headers with a short `max-age`. Monitor your traffic both from users and other clients, and also dependents' performance, such as ads
  >   3) Slowly increase the HSTS `max-age`
  >   4) If HSTS doesn't affect your users and search engines negatively, you can, if you wish, ask your site to be added to the HSTS preload list used by most major browsers

  **My recommendation:**

  > Set the `max-age` to a big value like `31536000` (12 months) or `63072000` (24 months) with `includeSubdomains` parameter.

###### Example

```nginx
add_header Strict-Transport-Security "max-age=63072000; includeSubdomains" always;
```

&nbsp;&nbsp;:arrow_right: ssllabs score: <b>A+</b>

###### External resources

- [OWASP Secure Headers Project - HSTS](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project#hsts)
- [Strict-Transport-Security](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security)
- [Security HTTP Headers - Strict-Transport-Security](https://zinoui.com/blog/security-http-headers#strict-transport-security)
- [HTTP Strict Transport Security](https://https.cio.gov/hsts/)
- [HTTP Strict Transport Security Cheat Sheet](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)
- [HSTS Cheat Sheet](https://scotthelme.co.uk/hsts-cheat-sheet/)
- [HSTS Preload and Subdomains](https://textslashplain.com/2018/04/09/hsts-preload-and-subdomains/)
- [Check HSTS preload status and eligibility](https://hstspreload.org/)
- [HTTP Strict Transport Security (HSTS) and NGINX](https://www.nginx.com/blog/http-strict-transport-security-hsts-and-nginx/)
- [Is HSTS as a proper substitute for HTTP-to-HTTPS redirects?](https://www.reddit.com/r/bigseo/comments/8zw45d/is_hsts_as_a_proper_substitute_for_httptohttps/)
- [How to configure HSTS on www and other subdomains](https://www.danielmorell.com/blog/how-to-configure-hsts-on-www-and-other-subdomains)
- [HSTS: Is includeSubDomains on main domain sufficient?](https://serverfault.com/questions/927336/hsts-is-includesubdomains-on-main-domain-sufficient)
- [The HSTS preload list eligibility](https://www.danielmorell.com/blog/how-to-configure-hsts-on-www-and-other-subdomains)
- [HSTS Deployment Recommendations](https://hstspreload.org/#deployment-recommendations)
- [How does HSTS handle mixed content?](https://serverfault.com/questions/927145/how-does-hsts-handle-mixed-content)
- [Broadening HSTS to secure more of the Web](https://security.googleblog.com/2017/09/broadening-hsts-to-secure-more-of-web.html)
- [The Road To HSTS](https://engineeringblog.yelp.com/2017/09/the-road-to-hsts.html)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Reduce XSS risks (Content-Security-Policy)

###### Rationale

  > CSP reduce the risk and impact a wide range of attacks, including cross-site scripting and other cross-site injections in modern browsers (Cross-Site Scripting vulnerabilities allows you to enter into the code of the displayed page elements that will be executed by the browser when displaying the page (in particular, unauthorized scripts executed by the attacker's browser)). Is a good defence-in-depth measure to make exploitation of an accidental lapse in that less likely.

  > The inclusion of CSP policies significantly impedes successful XSS attacks, UI Redressing (Clickjacking), malicious use of frames or CSS injections.

  > Whitelisting known-good resource origins, refusing to execute potentially dangerous inline scripts, and banning the use of eval are all effective mechanisms for mitigating cross-site scripting attacks.

  > The default policy that starts building a header is: block everything. By modifying the CSP value, administrator/programmer loosens restrictions for specific groups of resources (e.g. separately for scripts, images, etc.).

  > You should approach very individually and never set CSP sample values found on the Internet or anywhere else. Blindly deploying "standard/recommend" versions of the CSP header will broke the most of web apps. Be aware that incorrectly configured Content Security Policy could expose an application against client-side threats including Cross-Site Scripting, Cross Frame Scripting and Cross-Site Request Forgery.

  > Before enabling this header, you should discuss about CSP parameters with developers and application architects. They probably going to have to update web application to remove any inline scripts and styles, and make some additional modifications there (implementation of content validation mechanisms introduced by users, use of lists of allowed characters that can be entered into individual fields of the application by its users or encoding of user data transferred by the application to the browser).

  > Strict policies will significantly increase security, and higher code quality will reduce the overall number of errors. CSP can never replace secure code - new restrictions help reduce the effects of attacks (such as XSS), but they are not mechanisms to prevent them!

  > You should always validate CSP before implement:
  >
  > - [CSP Evaluator](https://csp-evaluator.withgoogle.com/)
  > - [Content Security Policy (CSP) Validator](https://cspvalidator.org/)

  > For generate a policy (remember, however, that these types of tools may become outdated or have errors):
  >
  > - [https://report-uri.com/home/generate](https://report-uri.com/home/generate)

###### Example

```nginx
# This policy allows images, scripts, AJAX, and CSS from the same origin, and does not allow any other resources to load:
add_header Content-Security-Policy "default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self';" always;
```

###### External resources

- [OWASP Secure Headers Project - Content-Security-Policy](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project#csp)
- [Content Security Policy (CSP) Quick Reference Guide](https://content-security-policy.com/)
- [Content Security Policy Cheat Sheet – OWASP](https://www.owasp.org/index.php/Content_Security_Policy_Cheat_Sheet)
- [Content Security Policy – OWASP](https://www.owasp.org/index.php/Content_Security_Policy)
- [Content Security Policy - An Introduction - Scott Helme](https://scotthelme.co.uk/content-security-policy-an-introduction/)
- [CSP Cheat Sheet - Scott Helme](https://scotthelme.co.uk/csp-cheat-sheet/)
- [Security HTTP Headers - Content-Security-Policy](https://zinoui.com/blog/security-http-headers#content-security-policy)
- [CSP Evaluator](https://csp-evaluator.withgoogle.com/)
- [Content Security Policy (CSP) Validator](https://cspvalidator.org/)
- [Can I Use CSP](https://caniuse.com/#search=CSP)
- [CSP Is Dead, Long Live CSP!](https://ai.google/research/pubs/pub45542)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Control the behaviour of the Referer header (Referrer-Policy)

###### Rationale

  > Referral policy deals with what information (related to the url) the browser ships to a server to retrieve an external resource.

  > Basically this is a privacy enhancement, when you want to hide information for owner of the domain of a link where is clicked that the user came from your website.

  > I think the most secure value is `no-referrer` which specifies that no referrer information is to be sent along with requests made from a particular request client to any origin. The header will be omitted entirely.

  > The use of `no-referrer` has its advantages because it allows you to hide the HTTP header, and this increases online privacy and the security of users themselves. On the other hand, it can mainly affects analytics (in theory, should not have any SEO impact) because `no-referrer` specifies to hide that kind of information.

  > Mozilla has a good table explaining how each of referrer policy options works. It comes from [Mozilla's reference documentation about Referer Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy).

###### Example

```nginx
# This policy does not send information about the referring site after clicking the link:
add_header Referrer-Policy "no-referrer";
```

###### External resources

- [OWASP Secure Headers Project - Referrer-Policy](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project#rp)
- [A new security header: Referrer Policy](https://scotthelme.co.uk/a-new-security-header-referrer-policy/)
- [Security HTTP Headers - Referrer-Policy](https://zinoui.com/blog/security-http-headers#referrer-policy)
- [What you need to know about Referrer Policy](https://searchengineland.com/need-know-referrer-policy-276185)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Provide clickjacking protection (X-Frame-Options)

###### Rationale

  > Helps to protect your visitors against clickjacking attacks by declaring a policy whether your application may be embedded on other (external) pages using frames.

  > It is recommended that you use the `x-frame-options` header on pages which should not be allowed to render a page in a frame.

  > This header allows 3 parameters, but in my opinion you should consider only two: a `deny` parameter to disallow embedding the resource in general or a `sameorigin` parameter to allow embedding the resource on the same host/origin.

  > It has a lower priority than CSP but in my opinion it is worth using as a fallback.

###### Example

```nginx
# Only pages from the same domain can "frame" this URL:
add_header X-Frame-Options "SAMEORIGIN" always;
```

###### External resources

- [OWASP Secure Headers Project - X-Frame-Options](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project#xfo)
- [HTTP Header Field X-Frame-Options](https://tools.ietf.org/html/rfc7034) <sup>[IETF]</sup>
- [Clickjacking Defense Cheat Sheet](https://www.owasp.org/index.php/Clickjacking_Defense_Cheat_Sheet)
- [Security HTTP Headers - X-Frame-Options](https://zinoui.com/blog/security-http-headers#x-frame-options)
- [X-Frame-Options - Scott Helme](https://scotthelme.co.uk/hardening-your-http-response-headers/#x-frame-options)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Prevent some categories of XSS attacks (X-XSS-Protection)

###### Rationale

  > Enable the cross-site scripting (XSS) filter built into modern web browsers.

  >  It's usually enabled by default anyway, so the role of this header is to re-enable the filter for this particular website if it was disabled by the user.

  > I think you can set this header without consulting its value with web application architects but all well written apps have to emit header `X-XSS-Protection: 0` and just forget about this feature. If you want to have extra security that better user agents can provide, use a strict `Content-Security-Policy` header. There is an [exact answer](https://stackoverflow.com/a/57802070) by [Mikko Rantalainen](https://stackoverflow.com/users/334451/mikko-rantalainen).

###### Example

```nginx
add_header X-XSS-Protection "1; mode=block" always;
```

###### External resources

- [OWASP Secure Headers Project - X-XSS-Protection](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project#xxxsp)
- [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://www.owasp.org/index.php/XSS_(Cross_Site_Scripting)_Prevention_Cheat_Sheet)
- [DOM based XSS Prevention Cheat Sheet](https://www.owasp.org/index.php/DOM_based_XSS_Prevention_Cheat_Sheet)
- [X-XSS-Protection HTTP Header](https://www.tunetheweb.com/security/http-security-headers/x-xss-protection/)
- [Security HTTP Headers - X-XSS-Protection](https://zinoui.com/blog/security-http-headers#x-xss-protection)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Prevent Sniff Mimetype middleware (X-Content-Type-Options)

###### Rationale

  > It prevents the browser from doing MIME-type sniffing.

  > Setting this header will prevent the browser from interpreting files as something else than declared by the content type in the HTTP headers.

###### Example

```nginx
# Disallow content sniffing:
add_header X-Content-Type-Options "nosniff" always;
```

###### External resources

- [OWASP Secure Headers Project - X-Content-Type-Options](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project#xcto)
- [X-Content-Type-Options HTTP Header](https://www.keycdn.com/support/x-content-type-options)
- [Security HTTP Headers - X-Content-Type-Options](https://zinoui.com/blog/security-http-headers#x-content-type-options)
- [X-Content-Type-Options - Scott Helme](https://scotthelme.co.uk/hardening-your-http-response-headers/#x-content-type-options)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Deny the use of browser features (Feature-Policy)

###### Rationale

  > This header protects your site from third parties using APIs that have security and privacy implications, and also from your own team adding outdated APIs or poorly optimised images.

###### Example

```nginx
add_header Feature-Policy "geolocation 'none'; midi 'none'; notifications 'none'; push 'none'; sync-xhr 'none'; microphone 'none'; camera 'none'; magnetometer 'none'; gyroscope 'none'; speaker 'none'; vibrate 'none'; fullscreen 'none'; payment 'none'; usb 'none';";
```

###### External resources

- [Feature Policy Explainer](https://docs.google.com/document/d/1k0Ua-ZWlM_PsFCFdLMa8kaVTo32PeNZ4G7FFHqpFx4E/edit)
- [Policy Controlled Features](https://github.com/w3c/webappsec-feature-policy/blob/master/features.md)
- [Security HTTP Headers - Feature-Policy](https://zinoui.com/blog/security-http-headers#feature-policy)
- [Feature policy playground](https://featurepolicy.info/)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Reject unsafe HTTP methods

###### Rationale

  > An ordinary web server supports the `GET`, `HEAD` and `POST` methods to retrieve static and dynamic content. Other (e.g. `OPTIONS`, `TRACE`) methods should not be supported on public web servers, as they increase the attack surface.

  > Some of these methods are typically dangerous to expose, and some are just extraneous in a production environment, which could be considered extra attack surface. Still, worth shutting those off too, since you probably wont need them.

  > Some of the APIs (e.g. RESTful APIs) uses also other methods. In addition to the following protection, application architects should also verify incoming requests.

  > Support for the `TRACE` method can allow Cross-Site Tracing attack that can facilitate to capture of the session ID of another application user. In addition, this method can be used to attempt to identify additional information about the environment in which the application operates (e.g. existence of cache servers on the path to the application).

  > Support for the `OPTIONS` method is not a direct threat, but it is a source of additional information for the attacker that can facilitate an effective attack.

  > Support for the `HEAD` method is also risky (really!) - it is not considered dangerous but it can be used to attack a web application by mimicking the `GET` request. Secondly, usage of `HEAD` can speed up the attack process by limiting the volume of data sent from the server. If the authorization mechanisms are based on the `GET` and `POST`, the `HEAD` method may allow to bypass these protections.

  > I think, that `HEAD` requests are commonly used by proxies or CDN's to efficiently determine whether a page has changed without downloading the entire body (it is useful for retrieving meta-information written in response headers). What's more, if you disabled it, you'd just increase your throughput cost.

  > It is not recommended to use `if` statements to block unsafe HTTP methods, instead you can use `limit_except` directive (should be faster than regexp evaluation), but remember, it has limited use: inside `location` only. I think, use of regular expressions in this case is a bit more flexible.

  > Before chosing to configure either method, note this incredible explanation of the [difference between 401, 403 and 405 HTTP response codes](https://serverfault.com/questions/905708/using-limit-except-to-deny-all-except-get-head-and-post/905922#905922) (with example that combines the 401, 403 and 405 responses and should clarify their precendence in a typical configuration). There is a brief description of HTTP method differences:
  >
  >   - 0: A request comes in...
  >   - 1: `405 Method Not Allowed` refers to the server not allowing that method on that uri
  >   - 2: `401 Unauthorized` refers to the user is not authenticated
  >   - 3: `403 Forbidden` refers to the accessing client not being authorized to do that request

  > In my opinion, if a HTTP resource is not able to handle a request with the given HTTP method, it should send an `Allow` header to list the allowed HTTP methods. For this, you may use `add_header` but remember of [potential problems](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly).

###### Example

Recommended configuration:

```nginx
# If we are in server context, it’s good to use construction like this:
add_header Allow "GET, HEAD, POST" always;

if ($request_method !~ ^(GET|HEAD|POST)$) {

  # You can also use 'add_header' inside 'if' context:
  # add_header Allow "GET, HEAD, POST" always;
  return 405;

}
```

Alternative configuration (only inside `location` context):

```nginx
# Note: allowing the GET method makes the HEAD method also allowed.
location /api {

  limit_except GET POST {

    allow 192.168.1.0/24;
    deny  all;  # always return 403 error code

    # or:
    # auth_basic "Restricted access";
    # auth_basic_user_file /etc/nginx/htpasswd;

    ...

  }

}
```

But never do nothing like this one (it is highly not recommend!) with mixed `allow/deny` and `return` directives:

```nginx
location /api {

  limit_except GET POST {

    allow 192.168.1.0/24;
    # It's only example (return is not allowed in limit_except),
    # all clients (also from 192.168.1.0/24) might get 405 error code if it worked:
    return 405;

    ...

  }

}
```

###### External resources

- [Hypertext Transfer Protocol (HTTP) Method Registry](https://www.iana.org/assignments/http-methods/http-methods.xhtml) <sup>[IANA]</sup>
- [Vulnerability name: Unsafe HTTP methods](https://www.onwebsecurity.com/security/unsafe-http-methods.html)
- [Cross Site Tracing](https://owasp.org/www-community/attacks/Cross_Site_Tracing)
- [Cross-Site Tracing (XST): The misunderstood vulnerability](https://deadliestwebattacks.com/2010/05/18/cross-site-tracing-xst-the-misunderstood-vulnerability/)
- [Penetration Testing Of A Web Application Using Dangerous HTTP Methods](https://www.sans.org/reading-room/whitepapers/testing/penetration-testing-web-application-dangerous-http-methods-33945) <sup>[pdf]</sup>
- [Blocking/allowing IP addresses (from this handbook)](HELPERS.md#blockingallowing-ip-addresses)
- [allow and deny (from this handbook)](NGINX_BASICS.md#allow-and-deny)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Prevent caching of sensitive data

###### Rationale

  > This policy should be implemented by the application architect, however, I know from experience that this does not always happen.

  > Don' to cache or persist sensitive data. As browsers have different default behaviour for caching HTTPS content, pages containing sensitive information should include a `Cache-Control` header to ensure that the contents are not cached.

  > One option is to add anticaching headers to relevant HTTP/1.1 and HTTP/2 responses, e.g. `Cache-Control: no-cache, no-store` and `Expires: 0`.

  > To cover various browser implementations the full set of headers to prevent content being cached should be:
  >
  > 1 - `Cache-Control: no-cache, no-store, private, must-revalidate, max-age=0, no-transform`<br>
  > 2 - `Pragma: no-cache`<br>
  > 3 - `Expires: 0`

###### Example

```nginx
location /api {

  expires 0;
  add_header Cache-Control "no-cache, no-store";

}
```

###### External resources

- [RFC 2616 - HTTP/1.1: Standards Track](https://tools.ietf.org/html/rfc2616) <sup>[IETF]</sup>
- [RFC 7234 - HTTP/1.1: Caching](https://tools.ietf.org/html/rfc7234) <sup>[IETF]</sup>
- [HTTP Cache Headers - A Complete Guide](https://www.keycdn.com/blog/http-cache-headers)
- [Caching best practices & max-age gotchas](https://jakearchibald.com/2016/caching-best-practices/)
- [Increasing Application Performance with HTTP Cache Headers](https://devcenter.heroku.com/articles/increasing-application-performance-with-http-cache-headers)
- [HTTP Caching](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Limit concurrent connections

###### Rationale

  > NGINX provides basic and simple to enable protection from denial of service attacks like DoS. By default, there are no limitations on the number of active connections a user can have.

  > In my opinion, it is also good to cut off redundant/unnecessary connections globally (in the `http` context), but be careful and monitor your access and error logs. You can set this on a per NGINX `location` match context too i.e. set it for search pages, online user displays, member lists etc.

  > You should limit the number of sessions that can be opened by a single client IP address, again to a value appropriate for real users. Because most often the excess traffic is generated by bots and is meant to overwhelm the server, the rate of traffic is much higher than a human user can generate. The limit concurrent connections must be active to enable a maximum session limit.

  > However, note that while NGINX is a key element of Cloudflare-style protection, it’s not enough to set NGINX up on your webserver and hope it will protect you.

  > IP connection limits will help to certain degree though with a large enough layer 7 ddos attack, it can still overwhelm your server. For me, the first line of defense should be the hardware firewall (but it is not enough) or DDoS mitigation devices with stateless protection mechanism that can handle millions of connection attempts (to provide deep inspection to filter out bad traffic and allow good traffic through) without requiring connection table entries or exhausting other system resources.

  > In particular, it is a good idea enable the mitigation on the network providers side and route the traffic through a layer 7 DDoS mitigation filter provided by an external company before it reaches you. I think it is the best solution.

###### Example

```nginx
http {

  limit_conn_zone $binary_remote_addr zone=slimit:10m;

  # Set globally:
  limit_conn slimit 10;

  ...

  server {

    # Or in the server context:
    limit_conn slimit 10;

    ...

  }

}
```

###### External resources

- [Module ngx_http_limit_conn_module](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html)
- [Mitigating DDoS Attacks with NGINX and NGINX Plus](https://www.nginx.com/blog/mitigating-ddos-attacks-with-nginx-and-nginx-plus/)
- [What is a DDoS Attack?](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/)
- [Nginx-Lua-Anti-DDoS](https://github.com/C0nw0nk/Nginx-Lua-Anti-DDoS)
- [Extend NGINX with Lua — DDOS Mitigation using Cookie validation](https://medium.com/@satrobit/extend-nginx-with-lua-ddos-mitigation-using-cookie-validation-8b27ffc1322a)
- [Blocking/allowing IP addresses (from this handbook)](HELPERS.md#blockingallowing-ip-addresses)
- [allow and deny (from this handbook)](NGINX_BASICS.md#allow-and-deny)
- [ngx_http_geoip_module (from this handbook)](NGINX_BASICS.md#ngx-http-geoip-module)
- [Control Buffer Overflow attacks - Hardening - P2 (from this handbook)](#beginner-control-buffer-overflow-attacks)
- [Mitigating Slow HTTP DoS attacks (Closing Slow Connections) - Hardening - P2 (from this handbook)](#beginner-mitigating-slow-http-dos-attacks-closing-slow-connections)
- [Use limit_conn to improve limiting the download speed - Performance - P3 (from this handbook)](#beginner-use-limit_conn-to-improve-limiting-the-download-speed)

#### :beginner: Control Buffer Overflow attacks

###### Rationale

  > Buffer overflow attacks are made possible by writing data to a buffer and exceeding that buffers’ boundary and overwriting memory fragments of a process. To prevent this in NGINX we can set buffer size limitations for all clients.

  > The large size of `POST` requests can effectively lead to a DoS attack if the entire server memory is used. Allowing large files to be uploaded to the server can make it easier for an attacker to utilize system resources and successfully perform a denial of service.

  > Corresponding values depends on your server memory and how many traffic you have. Long ago I found an interesting formula:
  >
  > &nbsp;&nbsp;`MAX_MEMORY = client_body_buffer_size x CONCURRENT_TRAFFIC - OS_RAM - FS_CACHE`
  >
  > I think the key is to monitor all the things (MEMORY/CPU/Traffic) and change settings according your usage, star little of course then increase until you can.

  > In my opinion, using a smaller `client_body_buffer_size` (a little bigger than 10k but not so much) is definitely better, since a bigger buffer could ease DoS attack vectors, since you would allocate more memory for it.

  > Tip: If a request body is larger than `client_body_buffer_size`, it's written to disk and not available in memory, hence no `$request_body`. Additionally, setting the `client_body_buffer_size` to high may affect the log file size (if you log `$request_body`).

###### Example

```nginx
client_body_buffer_size 16k;      # default: 8k (32-bit) | 16k (64-bit)
client_header_buffer_size 1k;     # default: 1k
client_max_body_size 100k;        # default: 1m
large_client_header_buffers 2 1k; # default: 4 8k
```

###### External resources

- [Module ngx_http_core_module](http://nginx.org/en/docs/http/ngx_http_core_module.html)
- [SCG WS nginx](https://www.owasp.org/index.php/SCG_WS_nginx)

#### :beginner: Mitigating Slow HTTP DoS attacks (Closing Slow Connections)

###### Rationale

  > You can close connections that are writing data too infrequently, which can represent an attempt to keep connections open as long as possible (thus reducing the server’s ability to accept new connections).

  > In my opinion, 2-3 seconds for `keepalive_timeout` are often enough for most folks to parse HTML/CSS and retrieve needed images, icons, or frames, connections are cheap in NGINX so increasing this is generally safe. However, setting this too high will result in the waste of resources (mainly memory) as the connection will remain open even if there is no traffic, potentially: significantly affecting performance. I think this should be as close to your average response time as possible.

  > I would also suggest that if you set the `send_timeout` small then your web server will close connections quickly which will give more overall connections available to connecting hosts.

  > These parameters are most likely only relevant in a high traffic webserver. Both are supporting the same goal and that is less connections and more efficient handling of requests. Either putting all requests into one connection (keep alive) or closing connections quickly to handle more requests (send timeout).

###### Example

```nginx
client_body_timeout 10s;    # default: 60s
client_header_timeout 10s;  # default: 60s
keepalive_timeout 5s 5s;    # default: 75s
send_timeout 10s;           # default: 60s
```

###### External resources

- [Module ngx_http_core_module](http://nginx.org/en/docs/http/ngx_http_core_module.html)
- [Module ngx_http_limit_conn_module](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html)
- [Mitigating DDoS Attacks with NGINX and NGINX Plus](https://www.nginx.com/blog/mitigating-ddos-attacks-with-nginx-and-nginx-plus/)
- [What is a DDoS Attack?](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/)
- [SCG WS nginx](https://www.owasp.org/index.php/SCG_WS_nginx)
- [How to Protect Against Slow HTTP Attacks](https://blog.qualys.com/securitylabs/2011/11/02/how-to-protect-against-slow-http-attacks)
- [Effectively Using and Detecting The Slowloris HTTP DoS Tool](https://ma.ttias.be/effectively-using-detecting-the-slowloris-http-dos-tool/)
- [Limit concurrent connections - Hardening - P1 (from this handbook)](#beginner-limit-concurrent-connections)

# Reverse Proxy

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

  > :pushpin:&nbsp; One of the frequent uses of the NGINX is setting it up as a proxy server that can off load much of the infrastructure concerns of a high-volume distributed web application.

- **[Base Rules](#base-rules)**
- **[Debugging](#debugging)**
- **[Performance](#performance)**
- **[Hardening](#hardening)**
- **[≡ Reverse Proxy (8)](#reverse-proxy)**
  * [Use pass directive compatible with backend protocol](#beginner-use-pass-directive-compatible-with-backend-protocol)
  * [Be careful with trailing slashes in proxy_pass directive](#beginner-be-careful-with-trailing-slashes-in-proxy_pass-directive)
  * [Set and pass Host header only with $host variable](#beginner-set-and-pass-host-header-only-with-host-variable)
  * [Set properly values of the X-Forwarded-For header](#beginner-set-properly-values-of-the-x-forwarded-for-header)
  * [Don't use X-Forwarded-Proto with $scheme behind reverse proxy](#beginner-dont-use-x-forwarded-proto-with-scheme-behind-reverse-proxy)
  * [Always pass Host, X-Real-IP, and X-Forwarded headers to the backend](#beginner-always-pass-host-x-real-ip-and-x-forwarded-headers-to-the-backend)
  * [Use custom headers without X- prefix](#beginner-use-custom-headers-without-x--prefix)
  * [Always use $request_uri instead of $uri in proxy_pass](#beginner-always-use-request_uri-instead-of-uri-in-proxy_pass)
- **[Load Balancing](#load-balancing)**
- **[Others](#others)**

#### :beginner: Use pass directive compatible with backend protocol

###### Rationale

  > All `proxy_*` directives are related to the backends that use the specific backend protocol.

  > You should always use `proxy_pass` only for HTTP servers working on the backend layer (set also the `http://` protocol before referencing the HTTP backend) and other `*_pass` directives only for non-HTTP backend servers (like a uWSGI or FastCGI).

  > Directives such as `uwsgi_pass`, `fastcgi_pass`, or `scgi_pass` are designed specifically for non-HTTP apps and you should use them instead of the `proxy_pass` (non-HTTP talking).

  > For example: `uwsgi_pass` uses an uwsgi protocol. `proxy_pass` uses normal HTTP to talking with uWSGI server. uWSGI docs claims that uwsgi protocol is better, faster and can benefit from all of uWSGI special features. You can send to uWSGI information what type of data you are sending and what uWSGI plugin should be invoked to generate response. With http (`proxy_pass`) you won't get that.

###### Example

Not recommended configuration:

```nginx
server {

  location /app/ {

    # For this, you should use uwsgi_pass directive.
    # backend layer: uWSGI Python app
    proxy_pass 192.168.154.102:4000;

  }

  ...

}
```

Recommended configuration:

```nginx
server {

  location /app/ {

    # backend layer: OpenResty as a front for app
    proxy_pass http://192.168.154.102:80;

  }

  location /app/v3 {

    # backend layer: uWSGI Python app
    uwsgi_pass 192.168.154.102:8080;

  }

  location /app/v4 {

    # backend layer: php-fpm app
    fastcgi_pass 192.168.154.102:8081;

  }
  ...

}
```

###### External resources

- [Passing a Request to a Proxied Server](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/#passing-a-request-to-a-proxied-server)
- [Reverse proxy (from this handbook)](NGINX_BASICS.md#reverse-proxy)

#### :beginner: Be careful with trailing slashes in `proxy_pass` directive

###### Rationale

  > NGINX replaces part literally and you could end up with some strange url.

  > If `proxy_pass` used without URI (i.e. without path after `server:port`) NGINX will put URI from original request exactly as it was with all double slashes, `../` and so on.

  > URI in `proxy_pass` acts like alias directive, means NGINX will replace part that matches location prefix with URI in `proxy_pass` directive (which I intentionally made the same as location prefix) so URI will be the same as requested but normalized (without doule slashes and all that staff).

###### Example

```nginx
location = /a {

  proxy_pass http://127.0.0.1:8080/a;

  ...

}

location ^~ /a/ {

  proxy_pass http://127.0.0.1:8080/a/;

  ...

}
```

###### External resources

- [Module ngx_http_proxy_module - proxy_pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)
- [Trailing slashes (from this handbook)](NGINX_BASICS.md#trailing-slashes)

#### :beginner: Set and pass `Host` header only with `$host` variable

###### Rationale

  > You should almost always use `$host` as a incoming host variable, because it's the only one guaranteed to have something sensible regardless of how the user-agent behaves, unless you specifically need the semantics of one of the other variables.

  > It’s always a good idea to modify the `Host` header to make sure that the virtual host resolution on the downstream server works as it should.

  > `$host` is simply `$http_host` with some processing (stripping port number and lowercasing) and a default value (of the `server_name`), so there's no less "exposure" to the `Host` header sent by the client when using `$http_host`. There's no danger in this though.

  > The variable `$host` is the host name from the request line or the http header. The variable `$server_name` is the name of the server block we are in right now.

  > The difference is explained in the NGINX documentation:
  >
  >   - `$host` contains in this order of precedence: host name from the request line, or host name from the `Host` request header field, or the server name matching a request
  >   - `$http_host` contains the content of the HTTP `Host` header field, if it was present in the request (equals always the `HTTP_HOST` request header)
  >   - `$server_name` contains the `server_name` of the virtual host which processed the request, as it was defined in the NGINX configuration. If a server contains multiple server names, only the first one will be present in this variable

  > `$http_host`, moreover, is better than `$host:$server_port` because it uses the port as present in the URL, unlike `$server_port` which uses the port that NGINX listens on.

  > On the other hand, using `$host` has it's own vulnerability; you must handle the situation when the `Host` field is absent properly by defining default server blocks to catch those requests. The key point though is that changing the `proxy_set_header Host $host` would not change this behavior at all because the `$host` value would be equal to the `$http_host` value when the `Host` request field is present.

  > In the NGINX server we will achieve this by use catch-all virtual hosts. These are vhosts referenced by web servers if an unrecognized/undefined `Host` header appears in the client request. It's also a good idea to specifying the exact (not wildcard) value of `server_name`.

  > Of course, the most important line of defense is the proper implementation of parsing mechanisms on the application side, e.g. using the list of allowed values for the `Host` header. Your web-app should fully comply with [RFC 7230](https://tools.ietf.org/html/rfc7230) to avoid problems caused by inconsistent interpretation of host to associate with an HTTP transaction. Per above RFC, the correct solution is to treat multiple `Host` headers and white-spaces around field-names as errors.

###### Example

```nginx
proxy_set_header Host $host;
```

###### External resources

- [RFC 2616 - The Resource Identified by a Request](http://tools.ietf.org/html/rfc2616#section-5.2) <sup>[IETF]</sup>
- [RFC 2616 - Host](http://tools.ietf.org/html/rfc2616#section-14.23) <sup>[IETF]</sup>
- [Module ngx_http_proxy_module - proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header)
- [What is the difference between Nginx variables $host, $http_host, and $server_name?](https://serverfault.com/questions/706438/what-is-the-difference-between-nginx-variables-host-http-host-and-server-na/706439#706439)
- [HTTP_HOST and SERVER_NAME Security Issues](https://expressionengine.com/blog/http-host-and-server-name-security-issues)
- [Reasons to use '$http_host' instead of '$host' with 'proxy_set_header Host' in template?](https://github.com/jwilder/nginx-proxy/issues/763#issuecomment-286481168)
- [Tip: keep the Host header via nginx proxy_pass](https://www.simplicidade.org/notes/2011/02/15/tip-keep-the-host-header-via-nginx-proxy_pass/)
- [What is a Host Header Attack?](https://www.acunetix.com/blog/articles/automated-detection-of-host-header-attacks/)
- [Practical HTTP Host header attacks](https://www.skeletonscribe.net/2013/05/practical-http-host-header-attacks.html)
- [Host of Troubles Vulnerabilities](https://hostoftroubles.com/)
- [$10k host header](https://www.ezequiel.tech/p/10k-host-header.html)

#### :beginner: Set properly values of the `X-Forwarded-For` header

###### Rationale

  > `X-Forwarded-For` (XFF) is the custom HTTP header that carries along the original IP address of a client (identifies the client IP address for an original request that was served through a proxy or load balancer) so the app at the other end knows what it is. Otherwise it would only see the proxy IP address, and that makes some apps angry.

  > The `X-Forwarded-For` depends on the proxy server, which should actually pass the IP address of the client connecting to it. Where a connection passes through a chain of proxy servers, `X-Forwarded-For` can give a comma-separated list of IP addresses with the first being the furthest downstream (that is, the user). Because of this, servers behind proxy servers need to know which of them are trustworthy.

  > In the most cases, the most proxies or load balancers automatically include an `X-Forwarded-For` header, for debugging, statistics, and generating location-dependent content, based on the original request.

  > The usefulness of XFF depends on the proxy server truthfully reporting the original host's IP address; for this reason, effective use of XFF requires knowledge of which proxies are trustworthy, for instance by looking them up in a whitelist of servers whose maintainers can be trusted.

  > The proxy used can set this header to anything it wants to, and therefore you can't trust its value. Most proxies do set the correct value though. This header is mostly used by caching proxies, and in those cases you're in control of the proxy and can thus verify that is gives you the correct information. In all other cases its value should be considered untrustworthy.

  > Some systems also use `X-Forwarded-For` to enforce access control. A good number of applications rely on knowing the actual IP address of a client to help prevent fraud and enable access.

  > Value of the `X-Forwarded-For` header field can be set at the client's side - this can also be termed as `X-Forwarded-For` spoofing. However, when the web request is made via a proxy server, the proxy server modifies the `X-Forwarded-For` field by appending the IP address of the client (user). This will result in 2 comma separated IP addresses in the `X-Forwarded-For` field.

  > A reverse proxy is not source IP address transparent. This is a pain when you need the client source IP address to be correct in the logs of the backend servers. I think the best solution of this problem is configure the load balancer to add/modify an `X-Forwarded-For` header with the source IP of the client and forward it to the backend in the correct form.

  > Unfortunately, on the proxy side we are not able to solve this problem (all solutions can be spoofable), it is important that this header is correctly interpreted by application servers. Doing so ensures that the apps or downstream services have accurate information on which to make their decisions, including those regarding access and authorization.

  > In the light of the latest httpoxy vulnerabilities, there is really a need for a full example, how to use `HTTP_X_FORWARDED_FOR` properly. In short, the load balancer sets the 'most recent' part of the header. In my opinion, for security reasons, the proxy servers must be specified by the administrator manually.

  There is also an interesing idea what to do in this situation:

  > _To prevent this we must distrust that header by default and follow the IP address breadcrumbs backwards from our server. First we need to make sure the `REMOTE_ADDR` is someone we trust to have appended a proper value to the end of `X-Forwarded-For`. If so then we need to make sure we trust the `X-Forwarded-For` IP to have appended the proper IP before it, so on and so forth. Until, finally we get to an IP we don’t trust and at that point we have to assume that’s the IP of our user._ - it comes from [Proxies & IP Spoofing](https://xyu.io/2013/07/04/proxies-ip-spoofing/) by [Xiao Yu](https://github.com/xyu).

###### Example

```nginx
# The whole purpose that it exists is to do the appending behavior:
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

# Above is equivalent for this:
proxy_set_header X-Forwarded-For $http_x_forwarded_for,$remote_addr;

# The following is also equivalent for above but in this example we use http_realip_module:
proxy_set_header X-Forwarded-For "$http_x_forwarded_for, $realip_remote_addr";
```

###### External resources

- [Prevent X-Forwarded-For Spoofing or Manipulation](https://totaluptime.com/kb/prevent-x-forwarded-for-spoofing-or-manipulation/)
- [Bypass IP blocks with the X-Forwarded-For header](https://www.sjoerdlangkemper.nl/2017/03/01/bypass-ip-block-with-x-forwarded-for-header/)
- [Forwarded header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Forwarded)

#### :beginner: Don't use `X-Forwarded-Proto` with `$scheme` behind reverse proxy

###### Rationale

  > `X-Forwarded-Proto` can be set by the reverse proxy to tell the app whether it is HTTPS or HTTP or even an invalid name.

  > The scheme (i.e. HTTP, HTTPS) variable evaluated only on demand (used only for the current request).

  > Setting the `$scheme` variable will cause distortions if it uses more than one proxy along the way. For example: if the client go to the `https://example.com`, the proxy stores the scheme value as HTTPS. If the communication between the proxy and the next-level proxy takes place over HTTP, then the backend sees the scheme as HTTP. So if you set `$scheme` for `X-Forwarded-Proto` on the next-level proxy, app will see a different value than the one the client came with.

  > For resolve this problem you can also use [this](HELPERS.md#set-correct-scheme-passed-in-x-forwarded-proto) configuration snippet.

###### Example

```nginx
# 1) client <-> proxy <-> backend
proxy_set_header X-Forwarded-Proto $scheme;

# 2) client <-> proxy <-> proxy <-> backend
# proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Proto $proxy_x_forwarded_proto;
```

###### External resources

- [Reverse Proxy - Passing headers (from this handbook)](NGINX_BASICS.md#passing-headers)

#### :beginner: Always pass `Host`, `X-Real-IP`, and `X-Forwarded` headers to the backend

###### Rationale

  > When using NGINX as a reverse proxy you may want to pass through some information of the remote client to your backend web server. I think it's good practices because gives you more control of forwarded headers.

  > It's very important for servers behind proxy because it allow to interpret the client correctly. Proxies are the "eyes" of such servers, they should not allow a curved perception of reality. If not all requests are passed through a proxy, as a result, requests received directly from clients may contain e.g. inaccurate IP addresses in headers.

  > `X-Forwarded` headers are also important for statistics or filtering. Other example could be access control rules on your app, because without these headers filtering mechanism may not working properly.

  > If you use a front-end service like Apache or whatever else as the front-end to your APIs, you will need these headers to understand what IP or hostname was used to connect to the API.

  > Forwarding these headers is also important if you use the HTTPS protocol (it has become a standard nowadays).

  > However, I would not rely on either the presence of all `X-Forwarded` headers, or the validity of their data.

###### Example

```nginx
location / {

  proxy_pass http://bk_upstream_01;

  # The following headers also should pass to the backend:
  #   - Host - host name from the request line, or host name from the Host request header field, or the server name matching a request
  # proxy_set_header Host $host:$server_port;
  # proxy_set_header Host $http_host;
  proxy_set_header Host $host;

  #   - X-Real-IP - forwards the real visitor remote IP address to the proxied server
  proxy_set_header X-Real-IP $remote_addr;

  # X-Forwarded headers stack:
  #   - X-Forwarded-For - mark origin IP of client connecting to server through proxy
  # proxy_set_header X-Forwarded-For $remote_addr;
  # proxy_set_header X-Forwarded-For $http_x_forwarded_for,$remote_addr;
  # proxy_set_header X-Forwarded-For "$http_x_forwarded_for, $realip_remote_addr";
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

  #   - X-Forwarded-Host - mark origin host of client connecting to server through proxy
  # proxy_set_header X-Forwarded-Host $host:443;
  proxy_set_header X-Forwarded-Host $host:$server_port;

  #   - X-Forwarded-Server - the hostname of the proxy server
  proxy_set_header X-Forwarded-Server $host;

  #   - X-Forwarded-Port - defines the original port requested by the client
  # proxy_set_header X-Forwarded-Port 443;
  proxy_set_header X-Forwarded-Port $server_port;

  #   - X-Forwarded-Proto - mark protocol of client connecting to server through proxy
  # proxy_set_header X-Forwarded-Proto https;
  # proxy_set_header X-Forwarded-Proto $proxy_x_forwarded_proto;
  proxy_set_header X-Forwarded-Proto $scheme;

}
```

###### External resources

- [Forwarding Visitor’s Real-IP + Nginx Proxy/Fastcgi backend correctly](https://easyengine.io/tutorials/nginx/forwarding-visitors-real-ip/)
- [Using the Forwarded header](https://www.nginx.com/resources/wiki/start/topics/examples/forwarded/)
- [Reverse Proxy - Passing headers (from this handbook)](NGINX_BASICS.md#passing-headers)
- [Set properly values of the X-Forwarded-For header - Reverse Proxy - P1 (from this handbook)](#beginner-set-properly-values-of-the-x-forwarded-for-header)
- [Don't use X-Forwarded-Proto with $scheme behind reverse proxy - Reverse Proxy - P1 (from this handbook)](#beginner-dont-use-x-forwarded-proto-with-scheme-behind-reverse-proxy)

#### :beginner: Use custom headers without `X-` prefix

###### Rationale

  > The use of custom headers with `X-` prefix is not forbidden but discouraged. In other words, you can keep using `X-` prefixed headers, but it's not recommended and you may not document them as if they are public standard.

  > The [IETF draft](https://tools.ietf.org/html/draft-saintandre-xdash-00) was posted to deprecate the recommendation of using the `X-` prefix for non-standard headers. The reason is that when non-standard headers prefixed with `X-` become standard, removing the `X-` prefix breaks backwards compatibility, forcing application protocols to support both names (E.g, `x-gzip` and `gzip` are now equivalent). So, the official recommendation is to just name them sensibly without the `X-` prefix.

  > Internet Engineering Task Force released in [RFC 6648](https://tools.ietf.org/html/rfc6648) <sup>[IETF]</sup> recommended official deprecation of `X-` prefix:

  > - _3. Recommendations for Creators of New Parameters [...] SHOULD NOT prefix their parameter names with "X-" or similar constructs._
  > - _4. Recommendations for Protocol Designers [...] SHOULD NOT prohibit parameters with an "X-" prefix or similar constructs from being registered. [...] MUST NOT stipulate that a parameter with an "X-" prefix or similar constructs needs to be understood as unstandardized. [...] MUST NOT stipulate that a parameter without an "X-" prefix or similar constructs needs to be understood as standardized._

  > The `X-` in front of a header name customarily has denoted it as experimental/non-standard/vendor-specific. Once it's a standard part of HTTP, it'll lose the prefix.

  > If it’s possible for new custom header to be standardized, use a non-used and meaningful header name.

###### Example

Not recommended configuration:

```nginx
add_header X-Backend-Server $hostname;
```

Recommended configuration:

```nginx
add_header Backend-Server $hostname;
```

###### External resources

- [Use of the "X-" Prefix in Application Protocols](https://tools.ietf.org/html/draft-saintandre-xdash-00) <sup>[IETF]</sup>
- [Why we need to deprecate x prefix for HTTP headers?](https://tonyxu.io/posts/2018/http-deprecate-x-prefix/)
- [Custom HTTP headers : naming conventions](https://stackoverflow.com/questions/3561381/custom-http-headers-naming-conventions/3561399#3561399)
- [Set the HTTP headers with add_header and proxy_*_header directives properly - Base Rules - P1 (from this handbook)](#beginner-set-the-http-headers-with-add_header-and-proxy__header-directives-properly)

#### :beginner: Always use `$request_uri` instead of `$uri` in `proxy_pass`

###### Rationale

  > Naturally, there are exceptions to what I'm going to say about this. I think the best rule for pass unchanged URI to the backend layer is use `proxy_pass http://<backend>` without any arguments.

  > If you add something more at the end of `proxy_pass` directive, you should always pass unchanged URI to the backend layer unless you know what you're doing. For example, using `$uri` accidentally in `proxy_pass` directives opens you up to http header injection vulnerabilities because URL encoded characters are decoded (this sometimes matters and is not equivalent to `$request_uri`). And what's more, the value of `$uri` may change during request processing, e.g. when doing internal redirects, or when using index files.

  > The `request_uri` is equal to the original request URI as received from the client including the arguments. In this case (pass variable like a `$request_uri`), if URI is specified in the directive, it is passed to the server as is, replacing the original request URI.

  > Note also that using `proxy_pass` with variables implies various other side effects, notably use of resolver for dynamic name resolution, and generally less effective than using names in a configuration.

  Look also what the NGINX documentation say about it:

  > _If proxy_pass is specified without a URI, the request URI is passed to the server in the same form as sent by a client when the original request is processed [...]_

###### Example

Not recommended configuration:

```nginx
location /foo {

  proxy_pass http://django_app_server$uri;

}
```

Recommended configuration:

```nginx
location /foo {

  proxy_pass http://django_app_server$request_uri;

}
```

Most recommended configuration:

```nginx
location /foo {

  proxy_pass http://django_app_server;

}
```

# Load Balancing

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

  > :pushpin:&nbsp; Load balancing is a useful mechanism to distribute incoming traffic around several capable servers. We may improve of some rules about the NGINX working as a load balancer.

- **[Base Rules](#base-rules)**
- **[Debugging](#debugging)**
- **[Performance](#performance)**
- **[Hardening](#hardening)**
- **[Reverse Proxy](#reverse-proxy)**
- **[≡ Load Balancing (2)](#load-balancing)**
  * [Tweak passive health checks](#beginner-tweak-passive-health-checks)
  * [Don't disable backends by comments, use down parameter](#beginner-dont-disable-backends-by-comments-use-down-parameter)
- **[Others](#others)**

#### :beginner: Tweak passive health checks

###### Rationale

  > Monitoring for health is important on all types of load balancing mainly for business continuity. Passive checks watches for failed or timed-out connections as they pass through NGINX as requested by a client.

  > This functionality is enabled by default but the parameters mentioned here allow you to tweak their behaviour. Default values are: `max_fails=1` and `fail_timeout=10s`.

###### Example

```nginx
upstream backend {

  server bk01_node:80 max_fails=3 fail_timeout=5s;
  server bk02_node:80 max_fails=3 fail_timeout=5s;

}
```

###### External resources

- [Module ngx_http_upstream_module](https://nginx.org/en/docs/http/ngx_http_upstream_module.html)

#### :beginner: Don't disable backends by comments, use `down` parameter

###### Rationale

  > Sometimes we need to turn off backends e.g. at maintenance-time. I think good solution is marks the server as permanently unavailable with `down` parameter even if the downtime takes a short time.

  > It's also important if you use IP Hash load balancing technique. If one of the servers needs to be temporarily removed, it should be marked with this parameter in order to preserve the current hashing of client IP addresses.

  > Comments are good for really permanently disable servers or if you want to leave information for historical purposes.

  > NGINX also provides a `backup` parameter which marks the server as a backup server. It will be passed requests when the primary servers are unavailable. I use this option rarely for the above purposes and only if I am sure that the backends will work at the maintenance time.

  > You can also use `ngx_dynamic_upstream` for operating upstreams dynamically with HTTP APIs.

###### Example

```nginx
upstream backend {

  server bk01_node:80 max_fails=3 fail_timeout=5s down;
  server bk02_node:80 max_fails=3 fail_timeout=5s;

}
```

###### External resources

- [Module ngx_http_upstream_module](https://nginx.org/en/docs/http/ngx_http_upstream_module.html)
- [Module ngx_dynamic_upstream](https://github.com/cubicdaiya/ngx_dynamic_upstream)

# Others

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

  > :pushpin:&nbsp; This rules aren't strictly related to the NGINX but in my opinion they're also very important aspect of security.

- **[Base Rules](#base-rules)**
- **[Debugging](#debugging)**
- **[Performance](#performance)**
- **[Hardening](#hardening)**
- **[Reverse Proxy](#reverse-proxy)**
- **[Load Balancing](#load-balancing)**
- **[≡ Others (4)](#others)**
  * [Set the certificate chain correctly](#beginner-set-the-certificate-chain-correctly)
  * [Enable DNS CAA Policy](#beginner-enable-dns-caa-policy)
  * [Define security policies with security.txt](#beginner-define-security-policies-with-securitytxt)
  * [Use tcpdump to diagnose and troubleshoot the HTTP issues](#beginner-use-tcpdump-to-diagnose-and-troubleshoot-the-http-issues)

#### :beginner: Set the certificate chain correctly

###### Rationale

  > A chain of trust is a linked path of verification and validation from an end-entity digital certificate to a root certificate authority (CA) that acts as a trust anchor.

  > Your browser (and possibly your OS) ships with a list of trusted CAs. These pre-installed certificates serve as trust anchors to derive all further trust from. When visiting an HTTPS website, your browser verifies that the trust chain presented by the server during the TLS handshake ends at one of the locally trusted root certificates.

  > Validation of the certificate chain is a critical part within any certificate-based authentication process. If a system does not follow the chain of trust of a certificate to a root server, the certificate loses all usefulness as a metric of trust.

  > The server always sends a chain but should never present certificate chains containing a trust anchor which is the root CA certificate, because the root is useless for validation purposes. As per the TLS standard, the chain may or may not include the root certificate itself; the client does not need that root since it already has it. And, indeed, if the client does not already have the root, then receiving it from the server would not help since a root can be trusted only by virtue of being already there.

  > What's more, the presence of a trust anchor in the certification path can have a negative impact on performance when establishing connections using SSL/TLS, because the root is "downloaded" on each handshake (allows you to save the 1 kB or so of data bandwith per connection and reduces server-side memory consumption for TLS session parameters).

  > For best practices, remove the self-signed root from the server. The certificate bundle should only include the certificate's public key, and the public key of any intermediate certificate authorities. Browsers will only trust certificates that resolve to roots that are already in their trust store, they will ignore a root certificate sent in the certificate bundle (otherwise, anyone could send any root).

  > With the chain broken, there is no verification that the server that's hosting the data is the correct (expected) server - there is no way to be sure the server is what the server says it is (you lose the ability to validate the security of the connection or to trust it). The connections is still secure (will be still encrypted) but the main concern would be to fix that certificate chain. You should solve the incomplete certificate chain issue manually by concatenating all certificates from the certificate to the trusted root certificate (exclusive, in this order), to prevent such issues.

  > Example of incomplete chain: [incomplete-chain.badssl.com](https://incomplete-chain.badssl.com/).

  From the "SSL Labs: SSL and TLS Deployment Best Practices - 2.1 Use Complete Certificate Chains":

  > _An invalid certificate chain effectively renders the server certificate invalid and results in browser warnings. In practice, this problem is sometimes difficult to diagnose because some browsers can reconstruct incomplete chains and some can’t. All browsers tend to cache and reuse intermediate certificates._

###### Example

On the OpenSSL side:

```bash
$ ls
root_ca.crt inter_ca.crt example.com.crt

# Build manually. Server certificate comes first in the chain file, then the intermediates:
$ cat example.com.crt inter_ca.crt > certs/example.com/example.com-chain.crt
```

To build a valid SSL certificate chain you may use [mkchain](https://github.com/trimstray/mkchain) tool. It also can help you fix the incomplete chain and download all missing CA certificates. You can also download all certificates from remote server and get your certificate chain right.

```bash
# If you have all certificates:
$ ls /data/certs/example.com
root.crt inter01.crt inter02.crt certificate.crt
$ mkchain -i /data/certs/example.com -o /data/certs/example.com-chain.crt

# If you have only server certificate (downloads all missing CA certificates automatically):
$ ls /data/certs/example.com
certificate.crt
$ mkchain -i certificate.crt -o /data/certs/example.com-chain.crt

# If you want to download certificate chain from existing domain:
$ mkchain -i https://incomplete-chain.badssl.com/ -o /data/certs/example.com-chain.crt
```

On the NGINX side:

```nginx
server {

  listen 192.168.10.2:443 ssl http2;

  ssl_certificate certs/example.com/example.com-chain.crt;
  ssl_certificate_key certs/example.com/example.com.key;

  ...
```

###### External resources

- [What is the SSL Certificate Chain?](https://support.dnsimple.com/articles/what-is-ssl-certificate-chain/)
- [What is a chain of trust?](https://www.ssl.com/faqs/what-is-a-chain-of-trust/)
- [The Difference Between Root Certificates and Intermediate Certificates](https://www.thesslstore.com/blog/root-certificates-intermediate/)
- [Get your certificate chain right](https://medium.com/@superseb/get-your-certificate-chain-right-4b117a9c0fce)
- [Verify certificate chain with OpenSSL](https://www.itsfullofstars.de/2016/02/verify-certificate-chain-with-openssl/)
- [Chain of Trust (from this handbook)](SSL_TLS_BASICS.md#chain-of-trust)

#### :beginner: Enable DNS CAA Policy

###### Rationale

  > DNS CAA policy helps you to control which Certificat Authorities are allowed to issue certificates for your domain becaues if no CAA record is present, any CA is allowed to issue a certificate for the domain.

  > The purpose of the CAA record is to allow domain owners to declare which certificate authorities are allowed to issue a certificate for a domain. They also provide a means of indicating notification rules in case someone requests a certificate from an unauthorized certificate authority.

  > If no CAA record is present, any CA is allowed to issue a certificate for the domain. If a CAA record is present, only the CAs listed in the record(s) are allowed to issue certificates for that hostname.

###### Example

Generic configuration (Google Cloud DNS, Route 53, OVH, and other hosted services) for Let's Encrypt:

```bash
example.com. CAA 0 issue "letsencrypt.org"
```

Standard Zone File (BIND, PowerDNS and Knot DNS) for Let's Encrypt:

```bash
example.com. IN CAA 0 issue "letsencrypt.org"
```

###### External resources

- [DNS Certification Authority Authorization (CAA) Resource Record](https://tools.ietf.org/html/rfc6844) <sup>[IETF]</sup>
- [CAA Records](https://support.dnsimple.com/articles/caa-record/)
- [CAA Record Helper](https://sslmate.com/caa/)

#### :beginner: Define security policies with `security.txt`

###### Rationale

  > Add `security.txt` to your site, with correct contact details inside the file, so that people reporting security issues won't have to guess where to send the reports to.

  > The main purpose of `security.txt` is to help make things easier for companies and security researchers when trying to secure platforms. It also provides information to assist in disclosing security vulnerabilities.

  > When security researchers detect potential vulnerabilities in a page or application, they will try to contact someone "appropriate" to "responsibly" reveal the problem. It's worth taking care of getting to the right address.

  > This file should be placed under the `/.well-known/` path, e.g. `/.well-known/security.txt` ([RFC 5785](https://tools.ietf.org/html/rfc5785) <sup>[IETF]</sup>) of a domain name or IP address for web properties.

###### Example

```bash
$ curl -ks https://example.com/.well-known/security.txt

Contact: security@example.com
Contact: +1-209-123-0123
Encryption: https://example.com/pgp.txt
Preferred-Languages: en
Canonical: https://example.com/.well-known/security.txt
Policy: https://example.com/security-policy.html
```

And from Google:

```bash
$ curl -ks https://www.google.com/.well-known/security.txt

Contact: https://g.co/vulnz
Contact: mailto:security@google.com
Encryption: https://services.google.com/corporate/publickey.txt
Acknowledgements: https://bughunter.withgoogle.com/
Policy: https://g.co/vrp
Hiring: https://g.co/SecurityPrivacyEngJobs
# Flag: BountyCon{075e1e5eef2bc8d49bfe4a27cd17f0bf4b2b85cf}
```

###### External resources

- [A Method for Web Security Policies](https://tools.ietf.org/html/draft-foudil-securitytxt-05) <sup>[IETF]</sup>
- [security.txt](https://securitytxt.org/)
- [Say hello to security.txt](https://scotthelme.co.uk/say-hello-to-security-txt/)

#### :beginner: Use tcpdump to diagnose and troubleshoot the HTTP issues

###### Rationale

  > Tcpdump is a swiss army knife (is a well known command line packet analyzer/protocol decoding) for all the administrators and developers when it comes to troubleshooting. You can use it to monitor HTTP traffic between a proxy (or clients) and your backends.

  > I use tcpdump for a quick inspection. If I need a more in-depth inspection I capture everything to a file and open it with powerfull sniffer which can decode lots of protocols, lots of filters like a wireshark.

  > Run `man tcpdump | less -Ip examples` to see some examples.

###### Example

Capture everything and write to a file:

```bash
tcpdump -X -s0 -w dump.pcap <tcpdump_params>
```

Monitor incoming (on interface) traffic, filter by `<ip:port>`:

```bash
tcpdump -ne -i eth0 -Q in host 192.168.252.1 and port 443
```

  * `-n` - don't convert addresses (`-nn` will not resolve hostnames or ports)
  * `-e` - print the link-level headers
  * `-i [iface|any]` - set interface
  * `-Q|-D [in|out|inout]` - choose send/receive direction (`-D` - for old tcpdump versions)
  * `host [ip|hostname]` - set host, also `[host not]`
  * `[and|or]` - set logic
  * `port [1-65535]` - set port number, also `[port not]`

Monitor incoming (on interface) traffic, filter by `<ip:port>` and write to a file:

```bash
tcpdump -ne -i eth0 -Q in host 192.168.252.10 and port 80 -c 5 -w dump.pcap
```

  * `-c [num]` - capture only num number of packets
  * `-w [filename]` - write packets to file, `-r [filename]` - reading from file

Monitor all HTTP GET traffic/requests:

```bash
tcpdump -i eth0 -s 0 -A -vv 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'
```

  * `tcp[((tcp[12:1] & 0xf0) >> 2):4]` - first determines the location of the bytes we are interested in (after the TCP header) and then selects the 4 bytes we wish to match against
  * `0x47455420` - represents the ASCII value of characters 'G', 'E', 'T', ' '

Monitor all HTTP POST traffic/requests, filter by destination port:

```bash
tcpdump -i eth0 -s 0 -A -vv 'tcp dst port 80 and (tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504f5354)'
```

  * `0x504F5354` - represents the ASCII value of characters 'P', 'O', 'S', 'T', ' '

Monitor HTTP traffic including request and response headers and message body, filter by port:

```bash
tcpdump -A -s 0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
```

Monitor HTTP traffic including request and response headers and message body, filter by `<src-ip:port>`:

```bash
tcpdump -A -s 0 'src 192.168.252.10 and tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
```

###### External resources

- [TCPDump Capture HTTP GET/POST requests – Apache, Weblogic & Websphere](https://www.middlewareinventory.com/blog/tcpdump-capture-http-get-post-requests-apache-weblogic-websphere/)
- [Wireshark tcp filter: `tcp[((tcp[12:1] & 0xf0) >> 2):4]`](https://security.stackexchange.com/questions/121011/wireshark-tcp-filter-tcptcp121-0xf0-24)
- [How to Use tcpdump Commands with Examples](https://linoxide.com/linux-how-to/14-tcpdump-commands-capture-network-traffic-linux/)
- [Helpers - Debugging (from this handbook)](https://github.com/trimstray/nginx-admins-handbook/blob/master/doc/HELPERS.md#debugging)
