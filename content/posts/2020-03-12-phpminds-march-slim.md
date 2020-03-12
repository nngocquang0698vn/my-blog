---
title: "PHPMiNDS March: Slim 4: PHP's Microframework"
description: "Recapping Rob Allen's talk about Slim 4 at PHPMiNDS."
tags:
- phpminds
- slim
- php
- events
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-03-12T22:16:12+0000
slug: "phpminds-march-slim"
---
[Tonight at PHPMiNDS](https://www.meetup.com/PHPMiNDS-in-Nottingham/events/268999773/), we had <span class="h-card"><a class="u-url" href="https://akrabat.com">Rob Allen</a></span> speak about the [Slim PHP Framework](https://www.slimframework.com/).

Having not touched much PHP development, it was interesting to see how things are done with other languages and frameworks.

Rob also shared that Slim is built as a microwebframework which is very flexible compared to larger, opinionated frameworks - both of which have their pros and cons. It's common to pick up a larger framework, but then throw away/ignore most of the functionality, but with a microwebframework you can combine different tools and build the solution you want.

One of my biggest takeaways from the talk is that Slim 4 is built on a number of PHP Standard Recommendations (PSR) which means that it's incredibly easy to use interchangeable libraries, such as pieces of middleware or Dependency Injection containers. I really like this idea of building upon standards and making it easy to work with the tools you want to!

After seeing the ease of getting up and running with it, I feel I need to get around to playing with it:

```php
<?php
// use ...

$app = AppFactory::create();

$app->get('/hello/{name}', function (Request $request, Response $response, array $args) {
    $name = $args['name'];
    $response->getBody()->write("Hello, $name");
    return $response;
});

$app->run();
```

As an aside, I enjoyed Rob's comment about how Slim's code examples are one of the few that can be fit into a single slide yet be very readable.

Thanks Rob for coming to speak about it despite the Coronavirus concerns - we had a great turnout, and lots of good discussion!
