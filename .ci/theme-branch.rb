#!/usr/bin/env ruby

# Ensure that theme is pointing to origin/master not a branch
Dir.chdir('themes/www.jvt.me-theme') do
  commit = `git rev-parse HEAD`.chomp
  contains = `git branch main --contains #{commit}`
  raise "branch `main` does not contain commit #{commit}" if contains.length.zero?
end
