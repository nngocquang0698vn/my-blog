require 'github_api'

PRIVATE_TOKEN = ENV['GITHUB_TOKEN'].freeze

def report_merge_requests_and_issues(merge_requests_and_issues_h)
  merge_requests_and_issues_h.each do |project_id, h|
    puts "Project #{h['name']} has had:"

    if h['issues']
      h['issues'].each do |state_h|
        out = "- #{state_h[1].length} issues "
        case state_h[0]
        when 'open'
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
        when 'open'
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


def collect_issues_and_merge_requests_h(github_token, year_to_use)
  github = Github.new oauth_token: github_token
  issues = github.issues.list filter: 'created'
  h = {}
  issues.each do |i|
    d = Date.parse(i['created_at'])
    next unless year_to_use.to_i == d.year

    repo_id = i['repository']['id']
    h[repo_id] ||= {
      'issues' => {
        'closed' => [],
        'open' => []
      },
      'merge_requests' => {
        'closed' => [],
        'open' => []
      },
      'name' => i['repository']['full_name']
    }

    state = i['state']

    if i['pull_request']
      h[repo_id]['merge_requests'][state] << i
    else
      h[repo_id]['issues'][state] << i
    end

  end
  h
end

h = collect_issues_and_merge_requests_h(PRIVATE_TOKEN, ARGV[0])
report_merge_requests_and_issues h
