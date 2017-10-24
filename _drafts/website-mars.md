---
3-22 mins (if at all) - Earth to Mars light
HTTP request ~44 mins return trip

deploy to `mars-west-1`?

how do you handle a massive latency?

no realtime comms

serverless? nope

radio waves for comms
or interplanetary internet (real word internet - networks)
built for high-latency, unstable networks
multi nodes
- store the data sent to it, then pass it on
- each node retries, rather than whole data load

service workers - proxy between `app -> browser`

remove noisiness
fewer API calls i.e. GraphQL
specify data we want, rather than many calls to get the same response

pouchdb, sync to client

background sync

web RTC - no server, P2P videochat

webtorent for sharing out videos via P2P - no need to have youtube when can be shared around

merkel tree for logs?

interplanetary file system (IPFS? Isn't that Internet Protocol FS)

we're not even building things that work on Earth
soon we need multi-planet
fix it!

can't "quick fix in prod" - eventual consistency




- offline first / sync via PouchDB
- GraphQL to reduce unnecessary API calls
- aside; how will SSL work? extra handshakes
- https://ipfs.io/
- Node-to-node to get to the

