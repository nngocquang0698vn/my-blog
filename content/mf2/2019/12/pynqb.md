{
  "kind" : "notes",
  "slug" : "2019/12/pynqb",
  "client_id" : "https://micropublish.net",
  "date" : "2019-12-03T00:40:56.344+01:00",
  "h" : "h-entry",
  "properties" : {
    "published" : [ "2019-12-03T00:40:56.344+01:00" ],
    "content" : [ {
      "html" : "",
      "value" : "So around ~1312 my server that hosts services such as https://meetup-mf2.jvt.me and https://eventbrite-mf2.jvt.me/ but also my Micropub endpoint and other things restarted. Not 100% sure why (as it turns out that the logs didn't persist) but turns out that my webserver ( https://caddyserver.com/ ) hadn't been configured to restart post-boot, but all the other services had. Woops! Glad I didn't have a tonne of content to push, but it was a bit worrying having no way to resolve it, as I had no laptop to SSH and diagnose."
    } ]
  }
}
