require 'json'
require 'rest-client'

ENDPOINT = 'https://gitlab.com/api/v4'.freeze
# `api` access required Personal Access Token
PRIVATE_TOKEN = ENV['GITLAB_TOKEN'].freeze

def get(url, token)
  headers = {
    'Private-Token' => token
  }

  RestClient.get(url, headers)
end

def follow_and_parse_pagination(url, token)
  initial = get(url, token)
  page = 1 # 1 indexed

  results = []

  while page < initial.headers[:x_total_pages].to_i
    # concat so we can merge in each set of MRs
    results.concat(parse_get(url + '?page=' + page.to_s, token))
    page += 1
  end

  results
end

def parse_get(url, token)
  response = get(url, token)
  JSON.parse(response.body)
end

def get_project_name(url, token)
  response = get(url, token)
  json = JSON.parse(response.body)
  json['name_with_namespace']
end

def merge_requests_and_issues_to_h(issues, merge_requests, year_to_use)
  h = {}
  merge_requests.each do |mr|
    d = Date.parse(mr['created_at'])
    next unless year_to_use.to_i == d.year

    h[mr['project_id']] ||= {}
    h[mr['project_id']]['merge_requests'] ||= {}
    h[mr['project_id']]['merge_requests'][mr['state']] ||= []
    h[mr['project_id']]['merge_requests'][mr['state']] << mr
  end

  issues.each do |mr|
    d = Date.parse(mr['created_at'])
    next unless year_to_use.to_i == d.year

    h[mr['project_id']] ||= {}
    h[mr['project_id']]['issues'] ||= {}
    h[mr['project_id']]['issues'][mr['state']] ||= []
    h[mr['project_id']]['issues'][mr['state']] << mr
  end
  h
end

def report_merge_requests_and_issues(merge_requests_and_issues_h)
  merge_requests_and_issues_h.each do |project_id, h|
    project_path = get_project_name(ENDPOINT + '/projects/' + project_id.to_s, PRIVATE_TOKEN)
    puts "Project #{project_path} has had:"

    if h['issues']
      h['issues'].each do |state_h|
        out = "- #{state_h[1].length} issues "
        case state_h[0]
        when 'opened'
          out += 'opened, but not yet closed'
        else
          out += state_h[0]
        end
        puts out
      end
    end
    if h['merge_requests']
      h['merge_requests'].each do |state_h|
        out = "- #{state_h[1].length} MRs "
        case state_h[0]
        when 'opened'
          out += 'raised, but not yet merged'
        else
          out += state_h[0]
        end
        puts out
      end
    end
    # extra newline for better spacing
    puts ''
  end
end

all_issues = follow_and_parse_pagination(ENDPOINT + '/issues', PRIVATE_TOKEN)
all_merge_requests = follow_and_parse_pagination(ENDPOINT + '/merge_requests', PRIVATE_TOKEN)

report_merge_requests_and_issues(merge_requests_and_issues_to_h(all_issues, all_merge_requests, ARGV[0]))
