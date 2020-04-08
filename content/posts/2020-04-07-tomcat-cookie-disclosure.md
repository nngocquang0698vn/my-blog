---
title: "Tomcat May Log Cookies Out-of-the-Box"
description: "Warning you about cookies being logged out-of-the-box, and how to resolve it."
tags:
- blogumentation
- security
- java
- tomcat
- spring-boot
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-04-07T21:44:32+0100
slug: "tomcat-cookie-disclosure"
image: https://media.jvt.me/b75dd10681.png
---
# What's all this about?

While I was looking through my logs for some of my personal APIs the other day, I noticed some odd log messages about cookie formats:

```
2020-04-07 20:31:41.429  INFO 223090 --- [nio-8082-exec-3] o.apache.tomcat.util.http.parser.Cookie  : A cookie header was received [this=logged] that contained an invalid cookie. That cookie will be ignored.
 Note: further occurrences of this error will be logged at DEBUG level.
```

The cookie in question was not the one shared above, but a cookie that exists on one of my domains, and that definitely should not be logged, as it provides access to hijack a session. These being logged is quite sensitive, as potentially if these logs were to be intercepted, this could be used to attack my services.

It appears this is expected, and affects default installations of standalone Tomcat (tested with v8.5.53 and v9.0.33) as well as Spring Boot services (tested with v2.2.4.RELEASE) that use Tomcat as the container.

# Am I affected?

By sending a request to your server using an invalid cookie (i.e. not separated with a `;`, as defined by the spec):

```sh
$ curl --cookie "userId=wibble,this=logged" http://localhost:8080
```

You will then see a log message, similar to the above in your logs. It will only occur once per Tomcat container lifetime, so you may need to restart the application to force it.

# TL;DR - How do I resolve it?

The easiest way to resolve this is to simply revert back to using the [`LegacyCookieProcessor`](https://stackoverflow.com/a/47585351) which is not as strict with the cookies that are sent, and therefore doesn't log them when found to be incorrect.

## Tomcat XML Configuration

If deploying Tomcat, you can update the `conf/context.xml` (i.e. stored in `/usr/local/apache-tomcat-8.5.53/conf/context.xml`):

```xml
<!-- via https://stackoverflow.com/a/47585351 -->
<?xml version="1.0" encoding="UTF-8"?>
<!-- The contents of this file will be loaded for each web application -->
<Context>

  <WatchedResource>WEB-INF/web.xml</WatchedResource>
  <WatchedResource>${catalina.base}/conf/web.xml</WatchedResource>

  <!-- The default, which may or may not be present, but needs to be removed
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor" />
  -->

  <CookieProcessor className="org.apache.tomcat.util.http.LegacyCookieProcessor" />

</Context>
```

## Spring Boot Applications

Alternatively, we can expose a Spring bean to customise Tomcat to specify the cookie processor:

```java
import org.apache.catalina.Context;
import org.apache.tomcat.util.http.LegacyCookieProcessor;
import org.springframework.boot.web.embedded.tomcat.TomcatContextCustomizer;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;

// via https://stackoverflow.com/a/56804540
@Bean
WebServerFactoryCustomizer<TomcatServletWebServerFactory> cookieProcessorCustomizer() {
  return new WebServerFactoryCustomizer<TomcatServletWebServerFactory>() {
    @Override
    public void customize(TomcatServletWebServerFactory tomcatServletWebServerFactory) {
      tomcatServletWebServerFactory.addContextCustomizers(new TomcatContextCustomizer() {
        @Override
        public void customize(Context context) {
          context.setCookieProcessor(new LegacyCookieProcessor());
        }
      });
    }
  };
}
```

## Overriding the String

Because Tomcat uses localisation settings, you can also just override the strings that it uses to log these messages out. We can do this by adding a file into i.e. `/src/main/resources/org/apache/tomcat/util/http/parser/LocalStrings.properties`, including the package structure.

In this case, we need to override `cookie.invalidCookieValue` to a safer value, such as:

```properties
cookie.invalidCookieValue=A cookie header was received that contained an invalid cookie. That cookie will be ignored.
```

**NOTE** that you need to copy the existing properties when overriding the file, otherwise when logging, it will log the key, not the actual log message i.e.

```
2020-04-08 08:19:05.014  INFO 348698 --- [nio-8082-exec-1] o.apache.tomcat.util.http.parser.Cookie  : cookie.invalidCookieValue
```
