---
title: "Creating a Zoho Mail alias using the API"
description: "How to use the Zoho Mail API to add an alias to your account."
date: 2023-08-30T14:23:21+0100
tags:
- "blogumentation"
- "zoho"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: zoho-mail-api-alias
---
I've been using [Zoho Mail](https://mail.zoho.eu) for some time, and really like the ability to set up aliases that allow me to send emails from an arbitrary email address on my domain, without setting up a new account.

If you wish to do this against your own account, you can do this through the Mail Admin UI, or alternatively, via the API.

To start off, we'll browse to the [Zoho API Console](https://api-console.zoho.com/), and create a "Self Client".

Once created, click onto the Self Client, and select the Generate Code.

Specify the scope `ZohoMail.organization.accounts.UPDATE` (not super clear [via](https://www.zoho.com/mail/help/api/)) and provide a description, click Create, and then download the result.

Retrieve an access token:

```sh
# assuming self_client.json is the downloaded file from the API Console
curl -i https://accounts.zoho.com/oauth/v2/token -d code="$(jq -r .code self_client.json)" -d grant_type=authorization_code -d redirect_uri=https://any.thing.example -d client_id="$(jq -r .client_id self_client.json)" -d client_secret="$(jq -r .client_secret self_client.json)"
```

This will return an OAuth2 access token and refresh token (pretty-printed for readability):

```json
{
  "access_token": "...",
  "api_domain": "https://www.zohoapis.com",
  "expires_in": 3600,
  "refresh_token": "...",
  "token_type": "Bearer"
}
```

Retrieve your Zoho User ID (ZUID), which can be found [in the Zoho Accounts page](https://accounts.zoho.com/home) if you click your profile picture in the top right.

Retrieve your Zoho Organisation ID (ZOID) from the [Zoho Mail Admin Organisation page](https://mailadmin.zoho.com/cpanel/home.do#organization/profile).

Finally, to add the alias:

```sh
export USER_ID=1...
export ORG_ID=1...
export ACCESS_TOKEN=100...
export ALIAS=new@email.domain
curl -i -X PUT -H "Authorization: Zoho-oauthtoken $ACCESS_TOKEN" https://mail.zoho.com/api/organization/$ORG_ID/accounts/$USER_ID -d '{
"zuid": "'$USER_ID'",
   "mode": "addEmailAlias",
   "emailAlias": [
      "'$ALIAS'"
   ]
}' -H 'content-type: application/json'
```
