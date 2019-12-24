#!/usr/bin/env ruby

require 'html-proofer'
require 'json'
require 'kwalify'
require 'rspec/core/rake_task'
require 'yaml'

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

def report_errors(all_errors)
  return false if all_errors.size.zero?

  puts 'Errors:'
  all_errors.each do |filename, errors|
    puts filename
    errors.each do |e|
      puts "- #{e}"
    end
  end
  true
end

namespace :test do
  desc 'Test links'
  task :links do
    options = {
      only_4xx: true,
      internal_domains: ['jvt.me', 'www.jvt.me'],
      url_ignore: [
        /pic\.twiter\.com/,
        /t\.co/,
        /indieauth.com/,
        /aperture.p3k.io/,
        /matrix.org/,
        /graphql.org/,
        /joind.in/,
        /meetup.com/,
        /www-api.jvt.me/,
        /haveibeenpwned.com/,
      ],
      checks_to_ignore: %w(ImageCheck ScriptCheck),
    }
    HTMLProofer.check_directory('./public', options).run
  end

  desc 'Test integrity of the site'
  task :html_proofer do
    require_relative 'lib/checks'
    options = {
      disable_external: true,
    }
    HTMLProofer.check_directory('./public', options).run
  end

  RSpec::Core::RakeTask.new(:spec)

  namespace :permalinks do
    desc 'Case-sensitive URLs are required'
    task :case_sensitive do
      raise 'Post missing - case sensitivity could be broken' unless File.exists?('./public/mf2/2019/11/nTzzs/index.html') && File.exists?('./public/mf2/2019/11/nTzzs/index.html')
    end

    desc 'Verify RSS permalinks are not broken'
    task :rss do
      permalinks = YAML.load_file('permalinks.yml')
      seen = []
      not_seen = []

      require 'nokogiri'
      feed = Nokogiri::XML(File.read('public/feed.xml'))

      feed.xpath('//item').each do |e|
        link = e.at_xpath('link').content
        # we don't care about anything that's not a blog post
        next unless /^https:\/\/www.jvt.me\/posts\//.match? link

        if permalinks['posts'].include? link
          seen << link
        else
          not_seen << link
        end
      end

      # if we've added a new post
      raise 'Posts not tracked in permalinks.yml ' + not_seen.to_s unless not_seen.length.zero?
      # if we've removed an old post
      raise "Posts seen (#{seen.length}) different to posts in `permalinks.yml` (#{permalinks['posts'].length})" if seen.length != permalinks['posts'].length
    end

    desc 'Verify sitemap permalinks are not broken'
    task :sitemap do
      permalinks = YAML.load_file('permalinks.yml')
      seen = []
      not_seen = []

      require 'nokogiri'
      feed = Nokogiri::XML(File.read('public/sitemap.xml'))

      feed.css('url').each do |e|
        link = e.css('loc').text
        # we don't care about anything that's not a blog post
        next unless /^https:\/\/www.jvt.me\/posts\/[0-9]{4}\//.match? link

        if permalinks['posts'].include? link
          seen << link
        elsif permalinks['aliases'].include? "#{link}/index.html"
          seen << link
        else
          not_seen << link
        end
      end

      # if we've added a new post
      raise 'Posts not tracked in permalinks.yml ' + not_seen.to_s unless not_seen.length.zero?
      # if we've removed an old post
      raise "Posts seen (#{seen.length}) different to posts in `permalinks.yml` (#{permalinks['posts'].length})" if seen.length != permalinks['posts'].length
    end
  end

  desc 'Verify permalinks are not broken'
  task permalinks: ['permalinks:rss', 'permalinks:case_sensitive', 'permalinks:sitemap']

  desc 'Ensure that duplicated tags do not exist'
  task :duplicate_tags do
    Dir.glob('content/**/*.md').each do |file|
      post = YAML.load(File.read(file))

      next unless post.key?('tags')
      tags = post['tags']

      raise "Duplicate tags exist in #{file}" unless tags.length == tags.uniq.length
    end
  end
end

task test: ['test:spec', 'test:permalinks', 'test:html_proofer', 'test:duplicate_tags']

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

namespace :validate do
  desc 'Validate posts are well-formed'
  task :posts do
    schema = YAML.load_file('.schema/post.yml')
    validator = Kwalify::Validator.new(schema)
    all_errors = {}
    Dir.glob('content/posts/*').each do |filename|
      next if 'content/posts/_index.md' == filename
      document = YAML.load_file(filename)
      errors = validator.validate(document)
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
  end

  desc 'Validate events are well-formed'
  task :events do
    schema = YAML.load_file('.schema/event.yml')
    validator = Kwalify::Validator.new(schema)
    all_errors = {}
    Dir.glob('content/events/*/[0-9]*').each do |filename|
      document = YAML.load_file(filename)
      errors = validator.validate(document)
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
  end

  desc 'Validate /mf2/ files are well-formed'
  task :mf2 do
    # Note that as these are published via Micropub, these should be valid before they get here
    # However, we may want to perform extra validation, such as the below:
    all_errors = {}
    Dir.glob('content/mf2/*.md').each do |filename|
      mf2 = JSON.parse(File.read(filename))
      errors = []
      errors << '$.date and $.properties.published[0] are not the same' unless mf2['date'] == mf2['properties']['published'][0]
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
  end

  desc 'Validate Feeds are well-formed'
  namespace :feed do
    desc 'Validate JSON Feed is well-formed'
    task :jsonfeed do
      require 'json-schema'
      jsonfeed = JSON.parse(File.read('public/feed.json'))
      JSON::Validator.validate!('.schema/jsonfeed.json', jsonfeed)
    end
  end

  task feed: ['feed:jsonfeed']
end

desc 'Create Bit.ly short URLs for a given article URL'
task :bitly_urls, [:url] do |_, args|
  raise 'Bit.ly personal access token not provided in ENV[BITLY_TOKEN]' if ENV.fetch('BITLY_TOKEN').to_s.length.zero?
  %w[slack.tn slack.c1 pulse twitter linkedin].each do |medium|
    body = {
      group_guid: 'Bb31fK0maG9',
      domain: 'u.jvt.me',
      long_url: args[:url] + "?utm_medium=#{medium}"
    }

    uri = URI.parse('https://api-ssl.bitly.com/v4/bitlinks')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req['Authorization'] = 'Bearer ' + ENV['BITLY_TOKEN']
    req.body = body.to_json
    res = https.request(req)
    if res.is_a?(Net::HTTPSuccess)
      res_body = JSON.parse(res.body)
      puts "#{medium}: #{res_body['link']}"
    else
      raise "Unsuccessful: Response #{res.code} #{res.message}: #{res.body}"
    end
  end
end

desc 'New Branch + Post'
task :new, [:title] do |_, args|
  date_str = Date.today.iso8601
  date = Date.parse date_str
  puts `git checkout -b article/#{args[:title]}`
  puts `hugo new posts/#{date_str}-#{args[:title]}.md`
  new_url = "https://www.jvt.me/posts/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{args[:title]}/"
  contents = YAML.load_file 'permalinks.yml'
  contents['posts'].unshift new_url

  File.open('permalinks.yml', 'w') do |f|
    f.write contents.to_yaml
  end
end

task validate: ['validate:events', 'validate:posts', 'validate:mf2']

task default: ['validate', 'test']
