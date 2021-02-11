{
  "date" : "2021-02-11T20:37:53.076Z",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "in-reply-to" : [ "https://github.com/indieweb/micropub-extensions/issues/24" ],
    "syndication" : [ "https://github.com/indieweb/micropub-extensions/issues/24#issuecomment-777775152" ],
    "name" : [ "Reply to https://github.com/indieweb/micropub-extensions/issues/24" ],
    "published" : [ "2021-02-11T20:37:53.076Z" ],
    "category" : [ "micropub", "www.jvt.me" ],
    "content" : [ {
      "html" : "",
      "value" : "I've also implemented this in my Micropub server:\r\n\r\n- when creating a post, and the `draft` scope is present, the `post-status` is forced to `draft` (even if it's set otherwise in the post)\r\n- when updating a post, and the `draft` scope is present, the update is only allowed when updating a `draft` post, otherwise returns `insufficient_scope`\r\n- delete/undelete returns `insufficient_scope` when the `draft` scope is present"
    } ]
  },
  "kind" : "replies",
  "slug" : "2021/02/sswpb",
  "tags" : [ "micropub", "www.jvt.me" ],
  "client_id" : "https://www-editor.jvt.me"
}
