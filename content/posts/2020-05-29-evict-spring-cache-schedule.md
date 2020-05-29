---
title: "Evicting Spring Cache on a Schedule"
description: "How to evict Spring Cache's `@Cacheable` data on a schedule."
tags:
- blogumentation
- java
- spring
- spring-cache
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-29T10:20:00+0100
slug: "evict-spring-cache-schedule"
---
If you're using [Spring Cache](https://docs.spring.io/spring/docs/current/spring-framework-reference/integration.html#cache), you may want to evict the cache on a schedule, to keep it updated.

If you're using out-of-the-box caching with Spring 5 (tested with v5.1.6) you can do something similar to the following:

```java
import javax.management.timer.Timer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

@EnableCaching
@EnableScheduling // remember this so your `@Scheduled` get picked up
@Configuration
public class CacheConfiguration {
  public static final String EVENTS_CACHE = "events";
  public static final String GROUPS_CACHE = "groups";

  private static final Logger LOGGER = LoggerFactory.getLogger(CacheConfiguration.class);
  private static final long SIX_HOURS = Timer.ONE_HOUR * 6;

  @Scheduled(fixedRate = Timer.ONE_HOUR)
  @CacheEvict(
      value = {EVENTS_CACHE},
      allEntries = true)
  public void clearEvents() {
    LOGGER.info("Clearing events caches");
  }

  @Scheduled(fixedRate = SIX_HOURS)
  @CacheEvict(
      value = {GROUPS_CACHE},
      allEntries = true)
  public void clearGroups() {
    LOGGER.info("Clearing groups caches");
  }
}
```

**Note** the `allEntries = true` is essential, [as noted by Johannes Di on _Schedule Spring cache eviction?_](https://stackoverflow.com/a/52774606/2257038) otherwise `@CacheEvict` will be a no-op.
