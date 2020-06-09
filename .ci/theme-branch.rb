#!/usr/bin/env ruby

# Ensure that theme is pointing to origin/master not a branch
Dir.chdir('themes/www.jvt.me-theme') do
  commit = `git rev-parse HEAD`.chomp
  contains = `git branch master --contains #{commit}`
  raise "branch `master` does not contain commit #{commit}" if contains.length.zero?
end
