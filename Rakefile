#!/usr/bin/env ruby

require 'yaml'

def notify_search_engine(base_url, search_engine_url)
  raise 'Top-level URL not specified' unless base_url

  uri = URI(search_engine_url + URI.escape("#{base_url}/sitemap.xml"))
  response = Net::HTTP.get_response(uri)
  raise response unless response.is_a? Net::HTTPSuccess
  puts "Received code #{response.code} back from #{uri}"
end

def get_field_from_yaml(filename, field_name)
  h = YAML.load_file(filename)
  if h.key?(field_name) && h[field_name]
    h[field_name].split ' '
  else
    []
  end
end

def get_field_from_files(glob, field)
  arr = []
  Dir.glob(glob).each do |f|
    arr << get_field_from_yaml(f, field)
  end
  arr.flatten!.uniq!.sort!
end

desc 'Test links'
task :test do
  # as Alpine doesn't have `nproc`, this is the next best thing
  num_cpus = `grep 'processor' /proc/cpuinfo  | wc -l`.to_i
  require 'html-proofer'
  HTMLProofer.check_directory('./_site',
                              only_4xx: true,
                              parallel: {
                                in_processes: num_cpus
                              },
                              internal_domains: ['jvt.me']).run
end

desc 'Notify all search engines'
task :notify, [:fqdn] do |_, args|
  Rake::Task['notify:google'].invoke(args[:fqdn])
  Rake::Task['notify:bing'].invoke(args[:fqdn])
end

namespace :notify do
  require 'net/http'
  require 'uri'

  desc 'Notify Google of updated sitemap'
  task :google, [:fqdn] do |_, args|
    notify_search_engine(args[:fqdn], 'https://google.com/webmasters/tools/ping?sitemap=')
  end

  desc 'Notify Bing of updated sitemap'
  task :bing, [:fqdn] do |_, args|
    notify_search_engine(args[:fqdn], 'https://bing.com/webmaster/ping.aspx?siteMap=')
  end
end

namespace :list do
  desc 'List all tags in the site'
  task :tags do
    arr = get_field_from_files('_posts/*.md', 'tags')
    puts "There are #{arr.length} tags: #{arr}"
  end

  desc 'List all categories in the site'
  task :categories do
    arr = get_field_from_files('_posts/*.md', 'categories')
    puts "There are #{arr.length} categories: #{arr}"
  end
end

task default: ['test']
