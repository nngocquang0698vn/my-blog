---
title: "JWKS-iCal Release v1.1.0: Adding Calendar Reminder"
description: "Updating jwks-ical to add support for calendar reminders before the certificate's expiry."
tags:
- jwks
- certificates
- jwks-ical
- calendar
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-16T11:42:08+0100
slug: "jwks-ical-calendar-reminder"
---
Since releasing [_Keeping Track of Certificate Expiry with a JWKS to iCalendar Converter_](/posts/2020/06/14/track-certificate-expiry-jwks-ical/), I've been using it a fair bit for some certs I manage.

However, something I wish was possible would be to informed, ahead of the date, something is expiring, because these require manual intervention to update them.

Therefore, I decided to add calendar reminders to the generated iCalendar feed. With version v1.1.0, which I have just released, you will now receive calendar reminders:

- on the day
- on the day before
- one week before

That being said, it may not quite work with your calendar app of choice. As per [this thread on the Google support forums](https://support.google.com/calendar/thread/9627602?hl=en), it appears to be a common issue with Google Calendar, I'm not sure if there's any solution - so this release may not be helpful, sorry!
