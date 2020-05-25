---
title: "Reading a Servlet/Spring Request Body Multiple Times"
description: "How to read the request body more than once using Java Servlet Filters."
tags:
- blogumentation
- java
- spring
- servlet
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-25T19:56:08+0100
slug: "read-servlet-request-body-multiple"
---
I've recently been writing a [`javax.servlet.Filter`](https://javaee.github.io/javaee-spec/javadocs/javax/servlet/Filter.html) to perform validation on a request coming from [Netlify's Deploy Notifications](https://docs.netlify.com/site-deploys/notifications/#outgoing-webhooks) and have needed to read the request body to validate that the request is correct.

However, I've found this a little bit painful, as the Java Servlets provide a `ServletInputStream` that can only be read once, and if you don't, the web server you're using i.e. Spring may reject the incoming request.

This means that your requests will fail with the following/a similar error:

```
HTTP/1.1 400
Content-Type: application/json
Transfer-Encoding: chunked
Date: Mon, 25 May 2020 15:45:29 GMT
Connection: close
{
    "timestamp": "2020-05-25T15:45:33.739+0000",
    "status": 400,
    "error": "Bad Request",
    "message": "Required request body is missing: public org.springframework.http.ResponseEntity<java.lang.String> me.jvt.hacking.controller.Controller.echo(java.lang.String)",
    "path": "/"
}
```

To avoid this, we need to cache the `ServletInputStream`, so the web server can read the input, as well as the `Filter`(s) themselves.

For the sake of this example, I'll create an endpoint that echoes the request body, i.e.

```
$ curl localhost:8080/ -d 'hi' -H 'content-type: application/json' -i
HTTP/1.1 200
Content-Type: text/plain;charset=UTF-8
Content-Length: 2
Date: Mon, 25 May 2020 15:42:16 GMT

hi
```

And will have a `Filter` that logs the request body, too.

Complete code can be found at <a href="https://gitlab.com/jamietanna/multiple-read-servlet"><i title="GitLab" class="fa fa-gitlab"></i>&nbsp;jamietanna/multiple-read-servlet</a>.

# Using `ContentCachingRequestWrapper`

On paper, using Spring's [`ContentCachingRequestWrapper`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/util/ContentCachingRequestWrapper.html) _should_ work. It caches content read from the `ServletInputStream`, and allows easy retrieval.

However, it doesn't take into account the need for the `ServletInputStream` to be re-read, which means we still receive the `HttpMessageNotReadableException` exceptions about the request body being missing.

# Creating our own class

Following [arberg's response on _Http Servlet request lose params from POST body after read it once_](https://stackoverflow.com/a/36619972/2257038) and [Marco's response on _HttpServletRequestWrapper, example implementation for setReadListener / isFinished / isReady?_](https://stackoverflow.com/a/30748533/2257038) we can create the following:

```java
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import org.apache.commons.io.IOUtils;

/*
via https://stackoverflow.com/a/36619972/2257038 and https://stackoverflow.com/a/30748533/2257038
*/
public class MultiReadHttpServletRequest extends HttpServletRequestWrapper {
  private ByteArrayOutputStream cachedBytes;

  public MultiReadHttpServletRequest(HttpServletRequest request) {
    super(request);
  }

  @Override
  public ServletInputStream getInputStream() throws IOException {
    if (cachedBytes == null) cacheInputStream();

    return new CachedServletInputStream(cachedBytes.toByteArray());
  }

  @Override
  public BufferedReader getReader() throws IOException {
    return new BufferedReader(new InputStreamReader(getInputStream()));
  }

  private void cacheInputStream() throws IOException {
    /* Cache the inputstream in order to read it multiple times. For
     * convenience, I use apache.commons IOUtils
     */
    cachedBytes = new ByteArrayOutputStream();
    IOUtils.copy(super.getInputStream(), cachedBytes);
  }

  /* An inputstream which reads the cached request body */
  public static class CachedServletInputStream extends ServletInputStream {
    private final ByteArrayInputStream buffer;

    public CachedServletInputStream(byte[] contents) {
      this.buffer = new ByteArrayInputStream(contents);
    }

    @Override
    public int read() throws IOException {
      return buffer.read();
    }

    @Override
    public boolean isFinished() {
      return buffer.available() == 0;
    }

    @Override
    public boolean isReady() {
      return true;
    }

    @Override
    public void setReadListener(ReadListener listener) {
      throw new RuntimeException("Not implemented");
    }
  }
}
```

This allows us to do the following in our `Filter`:

```java
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BodyReadFilter implements Filter {

  private static final Logger LOGGER = LoggerFactory.getLogger(BodyReadFilter.class);

  public void doFilter(
      ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
      throws IOException, ServletException {
    MultiReadHttpServletRequest wrappedRequest =
        new MultiReadHttpServletRequest((HttpServletRequest) servletRequest);
    LOGGER.info(
        "The body of the request was {}", IOUtils.toString(wrappedRequest.getInputStream()));
    filterChain.doFilter(wrappedRequest, servletResponse);
  }
}
```

Make sure the `wrappedRequest` is used for all interactions, so the `ServletInputStream` can be cached.
