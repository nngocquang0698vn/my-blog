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
      checks_to_ignore: %w(Mf2HasValidHentry),
    }
    HTMLProofer.check_directory('./public', options).run
  end

  RSpec::Core::RakeTask.new(:spec)

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

task test: ['test:spec', 'test:html_proofer', 'test:duplicate_tags']

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
  puts `git checkout -b article/#{args[:title]}`
  puts `hugo new posts/#{date_str}-#{args[:title]}.md`
  puts `git add content/posts/#{date_str}-#{args[:title]}.md`
end

def app_url(url, client_id)
  if url.start_with? '/'
    File.join(client_id, url)
  else
    url
  end
end

desc 'Update h-app information'
task :apps do
  require 'net/http'
  require 'microformats'
  require 'uri'
  apps = Dir.glob('content/mf2/**/*.md').filter_map do |f|
    next if f.end_with? '_index.md'

    mf2 = JSON.parse(File.read f)
    next unless mf2['client_id']

    mf2['client_id'] unless mf2['client_id'].nil?
  end

  apps.uniq.each do |app|
    mf2 = Microformats.parse(Net::HTTP.get URI(app))
    mf2.to_h['items'].each do |h|
      next unless h['type'].include? 'h-app'
      filename = URI.parse(app).host

      p = h['properties']

      if p.key? 'url'
        p['url'] = [app_url(p['url'][0], app)]
      end

      if p.key? 'logo'
        p['logo'] = [app_url(p['logo'][0], app)]
      end

      File.open("data/apps/#{filename}.json", 'w') do |a|
        a.write(JSON.pretty_generate(h) + "\n")
      end
    end
  end
end

task validate: ['validate:events', 'validate:posts', 'validate:mf2']

task default: ['validate', 'test']
