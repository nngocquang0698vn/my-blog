#!/usr/bin/env ruby

require 'kwalify'
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

desc 'Test links'
task :test do
  # as Alpine doesn't have `nproc`, this is the next best thing
  num_cpus = `grep 'processor' /proc/cpuinfo  | wc -l`.to_i
  require 'html-proofer'
  options = {
    only_4xx: true,
    parallel: {
      in_processes: num_cpus
    },
    internal_domains: ['jvt.me']
  }
  HTMLProofer.check_directory('./_site', options).run
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

namespace :validate do
  desc 'Validate posts are well-formed'
  task :posts do
    schema = YAML.load_file('.schema/post.yml')
    validator = Kwalify::Validator.new(schema)
    all_errors = {}
    Dir.glob('_posts/*').each do |filename|
      document = YAML.load_file(filename)
      errors = validator.validate(document)
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
  end

  desc 'Validate projects are well-formed'
  task :projects do
    schema = YAML.load_file('.schema/project.yml')
    # we have some extra requirements for projects {{{
    project_status = YAML.load_file('_data/project_status.yml')
    schema['mapping']['project_status']['enum'] = project_status.keys
    tech_stack = YAML.load_file('_data/techstack.yml')
    schema['mapping']['tech_stack']['sequence'][0]['enum'] = tech_stack.keys
    # }}}

    validator = Kwalify::Validator.new(schema)
    all_errors = {}
    Dir.glob('_projects/*').each do |filename|
      document = YAML.load_file(filename)
      errors = validator.validate(document)
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
  end

  desc 'Validate talks are well-formed'
  task :talks do
    schema = YAML.load_file('.schema/talk.yml')
    # we have some extra requirements for projects {{{
    talk_types = YAML.load_file('_data/talk_types.yml')
    schema['mapping']['type']['sequence'][0]['enum'] = talk_types.keys
    # }}}

    validator = Kwalify::Validator.new(schema)
    all_errors = {}
    Dir.glob('_talks/*').each do |filename|
      document = YAML.load_file(filename)
      errors = validator.validate(document)
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
  end
end

task validate: ['validate:posts', 'validate:projects', 'validate:talks']

task default: ['validate', 'test']
