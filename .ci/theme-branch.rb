#!/usr/bin/env ruby

# Ensure that theme is pointing to origin/fork not a branch
Dir.chdir('themes/tale-hugo') do
  commit = `git rev-parse HEAD`.chomp
  contains = `git branch fork --contains #{commit}`
  raise "branch `fork` does not contain commit #{commit}" if contains.length.zero?
end
