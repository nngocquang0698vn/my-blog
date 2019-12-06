---
title: "ChefSpec Gotcha: Using `render_file` When Deleting Files"
description: "How to use `render_file` with ChefSpec when you're deleting the file."
tags:
- blogumentation
- chef
- chefspec
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-06T21:44:10+0000
slug: "chefspec-gotcha-render-content-delete"
image: /img/vendor/chef-logo.png
---
If you're working with sensitive files, such as those with secrets, on a Chef run, you should ideally delete them from disk once the Chef run is complete, otherwise they could leak sensitive data.

However, this doesn't necessarily play nicely with ChefSpec ([which you should be using for testing your Chef codebase]({{< ref "2018-09-04-tdd-chef-cookbooks-chefspec-inspec" >}})).

For instance, let's say we have the following Chef code:

```ruby
template 'renders the EnvironmentFile for Caddy service secrets' do
  source 'secrets.erb'
  path '/etc/caddy/something.secrets'
  user 'root'
  group 'root'
  mode '0700'
  variables(
    variables: {
      DO_AUTH_TOKEN: new_resource.dns_api_key
    }
  )
  sensitive true
  cookbook 'cookbook-spectat'
  notifies 'file[Delete the sensitive file]'
end

file 'Delete the sensitive file' do
  path '/etc/caddy/something.secrets'
  backup false
  action :delete
end
```

This is great, until you try and validate the contents of the file in ChefSpec:

```ruby
it 'renders Caddy service secrets' do
  expect(chef_run).to create_template('renders Caddy service secrets')
    .with(source: 'secrets.erb')
    .with(path: '/etc/caddy/something.secrets')
    .with(user: 'root')
    .with(group: 'root')
    .with(mode: '0700')
    .with(variables: {
            variables: {
              DO_AUTH_TOKEN: 'SECRETwibbleAPIKEY'
            }
          })
    .with(sensitive: true)
    .with(cookbook: 'cookbook-spectat')
  expect(chef_run).to(render_file('/etc/caddy/something.secrets')
    .with_content do |content|
      expect(content).to match %r{^DO_AUTH_TOKEN=SECRETwibbleAPIKEY$}
    end)
end
```

This unfortunately doesn't work, and we receive the following error:

```
1) cookbook-spectat::_caddy_resource When it doesn't matter what configuration we have overrides Caddy cookbook's systemd config
   Failure/Error:
     expect(chef_run).to(render_file('/etc/caddy/something.secrets')
       .with_content do |content|
         expect(content).to match %r{^DO_AUTH_TOKEN=SECRETwibbleAPIKEY$}
       end)

     expected Chef run to render "/etc/caddy/something.secrets" matching:

     (the result of a proc)

     but got:



   # ./spec/unit/resources/caddy_spec.rb:88:in `block (3 levels) in <top (required)>'
```

This is because (un)fortunately Chef has now deleted the file, and when we try to validate the contents of the file, it's no longer available for ChefSpec.

One way that we can get around it is by deleting the containing folder for the secrets, not the file itself:

```ruby
directory 'Delete the sensitive file' do
  path '/etc/caddy/secrets'
  recursive true
  action :delete
end
```

This isn't ideal, but it does mean that we can at least validate the files are being rendered correctly.

Unfortunately this may not be future proof, so it's worth using cautiously. I've tested it with ChefDK 3.5.13 (with ChefSpec 7.3.2) and ChefDK 4.4.27 (with ChefSpec 7.4.0).

Note: if you are deleting a file, make sure you [remember to use `backup false`]({{< ref "2018-04-30-beware-chef-file-delete" >}})!
