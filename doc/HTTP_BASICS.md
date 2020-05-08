# HTTP Basics

Go back to the **[Table of Contents](https://github.com/trimstray/nginx-admins-handbook#table-of-contents)** or **[What's next?](https://github.com/trimstray/nginx-admins-handbook#whats-next)** section.

- **[≡ HTTP Basics](#http-basics)**
  * [Introduction](#introduction)
  * [Features and architecture](#features-and-architecture)
  * [HTTP/2](#http2)
    * [How to debug HTTP/2?](#how-to-debug-http2)
  * [HTTP/3](#http3)
  * [URI vs URL](#uri-vs-url)
  * [Connection vs request](#connection-vs-request)
  * [HTTP Headers](#http-headers)
    * [Header compression](#header-compression)
  * [HTTP Methods](#http-methods)
  * [Request](#request)
    * [Request line](#request-line)
      * [Methods](#methods)
      * [Request URI](#request-uri)
      * [HTTP version](#http-version)
    * [Request header fields](#request-header-fields)
    * [Message body](#message-body)
    * [Generate requests](#generate-requests)
  * [Response](#response)
    * [Status line](#status-line)
      * [HTTP version](#http-version-1)
      * [Status codes and reason phrase](#status-codes-and-reason-phrase)
    * [Response header fields](#response-header-fields)
    * [Message body](#message-body-1)
  * [HTTP client](#http-client)
    * [IP address shortcuts](#ip-address-shortcuts)
  * [Back-End web architecture](#back-end-web-architecture)
  * [Useful video resources](#useful-video-resources)

#### Introduction

Simply put, HTTP stands for hypertext transfer protocol and is used for transmitting data (e.g. web pages) over the Internet.

Some important information about HTTP:

- all requests originate at the client (e.g. browser)
- the server responds to a request
- the requests and responses are in readable text
- the requests are independent of each other and the server doesn’t need to track the requests

I will not describe the HTTP protocol meticulously so you have to look at this as an introduction. I will discuss only the most important things because we have some great documents which describe this protocol in a great deal of detail:

- [RFC 2616 - HTTP/1.1](https://tools.ietf.org/html/rfc2616) <sup>[IETF]</sup>
- [RFC 7230 - HTTP/1.1: Message Syntax and Routing](https://tools.ietf.org/html/rfc7230) <sup>[IETF]</sup>
- [HTTP Made Really Easy](https://www.jmarshall.com/easy/http/)
- [MDN web docs - An overview of HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
- [LWP in Action - Chapter 2. Web Basics](http://lwp.interglacial.com/ch02_01.htm)
- [HTTP and everything you need to know about it](https://medium.com/faun/http-and-everything-you-need-to-know-about-it-8273bc224491)

I also recommend to read:

- [Mini HTTP guide for developers](https://charemza.name/blog/posts/abstractions/http/http-guide-for-developers/)
- [10 Great Web Performance Blogs](https://www.aaronpeters.nl/blog/10-great-web-performance-blogs/)

We have some interesting books:

- [HTTP: The Definitive Guide](https://www.amazon.com/HTTP-Definitive-Guide-Guides-ebook/dp/B0043D2EKO)
- [High Performance Browser Networking](https://hpbn.co/)

Look also at the [useful video resources](#useful-video-resources) section of this chapter. And finally look at [this](https://github.com/bigcompany/know-your-http) amazing series of A1-sized posters about the HTTP protocol.

#### Features and architecture

The HTTP (1.0/1.1 = h1) protocol is a request/response protocol based on the client/server based architecture where web browsers, robots and search engines, etc. act like HTTP clients, and the Web server acts as a server. This is HTTP's message-based model. Every HTTP interaction includes a request and response.

By its nature, HTTP is stateless. Stateless means that all requests are separate from each other. So each request from your browser must contain enough information on its own for the server to fulfill the request.

Here is a brief explanation:

- most often the HTTP communication uses the TCP protocol

- the default port is TCP 80, but other ports can be used

- HTTP allow multiple requests and responses to be carried over a single (persistent) connection ([RFC 7230 - Persistence](https://tools.ietf.org/html/rfc7230#section-6.3) <sup>[IETF]</sup>)

- HTTP protocol is stateless (all requests are separate from each other)

- each transaction of the message based model of HTTP is processed separately from the others

- the HTTP client, i.e., a browser initiates an HTTP request and after a request is made, the client waits for the response

- the HTTP server handles and processing requests from clients (and continues to listen, and to accept other requests), after that it sends a response to the client

- any type of data can be sent by HTTP as long as both the client and the server know how to handle the data content

- the server and client are aware of each other only during a current request. Afterwards, both of them forget about each other

The HTTP protocol allows clients and servers to communicate. Clients send requests using an HTTP method request and servers listen for requests on a host and port. The following is a comparison:

- **client** - the HTTP client sends a request to the server in the form of a request method, URI, and protocol version, followed by a MIME-like message containing request modifiers, client information, and possible body content over a TCP/IP connection

- **server** - the HTTP server responds with a status line, including the message's protocol version and a success or error code, followed by a MIME-like message containing server information, entity meta information, and possible entity-body content

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/HTTP_steps.png" alt="HTTP_steps">
</p>

<sup><i>This infographic comes from [www.ntu.edu.sg - HTTP (HyperText Transfer Protocol)](https://www.ntu.edu.sg/home/ehchua/programming/webprogramming/HTTP_Basics.html).</i></sup>

#### HTTP/2

  > **:bookmark: [Use HTTP/2 - Performance - P1](RULES.md#beginner-use-http2)**

HTTP/2 (h2) is a major revision of the HTTP network protocol, intended as a higher performance alternative to HTTP/1.1. It introduces several new features, while remaining semantically compatible. HTTP/2 enables more efficient communication between browsers and servers that support it. All recent versions of major browsers support HTTP/2, including Chrome, Edge, Firefox, Opera, and Safari.

Look at the following comparison:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/http_comparison.png" alt="http_comparison">
</p>

I will not describe HTTP/2 because there are brilliant studies:

- [RFC 7540 - HTTP/2](https://tools.ietf.org/html/rfc7540) <sup>[IETF]</sup>
- [HTTP/2 finalized - a quick overview](https://evertpot.com/http-2-finalized/)
- [Introduction to HTTP/2](https://developers.google.com/web/fundamentals/performance/http2)
- [HTTP2 Explained](https://daniel.haxx.se/http2/)
- [HTTP/2 in Action](https://www.manning.com/books/http2-in-action)
- [HTTP/2 Frequently Asked Questions](https://http2.github.io/faq/)
- [How Does HTTP/2 Work?](https://sookocheff.com/post/networking/how-does-http-2-work/)
- [HTTP/2: the difference between HTTP/1.1, benefits and how to use it](https://medium.com/@factoryhr/http-2-the-difference-between-http-1-1-benefits-and-how-to-use-it-38094fa0e95b)
- [HTTP2 Vs. HTTP1 – Let’s Understand The Two Protocols](https://cheapsslsecurity.com/p/http2-vs-http1/)
- [HTTP 2 protocol – it is faster, but is it also safer?](https://research.securitum.com/http-2-protocol-it-is-faster-but-is-it-also-safer/)

However, you should know a client that does not support HTTP/2 will never ask the server for an HTTP/2 communication upgrade: the communication between them will be fully HTTP/1.1. A client that supports HTTP/2 never makes a HTTP/2 request by default and will ask the server (using HTTP/1.1 with `Upgrade: HTTP/2.0` header) for an HTTP/2 upgrade:

  - if the server is HTTP/2 ready, then the server will notice the client as such: the communication between them will be switched to HTTP/2
  - if the server is not HTTP/2 ready, then the server will ignore the upgrade request answering with HTTP/1.1: the communication between them should stay plenty HTTP/1.1

See also [NGINX Updates Mitigate the August 2019 HTTP/2 Vulnerabilities](https://www.nginx.com/blog/nginx-updates-mitigate-august-2019-http-2-vulnerabilities/).

##### How to debug HTTP/2?

There is a great explanation about [Tools for debugging, testing and using HTTP/2](https://blog.cloudflare.com/tools-for-debugging-testing-and-using-http-2/). Look also at [Useful tools for HTTP/2 debugging](https://community.akamai.com/customers/s/article/Useful-tools-for-HTTP-2-debugging?language=en_US).

#### HTTP/3

- [A QUIC look at HTTP/3](https://lwn.net/SubscriberLink/814522/ab3bfaa8f75c60ce/)
- [HTTP/3 explained](https://daniel.haxx.se/http3-explained/)
- [HTTP/3: the past, the present, and the future](https://blog.cloudflare.com/http3-the-past-present-and-future/)
- [What Is HTTP/3 – Lowdown on the Fast New UDP-Based Protocol](https://kinsta.com/blog/http3/)

#### URI vs URL

Uniform Resource Identifier (URI) is a string of characters used to identify a name or a resource on the Internet. A URI identifies a resource either by location, or a name, or both. A URI has two specializations known as URL and URN.

I think the best explanation is here: [The Difference Between URLs, URIs, and URNs](https://danielmiessler.com/study/url-uri/) by [Daniel Miessler](https://danielmiessler.com/about/).

For me, this short and clear comment is also interesting:

  > URIs **identify** and URLs **identify** and **locate**; however, **locators are also identifiers**, so every URL is also a URI, but there are URIs which are not URLs.

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/url_urn_uri.png" alt="url_urn_uri">
</p>

Look at the following examples to get your mind out of confusion and take it simple:

| <b>TYPE</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| URL | `https://www.google.com/folder/page.html` |
| URL | `http://example.com/resource?foo=bar#fragment` |
| URL | `ftp://example.com/download.zip` |
| URL | `mailto:user@example.com` |
| URL | `file:///home/user/file.txt` |
| URL | `/other/link.html` (a relative URL) |
| URN | `www.pierobon.org/iis/review1.htm#one` |
| URN | `urn:ietf:rfc:2648` |
| URN | `urn:isbn:0451450523` |
| URI | `http://www.pierobon.org/iis/review1.htm.html#one` |

The graphic below explains the URL format:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/url_format.png" alt="url_format">
</p>

If it is still unclear, I would advise you to look at the following articles:

- [What is the difference between a URI, a URL and a URN?](https://stackoverflow.com/questions/176264/what-is-the-difference-between-a-uri-a-url-and-a-urn/1984225)
- [The History of the URL: Path, Fragment, Query, and Auth](https://eager.io/blog/the-history-of-the-url-path-fragment-query-auth/)

#### Connection vs request

Basically connections are established to make requests using it. So you can have multiple requests per connection. Not at the same time, of course, but rendering a web page is a fairly lengthy process.

A connection is a TCP-based reliable pipeline between two endpoints. Each connection requires keeping track of both endpoint addresses/ports, sequence numbers, and which packets are unacknowledged or presumed missing.

A request is a HTTP request for a given resource with a particular method. There may be zero or more requests per session. (Yes, web browsers can and do open connections without sending a request.)

Most modern browsers open several connections at once, and download different files (images, css, js) at the same time to speed up the page load. But, like I said, each connection can handle multiple requests (downloads), too.

To summarize:

- HTTP connections - client and server introduce themselves; making a connection with server involves TCP handshaking and it is basically creating a socket connection with the server

- HTTP requests - client ask something from server; to make a HTTP request you should be already established a connection with the server. If you established connection with a server you can make multiple request using the same connection (HTTP/1.0 by default one request per connection, HTTP/1.1 by default it is keep alive)

There is also great comparison:

- opening 25 connections, one after another, and downloading 1 file through each connection (slowest)
- opening 1 connection and downloading 25 files through it (slow)
- opening 5 connections and downloading 5 files through each connection (fast)
- opening 25 connections and downloading 1 file through each connection (waste of resources)

So if you limit the number of connections or the number of requests too much, you will slow down your page load speeds.

#### HTTP Headers

When a client requests a resource from a server it uses HTTP. This request includes a set of key-value pairs giving information like the version of the browser or what file formats it understands. These key-value pairs are called request headers.

The server answers with the requested resource but also sends response headers giving information on the resource or the server itself.

See these articles about HTTP headers:

- [HTTP headers](https://developer.mozilla.org/pl/docs/Web/HTTP/Headers)
- [The HTTP Request Headers List](https://flaviocopes.com/http-request-headers/)
- [The HTTP Response Headers List](https://flaviocopes.com/http-response-headers/)
- [Exotic HTTP Headers](https://peteris.rocks/blog/exotic-http-headers/)
- [Secure your web application with these HTTP headers](https://odino.org/secure-your-web-application-with-these-http-headers/)
- [OWASP Secure Headers Project](https://owasp.org/www-project-secure-headers/)

HTTP headers allow the client and server to pass additional information with the request or the response. An HTTP header consists of its case-insensitive name followed by a colon `:`, then by its value (without line breaks).

###### Header compression

The role of header compression (HTTP/2):

  > _Header compression resulted in an ~88% reduction in the size of request headers and an ~85% reduction in the size of response headers. On the lower-bandwidth DSL link, in which the upload link is only 375 Kbps, request header compression in particular, led to significant page load time improvements for certain sites (i.e. those that issued large number of resource requests). We found a reduction of 45 - 1142 ms in page load time simply due to header compression._

- HTTP/2 supports a new dedicated header compression algorithm, called HPACK
- HPACK is resilient to CRIME
- HPACK uses three methods of compression: Static Dictionary, Dynamic Dictionary, Huffman Encoding

Please see also:

- [Designing Headers for HTTP Compression](https://www.mnot.net/blog/2018/11/27/header_compression)
- [HPACK: Header Compression for HTTP/2](https://http2.github.io/http2-spec/compression.html)
- [HPACK: the silent killer (feature) of HTTP/2](https://blog.cloudflare.com/hpack-the-silent-killer-feature-of-http-2/)

#### HTTP Methods

The HTTP protocol includes a set of methods that indicate which action to be done for a resource. The most common methods are `GET` and `POST`. But there are a few others, too:

- `GET` - is used to retreive data from a server at the specified resource

- `POST` - is used to create or append a resource to an existing resource

- `PUT` - is used to create or update (replace) the existing resource

- `HEAD` - is almost identical to `GET`, except without the response body

- `TRACE` - is used for used for diagnostic/debugging purposes which echo's back input back to the user

- `OPTIONS` - is used to describe the communication options (HTTP methods) that are available for the target resource

- `PATCH` - is used to apply partial modifications to a resource

- `DELETE` - is used to delete the specified resource

#### Request

A request consists of: `(1) a command or request + (2) optional headers + (4) optional body content`:

```
                      FIELDS OF HTTP REQUEST       PART OF RFC 2616
---------------------------------------------------------------------
  Request       = (1) : Request-line                 Section 5.1
                  (2) : *(( general-header           Section 4.5
                          | request-header           Section 5.3
                          | entity-header ) CRLF)    Section 7.1
                  (3) : CRLF
                  (4) : [ message-body ]             Section 4.3
```

Example of form an HTTP request to fetch `/alerts/status` page from the web server running on `localhost:8000`:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/http_request.png" alt="http_request">
</p>

Additional information about requests:

- route to the endpoint
- rewrite path/query
- deny access (acls)
- headers modification

##### Request line

The Request-line begins with a method, followed by the Request-URI and the protocol version, and ending with CRLF (`\r\n` or `0d0a` in a hex). The elements are separated by space SP characters:

```
Request-Line = Method SP Request-URI SP HTTP-Version CRLF
```

###### Methods

| <b>METHOD</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| `GET` | is used to retreive data from a server at the specified resource ([RFC 2616 - GET](https://tools.ietf.org/html/rfc2616#section-9.3)) <sup>[IETF]</sup> |

For example, say you have an API with a `/api/v2/users` endpoint. Making a `GET` request to that endpoint should return a list of all available users.

  > Requests with `GET` method does not change any data (the state of resource) and should never be used to submit new information to the server. This method is almost identical to `HEAD`. If `GET /users` returns a list of users, then `HEAD /users` will make the same request but won't get back the list of users.

At a basic level, these things should be validated:

- check that a valid `GET` request returns a `200` status code
- ensure that a `GET` request to a specific resource returns the correct data

When executing a `GET` request, you ask the server for one, or a set of entities. To allow the client to filter the result, it can use the so called "query string" (`?`) of the URL.

| <b>METHOD</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| `POST` | is used to send data to the sever to modify and update a resource ([RFC 2616 - POST](https://tools.ietf.org/html/rfc2616#section-9.5)) <sup>[IETF]</sup> |

Look at the definition of `POST`:

  > _The `POST` method is used to request that the origin server accept the entity enclosed in the request as a new subordinate of the resource identified by the Request-URI [...] The posted entity is subordinate to that URI in the same way that a file is subordinate to a directory containing it, a news article is subordinate to a newsgroup to which it is posted, or a record is subordinate to a database._

When executing a `POST` request, the client is actually submitting a new document to the remote host but the server decides the location where it is stored under the user collection.

  > Requests with `POST` method change data (the state of resource) on the backend server by modifying or updating a resource.

If you do not know the actual resource location, for instance, when you add a new article, but do not have any idea where to store it, you can `POST` it to an URL, and let the server decide the actual URL.

Here are some tips for testing `POST` requests:

- create a resource with a `POST` request (the server could respond with a `201 Created`)
- next, make a `GET` request to ensure a `200 OK` status code is returned (the data was saved correctly)
- add tests that ensure `POST` requests fail with incorrect or ill-formatted data

Modify and update a resource:

```
POST /items/<existing_item> HTTP/1.1
Host: example.com
```

The following is an error:

```
POST /items/<new_item> HTTP/1.1
Host: example.com
```

| <b>METHOD</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| `PUT` | is used to send data to the sever to create or overwrite a resource ([RFC 2616 - PUT](https://tools.ietf.org/html/rfc2616#section-9.6)) <sup>[IETF]</sup> |

Look at the definition of `PUT`:

  > _The `PUT` method requests that the enclosed entity be stored under the supplied Request-URI. If the Request-URI refers to an already existing resource, the enclosed entity SHOULD be considered as a modified version of the one residing on the origin server. If the Request-URI does not point to an existing resource [...] the origin server can create the resource with that URI._

The `PUT` specification requires that you already know the URL of the resource you wish to create or update. On create, if the client chooses the identifier for a resource a `PUT` request will create the new resource at the specified URL.

If you know that a resource already exists for a URL, you can make a `PUT` request to that URL to replace the state of that resource on the server.

Check for these things when testing `PUT` requests:

- repeatedly call a `PUT` request always returns the same result (idempotent)
- if an existing resource is modified, either the `200 OK` or `204 No Content` response codes SHOULD be sent to indicate successful completion of the request
- `PUT` requests should fail if invalid data is supplied in the request - nothing should be updated

For a new resource:

```
PUT /items/<new_item> HTTP/1.1
Host: example.com
```

To overwrite an existing resource:

```
PUT /items/<existing_item> HTTP/1.1
Host: example.com
```

For me, the difference between `POST` and `PUT` is sometimes unclear. I think both can be used for creating and the big difference is that a `POST` request is supposed to let the server decide how to (and if at all) create a new resource.

In my opinion, there is one more good explanation:

  > The `POST` method is used to send user-generated data to the web server. For example, a `POST` method is used when a user comments on a forum or if they upload a profile picture. A `POST` method should also be used if you do not know the specific URL of where your newly created resource should reside.

  > The `PUT` method completely replaces whatever currently exists at the target URL with something else. With this method, you can create a new resource or overwrite an existing one given you know the exact Request-URI.

Look also at [this](https://stackoverflow.com/a/630475) amazing answer by [Brian R. Bondy](https://stackoverflow.com/users/3153/brian-r-bondy).

###### Request URI

The Request-URI is a Uniform Resource Identifier and identifies the resource upon which to apply the request. The exact resource identified by an Internet request is determined by examining both the Request-URI and the Host header field.

The most common form of Request-URI is that used to identify a resource on an origin server or gateway. For example, a client wishing to retrieve a resource directly from the origin server would create a TCP connection to port 80 of the host `example.com` and send the following lines:

```
GET /pub/index.html HTTP/1.1
Host: example.com
```

The absoluteURI form is required when the request is being made to a proxy:

```
GET http://example.com/pub/index.html HTTP/1.1
```

  > Note that the absolute path cannot be empty; if none is present in the original URI, it MUST be given as `/` (the server root). The asterisk `*` is used when an HTTP request does not apply to a particular resource, but to the server itself, and is only allowed when the method used does not necessarily apply to a resource.

###### HTTP version

The last part of the request indicating the client's supported HTTP version. HTTP has four versions — HTTP/0.9, HTTP/1.0, HTTP/1.1, and HTTP/2.0. Today the versions in common use are HTTP/1.1 and HTTP/2.0.

Determining the appropriate version of the HTTP protocol is very important because it allows you to set specific HTTP method or required headers (e.g. `cache-control` for HTTP/1.1).

There is a nice explanation [How does a HTTP 1.1 server respond to a HTTP 1.0 request?](https://stackoverflow.com/questions/35850518/how-does-a-http-1-1-server-respond-to-a-http-1-0-request).

##### Request header fields

There are three types of HTTP message headers for requests:

- **General-header** - applying to both requests and responses but with no relation to the data eventually transmitted in the body

- **Request-header** - containing more information about the resource to be fetched or about the client itself

- **Entity-header** - containing more information about the body of the entity, like its content length or its MIME-type

The Request-header fields allow the client to pass additional information about the request, and about the client itself, to the server.

What is an accepted maximum allowed size for HTTP headers? Read [this](https://stackoverflow.com/questions/686217/maximum-on-http-header-values) great answer. HTTP does not define any limit. However, the most web servers do limit size of headers they accept. Server will return `413 Entity Too Large` error if headers size exceeds that limit.

##### Message body

Request (message) body is the part of the HTTP request where additional content can be sent to the server.

It is optional. Most of the HTTP requests are `GET` requests without bodies. However, simulating requests with bodies is important to properly stress the proxy code and to test various hooks working with such requests. Most HTTP requests with bodies use `POST` or `PUT` request method.

##### Generate requests

How to generate a request?

- `curl`

  ```bash
  curl -Iks -v -X GET -H "Connection: keep-alive" -H "User-Agent: X-AGENT" https://example.com
  ```

- `httpie`

  ```bash
  http -p Hh GET https://example.com User-Agent:X-AGENT --follow
  ```

- `telnet`

  ```bash
  telnet example.com 80
  GET /index.html HTTP/1.1
  Host: example.com
  ```

- `openssl`

  ```bash
  openssl s_client -servername example.com -connect example.com:443
  ...
  ---
  GET /index.html HTTP/1.1
  Host: example.com
  ```

For more examples, see [Testing](HELPERS.md#testing) chapter.

#### Response

After receiving and interpreting a request message, a server responds with an HTTP response message:

```
                     FIELDS OF HTTP RESPONSE       PART OF RFC 2616
---------------------------------------------------------------------
  Response      = (1) : Status-line                  Section 6.1
                  (2) : *(( general-header           Section 4.5
                          | response-header          Section 6.2
                          | entity-header ) CRLF)    Section 7.1
                  (3) : CRLF
                  (4) : [ message-body ]             Section 7.2
```

Example of form an HTTP response for a request to fetch the `/alerts/status` page from the web server running on `localhost:8000`:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/http_response.png" alt="http_request">
</p>

Additional information about responses:

- caching objects (browser/proxy)
- headers modification
- body modification

##### Status line

The Status-line consisting of the protocol version followed by a numeric status code and its associated textual phrase.

```
Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```

###### HTTP version

  > When an HTTP/1.1 message is sent to an HTTP/1.0 recipient or a recipient whose version is unknown, the HTTP/1.1 message is constructed such that it can be interpreted as a valid HTTP/1.0 message if all of the newer features are ignored.

###### Status codes and reason phrase

- `1xx: Informational` - Request received, continuing process
- `2xx: Success` - The action was successfully received, understood, and accepted
- `3xx: Redirection` - Further action must be taken in order to complete the request
- `4xx: Client Error` - The request contains bad syntax or cannot be fulfilled
- `5xx: Server Error` - The server failed to fulfill an apparently valid request

For more information please see:

- [HTTP response status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
- [HTTP Status Codes](https://httpstatuses.com/)
- [RFC 2616 - Status Code Definitions](https://tools.ietf.org/html/rfc2616#section-10)

Be sure to take a look at this (it's genius work!):

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/http_decision_diagram.png" alt="http_decision_diagram">
</p>

<sup><i>This diagram comes from [for-GET/http-decision-diagram](https://github.com/for-GET/http-decision-diagram) repository.</i></sup>

The diagram follows the indications in [RFC7230](https://tools.ietf.org/html/rfc7230), [RFC7231](https://tools.ietf.org/html/rfc7231), [RFC7232](https://tools.ietf.org/html/rfc7232), [RFC7233](https://tools.ietf.org/html/rfc7233), [RFC7234](https://tools.ietf.org/html/rfc7234), [RFC7235](https://tools.ietf.org/html/rfc7235), and fills in the void where necessary. Under no circumstances does this diagram override the HTTP specifications.

##### Response header fields

There are three types of HTTP message headers for responses:

- **General-header** - applying to both requests and responses but with no relation to the data eventually transmitted in the body

- **Response-header** - these header fields give information about the server and about further access to the resource identified by the Request-URI

- **Entity-header** - containing more information about the body of the entity, like its content length or its MIME-type

The response-header fields allow the server to pass additional information about the response.

##### Message body

Contains the resource data that was requested by the client.

#### HTTP client

HTTP client is a client that is able to send a request to and get a response from the server in HTTP format. Clients also originates a connection, passes any necessary authentication tokens and delivers the request for a specific piece of data.

  > The clients are anything that send requests to the back-end.

##### IP address shortcuts

IP addresses can be shortened by dropping the zeroes:

```
http://1.0.0.1 → http://1.1
http://127.0.0.1 → http://127.1
http://192.168.0.1 → http://192.168.1

http://0xC0A80001 or http://3232235521 → 192.168.0.1
http://192.168.257 → 192.168.1.1
http://192.168.516 → 192.168.2.4
```

  > This bypasses WAF filters for SSRF, open-redirect, etc where any IP as input gets blacklisted.

For more information please see [How to Obscure Any URL](http://www.pc-help.org/obscure.htm) and [Magic IP Address Shortcuts](https://stuff-things.net/2014/09/25/magic-ip-address-shortcuts/).

#### Back-End web architecture

  > I recommend to read these great repositories:
  >
  >   - [Learn how to design large-scale systems](https://github.com/donnemartin/system-design-primer)<br>
  >   - [Web Architecture 101](https://engineering.videoblocks.com/web-architecture-101-a3224e126947)

The back-end, or the "server side", is all of the technology required to process the incoming request and generate and send the response to the client. This typically includes three major parts:

- **server** - this is the computer that receives requests (backend/origin server)
- **app** - this is the application running on the server that listens for requests, retrieves information from the database, and sends a response
- **databases** - are used to organize and persist data

#### Useful video resources

- [HTTP Crash Course & Exploration](https://youtu.be/iYM2zFP3Zn0)
- [CS50 2017 - Lecture 6 - HTTP](https://youtu.be/PUPDGbnpSjw)
- [HTTP/2 101 (Chrome Dev Summit 2015)](https://youtu.be/r5oT_2ndjms)
- [Headers for Hackers: Wrangling HTTP Like a Pro](https://youtu.be/TNlcoYLIGFk)
- [Hacking with Andrew and Brad: an HTTP/2 client](https://youtu.be/yG-UaBJXZ80)
- [Advanced HTTP Protocol Hacking](https://youtu.be/up8Vz5PTX3M)
- [Hacking HTTP/2 - New Attacks on the Internet's Next Generation Foundation](https://youtu.be/kM8cc0kB21s)
