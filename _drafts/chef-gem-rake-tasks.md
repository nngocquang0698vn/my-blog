---
title: Bundling Common Rake Tasks (for Chef Development) into a Gem
description: 'An example of how to create a helper gem for common rake task across multiple projects, using the **example of** Chef cookbooks.'
categories: guide gem
tags: chef gem ruby rake foodcritic rubocop rspec knife-cookbook-doc gitlab-ci
image: TODO
---
**Note: The code snippets in this post are licensed as Apache-2.0.**

- As the number of cookbooks I'm working on grows, there are a number of common pieces of functionality that I need to have in them.
- Currently using `rake` for it
- Want to _at least_ have a Rake task for running `style`, `unit` and `doc`.
- targeting 2.4.17 (therefore using strict version pinning - how have we listed those versions?)
- This is the first time I'm creating my own Gem, so I wanted to have it documented **for myself**, and to see if there are any **helpers people can share**.

## Creating our Gem

As this gem is a helper for the cookbooks that run [Spectat Designs]' infrastructure, the name of the gem is going to be .

We want to create a gem called `cookbook_helper_gem`, following the naming scheme as [0].

We can create our Gem boilerplate using `bundle gem cookbook_helper_gem`. This creates the folder:

**TODO: Asciicast**

Let's fill in some of the information in the `cookbook_helper_gem.gemspec`:

```ruby
Gem::Specification.new do |spec|
  spec.name          = "cookbook_spectat_gem"
  spec.version       = CookbookSpectatGem::VERSION
  spec.authors       = ["Jamie Tanna"]
  spec.email         = ["rubygems@jamietanna.co.uk"]

  spec.summary       = %q{Opinionated Rake tasks for aiding with building a cookbook.}
  spec.description   = %q{}
  spec.homepage      = "https://gitlab.com/spectat/provisioning/cookbook_spectat_gem"
```

## Code Style Tasks

The quickest tasks we can bring in are the code style tasks, [Rubocop] and [FoodCritic].

### Rubocop

Starting with Rubocop, we need to first add the dependency to our Gemspec:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'foodcritic', '= 12.2.1'
```


We then follow the example of other Gems, and we create the file `lib/cookbook_spectat_gem/rake_task.rb`:

```ruby
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop)
```

### FoodCritic

- Maintain parity with `foodcritic` cli

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'rubocop', '= 0.49.1'
```

```ruby
require 'foodcritic/rake_task'
# ...
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  # As with the FoodCritic CLI, fail if there are any tags that fail
  t.options = {
    fail_tags: ['any']
  }
end
```

## Unit Testing Tasks

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'rspec', '= 3.7.0'
```

```ruby
require "rspec/core/rake_task"
# ...
RSpec::Core::RakeTask.new(:spec)
```

## Documentation Rake Tasks

As I've [spoken about before][tags-knife-cookbook-doc], I use [`knife-cookbook-doc`] as a means to generate a `README.md` with cookbook documentation from inline comments in the source.

### Generating Documentation

For pulling in `knife-cookbook-doc`, we also need to specify the version of `chef`, that we tie in with the version the ChefDK provides.

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'chef', '= 13.6.4'
  spec.add_runtime_dependency 'knife-cookbook-doc', '= 0.25.0'
```

Note that we need a minimum of `0.25.0` to support generating documentation for Chef 13.

### Testing Documentation

It may be useful to be able to generate documentation, but it'd also be pretty useful to be able to confirm whether the `README.md` has been updated.

```ruby
KnifeCookbookDoc::RakeTask.new(:readme_test) do |t|
  t.options[:output_file] = 'tmp/README.md'
end

task :readme_test_dir do
  FileUtils.mkdir_p 'tmp'
end

task doc_test: [:readme_test_dir, :readme_test] do
  unless FileUtils.identical?('README.md', 'tmp/README.md')
    $stderr.puts "Generated file is not identical to the README.md in the repo. Please update it:"
    sh 'diff -aur --color README.md tmp/README.md'
  end
end
```

We utilise Rake's dependencies functionality to ensure that `doc_test` isn't run until we have `readme_test_dir` and `readme_test`, in that order. Note that we use `FileUtils.mkdir_p` to silence errors if the `tmp` directory already exists.

When the files aren't identical, we output a friendly error message to inform the user that they need to update the documentation, as well as outputting the raw diff between the files. The diff itself is to make it easier to debug any cases where they're different.

## Cleaning up our `Rakefile`

### Using `namespace`s

Rake's `namespace`s functionality allows us to place common code into blocks, such as:

```ruby
namespace :style do
  RuboCop::RakeTask.new(:rubocop)

  FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
    # As with the FoodCritic CLI, fail if there are any tags that fail
    t.options = {
      fail_tags: ['any']
    }
  end
end

task style: ['style:rubocop', 'style:foodcritic']

namespace :unit do
  RSpec::Core::RakeTask.new(:spec)
end

namespace :doc do
  KnifeCookbookDoc::RakeTask.new(:readme)

  KnifeCookbookDoc::RakeTask.new(:readme_test) do |t|
    t.options[:output_file] = 'tmp/README.md'
  end

  task :test_dir do
    FileUtils.mkdir_p 'tmp'
  end

  task test: [:test_dir, :readme_test] do
    unless FileUtils.identical?('README.md', 'tmp/README.md')
      $stderr.puts "Generated file is not identical to the README.md in the repo. Please update it:"
      sh 'diff -aur --color README.md tmp/README.md'
    end
  end
end
```

This makes it much clearer when reading through the source, and **??**.

### Creating Default `task`s

However, this then makes it difficult to call certain tasks, as we now would have to run `rake style:rubocop && rake style:foodcritic` to run our style checks. By combining these in a top-level `task`, we can prevent this:

```ruby
# ...
task style: ['style:rubocop', 'style:foodcritic']
task unit: ['unit:spec']
task doc: ['doc:test']
```

We can also add in a `default` task to allow us to simply run `rake`, and call the helper `task`s:

```ruby
task default: ['style', 'doc', 'unit']
```

## Integrating into Cookbooks

Now we've written it, we need to actually integrate into another cookbook. However we should probably test this works before pushing it up to RubyGems.



Let's assume we've just created a new cookbook:

- `chef generate cookbook`
- create `Rakefile`
- add `Gemfile` reference to `local`
- asciicast

- via RubyGems?

## Extension: Generating GitLab CI Config for Test Kitchen Suites

**TODO: move to the second part?**

In my GitLab setup, I've got a separate test stage running for each Kitchen suite. However, updating the `.gitlab-ci.yml` manually is quite a pain, and I love automating things.

Instead, we can utilise `eruby` to work on this for us:

```eruby
<%= test %>
```

We can then create a handy test:

```ruby
```

For our implementation:

```ruby
```

And then hook it into our `rake_task.rb`:

- integration tests done through kitchen CLI
- autogenerate the CI YML to pick up all kitchen suites




[0]: http://guides.rubygems.org/name-your-gem
[tags-knife-cookbook-doc]: /tags/knife-cookbook-doc/
