{
  "date" : "2023-05-12T08:01:05.633641086Z",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "in-reply-to" : [ "https://social.lol/@carol/110351344212554584" ],
    "published" : [ "2023-05-12T08:01:05.633641086Z" ],
    "post-status" : [ "published" ],
    "content" : [ {
      "html" : "",
      "value" : "I've got [a Hugo site](https://gitlab.com/tanna.dev/jvt.me) that uses IndieWeb technologies (Micropub, Microformats, Webmention) to also interoperate with the Fediverse and Mastodon.\r\n\r\nMy site publishes an average of 50 commits a day, most of which are done using Micropub (using a custom built Micropub server).\r\n\r\nThen I use [Bridgy Fed](https://fed.brid.gy) to do the IndieWeb-to-Mastodon connectivity, sending it a webmention when I post a new thing, and it then syndicates it to my followers in the Fediverse. Bridgy Fed's rendering of content isn't maybe as flexible as you would want - I believe it's set to only syndicate specific things, but that may be something we can improve and/or make configurable!\r\n\r\nYou could use Netlify functions for your Micropub endpoint - I know a few folks have done that before (including @carol.gg)!\r\n\r\nOne thing to be cautious of is as you're starting to publish more content, [avoiding spamming folks with Webmentions](https://www.jvt.me/posts/2019/10/30/reader-mail-webmention-spam/).\r\n\r\nFor the PESOS items, I've been [doing it with my step counts](https://www.jvt.me/posts/2019/10/27/owning-step-count/), and similar could probably be done on Netlify with a scheduled function to grab the latest entries and publish them to your site."
    } ]
  },
  "kind" : "replies",
  "slug" : "2023/05/v8ued",
  "client_id" : "https://editor.tanna.dev/"
}
