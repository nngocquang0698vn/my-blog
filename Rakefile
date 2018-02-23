#!/usr/bin/env ruby

def notify_search_engine(base_url, search_engine_url)
  raise 'Top-level URL not specified' unless base_url

  uri = URI(search_engine_url + URI.escape("#{base_url}/sitemap.xml"))
  response = Net::HTTP.get_response(uri)
  raise response unless response.is_a? Net::HTTPSuccess
  puts "Received code #{response.code} back from #{uri}"
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
                              }
                             ).run
end

task notify: ['notify:google', 'notify:bing']
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

task default: ['test']
