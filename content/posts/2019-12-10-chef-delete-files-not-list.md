---
title: "Using Chef to Delete Files that aren't in a List"
description: "How to delete files in a directory that don't match a list."
tags:
- blogumentation
- chef
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-10T23:10:25+0000
slug: "chef-delete-files-not-list"
image: /img/vendor/chef-logo.png
---
I've seen some search traffic recently hitting my site while looking for "chef remove files that aren't in a list". I thought I'd document this for anyone who's trying to work this out.

This unfortunately isn't straightforward with pure Chef, as it requires some lazy evaluation on the node to list the directory we're running against. We need to use a `ruby_block` to perform this check, and then a separate `ruby_block` to delete the files.

The first thing we need to do is to determine all the files that exist in the directory, and then filter out any files that we don't want to delete. In the below example we're making this configurable using an attribute but this could also be hardcoded for your purpose.

Secondly, we need to delete each of these files using Ruby's `File.delete` method. Unfortunately we can't use Chef's `file` resource as there's no way to lazily set them up for the array, due to Chef's two-phase compile and converge phases.

An alternative to the below code would be to create a custom resource that can take i.e. `lazy { node.run_state['files_to_delete'] }`, and then use the `file` resource.

This works out-of-the-box with no custom resources, tested with Chef 15.5.17:

```ruby
ruby_block 'Determine the files to delete' do
  block do
    node.run_state['files_to_delete'] = Dir
      .glob(File.join(node['path_to_check'], '*'))
      .select { |f| File.file? f }
      .delete_if { |f| node['files_to_keep'].include? File.basename(f) }
  end
end

ruby_block 'Delete files that don\'t match' do
  block do
    node.run_state['files_to_delete'].each do |path|
      Chef::Log.info "Deleting file #{path}"
      File.delete path
    end
  end
end
```
