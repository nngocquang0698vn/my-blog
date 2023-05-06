{
  "date" : "2023-05-06T08:52:00+0100",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "syndication" : [ "https://brid.gy/publish/twitter" ],
    "published" : [ "2023-05-06T08:52:00+0100" ],
    "category" : [ "awslambda" ],
    "post-status" : [ "published" ],
    "content" : [ {
      "html" : "",
      "value" : "Had anyone ever seen an error like this with <a href=\"/tags/awslambda/\">#AWSLambda</a>? \n\nIt's a Node 18 app that calls out to [Renovate](https://docs.renovatebot.com) but fails due to some deep intenals in Node when doing some performance checking? \n\n\n```json \t\n{\n    \"errorType\": \"TypeError\",\n    \"errorMessage\": \"performance.markResourceTiming is not a function\",\n    \"stack\": [\n        \"TypeError: performance.markResourceTiming is not a function\",\n        \"    at markResourceTiming (node:internal/deps/undici/undici:10636:21)\",\n        \"    at finalizeAndReportTiming (node:internal/deps/undici/undici:10632:7)\",\n        \"    at Object.handleFetchDone [as processResponseEndOfBody] (node:internal/deps/undici/undici:10579:45)\",\n        \"    at node:internal/deps/undici/undici:10895:44\",\n        \"    at node:internal/process/task_queues:140:7\",\n        \"    at AsyncResource.runInAsyncScope (node:async_hooks:204:9)\",\n        \"    at AsyncResource.runMicrotask (node:internal/process/task_queues:137:8)\",\n        \"    at process.processTicksAndRejections (node:internal/process/task_queues:95:5)\"\n    ]\n}\n```\n\nVery odd, and [this Go issue](https://github.com/golang/go/issues/57516) is the only thing I could find that may relate 🤔"
    } ]
  },
  "kind" : "notes",
  "slug" : "2023/05/98kew",
  "tags" : [ "awslambda" ],
  "client_id" : "https://indiepass.marksuth.dev/"
}
