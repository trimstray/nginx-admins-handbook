# HTTP Basics

- **[⬆ HTTP Basics](https://github.com/trimstray/nginx-admins-handbook#toc-http-basics)**
  * [Features and architecture](#features-and-architecture)
  * [URI vs URL](#uri-vs-url)
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

HTTP stands for hypertext transfer protocol and is used for transmitting data (e.g. web pages) over the Internet.

Some important information about HTTP:

- all requests originate at the client (e.g. browser)
- the server responds to a request
- the requests and responses are in readable text
- the requests are independent of each other and the server doesn’t need to track the requests

I will not describe the HTTP protocol in detail, but I will discuss only the most important things because we have some great documents which describe it meticulously:

- [RFC 2616 - Hypertext Transfer Protocol - HTTP/1.1](https://tools.ietf.org/html/rfc2616)
- [HTTP Made Really Easy](https://www.jmarshall.com/easy/http/)
- [MDN web docs - An overview of HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
- [LWP in Action - Chapter 2. Web Basics](http://lwp.interglacial.com/ch02_01.htm)
- [HTTP and everything you need to know about it](https://medium.com/faun/http-and-everything-you-need-to-know-about-it-8273bc224491)

We have also some interesting books:

- [HTTP: The Definitive Guide](https://www.amazon.com/HTTP-Definitive-Guide-Guides-ebook/dp/B0043D2EKO)
- [RESTful Web Services](https://www.crummy.com/writing/RESTful-Web-Services/)

#### Features and architecture

The HTTP protocol is a request/response protocol based on the client/server based architecture where web browsers, robots and search engines, etc. act like HTTP clients, and the Web server acts as a server.

Here is a brief explanation:

- the HTTP client, i.e., a browser initiates an HTTP request and after a request is made, the client waits for the response

- the HTTP server handles and processing requests from clients, after that it sends a response to the client

- any type of data can be sent by HTTP as long as both the client and the server know how to handle the data content

- the server and client are aware of each other only during a current request. Afterwards, both of them forget about each other

The HTTP protocol allows clients and servers to communicate. Clients send requests using an HTTP method request and servers listen for requests on a host and port. The following is a comparison:

- **client** - the HTTP client sends a request to the server in the form of a request method, URI, and protocol version, followed by a MIME-like message containing request modifiers, client information, and possible body content over a TCP/IP connection

- **server** - the HTTP server responds with a status line, including the message's protocol version and a success or error code, followed by a MIME-like message containing server information, entity meta information, and possible entity-body content

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/HTTP_steps.png" alt="HTTP_steps">
</p>

<sup><i>This infographic comes from [www.ntu.edu.sg - HTTP (HyperText Transfer Protocol)](https://www.ntu.edu.sg/home/ehchua/programming/webprogramming/HTTP_Basics.html).</i></sup>

#### URI vs URL

Uniform Resource Identifier (URI) is a string of characters used to identify a name or a resource on the Internet. A URI identifies a resource either by location, or a name, or both. A URI has two specializations known as URL and URN.

I think, the best explanation is here: [The Difference Between URLs, URIs, and URNs](https://danielmiessler.com/study/url-uri/) by [Daniel Miessler](https://danielmiessler.com/about/).

For me, this short and clear explanation is also interesting:

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

If it is still unclear to you, I would advise you to look at the following articles:

- [What is the difference between a URI, a URL and a URN?](https://stackoverflow.com/questions/176264/what-is-the-difference-between-a-uri-a-url-and-a-urn/1984225)
- [The History of the URL: Path, Fragment, Query, and Auth](https://eager.io/blog/the-history-of-the-url-path-fragment-query-auth/)

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

##### Request line

The Request-line begins with a method, followed by the Request-URI and the protocol version, and ending with CRLF. The elements are separated by space SP characters:

```
Request-Line = Method SP Request-URI SP HTTP-Version CRLF
```

###### Methods

| <b>METHOD</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| `GET` | is used to retreive data from a server at the specified resource |

For example, say you have an API with a `/api/v2/users` endpoint. Making a `GET` request to that endpoint should return a list of all available users.

  > Requests with `GET` method does not change any data.

At a basic level, these things should be validated:

- check that a valid `GET` request returns a 200 status code
- ensure that a `GET` request to a specific resource returns the correct data

| <b>METHOD</b> | <b>DESCRIPTION</b> |
| :---:         | :---         |
| `POST` | is used to send data to the sever to modify and update a resource |

The simplest example is a contact form on a website. When you fill out the inputs in a form and hit Send, that data is put in the response body of the request and sent to the server.

  > Requests with `POST` method change data on the backend server (by modifying or updating a resource).

Here are some tips for testing `POST` requests:

- create a resource with a `POST` request and ensure a 200 status code is returned
- next, make a `GET` request for that resource, and ensure the data was saved correctly
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
| `PUT` | is used to send data to the sever to create or overwrite a resource |

The same `PUT` request multiple times will always produce the same result.

Check for these things when testing `PUT` requests:

- repeatedly cally a `PUT` request always returns the same result (idempotent)
- after updating a resource with a `PUT` request, a `GET` request for that resource should return the new data
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

  > Note that the absolute path cannot be empty; if none is present in the original URI, it MUST be given as `/` (the server root).

  > The asterisk `*` is used when an HTTP request does not apply to a particular resource, but to the server itself, and is only allowed when the method used does not necessarily apply to a resource.

###### HTTP version

The last part of the request indicating the client's supported HTTP version.

HTTP has four versions — HTTP/0.9, HTTP/1.0, HTTP/1.1, and HTTP/2.0. Today the versions in common use are HTTP/1.1 and HTTP/2.0.

Determining the appropriate version of the HTTP protocol is very important because it allows you to set specific HTTP method or required headers (e.g. `cache-control` for HTTP/1.1).

There is a nice explanation about [How does a HTTP 1.1 server respond to a HTTP 1.0 request?](https://stackoverflow.com/questions/35850518/how-does-a-http-1-1-server-respond-to-a-http-1-0-request).

##### Request header fields

There are three types of HTTP message headers for requests:

- **General-header** - applying to both requests and responses but with no relation to the data eventually transmitted in the body

- **Request-header** - containing more information about the resource to be fetched or about the client itself

- **Entity-header** - containing more information about the body of the entity, like its content length or its MIME-type

The Request-header fields allow the client to pass additional information about the request, and about the client itself, to the server.

What is an accepted maximum allowed size for HTTP headers? Read [this](https://stackoverflow.com/questions/686217/maximum-on-http-header-values) great answer. HTTP does not define any limit. However most web servers do limit size of headers they accept. Server will return `413 Entity Too Large` error if headers size exceeds that limit.

##### Message body

Request (message) body is the part of the HTTP request where additional content can be sent to the server.

It is optional. Most of the HTTP requests are `GET` requests without bodies. However, simulating requests with bodies is important to properly stress the proxy code and to test various hooks working with such requests. Most HTTP requests with bodies use `POST` or `PUT` request method.

##### Generate requests

How to generate a request?

- `curl`

  ```
  curl -Iks -v -X GET -H "Connection: keep-alive" -H "User-Agent: X-AGENT" https://example.com
  ```

- `httpie`

  ```
  http -p Hh GET https://example.com User-Agent:X-AGENT --follow
  ```

- `telnet`

  ```
  telnet example.com 80
  GET /index.html HTTP/1.1
  Host: example.com
  ```

- `openssl`

  ```
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
  Request       = (1) : Status-line                  Section 6.1
                  (2) : *(( general-header           Section 4.5
                          | response-header          Section 6.2
                          | entity-header ) CRLF)    Section 7.1
                  (3) : CRLF
                  (4) : [ message-body ]             Section 4.3
```

Example of form an HTTP response for a request to fetch the `/alerts/status` page from the web server running on `localhost:8000`:

<p align="center">
  <img src="https://github.com/trimstray/nginx-admins-handbook/blob/master/static/img/http/http_response.png" alt="http_request">
</p>

##### Status line

The Status-line consisting of the protocol version followed by a numeric status code and its associated textual phrase.

```
Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```

###### HTTP version

  > When an HTTP/1.1 message is sent to an HTTP/1.0 recipient or a recipient whose version is unknown, the HTTP/1.1 message is constructed such that it can be interpreted as a valid HTTP/1.0 message if all of the newer features are ignored.

###### Status codes and reason phrase

For more information please see:

- [HTTP response status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
- [HTTP Status Codes](https://httpstatuses.com/)
- [RFC 2616 - Hypertext Transfer Protocol -- HTTP/1.1 - Status Code Definitions](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)

##### Response header fields

There are three types of HTTP message headers for responses:

- **General-header** - applying to both requests and responses but with no relation to the data eventually transmitted in the body

- **Response-header** - these header fields give information about the server and about further access to the resource identified by the Request-URI

- **Entity-header** - containing more information about the body of the entity, like its content length or its MIME-type

The response-header fields allow the server to pass additional information about the response.

##### Message body

Contains the resource data that was requested by the client.
