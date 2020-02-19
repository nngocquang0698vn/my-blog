{
  "kind" : "replies",
  "slug" : "2020/02/limhe",
  "client_id" : "https://indigenous.realize.be",
  "date" : "2020-02-19T08:37:00Z",
  "h" : "h-entry",
  "properties" : {
    "name" : [ "Reply to https://github.com/aaronpk/IndieAuth.com/issues" ],
    "in-reply-to" : [ "https://github.com/aaronpk/IndieAuth.com/issues" ],
    "published" : [ "2020-02-19T08:37:00Z" ],
    "content" : [ {
      "html" : "",
      "value" : "Currently, the format of the tokens provided by IndieAuth.com is a signed JWT (JWS) using HS256.\n\nIf we were to update this to be RS256, we could allow clients to treat it as a JWS, not an opaque token that needs to be introspected by the token endpoint.\n\nThis could allow clients validating tokens as such to do so much more easily, locally, while reducing load on the token endpoint.\n\nBecause token revocation is not widespread at this point, it would enable clients to not need to introspect unnecessarily."
    } ]
  }
}
