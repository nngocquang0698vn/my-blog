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

def get_issue_line(state, count)
  out = "- #{count} issues "
  out += (
    case state
    when 'opened'
      'raised, but not yet closed'
    else
      state
    end
  )
  out
end

def get_merge_request_line(state, count)
  out = "- #{count} MRs "
  out += (
    case state
    when 'opened'
      'raised, but not yet merged'
    else
      state
    end
  )
  out
end

def report_merge_requests_and_issues(merge_requests_and_issues_h)
  issues = {
    'closed' => 0,
    'opened' => 0
  }

  merge_requests = {
    'closed' => 0,
    'locked' => 0,
    'merged' => 0,
    'opened' => 0
  }

  merge_requests_and_issues_h.each do |project_id, h|
    project_path = get_project_name(ENDPOINT + '/projects/' + project_id.to_s, PRIVATE_TOKEN)
    puts "Project #{project_path} has had:"

    if h['issues']
      h['issues'].each do |state_h|
        issues[state_h[0]] += state_h[1].length

        puts get_issue_line(state_h[0], state_h[1].length)
      end
    end
    if h['merge_requests']
      h['merge_requests'].each do |state_h|
        merge_requests[state_h[0]] += state_h[1].length

        puts get_merge_request_line(state_h[0], state_h[1].length)
      end
    end
    # extra newline for better spacing
    puts ''
  end

  number_projects = merge_requests_and_issues_h.length
  puts "In total, over #{number_projects} projects there have been:"

  issues.each do |state_h|
    puts get_issue_line(state_h[0], state_h[1])
  end
  merge_requests.each do |state_h|
    puts get_merge_request_line(state_h[0], state_h[1])
  end
  puts ''
end

all_issues = follow_and_parse_pagination(ENDPOINT + '/issues', PRIVATE_TOKEN)
all_merge_requests = follow_and_parse_pagination(ENDPOINT + '/merge_requests', PRIVATE_TOKEN)

report_merge_requests_and_issues(merge_requests_and_issues_to_h(all_issues, all_merge_requests, ARGV[0]))
