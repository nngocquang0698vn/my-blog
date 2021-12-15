{
  "date" : "2021-12-15T17:12:14.479695723Z",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "in-reply-to" : [ "https://stackoverflow.com/questions/64541192/assertthatthrownby-check-field-on-custom-exception" ],
    "syndication" : [ "https://stackoverflow.com/a/70367676/2257038" ],
    "name" : [ "Reply to https://stackoverflow.com/questions/64541192/assertthatthrownby-check-field-on-custom-exception" ],
    "published" : [ "2021-12-15T17:12:14.479695723Z" ],
    "category" : [ "java", "assertj" ],
    "post-status" : [ "published" ],
    "content" : [ {
      "html" : "",
      "value" : "It looks like you're looking for `catchThrowableOfType`, which allows you to receive the correct class:\r\n\r\n```java\r\nimport static org.assertj.core.api.Assertions.catchThrowableOfType;\r\n\r\nSomeException throwable = catchThrowableOfType(() -> service.doSomething(), SomeException.class);\r\n\r\nassertThat(throwable.getSomething()).isNotNull();\r\n```"
    } ]
  },
  "kind" : "replies",
  "slug" : "2021/12/gkmmt",
  "tags" : [ "java", "assertj" ],
  "client_id" : "https://www-editor.jvt.me"
}
