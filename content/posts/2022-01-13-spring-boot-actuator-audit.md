---
title: "Auditing with Spring Boot Actuator"
description: "How to use Spring Boot Actuator for your audit and business event logging needs."
tags:
- blogumentation
- java
- spring-boot
- spring-security
- logs
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-13T13:49:17+0000
slug: "spring-boot-actuator-audit"
---
[Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html) is described in the docs as the "Production-ready features" that can be used for improving Spring Boot applications, and I always reach for it with new Spring Boot applications.

Actuator has support for making it easier to publish audit events for your application, both to track authentication, authorization and other security events, but also to make it easier to add your own custom events.

Note that you don't necessarily need Actuator to publish these events, but it makes it easier to store them longer term, as well as query them via JMX or HTTP interactions.

This article has a corresponding [sample project on GitLab](https://gitlab.com/jamietanna/spring-boot-actuator-audit).

# Getting Started

To get started with Actuator for your audit logs, you need to do two things:

## Add the dependency

As [described in the docs](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html#actuator.enabling), we need to add the dependency:

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
</dependencies>
```

Or for Gradle:

```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-actuator'
}
```

This will then get picked up as part of Spring Boot's autoconfiguration and automagically start hooking in the actuator endpoints and configuration.

## Adding an `AuditEventRepository` bean

To make it possible for Actuator to store the audit events, for instance so you can retrieve them via JMX or HTTP, we need to provide an `AuditEventRepository` bean.

There's a very handy default implementation in actuator that stores them in-memory, which we'll use by default:

```java
import org.springframework.boot.actuate.audit.AuditEventRepository;
import org.springframework.boot.actuate.audit.InMemoryAuditEventRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AuditingConfiguration {
  @Bean
  public AuditEventRepository auditEventRepository() {
    // constructor also takes a default number of items to store in-memory for tuning
    return new InMemoryAuditEventRepository();
  }
}
```

And that's it - Actuator will now store any audit events published in this repository for future retrieval.

# Exposing the HTTP audit logs

Actuator defaults to making the audit logs available over JMX, but we may, for the purpose of testing, want to be able to query them over HTTP.

To do this, we can set the `management.endpoints.web.exposure.include` property, either on the command-line, or in our Spring properties files:

```sh
java -Dmanagement.endpoints.web.exposure.include='*' -jar build/libs/boot-audit-actuator-0.1-SNAPSHOT.jar
# or just for the audit events
java -Dmanagement.endpoints.web.exposure.include='auditevents' -jar build/libs/boot-audit-actuator-0.1-SNAPSHOT.jar
```

This then allows us to send a request to `/actuator/auditevents`:

```json
curl localhost:8080/actuator/auditevents -i
HTTP/1.1 200
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Pragma: no-cache
Expires: 0
X-Frame-Options: DENY
Content-Type: application/vnd.spring-boot.actuator.v3+json
Transfer-Encoding: chunked
Date: Thu, 13 Jan 2022 10:58:10 GMT

{"events":[]}
```

# Storing the audit events in a data store

Depending on the nature of the audit events, and your business requirements, it may be necessary to store them for a longer period of time than the ephemeral nature of the in-memory data store allows.

The recommendation is that you implement your own `AuditEventRepository`, for instance as a `CrudRepository` which then provides the ability to use a backing data store for our audit events.

I'll leave this as an exercise to the reader in terms of how we would do that.

# Adding an `EventListener` to add logging events

One alternate means of getting access to audit events - again, depending on business requirements - can be using logging to output the audit events to i.e. `stdout` or a file.

This has the risk that, i.e. in the case of a network blip you may lose events, depending on how your logging infrastructure works, but it's an option that can work, especially if you don't need longer term storage.

To do this, we can use an `EventListener` for events, and log them out i.e. using SLF4J:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.actuate.audit.listener.AuditApplicationEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class LoggingAuditEventListener {

  private static final Logger LOGGER = LoggerFactory.getLogger("AuditLogger");

  @EventListener
  public void on(AuditApplicationEvent event) {
    LOGGER.info("An Audit Event was received: {}", event);
  }
}
```

Now, this gives us a little bit of information about the event, and if we're using [structured logging](/posts/2021/05/31/spring-boot-structured-logging/), we'd see something like:

```json
{
  "@timestamp": "2022-01-13T11:20:38.818+0000",
  "@version": 1,
  "level": "INFO",
  "logger_name": "AuditLogger",
  "message": "An Audit Event was received: org.springframework.boot.actuate.audit.listener.AuditApplicationEvent[source=AuditEvent [timestamp=2022-01-13T11:20:38.818789920Z, principal=user, type=AUTHENTICATION_SUCCESS, data={details=WebAuthenticationDetails [RemoteIpAddress=127.0.0.1, SessionId=null]}]]",
  "source_host": "TheColonel",
  "thread_name": "http-nio-8080-exec-3"
}
```

But this isn't ideal, as we don't get much information about the audit event itself, and we have to use our brains a bit more than we want to try and make sense of the event itself.

Especially in the case of using structured logging, we want to make sure that we can more easily view and filter by different items in the logs.

We can instead make use of the MDC in SLF4J, and replace our code with something like this:

```java
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.boot.actuate.audit.listener.AuditApplicationEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class LoggingAuditEventListener {

  private static final Logger LOGGER = LoggerFactory.getLogger("AuditLogger");

  @EventListener
  public void on(AuditApplicationEvent event) {
    Map<String, String> backup = MDC.getCopyOfContextMap();
    MDC.put("event.type", event.getAuditEvent().getType());
    MDC.put("event.principal", event.getAuditEvent().getPrincipal());

    LOGGER.info("An Audit Event was received: {}", event);

    if (backup != null) {
      MDC.setContextMap(backup);
    }
  }
}
```

Which then populates our logs with a bit more information:

```json
{
  "@timestamp": "2022-01-13T11:24:56.430+0000",
  "@version": 1,
  "level": "INFO",
  "logger_name": "AuditLogger",
  "mdc": {
    "event.principal": "user",
    "event.type": "AUTHENTICATION_SUCCESS"
  },
  "message": "An Audit Event was received: org.springframework.boot.actuate.audit.listener.AuditApplicationEvent[source=AuditEvent [timestamp=2022-01-13T11:24:56.427302613Z, principal=user, type=AUTHENTICATION_SUCCESS, data={details=WebAuthenticationDetails [RemoteIpAddress=127.0.0.1, SessionId=null]}]]",
  "source_host": "TheColonel",
  "thread_name": "http-nio-8080-exec-1"
}
```

We may want to retrieve more information out of the logs, but have the issue that we may receive different types of audit events, which each have different things in them and may want to be logged differently, such as when there's an authorization failure:

```json
{
  "@timestamp": "2022-01-13T11:26:43.950+0000",
  "@version": 1,
  "level": "INFO",
  "logger_name": "AuditLogger",
  "mdc": {
    "event.principal": "anonymousUser",
    "event.type": "AUTHORIZATION_FAILURE"
  },
  "message": "An Audit Event was received: org.springframework.boot.actuate.audit.listener.AuditApplicationEvent[source=AuditEvent [timestamp=2022-01-13T11:26:43.950128282Z, principal=anonymousUser, type=AUTHORIZATION_FAILURE, data={details=WebAuthenticationDetails [RemoteIpAddress=127.0.0.1, SessionId=null], type=org.springframework.security.access.AccessDeniedException, message=Access is denied}]]",
  "source_host": "TheColonel",
  "thread_name": "http-nio-8080-exec-3"
}
```

As well as doing an `instanceof` check inside the generic listener, we could also replace/augment our generic listener with a more specific one, such as looking for cases where we have an `AbstractAuthorizationEvent`:

```java
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.boot.actuate.audit.listener.AuditApplicationEvent;
import org.springframework.context.event.EventListener;
import org.springframework.security.access.event.AbstractAuthorizationEvent;
import org.springframework.security.access.event.AuthorizationFailureEvent;
import org.springframework.security.web.FilterInvocation;
import org.springframework.stereotype.Component;

@Component
public class LoggingAuditEventListener {

  private static final Logger LOGGER = LoggerFactory.getLogger("AuditLogger");

  @EventListener
  public void on(AuditApplicationEvent event) {
    Map<String, String> backup = MDC.getCopyOfContextMap();
    MDC.put("event.type", event.getAuditEvent().getType());
    MDC.put("event.principal", event.getAuditEvent().getPrincipal());

    LOGGER.info("An Audit Event was received: {}", event);

    if (backup != null) {
      MDC.setContextMap(backup);
    }
  }

  /*
  or just listen for an `AuthorizationFailureEvent`
   */
  @EventListener
  public void on(AbstractAuthorizationEvent abstractEvent) {
    Map<String, String> backup = MDC.getCopyOfContextMap();
    if (abstractEvent instanceof AuthorizationFailureEvent) {
      AuthorizationFailureEvent event = (AuthorizationFailureEvent) abstractEvent;
      MDC.put("event.type", "AUTHORIZATION_FAILURE_EVENT");
      MDC.put("event.principal", event.getAuthentication().getName());
      FilterInvocation filterInvocation = (FilterInvocation) event.getSource();
      MDC.put("source.requestUrl", filterInvocation.getRequestUrl());
    }
    // and other checks for other subclasses
    LOGGER.info("An AuthorizationFailureEvent was received: {}", abstractEvent);

    if (backup != null) {
      MDC.setContextMap(backup);
    }
  }
}
```

Which then logs the following:

```json
{
  "@timestamp": "2022-01-13T11:35:51.046+0000",
  "@version": 1,
  "level": "INFO",
  "logger_name": "AuditLogger",
  "mdc": {
    "event.principal": "anonymousUser",
    "event.type": "AUTHORIZATION_FAILURE_EVENT",
    "source.requestUrl": "/actuator/auditevents"
  },
  "message": "An AuthorizationFailureEvent was received: org.springframework.security.access.event.AuthorizationFailureEvent[source=filter invocation [GET /actuator/auditevents]]",
  "source_host": "TheColonel",
  "thread_name": "http-nio-8080-exec-1"
}
```

Because the `EventListener` allows us to listen to any events that are published, you can hopefully see how we'd be able to add logging for specific events we're interested in, and add the relevant information from them to our logs.

# Spring Security

If you're using [Spring Security](https://docs.spring.io/spring-security/reference/) to secure your application, you'll find that Actuator picks up the audit events emitted by Spring Security, providing for instance the following entries in the audit log:

```json
HTTP/1.1 200
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Pragma: no-cache
Expires: 0
X-Frame-Options: DENY
Content-Type: application/vnd.spring-boot.actuator.v3+json
Transfer-Encoding: chunked
Date: Thu, 13 Jan 2022 11:07:19 GMT

{
  "events": [
    {
      "data": {
        "details": {
          "remoteAddress": "127.0.0.1",
          "sessionId": null
        },
        "message": "Access is denied",
        "type": "org.springframework.security.access.AccessDeniedException"
      },
      "principal": "anonymousUser",
      "timestamp": "2022-01-13T11:07:04.406503316Z",
      "type": "AUTHORIZATION_FAILURE"
    },
    {
      "data": {
        "details": {
          "remoteAddress": "127.0.0.1",
          "sessionId": null
        },
        "message": "Access is denied",
        "type": "org.springframework.security.access.AccessDeniedException"
      },
      "principal": "anonymousUser",
      "timestamp": "2022-01-13T11:07:09.163322945Z",
      "type": "AUTHORIZATION_FAILURE"
    },
    {
      "data": {
        "details": {
          "remoteAddress": "127.0.0.1",
          "sessionId": null
        }
      },
      "principal": "user",
      "timestamp": "2022-01-13T11:07:13.208507723Z",
      "type": "AUTHENTICATION_SUCCESS"
    },
    {
      "data": {
        "details": {
          "remoteAddress": "127.0.0.1",
          "sessionId": null
        }
      },
      "principal": "user",
      "timestamp": "2022-01-13T11:07:19.451857091Z",
      "type": "AUTHENTICATION_SUCCESS"
    }
  ]
}
```

Although there's more that we could use to make this more useful, for instance using the logging method mentioned above, it's still a handy way of getting information out of the events that are being triggered, with almost zero work required on our side.

# Custom Events

These are pretty useful, but what about our own application's audit logging? We may have custom events, metrics, and business reporting that we need to do.

Fortunately, we can simply create our own events and add an `EventListener`. Generally these would either implement the generic `ApplicationEvent` interface, or we could use the `AuditApplicationEvent` if we want to retain information about the principal of a request.

For instance, let's say that we have a filter that executes on each request for [tracking the `correlation-id` header](/posts/2021/11/22/correlation-ids/), and we want to publish an event to indicate the incoming request and the correlation ID.

Let's start by creating a new event, which in this case uses an `AuditApplicationEvent` to know who's authenticated, if anyone:

```java
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import javax.servlet.http.HttpServletRequest;
import org.springframework.boot.actuate.audit.listener.AuditApplicationEvent;

public class HttpRequestReceivedEvent extends AuditApplicationEvent {
  public HttpRequestReceivedEvent(HttpServletRequest request, String correlationId) {
    super(principal(request), "HTTP_REQUEST_RECEIVED", details(request, correlationId));
  }

  private static String principal(HttpServletRequest request) {
    return Optional.ofNullable(request.getUserPrincipal())
        .map(Principal::getName)
        .orElse("anonymousUser");
  }

  private static Map<String, Object> details(HttpServletRequest request, String correlationId) {
    Map<String, Object> details = new HashMap<>();
    details.put("http.correlationId", correlationId);
    details.put("http.method", request.getMethod());
    // other details here
    return details;
  }
}
```

Now we want to make our `CorrelationIdFilter` publish this event when we have received a request:

```java
import java.io.IOException;
import java.util.UUID;
import java.util.regex.Pattern;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import me.jvt.hacking.audit.HttpRequestReceivedEvent;
import org.slf4j.MDC;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class CorrelationIdFilter extends OncePerRequestFilter {
  // UUIDv4, matching either case, but depends on what format you want to use
  private static final Pattern UUID_PATTERN =
      Pattern.compile("([a-fA-F0-9]{8}(-[a-fA-F0-9]{4}){4}[a-fA-F0-9]{8})");

  private final ApplicationEventPublisher publisher;

  public CorrelationIdFilter(ApplicationEventPublisher publisher) {
    this.publisher = publisher;
  }

  @Override
  protected void doFilterInternal(
      @NonNull HttpServletRequest request,
      @NonNull HttpServletResponse response,
      @NonNull FilterChain filterChain)
      throws ServletException, IOException {
    String correlationId = request.getHeader("correlation-id");
    if (null == correlationId || !UUID_PATTERN.matcher(correlationId).matches()) {
      // only allow UUIDs, if it's not valid according to our contract, allow it to be rewritten
      // alternatively, we would rejct the request with an HTTP 400 Bad Request, as a client
      // hasn't fulfilled the contract
      correlationId = UUID.randomUUID().toString();
    }
    publisher.publishEvent(new HttpRequestReceivedEvent(request, correlationId));
    // make sure that the Mapped Diagnostic Context (MDC) has the `correlationId` so it can then
    // be populated in the logs
    try (MDC.MDCCloseable ignored = MDC.putCloseable("correlationId", correlationId)) {
      response.addHeader("correlation-id", correlationId);
      filterChain.doFilter(request, response);
    }
  }
}
```

Note that we've made sure our filter uses an (implicitly autowired) `ApplicationEventPublisher`. The recommended route from Actuator is to implement `ApplicationEventPublisherAware`, but as constructor injection also works - and is my personal preference - we can use that instead.

Note that if you inject the raw `AuditEventRepository`, you will not be able to listen for the events, as they bypass this route.
