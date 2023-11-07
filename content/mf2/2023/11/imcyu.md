{
  "date" : "2023-11-07T16:26:41.549313906Z",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "syndication" : [ "https://brid.gy/publish/twitter" ],
    "published" : [ "2023-11-07T16:26:41.549313906Z" ],
    "category" : [ "sqlite", "sql" ],
    "post-status" : [ "published" ],
    "content" : [ {
      "html" : "",
      "value" : "Anyone know a good place to ask <a href=\"/tags/sqlite/\"><a href=\"/tags/sql/\">#sql</a>ite</a> or <a href=\"/tags/sql/\">#sql</a> questions? \r\n\r\nI'm trying to convert rows (produced by a big query that then uses a `GROUP BY advisory_type`) that produces data like: \r\n\r\n```sql\r\n-- the `advisory_type` can be one of multiple values, i.e. SECURITY, DEPRECATED, UNSUPPORTED\r\nrepo    advisory_type  total_advisories\r\n------  -------------  ----------------\r\njvt.me  SECURITY       10               \r\njvt.me  DEPRECATED     5               \r\n```\r\n\r\nAnd I'm trying to convert this to:\r\n\r\n```sql\r\nrepo    total_security total_deprecated total_unmaintained\r\n------  -------------  ---------------- ----------------\r\njvt.me  10             5                0               \r\n```\r\n\r\nAny clue how I'd go about doing so? Happy to provide more details / some data for you to query too, but been playing around with it on and off and not really having any luck."
    } ]
  },
  "kind" : "notes",
  "slug" : "2023/11/imcyu",
  "tags" : [ "sqlite", "sql" ],
  "client_id" : "https://editor.tanna.dev/"
}
