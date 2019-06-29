---
title: "Using Hugo `.Render` to Save Repetition"
description: "Replacing `if`s with `.Render` to save duplication in Hugo templates."
tags:
- blogumentation
- hugo
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-05-26T11:15:45+0100
slug: "hugo-render"
image: /img/vendor/hugo-logo.png
---
Up until recently, my Hugo site's templates were full of snippets like:

```go-html-template
{{- if eq .Type "posts" -}}
<meta name="twitter:label1" value="Reading time" />
{{ if eq 1 .ReadingTime }}
	<meta name="twitter:data1" value="{{ .ReadingTime }} min" />
{{ else }}
	<meta name="twitter:data1" value="{{ .ReadingTime }} mins" />
{{ end }}
{{ end }}
{{- if (eq .Type "events") -}}
	{{ if .Params.Start }}
	<meta name="twitter:label1" value="Start time" />
	<meta name="twitter:data1" value="{{ dateFormat "Mon, 02 Jan 2006 15:04:05 MST" .Params.Start }}" />
	{{ end }}
	{{ if .Params.Adr }}
	<meta name="twitter:label2" value="Address" />
	<meta name="twitter:data2" value="{{ .Params.adr.street_address }}, {{ .Params.adr.locality }}, {{ .Params.adr.postal_code }}" />
	{{ end }}
{{- end -}}
```

This wasn't really a very scalable solution, as each time I created a new content type, I'd need to add a new case statement.

But recently I learned about Hugo's [`.Render`](https://gohugo.io/functions/render/) functionality, which means I can update my templates to just call to `.Render`:

```diff
 		<meta name="twitter:card" content="summary" />
 		<meta name="twitter:title" content="{{ .Title }} &middot; {{ .Site.Title }}" />
 		<meta name="twitter:description" content="{{ $description }}" />
-
-		{{- if eq .Type "posts" -}}
-		<meta name="twitter:label1" value="Reading time" />
-		{{ if eq 1 .ReadingTime }}
-			<meta name="twitter:data1" value="{{ .ReadingTime }} min" />
-		{{ else }}
-			<meta name="twitter:data1" value="{{ .ReadingTime }} mins" />
-		{{ end }}
-		{{ end }}
-		{{- if (eq .Type "events") -}}
-			{{ if .Params.Start }}
-			<meta name="twitter:label1" value="Start time" />
-			<meta name="twitter:data1" value="{{ dateFormat "Mon, 02 Jan 2006 15:04:05 MST" .Params.Start }}" />
-			{{ end }}
-			{{ if .Params.Adr }}
-			<meta name="twitter:label2" value="Address" />
-			<meta name="twitter:data2" value="{{ .Params.adr.street_address }}, {{ .Params.adr.locality }}, {{ .Params.adr.postal_code }}" />
-			{{ end }}
-		{{- end -}}
 		<meta name="twitter:image" content="{{ $imageUrl }}" />
+		{{ .Render "sharing-card" }}
```

And then i.e. in `events/sharing-card.html`:

```go-html-template
{{ if .Params.Start }}
  <meta name="twitter:label1" value="Start time" />
  <meta name="twitter:data1" value="{{ dateFormat "Mon, 02 Jan 2006 15:04:05 MST" .Params.Start }}" />
{{ end }}
{{ if .Params.Adr }}
  <meta name="twitter:label2" value="Address" />
  <meta name="twitter:data2" value="{{ .Params.adr.street_address }}, {{ .Params.adr.locality }}, {{ .Params.adr.postal_code }}" />
{{ end }}
```

And in `posts/sharing-card.html`:

```go-html-template
<meta name="twitter:label1" value="Reading time" />
{{ if eq 1 .ReadingTime }}
  <meta name="twitter:data1" value="{{ .ReadingTime }} min" />
{{ else }}
  <meta name="twitter:data1" value="{{ .ReadingTime }} mins" />
{{ end }}
```

As well as that, you can set up a `_default/sharing-card.html`, which will be used if each content type doesn't override it.

EDIT: However, as found [the other day](https://gitlab.com/jamietanna/jvt.me/issues/514), this actually broke my RSS/JSON Feeds.

`.Render` looks up [Content Views](https://gohugo.io/templates/views) for the same output format that it's currently rendering. So when I set i.e. my RSS feed to `.Render "content"` it was actually looking up `content.xml`, which didn't exist, as it's `content.html`! The workaround I've now employed is to have a partial that stores the HTML rendering of the page, and can then be called from JSON Feed, HTML or RSS to save on duplication.

Fortunately this didn't break my [h-feed]({{< ref 2019-05-12-implementing-hfeed-making-content-discoverable >}}) - maybe we should be using these instead of JSON Feed/RSS, eh?
