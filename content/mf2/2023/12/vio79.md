{
  "date" : "2023-12-21T10:24:05.31504724Z",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "syndication" : [ "https://brid.gy/publish/twitter" ],
    "published" : [ "2023-12-21T10:24:05.31504724Z" ],
    "category" : [ "git" ],
    "post-status" : [ "published" ],
    "content" : [ {
      "html" : "",
      "value" : "Something cool newer <a href=\"/tags/git/\">#git</a> versions are doing - you'll now see `Reapply` instead of `Revert Revert ...` in commit messages, if you're reverting a revert.\r\n\r\nIn an older version of Git (i.e. with 2.34.x) you would see:\r\n\r\n```\r\nRevert \"Revert \"Commit title here\"\"\r\nRevert \"Commit title here\"\r\nCommit title here\r\n```\r\n\r\nHowever, in newer versions (i.e. with 2.43.x) you now see:\r\n\r\n```\r\nReapply \"Commit title here\"\r\nRevert \"Commit title here\"\r\nCommit title here\r\n```\r\n\r\nWhich makes it a little bit cleaner in your Git log"
    } ]
  },
  "kind" : "notes",
  "slug" : "2023/12/vio79",
  "tags" : [ "git" ],
  "client_id" : "https://editor.tanna.dev/"
}
