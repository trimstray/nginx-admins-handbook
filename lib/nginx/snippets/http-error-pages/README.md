# HTTP Static Error Pages Generator

## Description

A simple to use generator for **static pages with errors** to replace the default error pages that come with any web server like **Nginx** or **Apache**.

## Use example

Then an example of starting the tool:

```bash
./httpgen
```

The command result is located in the **sites/** directory.

## Error examples

### 404 Not Found
![alt text](doc/img/404_not_found.png)

### 503 Service Unavailable
![alt text](doc/img/503_service_unavailable.png)

### Temporary Maintenance
![alt text](doc/img/temporary_maintenance.png)

### Rate Limit
![alt text](doc/img/rate_limit.png)

## Your own error pages

If you would like to add your own static pages to generate, edit the **src/other.json** file and add to it:

```bash
  {
    "code" : "903",
    "title": "HTTP Error Code",
    "desc" : "This is a example http error code description.",
    "icon" : "fas fa-info-circle blue"
  }
```

Description:

- `code` - specifies the response status codes (eg. 400, 404, 501)
- `title` - specifies the short title of status code, related to the `code` key (eg. "Not Found", "Bad Gateway")
- `desc` - determines the possible reason for the error (eg. "The web server is currently undergoing some maintenance")
- `icon` - sets a small icon from font-awesome for error code (eg. "fas fa-info-circle green", "fas fa-info-circle red")

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Project architecture

    |-- LICENSE.md                    # GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
    |-- README.md                     # this simple documentation
    |-- CONTRIBUTING.md               # principles of project support
    |-- .gitignore                    # ignore untracked files
    |-- httpgen                       # main script (init)
    |-- sites                         # store generated static pages (default empty)
    |-- src
        |-- 4xx.json                  # data for 4xx errors
        |-- 5xx.json                  # data for 5xx errors
        |-- other.json                # data for other (eg. rate-limit) errors
        |-- main.css                  # main css file for all static pages
        |-- templates
            |-- _template.html        # static page for all other errors (eg. 404, 500)
            |-- nginx
                |-- errors.conf       # config file with error directives
    |-- doc
        |-- img                       # error examples

## License

GPLv3 : <http://www.gnu.org/licenses/>

**Free software, Yeah!**

