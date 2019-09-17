# NGINX Basics

- **[⬆ NGINX Basics](../README.md#toc-nginx-basics)**
  * [Directories and files](#directories-and-files)
  * [Commands](#commands)
  * [Processes](#processes)
  * [Configuration syntax](#configuration-syntax)
    * [Comments](#comments)
    * [End of lines](#end-of-lines)
    * [Variables, Strings, and Quotes](#variables-strings-and-quotes)
    * [Directives, Blocks, and Contexts](#directives-blocks-and-contexts)
    * [External files](#external-files)
    * [Measurement units](#measurement-units)
    * [Regular expressions with PCRE](#regular-expressions-with-pcre)
    * [Enable syntax highlighting](#enable-syntax-highlighting)
  * [Connection processing](#connection-processing)
    * [Event-Driven architecture](#event-driven-architecture)
    * [Multiple processes](#multiple-processes)
    * [Simultaneous connections](#simultaneous-connections)
    * [HTTP Keep-Alive connections](#http-keep-alive-connections)
  * [Request processing stages](#request-processing-stages)
  * [Server blocks logic](#server-blocks-logic)
    * [Handle incoming connections](#handle-incoming-connections)
    * [Matching location](#matching-location)
    * [rewrite vs return](#rewrite-vs-return)
    * [try_files directive](#try_files-directive)
    * [if, break, and set](#if-break-and-set)
    * [root vs alias](#root-vs-alias)
    * [internal directive](#internal-directive)
    * [External and internal redirects](#external-and-internal-redirects)
  * [Log files](#log-files)
    * [Conditional logging](#conditional-logging)
    * [Manually log rotation](#manually-log-rotation)
    * [Error log severity levels](#error-log-severity-levels)
  * [Reverse proxy](#reverse-proxy)
    * [Passing requests](#passing-requests)
    * [Trailing slashes](#trailing-slashes)
    * [Processing headers](#processing-headers)
    * [Passing headers](#passing-headers)
      * [Importance of the Host header](#importance-of-the-host-header)
      * [Redirects and X-Forwarded-Proto](#redirects-and-x-forwarded-proto)
      * [A warning about the X-Forwarded-For](#a-warning-about-the-x-forwarded-for)
      * [Improve extensibility with Forwarded](#improve-extensibility-with-forwarded)
  * [Load balancing algorithms](#load-balancing-algorithms)
    * [Backend parameters](#backend-parameters)
    * [Round Robin](#round-robin)
    * [Weighted Round Robin](#weighted-round-robin)
    * [Least Connections](#least-connections)
    * [Weighted Least Connections](#weighted-least-connections)
    * [IP Hash](#ip-hash)
    * [Generic Hash](#generic-hash)
    * [Other methods](#other-methods)
  * [Rate limiting](#rate-limiting)
    * [Variables](#variables)
    * [Directives, keys, and zones](#directives-keys-and-zones)
    * [Burst and nodelay parameters](#burst-and-nodelay-parameters)

#### Directories and files

  > If you compile NGINX with default parameters all files and directories are available from `/usr/local/nginx` location.

For upstream NGINX packaging paths can be as follows (it depends on the type of system/distribution):

- `/etc/nginx` - is the default configuration root for the NGINX service
  * other locations: `/usr/local/etc/nginx`, `/usr/local/nginx/conf`

- `/etc/nginx/nginx.conf` - is the default configuration entry point used by the NGINX services, includes the top-level http block and all other configuration contexts and files
  * other locations: `/usr/local/etc/nginx/nginx.conf`, `/usr/local/nginx/conf/nginx.conf`

- `/usr/share/nginx` - is the default root directory for requests, contains `html` directory and basic static files
  * other locations: `html/` in root directory

- `/var/log/nginx` - is the default log (access and error log) location for NGINX
  * other locations: `logs/` in root directory

- `/var/cache/nginx` - is the default temporary files location for NGINX
  * other locations: `/var/lib/nginx`

- `/etc/nginx/conf` - contains custom/vhosts configuration files
  * other locations:  `/etc/nginx/conf.d`, `/etc/nginx/sites-enabled` (I can't stand this debian-like convention...)

- `/var/run/nginx` - contains information about NGINX process(es)
  * other locations: `/usr/local/nginx/logs`, `logs/` in root directory

#### Commands

  > **:bookmark: [Use reload option to change configurations on the fly](RULES.md#beginner-use-reload-option-to-change-configurations-on-the-fly)**

- `nginx -h` - shows the help
- `nginx -v` - shows the NGINX version
- `nginx -V` - shows the extended information about NGINX: version, build parameters, and configuration arguments
- `nginx -t` - tests the NGINX configuration
- `nginx -c <filename>` - sets configuration file (default: `/etc/nginx/nginx.conf`)
- `nginx -p <directory>` - sets prefix path (default: `/etc/nginx/`)
- `nginx -T` - tests the NGINX configuration and prints the validated configuration on the screen
- `nginx -s <signal>` - sends a signal to the NGINX master process:
  - `stop` - discontinues the NGINX process immediately
  - `quit` - stops the NGINX process after it finishes processing
inflight requests
  - `reload` - reloads the configuration without stopping processes
  - `reopen` - instructs NGINX to reopen log files
- `nginx -g <directive>` - sets [global directives](https://nginx.org/en/docs/ngx_core_module.html) out of configuration file

Some useful snippets for management of the NGINX daemon:

- testing configuration:

  ```bash
  /usr/sbin/nginx -t -c /etc/nginx/nginx.conf
  /usr/sbin/nginx -t -q -g 'daemon on; master_process on;' # ; echo $?
  ```

- starting daemon:

  ```bash
  /usr/sbin/nginx -g 'daemon on; master_process on;'

  service nginx start
  systemctl start nginx

  # You can also start NGINX from start-stop-daemon script:
  /sbin/start-stop-daemon --quiet --start --exec /usr/sbin/nginx --background --retry QUIT/5 --pidfile /run/nginx.pid
  ```

- stopping daemon:

  ```bash
  /usr/sbin/nginx -s quit     # graceful shutdown (waiting for the worker processes to finish serving current requests)
  /usr/sbin/nginx -s stop     # fast shutdown (kill connections immediately)

  service nginx stop
  systemctl stop nginx

  # You can also stop NGINX from start-stop-daemon script:
  /sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
  ```

- reloading daemon:

  ```bash
  /usr/sbin/nginx -g 'daemon on; master_process on;' -s reload

  service nginx reload
  systemctl reload nginx

  kill -HUP $(cat /var/run/nginx.pid)
  kill -HUP $(pgrep -f "nginx: master")
  ```

#### Configuration syntax

  > **:bookmark: [Organising Nginx configuration](RULES.md#beginner-organising-nginx-configuration)**<br>
  > **:bookmark: [Format, prettify and indent your Nginx code](RULES.md#beginner-format-prettify-and-indent-your-nginx-code)**

NGINX uses a micro programming language in the configuration files. This language's design is heavily influenced by Perl and Bourne Shell. For me NGINX configuration has a simple and very transparent structure.

##### Comments

NGINX configuration files don't support comment blocks, they only accept `#` at the beginning of a line for a comment.

##### End of lines

Lines containing directives must end with a `;` or NGINX will fail to load the configuration and report an error.

##### Variables, Strings, and Quotes

Variables start with `$`. Some modules introduce variables can be used when setting directives.

  > There are some directives that do not support variables, e.g. `access_log` or `error_log`.

To assign value to the variable you should use a `set` directive:

```bash
set $var "value";
```

  > See [`if`, `break`, and `set`](#if-break-and-set) section to learn more about variables.

Some interesting things about variables:

  > Make sure to read the [agentzh's Nginx Tutorials](https://openresty.org/download/agentzh-nginx-tutorials-en.html) - it's about NGINX tips & tricks. This guy is a Guru and creator of the OpenResty. In these tutorials he describes, amongst other things, variables in great detail. I also recommend [nginx built-in variables](http://siwei.me/blog/posts/nginx-built-in-variables).

- the most variables in NGINX only exist at runtime, not during configuration time
- the scope of variables spreads out all over configuration
- variable assignment occurs when requests are actually being served
- variable have exactly the same lifetime as the corresponding request
- each request does have its own version of all those variables' containers (different containers values)
- requests do not interfere with each other even if they are referencing a variable with the same name
- the assignment operation is only performed in requests that access location

Strings may be inputted without quotes unless they include blank spaces, semicolons or curly braces, then they need to be escaped with backslashes or enclosed in single/double quotes.

Quotes are required for values which are containing space(s) and/or some other special characters, otherwise NGINX will not recognize them. You can either quote or `\`-escape some special characters like `" "` or `";"` in strings (characters that would make the meaning of a statement ambiguous). So the following instructions are the same:

```bash
# 1)
add_header X-Header "nginx web server;";

# 2)
add_header X-Header nginx\ web\ server\;;
```

Variables in quoted strings are expanded normally unless the `$` is escaped.

##### Directives, Blocks, and Contexts

  > Read this great article about [the NGINX configuration inheritance model](https://blog.martinfjordvald.com/2012/08/understanding-the-nginx-configuration-inheritance-model/) by [Martin Fjordvald](https://blog.martinfjordvald.com/about/).

Configuration options are called directives. We have four types of directives:

- standard directive - one value per context:

  ```bash
  worker_connections 512;
  ```

- array directive - multiple values per context:

  ```bash
  error_log /var/log/nginx/localhost/localhost-error.log warn;
  ```

- action directive - something which does not just configure:

  ```bash
  rewrite ^(.*)$ /msie/$1 break;
  ```

- `try_files` directive:

  ```bash
  try_files $uri $uri/ /test/index.html;
  ```

Directives are organised into groups known as **blocks** or **contexts**. Generally, context is a block directive that can have other directives inside braces. It appears to be organised in a tree-like structure, defined by sets of brackets - `{` and `}`.

As a general rule, if a directive is valid in multiple nested scopes, a declaration in a broader context will be passed on to any child contexts as default values. The children contexts can override these values at will.

  > Directives placed in the configuration file outside of any contexts are considered to be in the global/main context.

Directives can only be used in the contexts that they were designed for. NGINX will error out on reading a configuration file with directives that are declared in the wrong context.

  > If you want to review all directives see [alphabetical index of directives](https://nginx.org/en/docs/dirindex.html).

Contexts can be layered within one another (a level of inheritance). Their structure looks like this:

```
Global/Main Context
        |
        |
        +-----» Events Context
        |
        |
        +-----» HTTP Context
        |          |
        |          |
        |          +-----» Server Context
        |          |          |
        |          |          |
        |          |          +-----» Location Context
        |          |
        |          |
        |          +-----» Upstream Context
        |
        |
        +-----» Mail Context
```

NGINX also provides other contexts (mainly used for mapping) such as:

- `map` - is used to set the value of a variable depending on the value of another variable. It provides a mapping of one variable’s values to determine what the second variable should be set to

- `geo` - is used to specify a mapping. However, this mapping is specifically used to categorize client IP addresses. It sets the value of a variable depending on the connecting IP address

- `types` - is used to map MIME types to the file extensions that should be associated with them

- `if` - provide conditional processing of directives defined within, execute the instructions contained if a given test returns `true`

- `limit_except` - is used to restrict the use of certain HTTP methods within a location context

Also look at the graphic below. It presents the most important contexts with reference to the configuration:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx_contexts.png" alt="nginx-contexts">
</p>

NGINX lookup starts from the http block, then through one or more server blocks, followed by the location block(s).

##### External files

`include` directive may appear inside any contexts to perform conditional inclusion. It attaching another file, or files matching the specified mask:

```bash
include /etc/nginx/proxy.conf;
```

##### Measurement units

Sizes can be specified in:

- `k` or `K`: Kilobytes
- `m` or `M`: Megabytes
- `g` or `G`: Gigabytes

```bash
client_max_body_size 2M;
```

Time intervals can be specified in:

- `ms`: Milliseconds
- `s`: Seconds (default, without a suffix)
- `m`: Minutes
- `h`: Hours
- `d`: Days
- `w`: Weeks
- `M`: Months (30 days)
- `y`: Years (365 days)

```bash
proxy_read_timeout 20s;
```

##### Regular expressions with PCRE

  > **:bookmark: [Enable PCRE JIT to speed up processing of regular expressions](RULES.md#beginner-enable-pcre-jit-to-speed-up-processing-of-regular-expressions)**

Before start reading next chapters you should know what regular expressions are and how they works (they are not a black magic really). I recommend two great and short write-ups about regular expressions created by [Jonny Fox](https://medium.com/@jonny.fox):

- [Regex tutorial — A quick cheatsheet by examples](https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285)
- [Regex cookbook — Top 10 Most wanted regex](https://medium.com/factory-mind/regex-cookbook-most-wanted-regex-aa721558c3c1)

Why? Regular expressions can be used in both the `server_name` and `location` (also in other) directives, and sometimes you must have a great skills of reading them. I think you should create the most readable regular expressions that do not become spaghetti code - impossible to debug and maintain.

NGINX uses the [PCRE](https://www.pcre.org/) library to perform complex manipulations with your `location` blocks and use the powerful `rewrite` and `return` directives. Below is something interesting:

- [Learn PCRE in Y minutes](https://learnxinyminutes.com/docs/pcre/)
- [PCRE Regex Cheatsheet](https://www.debuggex.com/cheatsheet/regex/pcre)
- [Regular Expression Cheat Sheet - PCRE](https://github.com/niklongstone/regular-expression-cheat-sheet)
- [Regex cheatsheet](https://remram44.github.io/regex-cheatsheet/regex.html)
- [Regular expressions in Perl](http://jkorpela.fi/perl/regexp.html)
- [Regexp Security Cheatsheet](https://github.com/attackercan/regexp-security-cheatsheet)

You can also use external tools for testing regular expressions. For more please see [online tools](../README.md#online-tools) chapter.

If you're good at it, check these very nice and brainstorming regex challenges:

- [RegexGolf](https://alf.nu/RegexGolf)
- [Regex Crossword](https://regexcrossword.com/)

##### Enable syntax highlighting

###### vi/vim

```bash
# 1) Download vim plugin for NGINX:

# Official NGINX vim plugin:
mkdir -p ~/.vim/syntax/

wget "http://www.vim.org/scripts/download_script.php?src_id=19394" -O ~/.vim/syntax/nginx.vim

# Improved NGINX vim plugin (incl. syntax highlighting) with Pathogen:
mkdir -p ~/.vim/{autoload,bundle}/

curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo -en "\nexecute pathogen#infect()\n" >> ~/.vimrc

git clone https://github.com/chr4/nginx.vim ~/.vim/bundle/nginx.vim

# 2) Set location of NGINX config files:
cat > ~/.vim/filetype.vim << __EOF__
au BufRead,BufNewFile /etc/nginx/*,/etc/nginx/conf.d/*,/usr/local/nginx/conf/*,*/conf/nginx.conf if &ft == '' | setfiletype nginx | endif
__EOF__
```

  > It may be interesting for you: [Highlight insecure SSL configuration in Vim](https://github.com/chr4/sslsecure.vim).

###### Sublime Text

Install `cabal` - system for building and packaging Haskell libraries and programs (on Ubuntu):

```bash
add-apt-repository -y ppa:hvr/ghc
apt-get update

apt-get install -y cabal-install-1.22 ghc-7.10.2

# Add this to the main configuration file of your shell:
export PATH=$HOME/.cabal/bin:/opt/cabal/1.22/bin:/opt/ghc/7.10.2/bin:$PATH
source $HOME/.<shellrc>

cabal update
```

- `nginx-lint`:

  ```bash
  git clone https://github.com/temoto/nginx-lint

  cd nginx-lint && cabal install --global
  ```

- `sublime-nginx` + `SublimeLinter-contrib-nginx-lint`:

  Bring up the _Command Palette_ and type `install`. Among the commands you should see _Package Control: Install Package_. Type `nginx` to install [sublime-nginx](https://github.com/brandonwamboldt/sublime-nginx) and after that do the above again for install [SublimeLinter-contrib-nginx-lint](https://github.com/irvinlim/SublimeLinter-contrib-nginx-lint): type `SublimeLinter-contrib-nginx-lint`.

#### Processes

NGINX has **one master process** and **one or more worker processes**.

The main purposes of the master process is to read and evaluate configuration files, as well as maintain the worker processes (respawn when a worker dies), handle signals, notify workers, opens log files, and, of course binding to ports.

Master process should be started as root user, because this will allow NGINX to open sockets below 1024 (it needs to be able to listen on port 80 for HTTP and 443 for HTTPS).

The worker processes do the actual processing of requests and get commands from master process. They runs in an event loop (registering events and responding when one occurs), handle network connections, read and write content to disk, and communicate with upstream servers. These are spawned by the master process, and the user and group will as specified (unprivileged).

  > NGINX has also cache loader and cache manager processes but only if you enable caching.

The following signals can be sent to the NGINX master process:

| <b>SIGNAL</b> | <b>NUM</b> | <b>DESCRIPTION</b> |
| :---         | :---:        | :---         |
| `TERM`, `INT` | **15**, **2** | quick shutdown |
| `QUIT` | **3** | graceful shutdown |
| `KILL` | **9** | halts a stubborn process |
| `HUP` | **1** | configuration reload, start new workers, gracefully shutdown the old worker processes |
| `USR1` | **10** | reopen the log files |
| `USR2` | **12** | upgrade executable on the fly |
| `WINCH` | **28** | gracefully shutdown the worker processes |

There’s no need to control the worker processes yourself. However, they support some signals too:

| <b>SIGNAL</b> | <b>NUM</b> | <b>DESCRIPTION</b> |
| :---         | :---:        | :---         |
| `TERM`, `INT` | **15**, **2** | quick shutdown |
| `QUIT` | **3** | graceful shutdown |
| `USR1` | **10** | reopen the log files |

#### Connection processing

NGINX supports a variety of [connection processing methods](https://nginx.org/en/docs/events.html) which depends on the platform used.

In general there are four types of event multiplexing:

- `select` - is anachronism and not recommended but installed on all platforms as a fallback
- `poll` - is anachronism and not recommended

And the most efficient implementations of non-blocking I/O:

- `epoll` - recommend if you're using GNU/Linux
- `kqueue` - recommend if you're using BSD (is technically superior to `epoll`)

There are also great resources (also makes comparisons) about them:

- [Kqueue: A generic and scalable event notification facility](https://people.freebsd.org/~jlemon/papers/kqueue.pdf)
- [poll vs select vs event-based](https://daniel.haxx.se/docs/poll-vs-select.html)
- [select/poll/epoll: practical difference for system architects](http://www.ulduzsoft.com/2014/01/select-poll-epoll-practical-difference-for-system-architects/)
- [Scalable Event Multiplexing: epoll vs. kqueue](https://people.eecs.berkeley.edu/~sangjin/2012/12/21/epoll-vs-kqueue.html)
- [Async IO on Linux: select, poll, and epoll](https://jvns.ca/blog/2017/06/03/async-io-on-linux--select--poll--and-epoll/)
- [A brief history of select(2)](https://idea.popcount.org/2016-11-01-a-brief-history-of-select2/)
- [Select is fundamentally broken](https://idea.popcount.org/2017-01-06-select-is-fundamentally-broken/)
- [Epoll is fundamentally broken](https://idea.popcount.org/2017-02-20-epoll-is-fundamentally-broken-12/)
- [I/O Multiplexing using epoll and kqueue System Calls](https://austingwalters.com/io-multiplexing/)
- [Benchmarking BSD and Linux](http://bulk.fefe.de/scalability/)
- [The C10K problem](http://www.kegel.com/c10k.html)

Look also at libevent benchmark (read about [libevent – an event notification library](http://libevent.org/)):

<p align="center">
  <a href="https://www.nginx.com/resources/library/infographic-inside-nginx/">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/libevent-benchmark.jpg" alt="libevent-benchmark">
  </a>
</p>

<sup><i>This infographic comes from [daemonforums - An interesting benchmark (kqueue vs. epoll)](http://daemonforums.org/showthread.php?t=2124).</i></sup>

You may also view why big players use NGINX on FreeBSD instead of on GNU/Linux:

- [FreeBSD NGINX Performance](https://devinteske.com/wp/freebsd-nginx-performance/)
- [Why did Netflix use NGINX and FreeBSD to build their own CDN?](https://www.youtube.com/watch?v=KP_bKvXkoC4)

##### Event-Driven architecture

  > [Thread Pools in NGINX Boost Performance 9x!](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) - this official article is an amazing explanation about thread pools and generally about handling connections. I also recommend [Inside NGINX: How We Designed for Performance & Scale](https://www.nginx.com/blog/inside-nginx-how-we-designed-for-performance-scale). Both are really great.

NGINX uses Event-Driven architecture which heavily relies on Non-Blocking I/O. One advantage of non-blocking/asynchronous operations is that you can maximize the usage of a single CPU as well as memory because is that your thread can continue it's work in parallel.

  > There is a perfectly good and brief [summary](https://stackoverflow.com/questions/8546273/is-non-blocking-i-o-really-faster-than-multi-threaded-blocking-i-o-how) about non-blocking I/O and multi-threaded blocking I/O by [Werner Henze](https://stackoverflow.com/users/1023911/werner-henze).

Look what the official documentation says about it:

  > _It’s well known that NGINX uses an asynchronous, event‑driven approach to handling connections. This means that instead of creating another dedicated process or thread for each request (like servers with a traditional architecture), it handles multiple connections and requests in one worker process. To achieve this, NGINX works with sockets in a non‑blocking mode and uses efficient methods such as epoll and kqueue._

  > _Because the number of full‑weight processes is small (usually only one per CPU core) and constant, much less memory is consumed and CPU cycles aren’t wasted on task switching. The advantages of such an approach are well‑known through the example of NGINX itself. It successfully handles millions of simultaneous requests and scales very well._

I must not forget to mention here about Non-Blocking and 3rd party modules (from official documentation):

  > _Unfortunately, many third‑party modules use blocking calls, and users (and sometimes even the developers of the modules) aren’t aware of the drawbacks. Blocking operations can ruin NGINX performance and must be avoided at all costs._

To handle concurrent requests with a single worker process NGINX uses the [reactor design pattern](https://stackoverflow.com/questions/5566653/simple-explanation-for-the-reactor-pattern-with-its-applications). Basically, it's a single-threaded but it can fork several processes to utilize multiple cores.

However, NGINX is not a single threaded application. Each of worker processes is single-threaded and can handle thousands of concurrent connections. NGINX does not create a new process/thread for each connection/requests but it starts several worker threads during start. It does this asynchronously with one thread, rather than using multi-threaded programming (it uses an event loop with asynchronous I/O).

That way, the I/O and network operations are not a very big bottleneck (remember that your CPU would spend a lot of time waiting for your network interfaces, for example). This results from the fact that NGINX only use one thread to service all requests. When requests arrive at the server, they are serviced one at a time. However, when the code serviced needs other thing to do it sends the callback to the other queue and the main thread will continue running (it doesn't wait).

Now you see why NGINX can handle a large amount of requests perfectly well (and without any problems).

For more information take a look at following resources:

- [Asynchronous, Non-Blocking I/O](https://medium.com/@entzik/on-asynchronous-non-blocking-i-o-4a2ac0af5c50)
- [Asynchronous programming. Blocking I/O and non-blocking I/O](https://luminousmen.com/post/asynchronous-programming-blocking-and-non-blocking)
- [About High Concurrency, NGINX architecture and internals](http://www.aosabook.org/en/nginx.html)
- [A little holiday present: 10,000 reqs/sec with Nginx!](https://blog.webfaction.com/2008/12/a-little-holiday-present-10000-reqssec-with-nginx-2/)
- [Nginx vs Apache: Is it fast, if yes, why?](http://planetunknown.blogspot.com/2011/02/why-nginx-is-faster-than-apache.html)
- [How is Nginx handling its requests in terms of tasks or threading?](https://softwareengineering.stackexchange.com/questions/256510/how-is-nginx-handling-its-requests-in-terms-of-tasks-or-threading)
- [Why nginx is faster than Apache, and why you needn’t necessarily care](https://djangodeployment.com/2016/11/15/why-nginx-is-faster-than-apache-and-why-you-neednt-necessarily-care/)

##### Multiple processes

NGINX uses only asynchronous I/O, which makes blocking a non-issue. The only reason NGINX uses multiple processes is to make full use of multi-core, multi-CPU, and hyper-threading systems. NGINX requires only enough worker processes to get the full benefit of symmetric multiprocessing (SMP).

From official documentation:

  > _The NGINX configuration recommended in most cases - running one worker process per CPU core - makes the most efficient use of hardware resources._

NGINX uses a custom event loop which was designed specifically for NGINX - all connections are processed in a highly efficient run-loop in a limited number of single-threaded processes called workers.

Multiplexing works by using a loop to increment through a program chunk by chunk operating on one piece of data/new connection/whatever per connection/object per loop iteration. It is all based on events multiplexing like `epoll()`, `kqueue()`, or `select()`. Within each worker NGINX can handle many thousands of concurrent connections and requests per second.

  > See [Nginx Internals](https://www.slideshare.net/joshzhu/nginx-internals) presentation as a lot of great stuff about the internals of NGINX.

NGINX does not fork a process or thread per connection (like Apache) so memory usage is very conservative and extremely efficient in the vast majority of cases. NGINX is a faster and consumes less memory than Apache. It is also very friendly for CPU because there's no ongoing create-destroy pattern for processes or threads.

Finally and in summary:

- uses Non-Blocking "Event-Driven" architecture
- uses the single-threaded reactor pattern to handle concurrent requests
- uses highly efficient loop for connection processing
- is not a single threaded application because it starts multiple worker processes (to handle multiple connections and requests) during start

##### Simultaneous connections

Okay, so how many simultaneous connections can be processed by NGINX?

```bash
worker_processes * worker_connections = max connections
```

According to this: if you are running **4** worker processes with **4,096** worker connections per worker, you will be able to serve **16,384** connections. Of course, these are the NGINX settings limited by the kernel (number of connections, number of open files, or number of processes).

  > At this point, I would like to mention about [Understanding socket and port in TCP](https://medium.com/fantageek/understanding-socket-and-port-in-tcp-2213dc2e9b0c). It is a great and short explanation. I also recommend to read [Theoretical maximum number of open TCP connections that a modern Linux box can have](https://stackoverflow.com/questions/2332741/what-is-the-theoretical-maximum-number-of-open-tcp-connections-that-a-modern-lin).

I've seen some admins does directly translate the sum of `worker_processes` and `worker_connections` into the number of clients that can be served simultaneously. In my opinion, it is a mistake because certain of clients (e.g. browsers) **opens a number of parallel connections** (see [this](https://stackoverflow.com/questions/985431/max-parallel-http-connections-in-a-browser) to confirm my words). Clients typically establish 4-8 TCP connections so that they can download resources in parallel (to download various components that compose a web page, for example, images, scripts, and so on). This increases the effective bandwidth and reduces latency.

Additionally, you must know that the `worker_connections` directive **includes all connections** per worker (e.g. connection structures are used for listen sockets, internal control sockets between NGINX processes, connections with proxied servers, and for upstream connections), not only incoming connections from clients.

  > Be aware that every worker connection (in the sleeping state) needs 256 bytes of memory, so you can increase it easily.

The number of connections is especially limited by the maximum number of open files (`RLIMIT_NOFILE`) on your system. The reason is that the operating system needs memory to manage each open file, and memory is a limited resource. This limitation only affects the limits for the current process. The limits of the current process are bequeathed to children processes too, but each process has a separate count.

To change the limit of the maximum file descriptors (that can be opened by a single worker process) you can also edit the `worker_rlimit_nofile` directive. With this, NGINX provides very powerful dynamic configuration capabilities with no service restarts.

  > The number of file descriptors is not the only one limitation of the number of connections - remember also about the kernel network (TCP/IP stack) parameters and the maximum number of processes.

I don't like this piece of the NGINX documentation. Maybe I'm missing something but it says the `worker_rlimit_nofile` is a limit on the maximum number of open files for worker processes. I believe it is associated to a single worker process.

If you set `RLIMIT_NOFILE` to 25,000 and `worker_rlimit_nofile` to 12,000, NGINX sets (only for workers) the maximum open files limit as a `worker_rlimit_nofile`. But the master process will have a set value of `RLIMIT_NOFILE`. Default value of `worker_rlimit_nofile` directive is `none` so by default NGINX sets the initial value of maximum open files from the system limits.

```bash
grep "LimitNOFILE" /lib/systemd/system/nginx.service
LimitNOFILE=5000

grep "worker_rlimit_nofile" /etc/nginx/nginx.conf
worker_rlimit_nofile 256;

   PID       SOFT HARD
 24430       5000 5000
 24431        256 256
 24432        256 256
 24433        256 256
 24434        256 256
```

This is also controlled by the OS because the worker is not the only process running on the machine. It would be very bad if your workers used up all of the file descriptors available to all processes, don't set your limits so that is possible.

In my opinion, relying on the `RLIMIT_NOFILE` than `worker_rlimit_nofile` value is more understandable and predictable. To be honest, it doesn't really matter which method is used to set, but you should keep a constant eye on the priority of the limits.

  > If you don't set the `worker_rlimit_nofile` directive manually, then the OS settings will determine how many file descriptors can be used by NGINX.

I think that the chance of running out of file descriptors is minimal, but it might be a big problem on a high traffic websites.

Ok, so how many fds are opens by NGINX?

- one file handler for the client's active connection
- one file handler for the proxied connection (that will open a socket handling these requests to remote or local host/process)
- one file handler for opening file (e.g. static file)
- other file handlers for internal connections, shared libraries, log files, and sockets

Also important is:

  > NGINX can use up to two file descriptors per full-fledged connection.

Look also at these diagrams:

- 1 file handler for connection with client and 1 file handler for static file being served by NGINX:

  ```
  # 1 connection, 2 file handlers

                       +-----------------+
  +----------+         |                 |
  |          |    1    |                 |
  |  CLIENT <---------------> NGINX      |
  |          |         |        ^        |
  +----------+         |        |        |
                       |      2 |        |
                       |        |        |
                       |        |        |
                       | +------v------+ |
                       | | STATIC FILE | |
                       | +-------------+ |
                       +-----------------+
  ```

- 1 file handler for connection with client and 1 file handler for a open socket to the remote or local host/process:

  ```
  # 2 connections, 2 file handlers

                       +-----------------+
  +----------+         |                 |         +-----------+
  |          |    1    |                 |    2    |           |
  |  CLIENT <---------------> NGINX <---------------> BACKEND  |
  |          |         |                 |         |           |
  +----------+         |                 |         +-----------+
                       +-----------------+
  ```

- 2 file handlers for two simultaneous connections from the same client (1, 4), 1 file handler for connection with other client (3), 2 file handlers for static files (2, 5), and 1 file handler for a open socket to the remote or local host/process (6), so in total it is 6 file descriptors:

  ```
  # 4 connections, 6 file handlers

                    4
        +-----------------------+
        |              +--------|--------+
  +-----v----+         |        |        |
  |          |    1    |        v        |  6
  |  CLIENT <-----+---------> NGINX <---------------+
  |          |    |    |        ^        |    +-----v-----+
  +----------+    |    |        |        |    |           |
                3 |    |      2 | 5      |    |  BACKEND  |
  +----------+    |    |        |        |    |           |
  |          |    |    |        |        |    +-----------+
  |  CLIENT  <----+    | +------v------+ |
  |          |         | | STATIC FILE | |
  +----------+         | +-------------+ |
                       +-----------------+
  ```

In the first two examples: we can take that NGINX needs 2 file handlers for full-fledged connection (but still uses 2 worker connections). In the third example NGINX can take still 2 file handlers for every full-fledged connection (also if client uses parallel connections).

So, to conclude, I think that the correct value of `worker_rlimit_nofile` per all connections of worker should be greater than `worker_connections`.

In my opinion, the safe value of `worker_rlimit_nofile` (and system limits) is:

```bash
# 1 file handler for 1 connection:
worker_connections + (shared libs, log files, event pool etc.) = worker_rlimit_nofile

# 2 file handlers for 1 connection:
(worker_connections * 2) + (shared libs, log files, event pool etc.) = worker_rlimit_nofile
```

That is probably how many files can be opened by each worker and should have a value greater than to the number of connections per worker (according to the above formula).

In the most articles and tutorials we can see that this parameter has a value similar to the maximum number (or even more) of all open files by the NGINX. If we assume that this parameter applies to each worker separately these values are altogether excessive.

However, after a deeper reflection they are rational because they allow one worker to use all the file descriptors so that they are not confined to other workers if something happens to them. Remember though that we are still limited by the connections per worker. May I remind you that any connection opens at least one file.

So, moving on, the maximum number of open files by the NGINX should be:

```bash
(worker_processes * worker_connections * 2) + (shared libs, log files, event pool) = max open files
```

  > To serve **16,384** connections by all workers (4,096 connections for each worker), and bearing in mind about the other handlers used by NGINX, a reasonably value of max files handlers in this case may be **35,000**. I think it's more than enough.

Given the above to change/improve the limitations you should:

1. Edit the maximum, total, global number of file descriptors the kernel will allocate before choking (this step is optional, I think you should change this only for a very very high traffic):

    ```bash
    # Find out the system-wide maximum number of file handles:
    sysctl fs.file-max

    # Shows the current number of all file descriptors in kernel memory:
    #   first value:  <allocated file handles>
    #  second value:  <unused-but-allocated file handles>
    #   third value:  <the system-wide maximum number of file handles> # fs.file-max
    sysctl fs.file-nr

    # Set it manually and temporarily:
    sysctl -w fs.file-max=150000

    # Set it permanently:
    echo "fs.file-max = 150000" > /etc/sysctl.d/99-fs.conf

    # And load new values of kernel parameters:
    sysctl -p       # for /etc/sysctl.conf
    sysctl --system # for /etc/sysctl.conf and all of the system configuration files
    ```

2. Edit the system-wide value of the maximum file descriptor number that can be opened by a single process:

    - for non-systemd systems:

      ```bash
      # Set the maximum number of file descriptors for the users logged in via PAM:
      #   /etc/security/limits.conf
      nginx       soft    nofile    35000
      nginx       hard    nofile    35000
      ```

    - for systemd systems:

      ```bash
      # Set the maximum number (hard limit) of file descriptors for the services started via systemd:
      #   /etc/systemd/system.conf          - global config (default values for all units)
      #   /etc/systemd/user.conf            - this specifies further per-user restrictions
      #   /lib/systemd/system/nginx.service - default unit for the NGINX service
      #   /etc/systemd/system/nginx.service - for your own instance of the NGINX service
      [Service]
      # ...
      LimitNOFILE=35000

      # Reload a unit file and restart the NGINX service:
      systemctl daemon-reload && systemct restart nginx
      ```

3.  Adjusts the system limit on number of open files for the NGINX worker. The maximum value can not be greater than `LimitNOFILE` (in this example: 35,000). You can change it at any time:

    ```bash
    # Set the limit for file descriptors for a single worker process (change it as needed):
    #   nginx.conf within the main context
    worker_rlimit_nofile          10000;

    # You need to reload the NGINX service:
    nginx -s reload
    ```

To show the current hard and soft limits applying to the NGINX processes (with `nofile`, `LimitNOFILE`, or `worker_rlimit_nofile`):

```bash
for _pid in $(pgrep -f "nginx: [master,worker]") ; do

  echo -en "$_pid "
  grep "Max open files" /proc/${_pid}/limits | awk '{print $4" "$5}'

done | xargs printf '%6s %10s\t%s\n%6s %10s\t%s\n' "PID" "SOFT" "HARD"
```

To list the current open file descriptors for each NGINX process:

```bash
for _pid in $(pgrep -f "nginx: [master,worker]") ; do

  _fds=$(find /proc/${_pid}/fd/*)
  _fds_num=$(echo "$_fds" | wc -l)

  echo -en "\n\n##### PID: $_pid ($_fds_num fds) #####\n\n"

  # List all files from the proc/{pid}/fd directory:
  echo -en "$_fds\n\n"

  # List all open files (log files, memory mapped files, libs):
  lsof -as -p $_pid | awk '{if(NR>1)print}'

done
```

You should also remember about the following rules:

- `worker_rlimit_nofile` serves to dynamically change the maximum file descriptors the NGINX worker processes can handle, which is typically defined with the system's soft limit (`ulimit -Sn`)

- `worker_rlimit_nofile` works only at the process level, it's limited to the system's hard limit (`ulimit -Hn`)

- if you have SELinux enabled, you will need to run `setsebool -P httpd_setrlimit 1` so that NGINX has permissions to set its rlimit. To diagnose SELinux denials and attempts you can use `sealert -a /var/log/audit/audit.log`, or `audit2why` and `audit2allow` tools

To sum up this example:

- each of the NGINX processes (master + workers) have the ability to create up to 35,000 files
- for all workers, the maximum number of file descriptors is 140,000 (`LimitNOFILE` per worker)
- for each worker, the initial/current number of file descriptors is 10,000 (`worker_rlimit_nofile`)

```
nginx: master process         = LimitNOFILE (35,000)
  \_ nginx: worker process    = LimitNOFILE (35,000), worker_rlimit_nofile (10,000)
  \_ nginx: worker process    = LimitNOFILE (35,000), worker_rlimit_nofile (10,000)
  \_ nginx: worker process    = LimitNOFILE (35,000), worker_rlimit_nofile (10,000)
  \_ nginx: worker process    = LimitNOFILE (35,000), worker_rlimit_nofile (10,000)

                              = master (35,000), all workers (140,000 or 40,000)
```

Look also at this great article about [Optimizing Nginx for High Traffic Loads](https://blog.martinfjordvald.com/2011/04/optimizing-nginx-for-high-traffic-loads/).

##### HTTP Keep-Alive connections

Before starting this section I recommend to read the following articles:

- [HTTP Keepalive Connections and Web Performance](https://www.nginx.com/blog/http-keepalives-and-web-performance/)
- [Optimizing HTTP: Keep-alive and Pipelining](https://www.igvita.com/2011/10/04/optimizing-http-keep-alive-and-pipelining/)
- [Evolution of HTTP — HTTP/0.9, HTTP/1.0, HTTP/1.1, Keep-Alive, Upgrade, and HTTPS](https://medium.com/platform-engineer/evolution-of-http-69cfe6531ba0)

The original model of HTTP, and the default one in HTTP/1.0, is short-lived connections. Each HTTP request is completed on its own connection; this means a TCP handshake happens before each HTTP request, and these are serialized. The client creates a new TCP connection for each transaction (and the connection is torn down after the transaction completes).

HTTP Keep-Alive connection or persistent connection is the idea of using a single TCP connection to send and receive multiple HTTP requests/responses (Keep Alive's work between requests), as opposed to opening a new connection for every single request/response pair.

This mechanism hold open the TCP connection between the client and the server after an HTTP transaction has completed. It's important because NGINX needs to close connections from time to time, even if you configure NGINX to allow infinite keep-alive-timeouts and a huge amount of acceptable requests per connection, to return results and as well errors and success messages.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/closed_vs_keepalive.png" alt="closed_vs_keepalive">
</p>

Persistent connection model keeps connections opened between successive requests, reducing the time needed to open new connections. The HTTP pipelining model goes one step further, by sending several successive requests without even waiting for an answer, reducing much of the latency in the network.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http_connections.png" alt="http_connections">
</p>

<sup><i>This infographic comes from [Mozilla MDN - Connection management in HTTP/1.x](https://developer.mozilla.org/en-US/docs/Web/HTTP/Connection_management_in_HTTP_1.x).</i></sup>

Look also at this example that shows how a Keep-Alive header could be used:

```
 Client                        Proxy                         Server
   |                             |                              |
   +- Keep-Alive: timeout=600 -->|                              |
   |  Connection: Keep-Alive     |                              |
   |                             +- Keep-Alive: timeout=1200 -->|
   |                             |  Connection: Keep-Alive      |
   |                             |                              |
   |                             |<-- Keep-Alive: timeout=300 --+
   |                             |    Connection: Keep-Alive    |
   |<- Keep-Alive: timeout=5000 -+                              |
   |    Connection: Keep-Alive   |                              |
   |                             |                              |
```

NGINX official documentation say:

  > _All connections are independently negotiated. The client indicates a timeout of 600 seconds (10 minutes), but the proxy is only prepared to retain the connection for at least 120 seconds (2 minutes). On the link between proxy and server, the proxy requests a timeout of 1200 seconds and the server reduces this to 300 seconds. As this example shows, the timeout policies maintained by the proxy are different for each connection. Each connection hop is independent._

Keepalive connections reduce overhead, especially when SSL/TLS is in use but they also have drawbacks; even when idling they consume server resources, and under heavy load, DoS attacks can be conducted. In such cases, using non-persistent connections, which are closed as soon as they are idle, can provide better performance.

  > NGINX closes keepalive connections when the `worker_connections` limit is reached.

To better understand how Keep-Alive works, I recommend a great [explanation](https://stackoverflow.com/a/38190172) by [Barry Pollard](https://stackoverflow.com/users/2144578/barry-pollard).

NGINX provides the two layers to enable Keep-Alive:

###### Client layer

- the maximum number of keepalive requests a client can make over a given connection, which means a client can make e.g. 256 successfull requests inside one keepalive connection:

  ```bash
  # Default: 100
  keepalive_requests  256;
  ```

- server will close connection after this time. A higher number may be required when there is a larger amount of traffic to ensure there is no frequent TCP connection re-initiated. If you set it lower, you are not utilizing keep-alives on most of your requests slowing down client:

  ```bash
  # Default: 75s
  keepalive_timeout   10s;
  ```

  > Increase this to allow the keepalive connection to stay open longer, resulting in faster subsequent requests. However, setting this too high will result in the waste of resources (mainly memory) as the connection will remain open even if there is no traffic, potentially: significantly affecting performance. I think this should be as close to your average response time as possible.

###### Upstream layer

- the number of idle keepalive connections that remain open for each worker process. The connections parameter sets the maximum number of idle keepalive connections to upstream servers that are preserved in the cache of each worker process (when this number is exceeded, the least recently used connections are closed):

  ```bash
  # Default: disable
  keepalive         32;
  ```

NGINX, by default, only talks HTTP/1.0 to the upstream servers. To keep TCP connection alive both upstream section and origin server should be configured to not finalise the connection.

  > Please keep in mind that keepalive is a feature of HTTP 1.1, NGINX uses HTTP 1.0 per default for upstreams.

Connection won't be reused by default because keepalive in the upstream section means no keepalive (each time you can see TCP stream number increases per every request to origin server).

HTTP keepalive enabled in NGINX upstream servers reduces latency thus improves performance and it reduces the possibility that the NGINX runs out of ephemeral ports.

  > The connections parameter should be set to a number small enough to let upstream servers process new incoming connections as well.

Update your upstream configuration to use keepalive:

```bash
upstream bk_x8080 {

  ...

  keepalive         16;

}
```

And enable the HTTP/1.1 protocol in all upstream requests:

```bash
server {

  ...

  location / {

    # Default is HTTP/1, keepalive is only enabled in HTTP/1.1:
    proxy_http_version  1.1;
    # Remove the Connection header if the client sends it,
    # it could be "close" to close a keepalive connection:
    proxy_set_header    Connection "";

    proxy_pass          http://bk_x8080;

  }

}

...

}
```

#### Request processing stages

There can be altogether 11 phases when NGINX handles (processes) a request:

- `NGX_HTTP_POST_READ_PHASE` - first phase, read the request header
  - example modules: [ngx_http_realip_module](https://nginx.org/en/docs/http/ngx_http_realip_module.html)

- `NGX_HTTP_SERVER_REWRITE_PHASE` - implementation of rewrite directives defined in a server block; to change request URI using PCRE regular expressions, return redirects, and conditionally select configurations
  - example modules: [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)

- `NGX_HTTP_FIND_CONFIG_PHASE` - replace the location according to URI (location lookup)

- `NGX_HTTP_REWRITE_PHASE` - URI transformation on location level
  - example modules: [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)

- `NGX_HTTP_POST_REWRITE_PHASE` - URI transformation post-processing (the request is redirected to a new location)
  - example modules: [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)

- `NGX_HTTP_PREACCESS_PHASE` - authentication preprocessing request limit, connection limit (access restriction)
  - example modules: [ngx_http_limit_req_module](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html), [ngx_http_limit_conn_module](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html), [ngx_http_realip_module](https://nginx.org/en/docs/http/ngx_http_realip_module.html)

- `NGX_HTTP_ACCESS_PHASE` - verification of the client (the authentication process, limiting access)
  - example modules: [ngx_http_access_module](https://nginx.org/en/docs/http/ngx_http_access_module.html), [ngx_http_auth_basic_module](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html)

- `NGX_HTTP_POST_ACCESS_PHASE` - access restrictions check post-processing phase, the certification process, processing `satisfy any` directive
  - example modules: [ngx_http_access_module](https://nginx.org/en/docs/http/ngx_http_access_module.html), [ngx_http_auth_basic_module](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html)

- `NGX_HTTP_PRECONTENT_PHASE` - generating content
  - example modules: [ngx_http_try_files_module](https://nginx.org/en/docs/http/ngx_http_core_module.html#try_files)

- `NGX_HTTP_CONTENT_PHASE` - content processing
  - example modules: [ngx_http_index_module](https://nginx.org/en/docs/http/ngx_http_index_module.html), [ngx_http_autoindex_module](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html), [ngx_http_gzip_module](https://nginx.org/en/docs/http/ngx_http_gzip_module.html)

- `NGX_HTTP_LOG_PHASE` - log processing
  - example modules: [ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html)

You may feel lost now (me too...) so I let myself put this great and simple preview:

<p align="center">
  <a href="https://www.nginx.com/resources/library/infographic-inside-nginx/">
    <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/request-flow.png" alt="request-flow">
  </a>
</p>

<sup><i>This infographic comes from [Inside NGINX](https://www.nginx.com/resources/library/infographic-inside-nginx/) official library.</i></sup>

On every phase you can register any number of your handlers. Each phase has a list of handlers associated with it.

I recommend a great explanation about [HTTP request processing phases in Nginx](http://scm.zoomquiet.top/data/20120312173425/index.html) and, of course, official [Development guide](http://nginx.org/en/docs/dev/development_guide.html).

#### Server blocks logic

  > NGINX does have **server blocks** (like a virtual hosts in an Apache) that use `listen` and `server_name` directives to bind to TCP sockets.

It's a short example of two server block contexts with several regular expressions:

```bash
http {

  index index.html;
  root /var/www/example.com/default;

  server {

    listen 10.10.250.10:80;
    server_name www.example.com;

    access_log logs/example.access.log main;

    root /var/www/example.com/public;

    location ~ ^/(static|media)/ { ... }

    location ~* /[0-9][0-9](-.*)(\.html)$ { ... }

    location ~* \.(jpe?g|png|gif|ico)$ { ... }

    location ~* (?<begin>.*app)/(?<end>.+\.php)$ { ... }

    ...

  }

  server {

    listen 10.10.250.11:80;
    server_name "~^(api.)?example\.com api.de.example.com";

    access_log logs/example.access.log main;

    location ~ ^(/[^/]+)/api(.*)$ { ... }

    location ~ ^/backend/id/([a-z]\.[a-z]*) { ... }

    ...

  }

}
```

##### Handle incoming connections

  > **:bookmark: [Separate listen directives for 80 and 443](RULES.md#beginner-separate-listen-directives-for-80-and-443)**<br>
  > **:bookmark: [Define the listen directives explicitly with address:port pair](RULES.md#beginner-define-the-listen-directives-explicitly-with-addressport-pair)**

NGINX uses the following logic to determining which virtual server (server block) should be used:

1. Match the `address:port` pair to the `listen` directive - that can be multiple server blocks with `listen` directives of the same specificity that can handle the request

    > NGINX use the `address:port` combination for handle incoming connections. This pair is assigned to the `listen` directive.

    The `listen` directive can be set to:

      - an IP address/port combination (`127.0.0.1:80;`)

      - a lone IP address, if only address is given, the port `80` is used (`127.0.0.1;`) - becomes `127.0.0.1:80;`

      - a lone port which will listen to every interface on that port (`80;` or `*:80;`) - becomes `0.0.0.0:80;`

      - the path to a UNIX domain socket (`unix:/var/run/nginx.sock;`)

    If the `listen` directive is not present then either `*:80` is used (runs with the superuser privileges), or `*:8000` otherwise.

    To play with `listen` directive NGINX must follow the following steps:

      - NGINX translates all incomplete `listen` directives by substituting missing values with their default values (see above)

      - NGINX attempts to collect a list of the server blocks that match the request most specifically based on the `address:port`

      - If any block that is functionally using `0.0.0.0`, will not be selected if there are matching blocks that list a specific IP

      - If there is only one most specific match, that server block will be used to serve the request

      - If there are multiple server blocks with the same level of matching, NGINX then begins to evaluate the `server_name` directive of each server block

    Look at this short example:

    ```bash
    # From client side:
    GET / HTTP/1.0
    Host: api.random.com

    # From server side:
    server {

      # This block will be processed:
      listen 192.168.252.10;  # --> 192.168.252.10:80

      ...

    }

    server {

      listen 80;  # --> *:80 --> 0.0.0.0:80
      server_name api.random.com;

      ...

    }
    ```

2. Match the `Host` header field against the `server_name` directive as a string (the exact names hash table)

3. Match the `Host` header field against the `server_name` directive with a
wildcard at the beginning of the string (the hash table with wildcard names starting with an asterisk)

    > If one is found, that block will be used to serve the request. If multiple matches are found, the longest match will be used to serve the request.

4. Match the `Host` header field against the `server_name` directive with a
wildcard at the end of the string (the hash table with wildcard names ending with an asterisk)

    > If one is found, that block is used to serve the request. If multiple matches are found, the longest match will be used to serve the request.

5. Match the `Host` header field against the `server_name` directive as a regular expression

    > The first `server_name` with a regular expression that matches the `Host` header will be used to serve the request.

6. If all the `Host` headers doesn't match, then direct to the `listen` directive marked as `default_server` (makes the server block answer all the requests that doesn’t match any server block)

7. If all the `Host` headers doesn't match and there is no `default_server`,
direct to the first server with a `listen` directive that satisfies first step

8. Finally, NGINX goes to the `location` context

<sup><i>This list is based on [Mastering Nginx - The virtual server section](../README.md#mastering-nginx).</i></sup>

##### Matching location

  > For each request, NGINX goes through a process to choose the best location block that will be used to serve that request.

The location block enables you to handle several types of URIs/routes, within a server block. Syntax looks like:

```bash
location optional_modifier location_match { ... }
```

`location_match` in the above defines what NGINX should check the request URI against. The `optional_modifier` below will cause the associated location block to be interpreted as follows (the order doesn't matter at this moment):

- `(none)`: if no modifiers are present, the location is interpreted as a prefix match. To determine a match, the location will now be matched against the beginning of the URI

- `=`: is an exact match, without any wildcards, prefix matching or regular expressions; forces a literal match between the request URI and the location parameter

- `~`: if a tilde modifier is present, this location must be used for case sensitive matching (RE match)

- `~*`: if a tilde and asterisk modifier is used, the location must be used for case insensitive matching (RE match)

- `^~`: assuming this block is the best non-RE match, a carat followed by a tilde modifier means that RE matching will not take place

And now, a short introduction to determines location priority:

- the exact match is the best priority (processed first); ends search if match

- the prefix match is the second priority; there are two types of prefixes: `^~` and `(none)`, if this match used the `^~` prefix, searching stops

- the regular expression match has the lowest priority; there are two types of prefixes: `~` and `~*`; in the order they are defined in the configuration file

- if regular expression searching yielded a match, that result is used, otherwise, the match from prefix searching is used

So look at this example, it comes from the [Nginx documentation - ngx_http_core_module](https://nginx.org/en/docs/http/ngx_http_core_module.html#location):

```bash
location = / {
  # Matches the query / only.
  [ configuration A ]
}
location / {
  # Matches any query, since all queries begin with /, but regular
  # expressions and any longer conventional blocks will be
  # matched first.
  [ configuration B ]
}
location /documents/ {
  # Matches any query beginning with /documents/ and continues searching,
  # so regular expressions will be checked. This will be matched only if
  # regular expressions don't find a match.
  [ configuration C ]
}
location ^~ /images/ {
  # Matches any query beginning with /images/ and halts searching,
  # so regular expressions will not be checked.
  [ configuration D ]
}
location ~* \.(gif|jpg|jpeg)$ {
  # Matches any request ending in gif, jpg, or jpeg. However, all
  # requests to the /images/ directory will be handled by
  # Configuration D.
  [ configuration E ]
}
```

To help you understand how does location match works:

- [Nginx location match tester](https://nginx.viraptor.info/)
- [Nginx location match visible](https://detailyang.github.io/nginx-location-match-visible/)

The process of choosing NGINX location block is as follows (a detailed explanation):

1. NGINX searches for an exact match. If a `=` modifier exactly matches the request URI, this specific location block is chosen right away

2. Prefix-based NGINX location matches (no regular expression). Each location will be checked against the request URI. If no exact (meaning no `=` modifier) location block is found, NGINX will continue with non-exact prefixes. It starts with the longest matching prefix location for this URI, with the following approach:

    - In case the longest matching prefix location has the `^~` modifier, NGINX will stop its search right away and choose this location.

    - Assuming the longest matching prefix location doesn’t use the `^~` modifier, the match is temporarily stored and the process continues.

    > I'm not sure about the order. In the official documentation it is not clearly indicated and external guides explain it differently. It seems logical to check the longest matching prefix location first.

3. As soon as the longest matching prefix location is chosen and stored, NGINX continues to evaluate the case-sensitive and insensitive regular expression locations. The first regular expression location that fits the URI is selected right away to process the request

4. If no regular expression locations are found that match the request URI, the previously stored prefix location is selected to serve the request

In order to better understand how this process work please see this short cheatsheet that will allow you to design your location blocks in a predictable way:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/nginx_location_cheatsheet.png" alt="nginx-location-cheatsheet">
</p>

  > I recommend to use external tools for testing regular expressions. For more please see [online tools](../README.md#online-tools) chapter.

Ok, so here's a more complicated configuration:

```bash
server {

 listen           80;
 server_name      xyz.com www.xyz.com;

 location ~ ^/(media|static)/ {
  root            /var/www/xyz.com/static;
  expires         10d;
 }

 location ~* ^/(media2|static2) {
  root            /var/www/xyz.com/static2;
  expires         20d;
 }

 location /static3 {
  root            /var/www/xyz.com/static3;
 }

 location ^~ /static4 {
  root            /var/www/xyz.com/static4;
 }

 location = /api {
  proxy_pass      http://127.0.0.1:8080;
 }

 location / {
  proxy_pass      http://127.0.0.1:8080;
 }

 location /backend {
  proxy_pass      http://127.0.0.1:8080;
 }

 location ~ logo.xcf$ {
  root            /var/www/logo;
  expires         48h;
 }

 location ~* .(png|ico|gif|xcf)$ {
  root            /var/www/img;
  expires         24h;
 }

 location ~ logo.ico$ {
  root            /var/www/logo;
  expires         96h;
 }

 location ~ logo.jpg$ {
  root            /var/www/logo;
  expires         48h;
 }

}
```

And here's the table with the results:

| <b>URL</b> | <b>LOCATIONS FOUND</b> | <b>FINAL MATCH</b> |
| :---         | :---         | :---         |
| `/` | <sup>1)</sup> prefix match for `/` | `/` |
| `/css` | <sup>1)</sup> prefix match for `/` | `/` |
| `/api` | <sup>1)</sup> exact match for `/api` | `/api` |
| `/api/` | <sup>1)</sup> prefix match for `/` | `/` |
| `/backend` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> prefix match for `/backend` | `/backend` |
| `/static` | <sup>1)</sup> prefix match for `/` | `/` |
| `/static/header.png` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `^/(media\|static)/` | `^/(media\|static)/` |
| `/static/logo.jpg` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `^/(media\|static)/` | `^/(media\|static)/` |
| `/media2` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `^/(media2\|static2)` | `^/(media2\|static2)` |
| `/media2/` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `^/(media2\|static2)` | `^/(media2\|static2)` |
| `/static2/logo.jpg` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `^/(media2\|static2)` | `^/(media2\|static2)` |
| `/static2/logo.png` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `^/(media2\|static2)` | `^/(media2\|static2)` |
| `/static3/logo.jpg` | <sup>1)</sup> prefix match for `/static3`<br><sup>2)</sup> prefix match for `/`<br><sup>3)</sup> case sensitive regex match for `logo.jpg$` | `logo.jpg$` |
| `/static3/logo.png` | <sup>1)</sup> prefix match for `/static3`<br><sup>2)</sup> prefix match for `/`<br><sup>3)</sup> case insensitive regex match for `.(png\|ico\|gif\|xcf)$` | `.(png\|ico\|gif\|xcf)$` |
| `/static4/logo.jpg` | <sup>1)</sup> priority prefix match for `/static4`<br><sup>2)</sup> prefix match for `/` | `/static4` |
| `/static4/logo.png` | <sup>1)</sup> priority prefix match for `/static4`<br><sup>2)</sup> prefix match for `/` | `/static4` |
| `/static5/logo.jpg` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `logo.jpg$` | `logo.jpg$` |
| `/static5/logo.png` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `.(png\|ico\|gif\|xcf)$` | `.(png\|ico\|gif\|xcf)$` |
| `/static5/logo.xcf` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case sensitive regex match for `logo.xcf$` | `logo.xcf$` |
| `/static5/logo.ico` | <sup>1)</sup> prefix match for `/`<br><sup>2)</sup> case insensitive regex match for `.(png\|ico\|gif\|xcf)$` | `.(png\|ico\|gif\|xcf)$` |

##### `rewrite` vs `return`

Generally there are two ways of implementing redirects in NGINX with: `rewrite` and `return`.

These directives (comes from the `ngx_http_rewrite_module`) are very useful but (from the NGINX documentation) the only 100% safe things which may be done inside if in a location context are:

- `return ...;`
- `rewrite ... last;`

Anything else may possibly cause unpredictable behaviour, including potential `SIGSEGV`.

###### `rewrite` directive

The `rewrite` directives are executed sequentially in order of their appearance in the configuration file. It's slower (but still extremely fast) than a `return` and returns HTTP 302 in all cases, irrespective of `permanent`.

The `rewrite` directive just changes the request URI, not the response of request. Importantly only the part of the original url that matches the regex is rewritten. It can be used for temporary url changes.

I sometimes used `rewrite` to capture elementes in the original URL, change or add elements in the path, and in general when I do something more complex:

```bash
location / {

  ...

  rewrite   ^/users/(.*)$       /user.php?username=$1 last;

  # or:
  rewrite   ^/users/(.*)/items$ /user.php?username=$1&page=items last;

}
```

`rewrite` directive accept optional flags:

- `break` - basically completes processing of rewrite directives, stops processing, and breakes location lookup cycle by not doing any location lookup and internal jump at all

  - if you use `break` flag inside `location` block:

    - no more parsing of rewrite conditions
    - internal engine continues to parse the current `location` block

    _Inside a location block, with `break`, NGINX only stops processing anymore rewrite conditions._

  - if you use `break` flag outside `location` block:

    - no more parsing of rewrite conditions
    - internal engine goes to the next phase (searching for `location` match)

    _Outside a location block, with `break`, NGINX stops processing anymore rewrite conditions._

- `last` - basically completes processing of rewrite directives, stops processing, and starts a search for a new location matching the changed URI

  - if you use `last` flag inside `location` block:

    - no more parsing of rewrite conditions
    - internal engine **starts to look** for another location match based on the result of the rewrite result
    - no more parsing of rewrite conditions, even on the next location match

    _Inside a location block, with last, NGINX stops processing anymore rewrite conditions and then **starts to look** for a new matching of location block. NGINX also ignores any rewrites in the new location block._

  - if you use `last` flag outside `location` block:

    - no more parsing of rewrite conditions
    - internal engine goes to the next phase (searching for `location` match)

    _Outside a location block, with `last`, NGINX stops processing anymore rewrite conditions._

- `redirect` - returns a temporary redirect with the 302 HTTP response code
- `permanent` - returns a permanent redirect with the 301 HTTP response code

Note:

- that outside location blocks, `last` and `break` are effectively the same
- processing of rewrite directives at server level may be stopped via `break`, but the location lookup will follow anyway

<sup><i>This explanation is based on the awesome answer by [Pothi Kalimuthu](https://serverfault.com/users/102173/pothi-kalimuthu) to [nginx url rewriting: difference between break and last](https://serverfault.com/a/829148).</i></sup>

Official documentation has a great tutorials about [Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/) and [Converting rewrite rules](https://nginx.org/en/docs/http/converting_rewrite_rules.html).

Finally, look at difference between `last` and `break` flags in action:

- `last` directive:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/rewrites/last_01.jpeg" alt="last">
</p>

- `break` directive:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/rewrites/break_01.jpeg" alt="break">
</p>

<sup><i>This infographic comes from [Internal rewrite - nginx](https://www.linkedin.com/pulse/internal-rewrite-nginx-ivan-dabi%C4%87) by [Ivan Dabic](https://www.linkedin.com/in/ivan-dabic).</i></sup>

###### `return` directive

The other way is a `return` directive. It's faster than rewrite because there is no regexp that has to be evaluated. It's stops processing and returns HTTP 301 (by default) to a client, and the entire url is rerouted to the url specified.

I use `return` directive in the following cases:

- force redirect from http to https:

  ```bash
  server {

    ...

    return  301 https://example.com$request_uri;

  }
  ```

- redirect from www to non-www and vice versa:

  ```bash
  server {

    ...

    # It's only example. You shouldn't use 'if' statement in the following case.
    if ($host = www.domain.com) {

      return  301 https://domain.com$request_uri;

    }

  }
  ```

- close the connection and log it internally:

  ```bash
  server {

    ...

    return 444;

  }
  ```

- send 4xx HTTP response for a client without any other actions:

  ```bash
  server {

    ...

    if ($request_method = POST) {

      return 405;

    }

    # or:
    if ($invalid_referer) {

      return 403;

    }

    # or:
    if ($request_uri ~ "^/app/(.+)$") {

      return 403;

    }

    # or:
    location ~ ^/(data|storage) {

      return 403;

    }

  }
  ```

- and sometimes for reply with HTTP code without serving a file:

  ```bash
  server {

    ...

    # NGINX will not allow a 200 with no response body (200's need to be with a resource in the response)
    return 204 "it's all okay";

    # Because default Content-Type is application/octet-stream, browser will offer to "save the file".
    # If you want to see reply in browser you should add properly Content-Type:
    # add_header Content-Type text/plain;

  }
  ```

##### `try_files` directive

We have one more very interesting and important directive: `try_files` (from the `ngx_http_core_module`). This directive tells NGINX to check for the existence of a named set of files or directories (checks files conditionally breaking on success).

I think the best explanation comes from official documentation:

  > _`try_files` checks the existence of files in the specified order and uses the first found file for request processing; the processing is performed in the current context. The path to a file is constructed from the file parameter according to the root and alias directives. It is possible to check directory’s existence by specifying a slash at the end of a name, e.g. `$uri/`. If none of the files were found, an internal redirect to the uri specified in the last parameter is made._

Generally it may check files on disk, redirect to proxies or internal locations, and return error codes, all in one directive.

Take a look at the following example:

```bash
server {

  ...

  root /var/www/example.com;

  location / {

    try_files $uri $uri/ /frontend/index.html;

  }

  location ^~ /images {

    root /var/www/static;
    try_files $uri $uri/ =404;

  }

  ...
```

- default root directory for all locations is `/var/www/example.com`

- `location /` - matches all locations without more specific locations, e.g. exact names

  - `try_files $uri` - when you receive a URI that's matched by this block try `$uri` first

    > For example: `https://example.com/tools/en.js` - NGINX will try to check if there's a file inside `/tools` called `en.js`, if found it, serve it in the first place.

  - `try_files $uri $uri/` - if you didn't find the first condition try the URI as a directory

    > For example: `https://example.com/backend/` - NGINX will try first check if a file called `backend` exists, if can't find it then goes to second check `$uri/` and see if there's a directory called `backend` exists then it will try serving it.

  - `try_files $uri $uri/ /frontend/index.html` - if a file and directory not found, NGINX sends `/frontend/index.html`

- `location ^~ /images` - handle any query beginning with `/images` and halts searching

  - default root directory for this location is `/var/www/static`

  - `try_files $uri` - when you receive a URI that's matched by this block try `$uri` first

    > For example: `https://example.com/images/01.gif` - NGINX will try to check if there's a file inside `/images` called `01.gif`, if found it, serve it in the first place.

  - `try_files $uri $uri/` - if you didn't find the first condition try the URI as a directory

    > For example: `https://example.com/images/` - NGINX will try first check if a file called `images` exists, if can't find it then goes to second check `$uri/` and see if there's a directory called `images` exists then it will try serving it.

  - `try_files $uri $uri/ =404` - if a file and directory not found, NGINX sends `HTTP 404` (Not Found)

On the other hand, `try_files` is relatively primitive. When encountered, NGINX will look for any of the specified files physically in the directory matched by the location block. If they don’t exist, NGINX does an internal redirect to the last entry in the directive.

##### `if`, `break` and `set`

The `ngx_http_rewrite_module` also provides additional directives:

- `break` - stops processing, if is specified inside the `location`, further processing of the request continues in this location:

  ```bash
  # It's useful for:
  if ($slow_resp) {

    limit_rate 50k;
    break;

  }
  ```

- `if` - you can use `if` inside a `server` but not the other way around, also notice that you shouldn't use `if` inside `location` as it may not work as desired. The NGINX docs say:

  > _There are cases where you simply cannot avoid using an `if`, for example if you need to test a variable which has no equivalent directive._

  You should also remember about this:

  > _The `if` context in NGINX is provided by the rewrite module and this is the primary intended use of this context. Since NGINX will test conditions of a request with many other purpose-made directives, `if` **should not** be used for most forms of conditional execution. This is such an important note that the NGINX community has created a page called [if is evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/) (yes, it's really evil and in most cases not needed)._

- `set` - sets a value for the specified variable. The value can contain text, variables, and their combination

Example of usage `if` and `set` directives:

```bash
# It comes from: https://gist.github.com/jrom/1760790:
if ($request_uri = /) {

  set $test  A;

}

if ($host ~* example.com) {

  set $test  "${test}B";

}

if ($http_cookie !~* "auth_token") {

  set $test  "${test}C";

}

if ($test = ABC) {

  proxy_pass http://cms.example.com;
  break;

}
```

##### `root` vs `alias`

  > Placing a `root` or `alias` directive in a location block overrides the `root` or `alias` directive that was applied at a higher scope.

With `alias` you can map to another file name. With `root` forces you to name your file on the server. In the first case, NGINX replaces the string prefix e.g `/robots.txt` in the URL path with e.g. `/var/www/static/robots.01.txt` and then uses the result as a filesystem path. In the second, NGINX inserts the string e.g. `/var/www/static/` at the beginning of the URL path and then uses the result as a file system path.

Look at this. There is a difference, when the `alias` is for a whole directory will work:

```bash
location ^~ /data/ { alias /home/www/static/data/; }
```

But the following code won't do:

```bash
location ^~ /data/ { root /home/www/static/data/; }
```

This would have to be:

```bash
location ^~ /data/ { root /home/www/static/; }
```

The `root` directive is typically placed in server and location blocks. Placing a `root` directive in the server block makes the `root` directive available to all location blocks within the same server block.

The `root` directive tells NGINX to take the request url and append it behind the specified directory. For example, with the following configuration block:

```bash
server {

  server_name example.com;
  listen 10.250.250.10:80;

  index index.html;
  root /var/www/example.com;

  location / {

    try_files $uri $uri/ =404;

  }

  location ^~ /images {

    root /var/www/static;
    try_files $uri $uri/ =404;

  }

}
```

NGINX will map the request made to:

- `http://example.com/images/logo.png` into the file path `/var/www/static/images/logo.png`
- `http://example.com/contact.html` into the file path `/var/www/example.com/contact.html`
- `http://example.com/about/us.html` into the file path `/var/www/example.com/about/us.html`

Like you want to forward all requests which start `/static` and your data present in `/var/www/static` you should set:

- first path: `/var/www`
- last path: `/static`
- full path: `/var/www/static`

```bash
location <last path> {

  root <first path>;

  ...

}
```

NGINX documentation on the `alias` directive suggests that it is better to use `root` over `alias` when the location matches the last part of the directive’s value.

The `alias` directive can only be placed in a location block. The following is a set of configurations for illustrating how the `alias` directive is applied:

```bash
server {

  server_name example.com;
  listen 10.250.250.10:80;

  index index.html;
  root /var/www/example.com;

  location / {

    try_files $uri $uri/ =404;

  }

  location ^~ /images {

    alias /var/www/static;
    try_files $uri $uri/ =404;

  }

}
```

NGINX will map the request made to:

- `http://example.com/images/logo.png` into the file path `/var/www/static/logo.png`
- `http://example.com/images/third-party/facebook-logo.png` into the file path `/var/www/static/third-party/facebook-logo.png`
- `http://example.com/contact.html` into the file path `/var/www/example.com/contact.html`
- `http://example.com/about/us.html` into the file path `/var/www/example.com/about/us.html`

##### `internal` directive

This directive specifies that the location block is internal. In other words,
the specified resource cannot be accessed by external requests.

On the other hand, it specifies how external redirections, i.e. locations like `http://example.com/app.php/some-path` should be handled; while set, they should return 404, only allowing internal redirections. In brief, this tells NGINX it's not accessible from the outside (it doesn't redirect anything).

Conditions handled as internal redirections are listed in the documentation for `internal` directive. Specifies that a given location can only be used for internal requests and are the following:

- requests redirected by the `error_page`, `index`, `random_index`, and `try_files` directives
- requests redirected by the `X-Accel-Redirect` response header field from an upstream server
- subrequests formed by the `include virtual` command of the `ngx_http_ssi_module module`, by the `ngx_http_addition_module` module directives, and by `auth_request` and `mirror` directives
- requests changed by the `rewrite` directive

Example 1:

```bash
error_page 404 /404.html;

location = /404.html {

  internal;

}
```

Example 2:

The files are served from the directory `/srv/hidden-files` by the path prefix `/hidden-files/`. Pretty straightforward. The internal declaration tells NGINX that this path is accessible only through rewrites in the NGINX config, or via the `X-Accel-Redirect `header in proxied responses.

To use this, just return an empty response which contains that header. The content of the header should be the location you want to redirect to:

```bash
location /hidden-files/ {

  internal;
  alias /srv/hidden-files/;

}
```

Example 3:

Another use case for internal redirects in NGINX is to hide credentials. Often you need to make requests to 3rd party services. For example, you want to send text messages or access a paid maps server. It would be the most efficient to send these requests directly from your JavaScript front end. However, doing so means you would have to embed an access token in the front end. This means savvy users could extract this token and make requests on your account.

An easy fix is to make an endpoint in your back end which initiates the actual request. We could make use of an HTTP client library inside the back end. However, this will again tie up workers, especially if you expect a barrage of requests and the 3rd party service is responding very slowly.

```bash
location /external-api/ {

  internal;
  set $redirect_uri "$upstream_http_redirect_uri";
  set $authorization "$upstream_http_authorization";

  # For performance:
  proxy_buffering off;
  # Pass on secret from backend:
  proxy_set_header Authorization $authorization;
  # Use URI determined by backend:
  proxy_pass $redirect_uri;

}
```

  > There is a limit of 10 internal redirects per request to prevent request processing cycles that can occur in incorrect configurations. If this limit is reached, the error 500 (Internal Server Error) is returned. In such cases, the `rewrite or internal redirection cycle` message can be seen in the error log.

<sup><i>Examples 2 and 3 (both are great!) comes from [How to use internal redirects in NGINX](https://clubhouse.io/developer-how-to/how-to-use-internal-redirects-in-nginx/).</i></sup>

Look also at [Authentication Based on Subrequest Result](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-subrequest-authentication/) from the official documentation.

##### External and internal redirects

External redirects originate directly from the client. So, if the client fetched `https://example.com/directory` it would be directly fall into preceding `location` block.

Internal redirect means that it doesn’t send a 302 response to the client, it simply performs an implicit rewrite of the url and attempts to process it as though the user typed the new url originally.

The internal redirect is different from the external redirect defined by HTTP response code 302 and 301, client browser won't update its URI addresses.

To begin rewriting internally, we should explain the difference between redirects and internal rewrite. When source points to a destination that is out of source domain that is what we call redirect as your request will go from source to outside domain/destination.

With internal rewrite you would be, basically, doing the same only the destination is local path under same domain and not the outside location.

There is also [great explanation](https://openresty.org/download/agentzh-nginx-tutorials-en.html#02-nginxdirectiveexecorder06) about internal redirects:

  > _The internal redirection (e.g. via the `echo_exec` or `rewrite` directive) is an operation that makes NGINX jump from one location to another while processing a request (are very similar to `goto` statement in the C language). This "jumping" happens completely within the server itself._

There are two different kinds of internal requests:

- internal redirects - redirects the client requests internally. The URI is
changed, and the request may therefore match another location block and
become eligible for different settings. The most common case of internal
redirects is when using the `rewrite` directive, which allows you to rewrite the
request URI

- sub-requests - additional requests that are triggered internally to generate (insert or append to the body of the original request) content that is complementary to the main request (`addition` or `ssi` modules)

#### Log files

  > **:bookmark: [Use custom log formats](RULES.md#beginner-use-custom-log-formats)**

Log files are a critical part of the NGINX management. It writes information about client requests in the access log right after the request is processed (in the last phase: `NGX_HTTP_LOG_PHASE`).

By default:

- the access log is located in `logs/access.log`, but I suggest you take it to `/var/log/nginx` directory
- data is written in the predefined `combined` format

It is the equivalent to the following configuration.

```bash
# In nginx.conf:
http {

  ...

  log_format combined '$remote_addr - $remote_user [$time_local] '
                      '"$request" $status $body_bytes_sent '
                      '"$http_referer" "$http_user_agent"';
  ...

}
```

For more information please see [Configuring Logging](https://docs.nginx.com/nginx/admin-guide/monitoring/logging/) and [ngx_http_log_module](http://nginx.org/en/docs/http/ngx_http_log_module.html).

##### Conditional logging

Sometimes certain entries are there just to fill up the logs or are cluttering them. I sometimes exclude requests - by client IP or whatever else - when I want to debug log files more effective.

So, in this example, if the `$error_codes` variable’s value is 0 - then log nothing (default action), but if 1 (e.g. `404` or `503` from backend) - to save this request to the log:

```bash
# Define map in the http context:
http {

  ...

  map $status $error_codes {

    default   1;
    ~^[23]    0;

  }

  ...

  # Add if condition to the access log:
  access_log /var/log/nginx/example.com-access.log combined if=$error_codes;

}
```

##### Manually log rotation

  > **:bookmark: [Configure log rotation policy](RULES.md#beginner-configure-log-rotation-policy)**

NGINX will re-open its logs in response to the `USR1` signal:

```bash
cd /var/log/nginx

mv access.log access.log.0
kill -USR1 $(cat /var/run/nginx.pid) && sleep 1

# >= gzip-1.6:
gzip -k access.log.0
# With any version:
gzip < access.log.0 > access.log.0.gz

# Test integrity and remove if test passed:
gzip -t access.log.0 && rm -fr access.log.0
```

##### Error log severity levels

The following is a list of all severity levels:

| <b>TYPE</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `debug` | information that can be useful to pinpoint where a problem is occurring |
| `info` | informational messages that aren’t necessary to read but may be good to know |
| `notice` | something normal happened that is worth noting |
| `warn` | something unexpected happened, however is not a cause for concern |
| `error` | something was unsuccessful, contains the action of limiting rules |
| `crit` | important problems that need to be addressed |
| `alert` | severe situation where action is needed promptly |
| `emerg` | the system is in an unusable state and requires immediate attention |

For example: if you set `crit` error log level, messages of `crit`, `alert`, and `emerg` levels are logged.

#### Reverse proxy

  > After reading this chapter, please see: [Rules: Reverse Proxy)](RULES.md#reverse-proxy-1).

This is one of the greatest feature of the NGINX. In simplest terms, a reverse proxy is a server that comes in-between internal applications and external clients, forwarding client requests to the appropriate server. It takes a client request, passes it on to one or more servers, and subsequently delivers the server’s response back to the client.

Official NGINX documentation say:

  > _Proxying is typically used to distribute the load among several servers, seamlessly show content from different websites, or pass requests for processing to application servers over protocols other than HTTP._

You can also read a very good explanation about [What's the difference between proxy server and reverse proxy server](https://stackoverflow.com/questions/224664/whats-the-difference-between-proxy-server-and-reverse-proxy-server/366212#366212).

A reverse proxy can off load much of the infrastructure concerns of a high-volume distributed web application.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/reverse-proxy/reverse-proxy_preview.png" alt="reverse-proxy_preview">
</p>

<sup><i>This infographic comes from [Jenkins with NGINX - Reverse proxy with https](https://medium.com/@sportans300/nginx-reverse-proxy-with-https-466daa4da4fc).</i></sup>

This allow you to have NGINX reverse proxy requests to unicorns, mongrels, webricks, thins, or whatever you really want to have run your servers.

Reverse proxy gives you number of advanced features such as:

- load balancing, failover, and transparent maintenance of the backend servers
- increased security (e.g. SSL termination, hide upstream configuration)
- increased performance (e.g. caching, load balancing)
- simplifies the access control responsibilities (single point of access and maintenance)
- centralised logging and auditing (single point of maintenance)
- add/remove/modify HTTP headers

In my opinion, the two most important things related to the reverse proxy are:

- the way of requests forwarded to the backend
- the type of headers forwarded to the backend

##### Passing requests

  > **:bookmark: [Use pass directive compatible with backend protocol](RULES.md#beginner-use-pass-directive-compatible-with-backend-protocol)**

When NGINX proxies a request, it sends the request to a specified proxied server, fetches the response, and sends it back to the client.

It is possible to proxy requests to:

- an HTTP servers (e.g. NGINX, Apache, or other) with `proxy_pass` directive:

  ```bash
  upstream bk_front {

    server 192.168.252.20:8080  weight=5;
    server 192.168.252.21:8080

  }

  server {

    location / {

      proxy_pass    http://bk_front;

    }

    location /api {

      proxy_pass    http://192.168.21.20:8080;

    }

    location /info {

      proxy_pass    http://localhost:3000;

    }

    location /ra-client {

      proxy_pass    http://10.0.11.12:8080/guacamole/;

    }

    location /foo/bar/ {

      proxy_pass    http://www.example.com/url/;

    }

    ...

  }
  ```

- a non-HTTP servers (e.g. PHP, Node.js, Python, Java, or other) with `proxy_pass` directive (as a fallback) or directives specially designed for this:

  - `fastcgi_pass` which passes a request to a FastCGI server ([PHP FastCGI Example](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)):

    ```bash
    server {

      ...

      location ~ ^/.+\.php(/|$) {

        fastcgi_pass    127.0.0.1:9000;
        include         /etc/nginx/fcgi_params;

      }

      ...

    }
    ```

  - `uwsgi_pass` which passes a request to a uWSGI server ([Nginx support uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/Nginx.html)):

    ```bash
    server {

      location / {

        root            html;
        uwsgi_pass      django_cluster;
        uwsgi_param     UWSGI_SCRIPT testapp;
        include         /etc/nginx/uwsgi_params;

      }

      ...

    }
    ```

  - `scgi_pass` which passes a request to an SCGI server:

    ```bash
    server {

      location / {

        scgi_pass       127.0.0.1:4000;
        include         /etc/nginx/scgi_params;

      }

      ...

    }
    ```

  - `memcached_pass` which passes a request to a Memcached server:

    ```bash
    server {

      location / {

        set            $memcached_key "$uri?$args";
        memcached_pass memc_instance:4004;

        error_page     404 502 504 = @memc_fallback;

      }

      location @memc_fallback {

        proxy_pass     http://backend;

      }

      ...

    }
    ```

  - `redis_pass` which passes a request to a Redis server ([HTTP Redis](https://www.nginx.com/resources/wiki/modules/redis/)):

    ```bash
    server {

      location / {

        set            $redis_key $uri;

        redis_pass     redis_instance:6379;
        default_type   text/html;
        error_page     404 = /fallback;

      }

      location @fallback {

        proxy_pass     http://backend;

      }

      ...

    }
    ```

The `proxy_pass` and other `*_pass` directives specifies that all requests which match the location block should be forwarded to the specific socket, where the backend app is running.

However, more complex apps may need additional directives:

  - `proxy_pass` - see [`ngx_http_proxy_module`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) directives explanation
  - `fastcgi_pass` - see [`ngx_http_fastcgi_module`](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html) directives explanation
  - `uwsgi_pass` - see [`ngx_http_uwsgi_module`](http://nginx.org/en/docs/http/ngx_http_uwsgi_module.html) directives explanation
  - `scgi_pass` - see [`ngx_http_scgi_module`](http://nginx.org/en/docs/http/ngx_http_scgi_module.html) directives explanation
  - `memcached_pass` - see [`ngx_http_memcached_module`](http://nginx.org/en/docs/http/ngx_http_memcached_module.html) directives explanation
  - `redis_pass` - see [`ngx_http_redis_module`](https://www.nginx.com/resources/wiki/modules/redis/) directives explanation

##### Trailing slashes

  > **:bookmark: [Be careful with trailing slashes in proxy_pass directive](RULES.md#beginner-be-careful-with-trailing-slashes-in-proxy_pass-directive)**

If you have something like:

```bash
location /public/ {

  proxy_pass http://bck_testing_01;

}
```

and go to `http://example.com/public`, NGINX will automatically redirect you to `http://example.com/public/`.

Look also at this example:

```bash
location /foo/bar/ {

  # proxy_pass  http://example.com/url/;
  proxy_pass    http://192.168.100.20/url/;

}
```

If the URI is specified along with the address, it replaces the part of the request URI that matches the location parameter. For example, here the request with the `/foo/bar/page.html` URI will be proxied to `http://www.example.com/url/page.html`.

If the address is specified without a URI, or it is not possible to determine the part of URI to be replaced, the full request URI is passed (possibly, modified).

Look also at this. Here is an example with trailing slash in location, but no trailig slash in `proxy_pass`:

```bash
location /foo/ {

  proxy_pass  http://127.0.0.1:8080/bar;

}
```

See how `bar` and `path` concatenates. If one go to address `http://yourserver.com/foo/path/id?param=1` NGINX will proxy request to `http://127.0.0.1/barpath/id?param=1`.

As stated in NGINX documentation if `proxy_pass` used without URI (i.e. without path after `server:port`) NGINX will put URI from original request exactly as it was with all double slashes, `../` and so on.

Look also at the configuration snippets: [Using trailing slashes](#using-trailing-slashes).

##### Passing headers

By default, NGINX redefines two header fields in proxied requests:

- the `Host` header is re-written to the value defined by the `$proxy_host` variable. This will be the IP address or name and port number of the upstream, directly as defined by the `proxy_pass` directive

- the `Connection` header is changed to `close`. This header is used to signal information about the particular connection established between two parties. In this instance, NGINX sets this to `close` to indicate to the upstream server that this connection will be closed once the original request is responded to. The upstream should not expect this connection to be persistent

When NGINX proxies a request, it automatically makes some adjustments to the request headers it receives from the client:

- NGINX drop empty headers. There is no point of passing along empty values to another server; it would only serve to bloat the request

- NGINX, by default, will consider any header that contains underscores as invalid. It will remove these from the proxied request. If you wish to have NGINX interpret these as valid, you can set the `underscores_in_headers` directive to `on`, otherwise your headers will never make it to the backend server

It is important to pass more than just the URI if you expect the upstream server handle the request properly. The request coming from NGINX on behalf of a client will look different than a request coming directly from a client.

  > Please read [Managing request headers](https://www.nginx.com/resources/wiki/start/topics/examples/headers_management/) from the official wiki.

NGINX use the `proxy_set_header` directive to sets headers that sends to the backend servers.

  > HTTP headers are used to transmit additional information between client and server. `add_header` sends headers to the client (browser) and will work on successful requests only, unless you set up `always` parameter. `proxy_set_header` sends headers to the backend server.

It's also important to distinguish between request headers and response headers. Request headers are for traffic inbound to the webserver or backend app. Response headers are going the other way (in the HTTP response you get back using client, e.g. curl or browser).

Ok, so look at following short explanation about proxy directives (for more information about valid header values please see [this](RULES.md#beginner-always-pass-host-x-real-ip-and-x-forwarded-stack-headers-to-the-backend) rule):

- `proxy_http_version` - defines the HTTP protocol version for proxying, by default it it set to 1.0. For Websockets and keepalive connections you need to use the version 1.1:

  ```bash
  proxy_http_version  1.1;
  ```

- `proxy_cache_bypass` - sets conditions under which the response will not be taken from a cache:

  ```bash
  proxy_cache_bypass  $http_upgrade;
  ```

- `proxy_intercept_errors` - means that any response with HTTP code 300 or greater is handled by the `error_page` directive and ensures that if the proxied backend returns an error status, NGINX will be the one showing the error page (overrides the error page on the backend side):

  ```bash
  proxy_intercept_errors on;
  error_page 500 503 504 @debug;  # go to the @debug location
  ```

- `proxy_set_header` - allows redefining or appending fields to the request header passed to the proxied server

  - `Upgrade` and `Connection` - these header fields are required if your application is using Websockets:

    ```bash
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    ```

  - `Host` - the `$host` variable in the following order of precedence contains: host name from the request line, or host name from the Host request header field, or the server name matching a request: NGINX uses `Host` header for `server_name` matching. It does not use TLS SNI. This means that for an SSL server, NGINX must be able to accept SSL connection, which boils down to having certificate/key. The cert/key can be any, e.g. self-signed:

    ```bash
    proxy_set_header Host $host;
    ```

  - `X-Real-IP` - forwards the real visitor remote IP address to the proxied server:

    ```bash
    proxy_set_header X-Real-IP $remote_addr;
    ```

  - `X-Forwarded-For` - is the conventional way of identifying the originating IP address of the user connecting to the web server coming from either a HTTP proxy or load balancer:

    ```bash
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    ```

  - `X-Forwarded-Proto` - identifies the protocol (HTTP or HTTPS) that a client used to connect to your proxy or load balancer:

    ```bash
    proxy_set_header X-Forwarded-Proto $scheme;
    ```

  - `X-Forwarded-Host` - defines the original host requested by the client:

    ```bash
    proxy_set_header X-Forwarded-Host $host;
    ```

  - `X-Forwarded-Port` - defines the original port requested by the client:

    ```bash
    proxy_set_header X-Forwarded-Port $server_port;
    ```

###### Importancy of the `Host` header

The `Host` header tells the webserver which virtual host to use (if set up). You can even have the same virtual host using several aliases (= domains and wildcard-domains). This why the host header exists. The host header specifies which website or web application should process an incoming HTTP request.

In NGINX, `$host` equals `$http_host`, lowercase and without the port number (if present), except when `HTTP_HOST` is absent or is an empty value. In that case, `$host` equals the value of the `server_name` directive of the server which processed the request

For example, if you set `Host: MASTER:8080`, `$host` will be "master" (while `$http_host` will be `MASTER:8080` as it just reflects the whole header).

###### Redirects and `X-Forwarded-Proto`

This header is very important because it prevent a redirect loop. When used inside HTTPS server block each HTTP response from the proxied server will be rewritten to HTTPS. Look at the following example:

1. Client sends the HTTP request to the Proxy
2. Proxy sends the HTTP request to the Server
3. Server sees that the URL is `http://`
4. Server sends back 3xx redirect response telling the Client to connect to `https://`
5. Client sends an HTTPS request to the Proxy
6. Proxy decrypts the HTTPS traffic and sets the `X-Forwarded-Proto: https`
7. Proxy sends the HTTP request to the Server
8. Server sees that the URL is `http://` but also sees that `X-Forwarded-Proto` is https and trusts that the request is HTTPS
9. Server sends back the requested web page or data

<sup><i>This explanation comes from [Purpose of the X-Forwarded-Proto HTTP Header](https://community.pivotal.io/s/article/Purpose-of-the-X-Forwarded-Proto-HTTP-Header).</i></sup>

In step 6 above, the Proxy is setting the HTTP header `X-Forwarded-Proto: https` to specify that the traffic it received is HTTPS. In step 8, the Server then uses the `X-Forwarded-Proto` to determine if the request was HTTP or HTTPS.

You can read about how to set it up correctly here:

- [Set correct scheme passed in X-Forwarded-Proto](RULES.md#set-correct-scheme-passed-in-x-forwarded-proto)
- [Don't use X-Forwarded-Proto with $scheme behind reverse proxy](RULES.md#beginner-dont-use-x-forwarded-proto-with-scheme-behind-reverse-proxy)

###### A warning about the `X-Forwarded-For`

I think, we should just maybe stop for a second. `X-Forwarded-For` is a one of the most important header that has the security implications.

Where a connection passes through a chain of proxy servers, `X-Forwarded-For` can give a comma-separated list of IP addresses with the first being the furthest downstream (that is, the user).

`X-Forwarded-For` should not be used for any Access Control List (ACL) checks because it can be spoofed by attackers. Use the real IP address for this type of restrictions. HTTP request headers such as `X-Forwarded-For`, `True-Client-IP`, and `X-Real-IP` are not a robust foundation on which to build any security measures, such as access controls.

[Set properly values of the X-Forwarded-For header (from this handbook)](RULES.md#beginner-set-properly-values-of-the-x-forwarded-for-header) - see this for more detailed information on how to set properly values of the `X-Forwarded-For` header.

But that's not all. Behind a reverse proxy, the user IP we get is often the reverse proxy IP itself. If you use other HTTP server working between proxy and app server you should also set the correct mechanism for interpreting values of this header.

I recommend to read [this](https://serverfault.com/questions/314574/nginx-real-ip-header-and-x-forwarded-for-seems-wrong/414166#414166) amazing explanation by [Nick M](https://serverfault.com/users/130923/nick-m).

1) Pass headers from proxy to the backend layer

    - [Always pass Host, X-Real-IP, and X-Forwarded stack headers to the backend](RULES.md#beginner-always-pass-host-x-real-ip-and-x-forwarded-stack-headers-to-the-backend)
    - [Set properly values of the X-Forwarded-For header (from this handbook)](RULES.md#beginner-set-properly-values-of-the-x-forwarded-for-header)

2) NGINX - modify the `set_real_ip_from` and `real_ip_header` directives:

    > For this, the `http_realip_module` must be installed (`--with-http_realip_module`).

    First of all, you should add the following lines to the configuration:

    ```bash
    # Add these to the set_real_ip.conf, there are the real IPs where your traffic is coming from (front proxy/lb):
    set_real_ip_from    192.168.20.10; # IP address of master
    set_real_ip_from    192.168.20.11; # IP address of slave

    # You can also add an entire subnet:
    set_real_ip_from    192.168.40.0/24;

    # Defines a request header field used to send the address for a replacement, in this case We use X-Forwarded-For:
    real_ip_header      X-Forwarded-For;

    # The real IP from your client address that matches one of the trusted addresses is replaced by the last non-trusted address sent in the request header field:
    real_ip_recursive   on;

    # Include it to the appropriate context:
    server {

      include /etc/nginx/set_real_ip.conf;

      ...

    }
    ```

3) NGINX - add/modify and set log format:

    ```bash
    log_format combined-1 '$remote_addr forwarded for $http_x_real_ip - $remote_user [$time_local]  '
                          '"$request" $status $body_bytes_sent '
                          '"$http_referer" "$http_user_agent"';

    # or:
    log_format combined-2 '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/example.com/access.log combined-1;
    ```

    This way, e.g. the `$_SERVER['REMOTE_ADDR']` will be correctly filled up in PHP fastcgi. You can test it with the following script:

    ```bash
    # tls_check.php
    <?php

    echo '<pre>';
    print_r($_SERVER);
    echo '</pre>';
    exit;

    ?>
    ```

    And send request to it:

    ```bash
    curl -H Cache-Control: no-cache -ks https://example.com/tls-check.php?${RANDOM} | grep "HTTP_X_FORWARDED_FOR\|HTTP_X_REAL_IP\|SERVER_ADDR\|REMOTE_ADDR"
    [HTTP_X_FORWARDED_FOR] => 172.217.20.206
    [HTTP_X_REAL_IP] => 172.217.20.206
    [SERVER_ADDR] => 192.168.10.100
    [REMOTE_ADDR] => 192.168.10.10
    ```

###### Improve extensibility with `Forwarded`

Since 2014, the IETF has approved a standard header definition for proxy, called `Forwarded`, documented [here](https://tools.ietf.org/html/rfc7239) and [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Forwarded) that should be use instead of `X-Forwarded` headers. This is the one you should use reliably to get originating IP in case your request is handled by a proxy. Official NGINX documentation also gives you how to [Using the Forwarded header](https://www.nginx.com/resources/wiki/start/topics/examples/forwarded/).

In general, the proxy headers (Forwarded or X-Forwarded-For) are the right way to get your client IP only when you are sure they come to you via a proxy. If there is no proxy header or no usable value in, you should default to the `REMOTE_ADDR` server variable.

#### Load balancing algorithms

Load Balancing is in principle a wonderful thing really. You can find out about it when you serve tens of thousands (or maybe more) of requests every second. Of course, load balancing is not the only reason - think also about maintenance tasks without downtime.

Generally load balancing is a technique used to distribute the workload across multiple computing resources and servers. I think you should always use this technique also if you have a simple app or whatever else what you're sharing with other.

The configuration is very simple. NGINX includes a `ngx_http_upstream_module` to define backends (groups of servers or multiple server instances). More specifically, the `upstream` directive is responsible for this.

  > `upstream` only provide a list of servers, some kind of weight, and other parameters related to the backend layer.

##### Backend parameters

Before we start talking about the load balancing techniques you should know something about `server` directive. It defines the address and other parameters of a backend servers.

This directive accepts the following options:

- `weight=<num>` - sets the weight of the origin server, e.g. `weight=10`

- `max_conns=<num>` - limits the maximum number of simultaneous active connections from the NGINX proxy server to an upstream server (default value: `0` = no limit), e.g. `max_conns=8`

  - if you set `max_conns=4` the 5th will be rejected
  - if the server group does not reside in the shared memory (`zone` directive), the limitation works per each worker process

- `max_fails=<num>` - the number of unsuccessful attempts to communicate with the backend (default value: `1`, `0` disables the accounting of attempts), e.g. `max_fails=3;`

- `fail_timeout=<time>` - the time during which the specified number of unsuccessful attempts to communicate with the server should happen to consider the server unavailable (default value: `10 seconds`), e.g. `fail_timeout=30s;`

- `zone <name> <size>` - defines shared memory zone that keeps the group’s configuration and run-time state that are shared between worker processes, e.g. `zone backend 32k;`

- `backup` - if server is marked as a backup server it does not receive requests unless both of the other servers are unavailable

- `down` - marks the server as permanently unavailable

##### Round Robin

It's the simpliest load balancing technique. Round Robin has the list of servers and forwards each request to each server from the list in order. Once it reaches the last server, the loop again jumps to the first server and start again.

```bash
upstream bck_testing_01 {

  # with default weight for all (weight=1)
  server 192.168.250.220:8080
  server 192.168.250.221:8080
  server 192.168.250.222:8080

}
```

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_round-robin.png" alt="round-robin">
</p>

##### Weighted Round Robin

In Weighted Round Robin load balancing algorithm, each server is allocated with a weight based on its configuration and ability to process the request.

This method is similar to the Round Robin in a sense that the manner by which requests are assigned to the nodes is still cyclical, albeit with a twist. The node with the higher specs will be apportioned a greater number of requests.

```bash
upstream bck_testing_01 {

  server 192.168.250.220:8080   weight=3
  server 192.168.250.221:8080              # default weight=1
  server 192.168.250.222:8080              # default weight=1

}
```

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_weighted-round-robin.png" alt="weighted-round-robin">
</p>

##### Least Connections

This method tells the load balancer to look at the connections going to each server and send the next connection to the server with the least amount of connections.

```bash
upstream bck_testing_01 {

  least_conn;

  # with default weight for all (weight=1)
  server 192.168.250.220:8080
  server 192.168.250.221:8080
  server 192.168.250.222:8080

}
```

For example: if clients D10, D11 and D12 attempts to connect after A4, C2 and C8 have already disconnected but A1, B3, B5, B6, C7 and A9 are still connected, the load balancer will assign client D10 to server 2 instead of server 1 and server 3. After that, client D11 will be assign to server 1 and client D12 will be assign to server 2.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_least-conn.png" alt="least-conn">
</p>

##### Weighted Least Connections

This is, in general, a very fair distribution method, as it uses the ratio of the number of connections and the weight of a server. The server in the cluster with the lowest ratio automatically receives the next request.

```bash
upstream bck_testing_01 {

  least_conn;

  server 192.168.250.220:8080   weight=3
  server 192.168.250.221:8080              # default weight=1
  server 192.168.250.222:8080              # default weight=1

}
```

For example: if clients D10, D11 and D12 attempts to connect after A4, C2 and C8 have already disconnected but A1, B3, B5, B6, C7 and A9 are still connected, the load balancer will assign client D10 to server 2 or 3 (because they have a least active connections) instead of server 1. After that, client D11 and D12 will be assign to server 1 because it has the biggest `weight` parameter.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_weighted-least-conn.png" alt="weighted-least-conn">
</p>

##### IP Hash

The IP Hash method uses the IP of the client to create a unique hash key and associates the hash with one of the servers. This ensures that a user is sent to the same server in future sessions (a basic kind of session persistence) except when this server is unavailable. If one of the servers needs to be temporarily removed, it should be marked with the `down` parameter in order to preserve the current hashing of client IP addresses.

This technique is especially helpful if actions between sessions has to be kept alive e.g. products put in the shopping cart or when the session state is of concern and not handled by shared memory of the application.

```bash
upstream bck_testing_01 {

  ip_hash;

  # with default weight for all (weight=1)
  server 192.168.250.220:8080
  server 192.168.250.221:8080
  server 192.168.250.222:8080

}
```

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_ip-hash.png" alt="ip-hash">
</p>

##### Generic Hash

This technique is very similar to the IP Hash but for each request the load balancer calculates a hash that is based on the combination of a text string, variable, or a combination you specify, and associates the hash with one of the servers.

```bash
upstream bck_testing_01 {

  hash $request_uri;

  # with default weight for all (weight=1)
  server 192.168.250.220:8080
  server 192.168.250.221:8080
  server 192.168.250.222:8080

}
```

For example: load balancer calculate hash from the full original request URI (with arguments). Clients A4, C7, C8 and A9 sends requests to the `/static` location and will be assign to server 1. Similarly clients A1, C2, B6 which get `/sitemap.xml` resource they will be assign to server 2. Clients B3 and B5 sends requests to the `/api/v4` and they will be assign to server 3.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/lb/nginx_lb_generic-hash.png" alt="generic-hash">
</p>

##### Other methods

It is similar to the Generic Hash method because you can also specify a unique hash identifier but the assignment to the appropriate server is under your control. I think it's a somewhat primitive method and I wouldn't say it is a full load balancing technique, but in some cases it is very useful.

  > Mainly this helps reducing the mess on the configuration made by a lot of `location` blocks with similar configurations.

First of all create a map:

```bash
map $request_uri $bck_testing_01 {

  default       "192.168.250.220:8080";

  /api/v4       "192.168.250.220:8080";
  /api/v3       "192.168.250.221:8080";
  /static       "192.168.250.222:8080";
  /sitemap.xml  "192.168.250.222:8080";

}
```

And add `proxy_pass` directive:

```bash
server {

  ...

  location / {

    proxy_pass    http://$bck_testing_01;

  }

  ...

}
```

#### Rate limiting

NGINX has a default module to setup rate limiting. For me, it's one of the most useful protect feature but sometimes really hard to understand.

I think, in case of doubt, you should read up on the following documents:

- [Rate Limiting with NGINX and NGINX Plus](https://www.nginx.com/blog/rate-limiting-nginx/)
- [NGINX rate-limiting in a nutshell](https://www.freecodecamp.org/news/nginx-rate-limiting-in-a-nutshell-128fe9e0126c/)
- [NGINX Rate Limiting](https://dzone.com/articles/nginx-rate-limiting)
- [How to protect your web site from HTTP request flood, DoS and brute-force attacks](https://www.ryadel.com/en/nginx-request-rate-limit-protect-web-site-http-request-flood-dos-brute-force/)

Rate limiting rules are useful for:

- traffic shaping
- traffic optimising
- slow down the rate of incoming requests
- protect http requests flood
- protect against slow http attacks
- prevent consume a lot of bandwidth
- mitigating ddos attacks
- protect brute-force attacks

##### Variables

NGINX has following variables (unique keys) that can be used in a rate limiting rules. For example:

| <b>VARIABLE</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `$remote_addr` | client address |
| `$binary_remote_addr`| client address in a binary form, it is smaller and saves space then `remote_addr` |
| `$server_name` | name of the server which accepted a request |
| `$request_uri` | full original request URI (with arguments) |
| `$query_string` | arguments in the request line |

<sup><i>Please see [official doc](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables) for more information about variables.</i></sup>

##### Directives, keys, and zones

NGINX also provides following keys:

| <b>KEY</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `limit_req_zone` | stores the current number of excessive requests |
| `limit_conn_zone` | stores the maximum allowed number of connections |

and directives:

| <b>DIRECTIVE</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `limit_req` | in combination with a `limit_conn_zone` sets the shared memory zone and the maximum burst size of requests |
| `limit_conn` | in combination with a `limit_req_zone` sets the shared memory zone and the maximum allowed number of (simultaneous) connections to the server per a client IP |

Keys are used to store the state of each IP address and how often it has accessed a limited object. This information are stored in shared memory available from all NGINX worker processes.

Both keys also provides response status parameters indicating too many requests or connections with specific http code (default **503**).

- `limit_req_status <value>`
- `limit_conn_status <value>`

For example, if you want to set the desired logging level for cases when the server limits the number of connections:

```bash
# Add this to http context:
limit_req_status 429;

# Set your own error page for 429 http code:
error_page 429 /rate_limit.html;
location = /rate_limit.html {

  root /usr/share/www/http-error-pages/sites/other;
  internal;

}

# And create this file:
cat > /usr/share/www/http-error-pages/sites/other/rate_limit.html << __EOF__
HTTP 429 Too Many Requests
__EOF__
```

Rate limiting rules also have zones that lets you define a shared space in which to count the incoming requests or connections.

  > All requests or connections coming into the same space will be counted in the same rate limit. This is what allows you to limit per URL, per IP, or anything else.

The zone has two required parts:

- `<name>` - is the zone identifier
- `<size>` - is the zone size

Example:

```bash
<key> <variable> zone=<name>:<size>;
```

  > State information for about **16,000** IP addresses takes **1 megabyte**. So **1 kilobyte** zone has **16** IP addresses.

The range of zones is as follows:

- **http context**

  ```bash
  http {

    ... zone=<name>;

  ```

- **server context**

  ```bash
  server {

    ... zone=<name>;

  ```

- **location directive**

  ```bash
  location /api {

    ... zone=<name>;

  ```

  > All rate limiting rules (definitions) should be added to the NGINX `http` context.

`limit_req_zone` key lets you set `rate` parameter (optional) - it defines the rate limited URL(s).

##### Burst and nodelay parameters

For enable queue you should use `limit_req` or `limit_conn` directives (see above). `limit_req` also provides optional parameters:

| <b>PARAMETER</b> | <b>DESCRIPTION</b> |
| :---         | :---         |
| `burst=<num>` | sets the maximum number of excessive requests that await to be processed in a timely manner; maximum requests as `rate` * `burst` in `burst` seconds |
| `nodelay`| it imposes a rate limit without constraining the allowed spacing between requests; default NGINX would return 503 response and not handle excessive requests |

  > `nodelay` parameters are only useful when you also set a `burst`.

Without `nodelay` NGINX would wait (no 503 response) and handle excessive requests with some delay.
