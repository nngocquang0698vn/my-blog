{{ $blogroll := getJSON "https://blogroll.jvt.me/blogs/index.json" }}

<ul>
  {{ range $blogroll.data }}
  <li>
    <a href="{{ .url }}">{{ .url }}</a>
  </li>
  {{ end }}
</ul>
