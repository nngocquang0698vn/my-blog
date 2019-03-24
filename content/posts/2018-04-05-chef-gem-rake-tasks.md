---
title: Bundling Common Rake Tasks into a Gem
description: 'An example of how to create a helper gem for common Rake task, using the real-world example of Chef cookbooks.'
categories:
- guide
- gem
tags:
- chef
- chefdk
- gem
- ruby
- rake
- foodcritic
- rubocop
- rspec
- knife-cookbook-doc
- gitlab-ci
image: /img/vendor/chef-logo.png
date: 2018-04-05T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-gem-rake-tasks
---
**Note: The code snippets in this post are licensed as Apache-2.0 and available at [<i class="fa fa-gitlab"></i> jamietanna/example-cookbook-helper-gem][example-cookbook-helper-gem].**

# Foreword

As the number of cookbooks I'm working on grows, there are a number of common tasks that I need to have automated. These include, but are not limited to, linting, unit testing and generating documentation. For cookbooks I test with GitLab CI, I also autogenerate the `.gitlab-ci.yml` file, creating a separate phase per test suite. These tasks are performed using Rake, the Ruby task runner.

Having multiple copies of the same code was starting to grind on me, and as part of my [Chef 13 upgrades][chef-13-upgrade], I've found there are a number of style changes to take effect in each `Rakefile`. Instead of making the changes in each repo, I bit the bullet and learned how to create my own Gem which would contain these tasks and make it easier to upgrade all Gems in one fell swoop. I've written this post to document it for posterity, and to show how easy it is to do.

**Note**: All the below commands are prefaced with `chef exec`, to tie the version of Ruby, RubyGems and Bundler with the version in the ChefDK, making sure all dependencies will be aligned.

# Determining Dependency Versions

Now, this seems like quite an easy task, but to throw a slight spanner in the works, we'll also require that the Gem tests against the **exact versions of tools** as in the ChefDK at version 2.4.17, which is the version I'm currently using. This ensures that across any machine, they'll only ever use the right versions, instead of potentially polluting our installation with incorrect Gem versions.

To check the versions of each of the dependencies we have, I ran the following:

```shell
$ docker run --rm chef/chefdk:2.4.17 chef gem list |\
  grep -e rubocop -e chef -e berkshelf -e chefspec -e foodcritic
berkshelf (6.3.1)
chef (13.6.4)
chef-api (0.7.1)
chef-config (13.6.4)
chef-dk (2.4.17)
chef-provisioning (2.6.0)
chef-provisioning-aws (3.0.0)
chef-provisioning-azure (0.6.0)
chef-provisioning-fog (0.26.0)
chef-sugar (3.6.0)
chef-vault (3.3.0)
chef-zero (13.1.0)
cheffish (13.1.0)
chefspec (7.1.1)
chefstyle (0.6.0)
foodcritic (12.2.1)
rubocop (0.49.1)
```

# Creating our Gem

For example, we'll call this Gem `cookbook_helper`, following the [naming scheme as defined in RubyGems' docs][name-your-gem].

We can create our Gem boilerplate by running the handy `chef exec bundle gem cookbook_helper`:

```shell
$ chef exec bundle gem cookbook_helper
Creating gem 'cookbook_helper'...
      create  cookbook_helper/Gemfile
      create  cookbook_helper/lib/cookbook_helper.rb
      create  cookbook_helper/lib/cookbook_helper/version.rb
      create  cookbook_helper/cookbook_helper.gemspec
      create  cookbook_helper/Rakefile
      create  cookbook_helper/README.md
      create  cookbook_helper/bin/console
      create  cookbook_helper/bin/setup
      create  cookbook_helper/.gitignore
      create  cookbook_helper/.travis.yml
      create  cookbook_helper/.rspec
      create  cookbook_helper/spec/spec_helper.rb
      create  cookbook_helper/spec/cookbook_helper_spec.rb
Initializing git repo in /path/to/cookbook_helper
```

Let's start by filling in some of the information in the `cookbook_helper.gemspec`:

```ruby
Gem::Specification.new do |spec|
  spec.name          = "cookbook_helper"
  spec.version       = CookbookHelper::VERSION
  spec.authors       = ["Jamie Tanna"]
  spec.email         = ["..."]

  spec.summary       = %q{Opinionated Rake tasks for aiding with building a cookbook in line with ChefDK 2.4.17}
  ...
```

# Code Style Tasks

The quickest tasks we can bring in are the code style tasks, [Rubocop] and [FoodCritic].

## Rubocop

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

## FoodCritic

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

However, this doesn't quite mirror the functionality of the FoodCritic CLI. For instance, when the CLI finds any FoodCritic violations, it returns an error code, whereas the Rake task [only fails on `correctness` tags][fc-12-2-1-fail], whereas the CLI returns an error code if `any` tags fail.

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
+end
```


# Unit Testing Tasks

Cookbook unit testing is traditionally done using [ChefSpec][chefspec], which wraps some Chef-iness around RSpec:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'chefspec', '= 7.1.1'
```

Adding the Rake task to `lib/cookbook_helper_gem/rake_task.rb`:

```ruby
require 'rspec/core/rake_task'
# ...
RSpec::Core::RakeTask.new(:spec)
```

If you're using [Berkshelf][berkshelf] for dependency management, you will also need to pull it in, so `ChefSpec` can download dependent cookbooks:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'berkshelf', '= 6.3.1'
```

# Documentation Rake Tasks

As I've [mentioned before][tags-knife-cookbook-doc], I use [knife-cookbook-doc] as a means to pull inline documentation into the `README.md`.

## Generating Documentation

For pulling in `knife-cookbook-doc`, we also need to specify the version of `chef`, which matches the version ChefDK 2.4.17 provides:

```ruby
Gem::Specification.new do |spec|
  # ...
  spec.add_runtime_dependency 'chef', '= 13.6.4'
  spec.add_runtime_dependency 'knife-cookbook-doc', '~> 0.25'
```

Note that we need a minimum of `0.25.0` to support generating documentation for Chef 13, but this could be anything, really. In this case, we'll pull in anything matching [Semantic Versioning minor bumps][semver].

## Testing Documentation

It may be useful to be able to generate documentation, but it'd also be pretty useful to be able to confirm whether the `README.md` has been updated.

```ruby
require 'knife_cookbook_doc/rake_task'
# ...
KnifeCookbookDoc::RakeTask.new(:readme)

KnifeCookbookDoc::RakeTask.new(:readme_test) do |t|
  t.options[:output_file] = 'tmp/README.md'
end

task :readme_test_dir do
  FileUtils.mkdir_p 'tmp'
end

task doc_test: [:readme_test_dir, :readme_test] do
  unless FileUtils.identical?('README.md', 'tmp/README.md')
    $stderr.puts "Generated file is not identical to the README.md in the repo. Please update it:"
    # the command will fail with an error code, therefore failing the Rake task
    sh 'diff -aur --color README.md tmp/README.md'
  end
end
```

We utilise Rake's dependencies functionality to ensure that `doc_test` isn't run until we have `readme_test_dir` and `readme_test`, in that order. Note that we use `FileUtils.mkdir_p` to silence errors if the `tmp` directory already exists.

When the files aren't identical, we output a friendly error message to inform the user that they need to update the documentation, as well as outputting the raw diff between the files. The diff itself is to make it easier to debug any cases where they're different.

# Cleaning up our `Rakefile`

## Wrapping Related Blocks in `namespace`s

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
      # the command will fail with an error code, therefore failing the Rake task
      $stderr.puts "Generated file is not identical to the README.md in the repo. Please update it:"
      sh 'diff -aur --color README.md tmp/README.md'
    end
  end
end
```

This makes it much clearer when reading through the source, as well as being able to see what each task corresponds with. For instance, before:

```shell
$ chef exec rake -T
rake foodcritic            # Lint Chef cookbooks
rake readme                # Generate cookbook documentation
rake readme_test           # Generate cookbook documentation
rake rubocop               # Run RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake spec                  # Run RSpec code examples
```

And after:

```shell
$ chef exec rake -T
rake doc:readme                  # Generate cookbook documentation
rake doc:readme_test             # Generate cookbook documentation
rake style:foodcritic            # Lint Chef cookbooks
rake style:rubocop               # Run RuboCop
rake style:rubocop:auto_correct  # Auto-correct RuboCop offenses
rake unit:spec                   # Run RSpec code examples
```

However, note that we're missing our `doc:test_dir` and `doc:test` tasks!

This is because they don't have corresponding documentation lines, i.e.

```diff
 namespace :doc do
   # ...
+  desc 'Verify that documentation has been generated from latest source code'
   task test: [:test_dir, :readme_test] do
     unless FileUtils.identical?('README.md', 'tmp/README.md')
       $stderr.puts "Generated file is not identical to the README.md in the repo. Please update it:"
       sh 'diff -au --color README.md tmp/README.md'
     end
   end
 end
```

This then makes the `doc:test` task appear:

```shell
$ chef exec rake -T
rake doc:readme                  # Generate cookbook documentation
rake doc:readme_test             # Generate cookbook documentation
rake doc:test                    # Verify that documentation has been generated from latest source code
rake style:foodcritic            # Lint Chef cookbooks
rake style:rubocop               # Run RuboCop
rake style:rubocop:auto_correct  # Auto-correct RuboCop offenses
rake unit:spec                   # Run RSpec code examples
```

## Creating Helper `task`s

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

# Integrating into Cookbooks

Now we've set up our Rake tasks, we need to actually integrate into another cookbook. However, we don't need to push it up to [RubyGems][rubygems] quite yet, as we can test it all locally.

First, we need a cookbook. For convenience, we'll create a fresh cookbook:

```shell
$ chef generate cookbook test-cookbook
```

We create a `Rakefile` to include our Gem's Rake tasks:

```ruby
require 'cookbook_helper/rake_task'
```

As well as making sure that the Gem is included in the cookbook via the `Gemfile`, taking care to reference the path on disk to the `cookbook_helper` folder:

```ruby
source 'https://rubygems.org'

gem 'cookbook_helper', path: '/path/to/cookbook_helper'
```

To verify this has worked, we can run the following:

```shell
$ chef exec bundle exec rake -T
rake doc:readme                  # Generate cookbook documentation
rake doc:readme_test             # Generate cookbook documentation
rake style:foodcritic            # Lint Chef cookbooks
rake style:rubocop               # Run RuboCop
rake style:rubocop:auto_correct  # Auto-correct RuboCop offenses
rake unit:spec                   # Run RSpec code examples
```

At this point, we've now got a Gem ready to release to RubyGems which pins exactly to a given version of the ChefDK.

There will be a follow-up post to describe how I build out my GitLab CI configuration for cookbooks.

[name-your-gem]: http://guides.rubygems.org/name-your-gem
[tags-knife-cookbook-doc]: /posts/tags/knife-cookbook-doc/
[rubocop]: https://github.com/bbatsov/rubocop
[foodcritic]: http://foodcritic.io
[chefspec]: https://github.com/chefspec/chefspec
[berkshelf]: https://github.com/berkshelf/berkshelf
[knife-cookbook-doc]: https://github.com/realityforge/knife-cookbook-doc/
[chef-13-upgrade]: {{< ref 2018-03-06-chef-13-upgrades >}}
[fc-12-2-1-fail]: https://github.com/Foodcritic/foodcritic/blob/v12.2.1/lib/foodcritic/rake_task.rb#L37
[semver]: http://guides.rubygems.org/patterns/#semantic-versioning
[example-cookbook-helper-gem]: https://gitlab.com/jamietanna/example-cookbook-helper-gem
[rubygems]: https://rubygems.org
