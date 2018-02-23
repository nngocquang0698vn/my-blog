#!/usr/bin/env ruby
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
  desc 'Notify Google of updated sitemap'
  task :google do
    begin
      require 'net/http'
      require 'uri'
      puts '* Notifying Google that the site has updated'
      Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' +
                    URI.escape('https://jvt.me/sitemap.xml'))
    rescue LoadError
      puts '! Could not ping Google about our sitemap, because Net::HTTP or URI could not be found.'
    end
  end

  desc 'Notify Bing of updated sitemap'
  task :bing do
    begin
      require 'net/http'
      require 'uri'
      puts '* Notifying Bing that the site has updated'
      Net::HTTP.get('www.bing.com', '/webmaster/ping.aspx?siteMap=' +
                    URI.escape('https://jvt.me/sitemap.xml'))
    rescue LoadError
      puts '! Could not ping Bing about our sitemap, because Net::HTTP or URI could not be found.'
    end
  end
end

task default: ['test']
