{
  "date" : "2023-06-11T08:20:17.418582779Z",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "published" : [ "2023-06-11T08:20:17.418582779Z" ],
    "category" : [ "sql" ],
    "like-of" : [ "https://stackoverflow.com/a/24227755" ],
    "post-status" : [ "published" ],
    "content" : [ {
      "html" : "",
      "value" : "I ended up using this for instance:\r\n\r\n```sql\r\nselect\r\n  distinct renovate.repo,\r\n  owner\r\nfrom\r\n  renovate\r\n  left join owners on renovate.platform = owners.platform\r\n  and renovate.organisation = owners.organisation\r\n  and renovate.repo = owners.repo\r\n```"
    } ]
  },
  "kind" : "likes",
  "slug" : "2023/06/snx0o",
  "tags" : [ "sql" ],
  "client_id" : "https://editor.tanna.dev/"
}
