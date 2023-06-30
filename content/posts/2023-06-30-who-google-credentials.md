---
title: "Who do these Google (JSON file) credentials belong to?"
description: "Given a JSON credentials file for Google APIs, are they still valid?"
date: 2023-06-30T17:12:22+0100
tags:
- blogumentation
- google
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: who-google-credentials
---
Earlier today I spotted in my downloads folder a JSON file that looks suspiciously like a set of credentials for a Google service account:

```json
{
  "type": "service_account",
  "project_id": "...",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIE...",
  "client_email": "...",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://accounts.google.com/o/oauth2/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "..."
}
```

I wondered whether they were still active, so hacked together this little Go script:

```go
package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"os"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

func main() {
	ctx := context.Background()
	data, err := os.ReadFile("creds.json")
	if err != nil {
		log.Fatal(err)
	}
	creds, err := google.CredentialsFromJSON(ctx, data, "openid")
	if err != nil {
		log.Fatal(err)
	}

	client := oauth2.NewClient(ctx, creds.TokenSource)
	if client == nil {
		log.Fatal("Couldn't construct an oauth2.NewClient")
	}

	resp, err := client.Get("https://www.googleapis.com/oauth2/v3/tokeninfo")
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Successfully authenticated with credentials: \n%s", body)
}
```

This allows us to authenticate as the service account, and if the credentials are still valid, we'll see a response from Google to show the issued token's claims.
