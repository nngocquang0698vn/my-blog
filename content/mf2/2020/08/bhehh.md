{
  "date" : "2020-08-16T17:13:00+01:00",
  "deleted" : false,
  "h" : "h-entry",
  "properties" : {
    "in-reply-to" : [ "https://github.com/indieweb/micropub-extensions/issues/17#issuecomment-674544268" ],
    "syndication" : [ "https://github.com/indieweb/micropub-extensions/issues/17#issuecomment-674546380" ],
    "name" : [ "Reply to https://github.com/indieweb/micropub-extensions/issues/17#issuecomment-674544268" ],
    "published" : [ "2020-08-16T17:13:00+01:00" ],
    "category" : [ ],
    "content" : [ {
      "html" : "",
      "value" : "Would that be needed? Generally with OAuth2 a 401 would indicate there is _some_ issue with the token and to either refresh a refresh token (if one was issued) or to request the user re-authorise the application.\n\nUnless we're recommending the use of a refresh token, I'm not sure if we'd need clients to keep an eye on the `expires_in` from the initial issue, or calls to introspect on the token endpoint"
    } ]
  },
  "kind" : "replies",
  "slug" : "2020/08/bhehh",
  "tags" : [ ],
  "client_id" : "https://indigenous.realize.be"
}
