---
title: "Reusing a browser session with Playwright"
description: "How to re-use your existing browser sessions with Playwright."
date: 2023-09-30T20:59:39+0100
tags:
- "blogumentation"
- "playwright"
- javascript
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: playwright-use-existing-session
---
If you're using [Playwright](https://playwright.dev/) for driving UI tests, you may want to use your browser with pre-configured user sessions.

By default, Playwright will start a fresh browser instance without your existing sessions, but that's not always ideal.

For instance, if we were running a Chromium-based browser with remote debugging enabled (for Chrome DevTools Protocol (CDP)):

```sh
chromium --remote-debugging-port 9222
```

We could then write the following code to connect to it, and re-use an existing page in the browser:

```javascript
const browser = await chromium.connectOverCDP('http://localhost:9222');

const defaultContext = browser.contexts()[0]
const page = defaultContext.pages()[0]

// then do whatever you'd like
await page.goto('https://twitter.com/settings/account');
```

Code adapted from [this Python example](https://medium.com/@robinclick/3-ways-of-attaching-to-existing-browsers-in-web-automation-4f3ce4e5161a).
