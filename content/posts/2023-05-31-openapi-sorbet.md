---
title: "Introducing `openapi-sorbet`, a command-line tool for generating Sorbet types from OpenAPI"
description: "How to generate Sorbet type-checked models from OpenAPI specifications."
tags:
- blogumentation
- sorbet
- ruby
- go
- command-line
- openapi
date: 2023-05-31T21:44:39+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: openapi-sorbet
image: https://media.jvt.me/8f043fe1ef.png
---
For a couple of the Ruby on Rails applications I work on at work, we use [Sorbet](https://sorbet.org) for type checking.

Late last year we were integrating a JSON Schema based Lambda with the Rails application, so needed to create models to interact with it.

I started hacking on a command-line tool to generate the schemas, but ended up not finishing it, as it was straightforward enough to hand-write the models.

This week, I revisited the need to generate Sorbet types from OpenAPI when trying to integrate with an API, but finding that there wasn't a generator out there for Sorbet, I sought to build it myself.

I've released the first iteration of this, [schema-sorbet](https://gitlab.com/tanna.dev/schema-sorbet) which includes an OpenAPI-to-Sorbet command-line tool.

For instance, if we take the petstore example:

```sh
go install gitlab.com/tanna.dev/schema-sorbet/cmd/openapi-sorbet@latest
curl https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/examples/v3.0/petstore.yaml -Lo petstore.yaml
openapi-sorbet -path petstore.yaml -module ExternalClients::Petstore
```

This will output the following files for the `#!/components/schemas` in the OpenAPI spec:

`out/external_clients/petstore/pets.rb`:

```ruby
# typed: strict
# frozen_string_literal: true

=begin
Generated from OpenAPI specification for
  Swagger Petstore 1.0.0
using
  openapi-sorbet version v0.4.0.
DO NOT EDIT.
=end
 module ExternalClients
 module Petstore
=begin
Pets
=end
Pets = T.type_alias { T::Array[Pet]}
end
end
```

`out/external_clients/petstore/pet.rb`:

```ruby
# typed: strict
# frozen_string_literal: true

=begin
Generated from OpenAPI specification for
  Swagger Petstore 1.0.0
using
  openapi-sorbet version v0.4.0.
DO NOT EDIT.
=end
 module ExternalClients
 module Petstore
=begin
Pet
=end
class Pet  < T::Struct
extend T::Sig

const :id, Integer
const :name, String
const :tag, T.nilable(String)
end
end
end
```

`out/external_clients/petstore/error.rb`:

```ruby
# typed: strict
# frozen_string_literal: true

=begin
Generated from OpenAPI specification for
Swagger Petstore 1.0.0
using
openapi-sorbet version (unknown).
DO NOT EDIT.
=end
module ExternalClients
module Petstore
=begin
Error
=end
class Error  < T::Struct
extend T::Sig

const :code, Integer
const :message, String
end
end
end
```

Note that these aren't formatted, so need some post-processing.

I've been using it so far with some fairly straightforward OpenAPI specifications, and it's been handy!
