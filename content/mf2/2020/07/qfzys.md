{
  "date" : "2020-07-07T19:45:00+01:00",
  "deleted" : false,
  "h" : "h-entry",
  "properties" : {
    "syndication" : [ "https://brid.gy/publish/twitter" ],
    "name" : [ "Like of @mjg59's tweet" ],
    "published" : [ "2020-07-07T19:45:00+01:00" ],
    "category" : [ "security" ],
    "like-of" : [ "https://twitter.com/mjg59/status/1280425441455517698" ]
  },
  "kind" : "likes",
  "slug" : "2020/07/qfzys",
  "context" : {
    "type" : [ "h-entry" ],
    "properties" : {
      "uid" : [ "tag:twitter.com:1280425441455517698" ],
      "url" : [ "https://twitter.com/mjg59/status/1280425441455517698" ],
      "published" : [ "2020-07-07T08:56:29+00:00" ],
      "author" : [ {
        "type" : [ "h-card" ],
        "properties" : {
          "uid" : [ "tag:twitter.com:mjg59" ],
          "numeric-id" : [ "229502009" ],
          "name" : [ "Matthew Garrett" ],
          "nickname" : [ "mjg59" ],
          "url" : [ "https://twitter.com/mjg59", "http://mjg59.dreamwidth.org" ],
          "published" : [ "2010-12-22T15:28:52+00:00" ],
          "location" : [ {
            "type" : [ "h-card", "p-location" ],
            "properties" : {
              "name" : [ "Oakland, CA" ]
            }
          } ],
          "photo" : [ "https://pbs.twimg.com/profile_images/459378005689630720/4f7Dml5q.png" ]
        }
      } ],
      "content" : [ {
        "value" : "private byte[] generatePrivateKey() {\n    byte[] bArr = new byte[32];\n    Sodium.randombytes(bArr, bArr.length);\n    Util.logByteArray(bArr);\n    return bArr;\n}\n\nARE YOU FUCKING SHITTING ME",
        "html" : "<div style=\"white-space: pre\">private byte[] generatePrivateKey() {\n    byte[] bArr = new byte[32];\n    Sodium.randombytes(bArr, bArr.length);\n    Util.logByteArray(bArr);\n    return bArr;\n}\n\nARE YOU FUCKING SHITTING ME</div>"
      } ]
    }
  },
  "tags" : [ "security" ],
  "client_id" : "https://indigenous.realize.be"
}
