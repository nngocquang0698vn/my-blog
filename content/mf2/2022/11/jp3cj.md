{
  "date" : "2022-11-15T13:15:31.681596611Z",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "syndication" : [ "https://brid.gy/publish/twitter" ],
    "published" : [ "2022-11-15T13:15:31.681596611Z" ],
    "category" : [ "javascript" ],
    "post-status" : [ "published" ],
    "content" : [ {
      "html" : "",
      "value" : "Fun JS bug of the day introduced by a linting change, that lost me a good amount of time trying to work out what was going wrong:\r\n\r\n```diff\r\n-  const tokenSet = await client.oauthCallback(redirect, params, { code_verifier });\r\n+  const tokenSet = await client.oauthCallback(redirect, params, { codeVerifier })\r\n```\r\n\r\nSilently changed the meaning of the code here, and needed to be fixed with:\r\n\r\n```diff\r\n-  const tokenSet = await client.oauthCallback(redirect, params, { codeVerifier }).catch((err) => {\r\n+  const tokenSet = await client.oauthCallback(redirect, params, { code_verifier: codeVerifier }).catch((err) => {\r\n```\r\n\r\nFunnily enough, I've had this lead to [dangerous logging](https://www.jvt.me/posts/2022/02/03/common-dangerous-logs/) in the past, but didn't spot this at first. That'll teach me!"
    } ]
  },
  "kind" : "notes",
  "slug" : "2022/11/jp3cj",
  "tags" : [ "javascript" ],
  "client_id" : "https://editor.tanna.dev/"
}
