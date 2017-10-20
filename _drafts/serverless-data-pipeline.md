---
So -> serverless -> dashboard
-> slack etc

i.e. static site -> serverless /contact endpoints
mostly doing nothing
get data from SO, if new, send notification + add to DB
microservices - i.e. nano service which is a single function / endpoint
- i.e. map a route (via API gateway) to a function
doesn't matter if it's ~1s until written to DB, as it's not realtime
prepare for cold startup
could most likely run on free tier

NoSQL document database (CloudAnt -> CouchDB)
- Cluster of Unreliable Commodity Hardware DB
schemaless
scalable
Erlang
HTTP API
JSON format
great replication

Apache openwhisk (IBM hosts this)
- own platform
- http://openwhisk.incubator.apache.org/

"use big words so people don't realise you're writing a function"
- trigger - event, ie incoming HTTP, tweet matched search term
- rule - what to do when it happens
- action - i.e. function to call, with parameters
- package - collect actions and parameters together
  - (grouped so you know what goes with what)
	- what if you want parameter(s) for all the functions to use
- sequence - more than one action in a row - i.e. piping/chaining

update === create if not exists
`--web true` i.e. gives it a URL to be used
useful i.e. webhooks, not when behind API gateway

OfflineFirst - client side JS, PouchDB
- then will sync when network appears
- can make changes as required

each function can be owned by a different team
each function can have its own modular, testable codebase
each function can also be a different language

data hygeine - don't make everything hit the DB
- can the function be given the data in params?

Hubot for fancy Slack integration

serverless as the next big thing to remove heavy dependencies and push them to little containers

https://lornajane.net
