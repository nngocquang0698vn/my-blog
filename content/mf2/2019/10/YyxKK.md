{
  "kind" : "notes",
  "slug" : "2019/10/YyxKK",
  "client_id" : "https://indigenous.realize.be",
  "date" : "2019-10-25T22:50:00+01:00",
  "h" : "h-entry",
  "properties" : {
    "published" : [ "2019-10-25T22:50:00+01:00" ],
    "category" : [ "micropub" ],
    "content" : [ {
      "html" : "",
      "value" : "Woo, thanks to https://realize.be/ for releasing an update of the wonderful Android app https://indigenous.realize.be/ which adds in a fix to not send multiple bearer tokens in Micropub requests ( https://github.com/swentel/indigenous-android/issues/241 )\n\nThis started breaking for me when I upgraded my Micropub endpoint to use the spring-oauth2-resource-server module ( https://gitlab.com/jamietanna/www-api/merge_requests/27 ) which is a well-formed OAuth2 server, whereas my previous implementation was not.\n\nSuper speedy fix, and glad to be back to using the app again! "
    } ]
  },
  "tags" : [ "micropub" ]
}
