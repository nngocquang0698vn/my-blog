---
title: "Beware: `delete`ing a `file` in Chef doesn't actually `delete` it"
description: "Why you should explicitly add `backup false` when `delete`ing a `file` through Chef, to avoid leaving potentially sensitive files still on the box."
categories: blogumentation
tags: blogumentation chef
no_toc: true
---
**Note** - this is slightly clickbait, as this behaviour is somewhat documented in the [Chef docs for the `file` resource][file-resource], although it is not made obvious, and can be a little gotcha.

I ran into this issue recently where I was doing an audit of one of my cookbooks to ensure that no plaintext credentials were being left on the box, despite me telling Chef to remove the file.

I had a Chef recipe such as:

```ruby
file '/tmp/abc.txt' do
  content 'secret file'
end

# do something with the credentials file

file '/tmp/abc.txt' do
  action :delete
end
```

When running this on a node, Chef told me that it had deleted the file as part of the Chef run:

```
Starting Chef Client, version 13.6.4
Creating a new client identity for default-debian using the validator key.
resolving cookbooks for run list: ["fake-cookbook::default"]
Synchronizing Cookbooks:
  - fake-cookbook (0.1.0)
Installing Cookbook Gems:
Compiling Cookbooks...
Converging 2 resources
Recipe: fake-cookbook::default
  * file[/tmp/abc.txt] action create
    - create new file /tmp/abc.txt
    - update content in file /tmp/abc.txt from none to c78470
    --- /tmp/abc.txt     2018-04-29 20:39:28.783960115 +0000
    +++ /tmp/.chef-abc20180429-100-12fjr5z.txt   2018-04-29 20:39:28.783960115 +0000
    @@ -1 +1,2 @@
    +secret file
  * file[/tmp/abc.txt] action delete
    - delete file /tmp/abc.txt

Running handlers:
Running handlers complete
Chef Client finished, 2/2 resources updated in 01 seconds
Finished converging <default-debian> (0m37.63s).
```

And when logging onto the box, I can verify that this file no longer exists:

```
$ ls -al /tmp
total 32
drwxrwxrwt 1 root    root       62 Apr 29 20:39 .
drwxr-xr-x 1 root    root      152 Apr 29 20:38 ..
-rw-r--r-- 1 root    root    23425 Apr 29 20:38 install.sh
drwxr-xr-x 1 kitchen kitchen   146 Apr 29 20:39 kitchen
-rw-r--r-- 1 root    root        2 Apr 29 20:38 sshd.pid
-rw-r--r-- 1 root    root      419 Apr 29 20:38 stderr
```

But when looking around, I found that there was a folder on the node with the file intact:

```
$ find /tmp/kitchen/backup/
/tmp/kitchen/backup/
/tmp/kitchen/backup/tmp
/tmp/kitchen/backup/tmp/abc.txt.chef-20180429203928.788594
```

Note that in Test Kitchen's case, this is `/tmp/kitchen/backup`, but in a regular Chef client run, it will be the value of `file_backup_path` in the `client.rb`.

It turns out that this is because a `file` resource's property `backup` defaults to `5`, which means that there is actually a copy of the file with its super secret contents:

```
$ cat /tmp/kitchen/backup/tmp/abc.txt.chef-20180429203928.788594
secret file
```

The best way to avoid this is simply to add the `backup false` property:

```diff
 file '/tmp/abc.txt' do
   action :delete
+  backup false
 end
```

And as we can now see, that folder no longer exists with a copy of our secret file!

```
$ find /tmp/kitchen/backup
find: `/tmp/kitchen/backup': No such file or directory
```

[file-resource]: https://docs.chef.io/resource_file.html
