---
title: "Retrofitting OpenAPI documentation to your Rails codebase"
description: "How to take a Rails codebase and introduce OpenAPI documentation and\
  \ contract tests, in a test-driven manner."
date: "2022-10-20T14:52:38+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1583097120675856384"
tags:
- "blogumentation"
- "ruby"
- "rails"
- "rspec"
- "openapi"
- "testing"
- "contract-testing"
- "tdd"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/7be186e7a3.png"
slug: "rails-openapi-contract-test-retrofit"
---
As written about in [_Setting up OpenAPI Contract Tests with a Rails and RSpec codebase_](https://www.jvt.me/posts/2022/06/07/rails-rspec-openapi-contract-test/), I've recently been working on some Rails codebases that, like everything in life, could do with some OpenAPI documentation.

<span class="h-card"><a class="u-url" href="https://nicolasiensen.github.io">Nícolas Iensen</a></span>'s post [_Validating requests and responses using OpenAPI specification with Committee_](https://nicolasiensen.github.io/2022-04-18-validating-requests-and-responses-using-openapi-specification-with-committee/) post is a great step-by-step of how to do this, but as someone who likes to have their tests lead me to a solution, I wanted to document how I've been TDD'ing OpenAPI into an existing codebase.

We'll be using [the committee gem](https://github.com/interagent/committee), which I've since found isn't quite as good as [the Go libraries we can use](https://www.jvt.me/posts/2022/05/22/go-openapi-contract-test/), so we need to do a little bit more thinking in terms of what needs to be added to our tests.

This article is based on example code [on GitLab](https://gitlab.com/tanna.dev/jvt.me-rails-openapi-contract-test-retrofit), which follows the basis of Nícolas' post above.

# Healthcheck endpoint

We'll start with a straightforward endpoint, which provides a healthcheck, and an unnecessary response body:

```ruby
class HealthController < ApplicationController
  def index
    render json: {
      status: :ok
    }
  end
end
```

With it, we have some basic tests that can validate the endpoint works as expected:

```ruby
require 'rails_helper'

RSpec.describe HealthController, type: :request do
  describe 'GET /health' do
    it 'returns 200 OK' do
      get health_index_url

      expect(response).to have_http_status(:ok)
    end

    it 'returns response body' do
      expected = {
        status: :ok
      }

      get health_index_url

      expect(response.media_type).to eq('application/json')
      expect(response.body).to eq(expected.to_json)
    end
  end
end
```

As mentioned above, we want to use a test-driven development approach to this, so we need to introduce a failing test for us to then fix. We want to write the minimal OpenAPI that is possible to start getting failing tests, which highlight that we need to fill in more information for our specification.

If we add the following minimal endpoint declaration, we'll notice that our tests still pass:

```diff
 openapi: '3.0.2'
 info:
   title: Cities API
   version: '1.0'
 paths:
+  /health: {}
```

To get this working, we need to write the following OpenAPI snippet:

```diff
 openapi: '3.0.2'
 info:
   title: Cities API
   version: '1.0'
 paths:
+  /health:
+    get:
+      summary: Check the service is healthy
+      responses:
+        '200':
+          description: OK
+          content:
+            application/json:
+              schema:
+                type: object
+                additionalProperties: false
```

Notice our use of `additionalProperties` in conjunction with this being an `object`, to force any data in the response body to trigger a test failure, like so:

```
Failures:

  1) HealthController GET /health returns 200 OK
     Failure/Error: get health_index_url

     Committee::InvalidResponse:
       #/paths/~1health/get/responses/200/content/application~1json/schema does not define properties: status
     # ./spec/requests/health_spec.rb:12:in `block (3 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/paths/~1health/get/responses/200/content/application~1json/schema does not define properties: status
     #   ./spec/requests/health_spec.rb:12:in `block (3 levels) in <top (required)>'

  2) HealthController GET /health returns response body
     Failure/Error: get health_index_url

     Committee::InvalidResponse:
       #/paths/~1health/get/responses/200/content/application~1json/schema does not define properties: status
     # ./spec/requests/health_spec.rb:22:in `block (3 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/paths/~1health/get/responses/200/content/application~1json/schema does not define properties: status
     #   ./spec/requests/health_spec.rb:22:in `block (3 levels) in <top (required)>'

Finished in 0.07709 seconds (files took 1.05 seconds to load)
2 examples, 2 failures

Failed examples:

rspec ./spec/requests/health_spec.rb:11 # HealthController GET /health returns 200 OK
rspec ./spec/requests/health_spec.rb:17 # HealthController GET /health returns response body
```

With this in place, we can then write the following OpenAPI specification:

```yaml
# ...
paths:
  /health:
    get:
      summary: Check the service is healthy
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                type: object
                additionalProperties: false
                properties:
                  status:
                    type: string
                    enum:
                      - ok
                required:
                  - status
```

I'd also recommend converting this to a reference, so code generators can generate types from it, as well as generally cleaning up the format of the file:

```diff
# ...
 paths:
   /health:
     get:
       summary: Check the service is healthy
       responses:
         '200':
           description: OK
           content:
             application/json:
               schema:
-               type: object
-               additionalProperties: false
-               properties:
-                 status:
-                   type: string
-                   enum:
-                     - ok
-               required:
-                 - status
+                $ref: '#/components/schemas/Healthcheck'
+components:
+  schemas:
+    Healthcheck:
+      type: object
+      additionalProperties: false
+      properties:
+        status:
+          type: string
+          enum:
+            - ok
+      required:
+        - status
```

# Cities

Now we've done a more straightforward endpoint, let's do something a little more complicated, and start filling in the details for our `CitiesController`:

```ruby
class CitiesController < ApplicationController
  before_action :set_city, only: %i[ show update destroy ]

  # GET /cities
  def index
    @cities = City.all

    render json: @cities
  end

  # GET /cities/1
  def show
    render json: @city
  end

  # POST /cities
  def create
    @city = City.new(city_params)

    if @city.save
      render json: @city, status: :created, location: @city
    else
      render json: @city.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def city_params
      params.require(:city).permit(:name, :latitude, :longitude, :demonym, :website)
    end
end
```

## `GET /cities`

For the bulk GET endpoint, the minimum changes needed to cause a failing test are to, again introduce a restrictive response body:

```diff
             application/json:
               schema:
                 $ref: '#/components/schemas/Healthcheck'
+  /cities:
+    get:
+      summary: List all cities
+      responses:
+        '200':
+          description: OK
+          content:
+            application/json:
+              schema:
+                $ref: '#/components/schemas/City'
 components:
   schemas:
     Healthcheck:
       type: object
       additionalProperties: false
       properties:
         status:
           type: string
           enum:
             - ok
       required:
         - status
+    City:
+      type: object
+      additionalProperties: false
```

This shows that actually we're returning an array, which I didn't expect, so it's another sign that doing this test-driven is good:

```
     Committee::InvalidResponse:
       #/components/schemas/City expected object, but received Array: [{"id"=>1, "name"=>"London", "latitude"=>51.50722, "longitude"=>-0.1275, "demonym"=>"Londoners", "website"=>"https://www.london.gov.uk/", "created_at"=>"2022-10-20T10:55:48.302Z", "updated_at"=>"2022-10-20T10:55:48.302Z"}]
```

So we need to make the following change to our OpenAPI:

```diff
  /cities:
    get:
      summary: List all cities
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
-               type: object
-               $ref: '#/components/schemas/City'
+               type: array
+               items:
+                 $ref: '#/components/schemas/City'
```

This leads to the following error:

```
Failures:

  1) /cities GET /index renders a successful response
     Failure/Error: get cities_url, headers: valid_headers, as: :json

     Committee::InvalidResponse:
       #/components/schemas/City/items does not define properties: id, name, latitude, longitude, demonym, website, created_at, updated_at
     # ./spec/requests/cities_spec.rb:50:in `block (3 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/components/schemas/City/items does not define properties: id, name, latitude, longitude, demonym, website, created_at, updated_at
     #   ./spec/requests/cities_spec.rb:50:in `block (3 levels) in <top (required)>'

Finished in 0.10126 seconds (files took 0.91961 seconds to load)
14 examples, 1 failure

Failed examples:

rspec ./spec/requests/cities_spec.rb:48 # /cities GET /index renders a successful response
```

And at this point we can now start to implement the response body. We can start with the first field - `id`:

```diff
     City:
       type: array
       items:
         type: object
         additionalProperties: false
         properties:
+         id: {}
```

Doing this one-by-one allows our test to pass:

```diff
     City:
       type: object
       additionalProperties: false
       properties:
         id: {}
+        name: {}
+        latitude: {}
+        longitude: {}
+        demonym: {}
+        website: {}
+        created_at: {}
+        updated_at: {}
```

However, that's not right, is it? This isn't super helpful, and also it doesn't denote which of these are required.

Unfortunately, we can't make this test-driven, so we just have to make the changes ourselves, and at this point I'd recommend extracting some of these out, so we end up with the following:

```yaml
# ...
  /cities:
    get:
      summary: List all cities
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/City'
components:
  schemas:
    # ...
    City:
      type: object
      additionalProperties: false
      properties:
        id:
          type: int
        name:
          type: string
        latitude:
          $ref: '#/components/schemas/Latitude'
        longitude:
          $ref: '#/components/schemas/Longitude'
        demonym:
          $ref: '#/components/schemas/Demonym'
        website:
          $ref: '#/components/schemas/Website'
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time
      required:
      - id
      - name
      - latitude
      - longitude
      - demonym
      - website
      - created_at
      - updated_at
    Latitude:
      type: number
      format: float
    Longitude:
      type: number
      format: float
    Demonym:
      type: string
    Website:
      type: string
      format: url
```

## `POST /cities`

As with above, we need to introduce a failing test, but we'll start with defining the request body:

```diff
+    post:
+      summary: Create a new city
+      requestBody:
+        content:
+          application/json:
+            schema:
+              type: object
+              additionalProperties: false
```

This then gives us the following failing tests:

```
Failures:

  1) /cities POST /create with valid parameters creates a new City
     Failure/Error:
       post cities_url,
            params: { city: valid_attributes }, headers: valid_headers, as: :json

     Committee::InvalidRequest:
       #/paths/~1cities/post/requestBody/content/application~1json/schema does not define properties: city
     # ./spec/requests/cities_spec.rb:67:in `block (5 levels) in <top (required)>'
     # ./spec/requests/cities_spec.rb:66:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/paths/~1cities/post/requestBody/content/application~1json/schema does not define properties: city
     #   ./spec/requests/cities_spec.rb:67:in `block (5 levels) in <top (required)>'

  2) /cities POST /create with valid parameters renders a JSON response with the new city
     Failure/Error:
       post cities_url,
            params: { city: valid_attributes }, headers: valid_headers, as: :json

     Committee::InvalidRequest:
       #/paths/~1cities/post/requestBody/content/application~1json/schema does not define properties: city
     # ./spec/requests/cities_spec.rb:73:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/paths/~1cities/post/requestBody/content/application~1json/schema does not define properties: city
     #   ./spec/requests/cities_spec.rb:73:in `block (4 levels) in <top (required)>'

  3) /cities POST /create with invalid parameters does not create a new City
     Failure/Error:
       post cities_url,
            params: { city: invalid_attributes }, as: :json

     Committee::InvalidRequest:
       #/paths/~1cities/post/requestBody/content/application~1json/schema does not define properties: city
     # ./spec/requests/cities_spec.rb:83:in `block (5 levels) in <top (required)>'
     # ./spec/requests/cities_spec.rb:82:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/paths/~1cities/post/requestBody/content/application~1json/schema does not define properties: city
     #   ./spec/requests/cities_spec.rb:83:in `block (5 levels) in <top (required)>'

  4) /cities POST /create with invalid parameters renders a JSON response with errors for the new city
     Failure/Error:
       post cities_url,
            params: { city: invalid_attributes }, headers: valid_headers, as: :json

     Committee::InvalidRequest:
       #/paths/~1cities/post/requestBody/content/application~1json/schema does not define properties: city
     # ./spec/requests/cities_spec.rb:89:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/paths/~1cities/post/requestBody/content/application~1json/schema does not define properties: city
     #   ./spec/requests/cities_spec.rb:89:in `block (4 levels) in <top (required)>'

Finished in 0.059 seconds (files took 0.84207 seconds to load)
14 examples, 4 failures

Failed examples:

rspec ./spec/requests/cities_spec.rb:65 # /cities POST /create with valid parameters creates a new City
rspec ./spec/requests/cities_spec.rb:72 # /cities POST /create with valid parameters renders a JSON response with the new city
rspec ./spec/requests/cities_spec.rb:81 # /cities POST /create with invalid parameters does not create a new City
rspec ./spec/requests/cities_spec.rb:88 # /cities POST /create with invalid parameters renders a JSON response with errors for the new city
```

We can convert this to a separate schema for the request body:

```diff
       requestBody:
         content:
           application/json:
             schema:
-              type: object
-              additionalProperties: false
+              $ref: '#/components/schemas/CreateCity'
 # ...
 components:
   schemas:
+    CreateCity:
+      type: object
+      additionalProperties: false
```

And then fill out the body:

```diff
 components:
   schemas:
     CreateCity:
       type: object
       additionalProperties: false
+     properties:
+       city:
+         type: object
+         additionalProperties: false
+     required:
+       - city
```

This then gives us a similar error to the one that we had at the creation of the `City` object:


```
Failures:

  1) /cities POST /create with valid parameters creates a new City
     Failure/Error:
       post cities_url,
            params: { city: valid_attributes }, headers: valid_headers, as: :json

     Committee::InvalidRequest:
       #/components/schemas/CreateCity/properties/city does not define properties: name, latitude, longitude, demonym, website
     # ./spec/requests/cities_spec.rb:67:in `block (5 levels) in <top (required)>'
     # ./spec/requests/cities_spec.rb:66:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/components/schemas/CreateCity/properties/city does not define properties: name, latitude, longitude, demonym, website
     #   ./spec/requests/cities_spec.rb:67:in `block (5 levels) in <top (required)>'
```

As the request we're sending doesn't include computed fields like `id`, `created_at` and `updated_at`, we can't re-use it. Fortunately we can re-use our shared definitions that we created as part of defining `City`, which results in the following:

```diff
 components:
   schemas:
     CreateCity:
       type: object
       additionalProperties: false
      properties:
        city:
          type: object
          additionalProperties: false
+          properties:
+            name:
+              type: string
+            latitude:
+              $ref: '#/components/schemas/Latitude'
+            longitude:
+              $ref: '#/components/schemas/Longitude'
+            demonym:
+              $ref: '#/components/schemas/Demonym'
+            website:
+              $ref: '#/components/schemas/Website'
+          required:
+          - name
+          - latitude
+          - longitude
+          - demonym
+          - website
      required:
        - city
```

This now gives us our valid request body, and passing tests! We can then introduce a failing test for the response body:

```diff
     post:
       summary: Create a new city
       requestBody:
         content:
           application/json:
             schema:
               $ref: '#/components/schemas/CreateCity'
+      responses:
+        '201':
+          description: OK
+          content:
+            application/json:
+              schema:
+                type: object
+                additionalProperties: false
```

This gives us our failing tests:

```
Failures:

  1) /cities POST /create with valid parameters creates a new City
     Failure/Error:
       post cities_url,
            params: { city: valid_attributes }, headers: valid_headers, as: :json

     Committee::InvalidResponse:
       #/paths/~1cities/post/responses/201/content/application~1json/schema expected string, but received Hash: {"id"=>1, "name"=>"London", "latitude"=>51.50722, "longitude"=>-0.1275, "demonym"=>"Londoners", "website"=>"https://www.london.gov.uk/", "created_at"=>"2022-10-20T12:43:50.449Z", "updated_at"=>"2022-10-20T12:43:50.449Z"}
     # ./spec/requests/cities_spec.rb:67:in `block (5 levels) in <top (required)>'
     # ./spec/requests/cities_spec.rb:66:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::ValidateError:
     #   #/paths/~1cities/post/responses/201/content/application~1json/schema expected string, but received Hash: {"id"=>1, "name"=>"London", "latitude"=>51.50722, "longitude"=>-0.1275, "demonym"=>"Londoners", "website"=>"https://www.london.gov.uk/", "created_at"=>"2022-10-20T12:43:50.449Z", "updated_at"=>"2022-10-20T12:43:50.449Z"}
     #   ./spec/requests/cities_spec.rb:67:in `block (5 levels) in <top (required)>'

  2) /cities POST /create with valid parameters renders a JSON response with the new city
     Failure/Error:
       post cities_url,
            params: { city: valid_attributes }, headers: valid_headers, as: :json

     Committee::InvalidResponse:
       #/paths/~1cities/post/responses/201/content/application~1json/schema expected string, but received Hash: {"id"=>1, "name"=>"London", "latitude"=>51.50722, "longitude"=>-0.1275, "demonym"=>"Londoners", "website"=>"https://www.london.gov.uk/", "created_at"=>"2022-10-20T12:43:50.452Z", "updated_at"=>"2022-10-20T12:43:50.452Z"}
     # ./spec/requests/cities_spec.rb:73:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::ValidateError:
     #   #/paths/~1cities/post/responses/201/content/application~1json/schema expected string, but received Hash: {"id"=>1, "name"=>"London", "latitude"=>51.50722, "longitude"=>-0.1275, "demonym"=>"Londoners", "website"=>"https://www.london.gov.uk/", "created_at"=>"2022-10-20T12:43:50.452Z", "updated_at"=>"2022-10-20T12:43:50.452Z"}
     #   ./spec/requests/cities_spec.rb:73:in `block (4 levels) in <top (required)>'

Finished in 0.08521 seconds (files took 0.90242 seconds to load)
14 examples, 2 failures

Failed examples:

rspec ./spec/requests/cities_spec.rb:65 # /cities POST /create with valid parameters creates a new City
rspec ./spec/requests/cities_spec.rb:72 # /cities POST /create with valid parameters renders a JSON response with the new city
```

As this looks like a `City` object, we can give that a go:

```diff
               schema:
-                type: object
-                additionalProperties: false
+                $ref: '#/components/schemas/City'
```

Which then passes our tests, and we've finished another endpoint.

## `GET /cities/{id}`

Finally, for the get-by-ID endpoint, we can expect the response body:

```diff
+  /cities/{id}:
+    get:
+      summary: List a given city
+      responses:
+        '200':
+          description: OK
+          content:
+            application/json:
+              schema:
+                additionalProperties: false
+                type: object
```

This leads to the following failing test:

```

Failures:

  1) /cities GET /show renders a successful response
     Failure/Error: get city_url(city), as: :json

     Committee::InvalidResponse:
       #/paths/~1cities~1{id}/get/responses/200/content/application~1json/schema does not define properties: id, name, latitude, longitude, demonym, website, created_at, updated_at
     # ./spec/requests/cities_spec.rb:58:in `block (3 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # OpenAPIParser::NotExistPropertyDefinition:
     #   #/paths/~1cities~1{id}/get/responses/200/content/application~1json/schema does not define properties: id, name, latitude, longitude, demonym, website, created_at, updated_at
     #   ./spec/requests/cities_spec.rb:58:in `block (3 levels) in <top (required)>'

Finished in 0.06922 seconds (files took 0.87772 seconds to load)
```

We can implement this with the following:

```diff
   /cities/{id}:
     get:
       summary: List a given city
       responses:
         '200':
           description: OK
           content:
             application/json:
               schema:
-                additionalProperties: false
-                type: object
+                $ref: '#/components/schemas/City'
```

Unfortunately, this hasn't yet defined the `{id}` parameter, so we need to manually define it:

```
   /cities/{id}:
+    parameters:
+      - name: id
+        in: path
+        schema:
+          type: int
     get:
       summary: List a given city
       responses:
         # ...
```

Et voila, we now have an OpenAPI-described endpoint.

# Conclusion

Hopefully this has given you a view of how to use test-driven development to introduce OpenAPI contract tests into your Rails codebase.
