---
title: Bundling Common Rake Tasks (for Chef Development) into a Gem
description: 'An example of how to create a helper gem for common rake task across multiple projects, using the **example of** Chef cookbooks.'
categories: guide gem
tags: chef gem ruby rake foodcritic rubocop rspec knife-cookbook-doc gitlab-ci
image: TODO
---
**Note: The code snippets in this post are licensed as Apache-2.0.**

As the number of cookbooks I'm working on grows, there are a number of common tasks that I need to have automated. These include, but are not limited to, linting, unit testing and generating documentation. For cookbooks I test with GitLab CI, I also autogenerate the `.gitlab-ci.yml` file, creating a separate phase per test suite. These tasks are performed using Rake, the Ruby task runner.

Having multiple copies of the same code was starting to grind on me, and as part of my [Chef 13 upgrades][chef-13-upgrade], I've found there are a number of style changes to take effect in each `Rakefile`. Instead of making the changes in each repo, I bit the bullet and learned how to create my own Gem which would contain these tasks and make it easier to upgrade all Gems in one fell swoop. I've written this post to document it for posterity, and to show how easy it is to do.

Now, this seems like quite an easy task, but to throw a slight spanner in the works, we'll also require that the Gem tests against the **exact versions of tools** as in the ChefDK at version 2.4.17, which is the version I'm currently using. This ensures that across any machine, they'll only ever use the right versions, instead of potentially polluting our installation with incorrect Gem versions.

**HOw to check versions?**

## Creating our Gem

For example, we'll call this Gem `cookbook_helper`, following the [naming scheme as defined in RubyGems' docs][name-your-gem].

We can create our Gem boilerplate by running the handy `bundle gem cookbook_helper` command. This creates the folder structure:

**TODO: Asciicast**

Let's start by filling in some of the information in the `cookbook_helper.gemspec`:

```ruby
Gem::Specification.new do |spec|
  spec.name          = "cookbook_helper"
  spec.version       = CookbookHelperGem::VERSION
  spec.authors       = ["Jamie Tanna"]
  spec.email         = ["..."]

  spec.summary       = %q{Opinionated Rake tasks for aiding with building a cookbook.}
  ...
```

## Code Style Tasks

The quickest tasks we can bring in are the code style tasks, [Rubocop] and [FoodCritic].

### Rubocop

Starting with Rubocop, we need to first add the dependency to our `cookbook_helper.gemspec`:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'rubocop', '= 0.49.1'
```

We then follow the example of other Gems, and we create the file `lib/cookbook_helper/rake_task.rb`:

```ruby
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop)
```

### FoodCritic

Again, we simply need to version pin FoodCritic:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'foodcritic', '= 12.2.1'
```

And again add the Rake task to `lib/cookbook_helper/rake_task.rb`:

```ruby
require 'foodcritic'
# ...
FoodCritic::Rake::LintTask.new(:foodcritic)
```

However, this doesn't quite mirror the functionality of the FoodCritic CLI, which always returns an error code if any tag is caught, whereas

However, this doesn't quite mirror the functionality of the FoodCritic CLI. I found some time ago that the Rake task [only fails on `correctness` tags][fc-12-2-1-fail], whereas the CLI returns an error code if `any` tags fail.

To preserve the functionality of the `foodcritic`, we can add the following config to the Rake task:

```diff
 require 'foodcritic'
 # ...
-FoodCritic::Rake::LintTask.new(:foodcritic)
+FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
+  # As with the FoodCritic CLI, fail if there are any tags that fail
+  t.options = {
+    fail_tags: ['any']
+  }
end
```


## Unit Testing Tasks

Cookbook unit testing is traditionally done using [ChefSpec][chefspec], which wraps some Chef-iness around RSpec:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'chefspec', '= 7.1.1'
```

Adding the Rake task to `lib/cookbook_helper_gem/rake_task.rb`:

```ruby
require "rspec/core/rake_task"
# ...
RSpec::Core::RakeTask.new(:spec)
```

If you're using [Berkshelf][berkshelf] for dependency management, you will also need to pull it in, so `ChefSpec` can download dependent cookbooks:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'berkshelf', '= 6.3.1'
```

## Documentation Rake Tasks

As I've [spoken about before][tags-knife-cookbook-doc], I use [knife-cookbook-doc] as a means to pull inline documentation into the `README.md`.

### Generating Documentation

For pulling in `knife-cookbook-doc`, we also need to specify the version of `chef`, which matches the version ChefDK 2.4.17 provides:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'chef', '= 13.6.4'
  spec.add_runtime_dependency 'knife-cookbook-doc', '<~ 0.25'
```

Note that we need a minimum of `0.25.0` to support generating documentation for Chef 13, but this could be anything, really. In this case, we'll pull in anything matching [Semantic Versioning minor bumps][semver].

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

### Wrapping Related Blocks in `namespace`s

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

This makes it much clearer when reading through the source, as well as being able to see what each task corresponds with. For instance, before:

```shell
$ rake -T
rake foodcritic            # Lint Chef cookbooks
rake readme                # Generate cookbook documentation
rake readme_test           # Generate cookbook documentation
rake rubocop               # Run RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake spec                  # Run RSpec code examples
```

And after:

```shell
$ rake -T
rake doc:readme                  # Generate cookbook documentation
rake doc:readme_test             # Generate cookbook documentation
rake style:foodcritic            # Lint Chef cookbooks
rake style:rubocop               # Run RuboCop
rake style:rubocop:auto_correct  # Auto-correct RuboCop offenses
rake unit:spec                   # Run RSpec code examples
```

However, note that we're missing our `doc:test_dir` and `doc:test` tasks!

This is because they don't have corresponding documentation lines, i.e.

```ruby
namespace :doc do
  # ...
  desc 'Verify that documentation has been generated from latest source code'
  task test: [:test_dir, :readme_test] do
    unless FileUtils.identical?('README.md', 'tmp/README.md')
      $stderr.puts "Generated file is not identical to the README.md in the repo. Please update it:"
      sh 'diff -aur --color README.md tmp/README.md'
    end
  end
end
```

This then makes the `doc:test` task appear:

```shell
$ rake -T
rake doc:readme                  # Generate cookbook documentation
rake doc:readme_test             # Generate cookbook documentation
rake doc:test                    # Verify that documentation has been generated from latest source code
rake style:foodcritic            # Lint Chef cookbooks
rake style:rubocop               # Run RuboCop
rake style:rubocop:auto_correct  # Auto-correct RuboCop offenses
rake unit:spec                   # Run RSpec code examples
```

### Creating Helper `task`s

Now we're using `namespace`s, it's more complicated to call certain tasks, such as `rake style:rubocop && rake style:foodcritic` to run our style checks. By combining these in a top-level `task`, we can prevent this:

```ruby
# ...
task style: ['style:rubocop', 'style:foodcritic']
task unit: ['unit:spec']
task doc: ['doc:readme']
```

We can also add in a `default` task to allow us to simply run `rake`, and call the helper `task`s:

```ruby
task default: ['style', 'doc:test', 'unit']
```

## Integrating into Cookbooks

Now we've set up our Rake tasks, we need to actually integrate into another cookbook. However, we don't need to push it up to <RubyGems.org> quite yet, as we can test it all locally.

First, we need a cookbook. For convenience, we'll create a fresh cookbook:

```shell
$ chef generate cookbook test-cookbook
```

**TODO asciicast**


However we should probably test this works before pushing it up to RubyGems.



Let's assume we've just created a new cookbook:

- `chef generate cookbook`
- create `Rakefile`
- add `Gemfile` reference to `local`
- asciicast

- via RubyGems?


[name-your-gem]: http://guides.rubygems.org/name-your-gem
[tags-knife-cookbook-doc]: /tags/knife-cookbook-doc/
[chefspec]: https://github.com/chefspec/chefspec
[berkshelf]: https://github.com/berkshelf/berkshelf
[knife-cookbook-doc]: https://github.com/realityforge/knife-cookbook-doc/
[chef-13-upgrade]: {% post_url 2018-03-06-chef-13-upgrades %}
[fc-12-2-1-fail]: https://github.com/Foodcritic/foodcritic/blob/v12.2.1/lib/foodcritic/rake_task.rb#L37
[semver]: http://guides.rubygems.org/patterns/#semantic-versioning
