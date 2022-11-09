---
title: "Creating a JSON Patch endpoint in Go"
description: "How to create a server-side JSON Patch API endpoint in Go."
date: 2022-11-09T15:39:14+0000
syndication:
- https://brid.gy/publish/twitter
tags:
- "blogumentation"
- "api"
- "json-patch"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "openapi-json-patch"
---
[JSON Patch](http://jsonpatch.com/) is a well-defined format for performing updates to HTTP objects, which allows you to avoid needing to design your own means for performing partial changes.

As I've been recently looking at setting up a Go API with JSON Patch, I wanted to explore options for making this more straightforward.

Fortunately, [evanphx/json-patch](https://github.com/evanphx/json-patch) makes it a breeze, allowing us to convert the request body into a JSON patch object, and then we can apply it to our object.

Inside our HTTP handler, we can

```go
func AccountsPatchHandler(w http.ResponseWriter, r *http.Request) {
	// ...

	body, err := io.ReadAll(r.Body)
	// handle err

	patch, err := jsonpatch.DecodePatch(body)
	// handle err

	// this would be retrieved by i.e. a Service or Repository tier object
	domainModel := Account{
		ID:    "1",
		Email: "example@example.com",
	}

	// then we map it into the type that's expected by our HTTP consumers
	current := AccountRepresenation{
		ID:    domainModel.ID,
		Email: domainModel.Email,
	}

	// marshal it to JSON, to be able to the patch
	currentBytes, err := json.Marshal(current)
	// handle err

	modifiedBytes, err := patch.Apply(currentBytes)
	if err != nil {
		w.Write([]byte(err.Error()))
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	var modified AccountRepresenation
	err = json.Unmarshal(modifiedBytes, &modified)
	// handle err

	// perform business logic checks
	if modified.ID != current.ID {
		w.WriteHeader(http.StatusUnprocessableEntity)
		w.Write([]byte("The ID field cannot be modified"))
		return
	}

	// we'd then usually persist the data here
	// but in this example, we don't have a way to

	// and we need to make sure that when returning the re-marshalled model, as if we return `modifiedBytes`, we could end up with unsupported fields being returned
	outBytes, err := json.Marshal(modified)
	_, _ = w.Write(outBytes)
```

This makes it quite convenient to be able to perform the patch, meaning we simply need to handle any business logic around the updates, and converting between data types.

The full code can be found in [a repo on GitLab](https://gitlab.com/tanna.dev/go-jsonpatch-http).
