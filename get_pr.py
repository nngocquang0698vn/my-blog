#!/usr/bin/env python3

import urllib.request
import json
import os.path
import re

JSON_PATH = "prs.json"

def flatten(xss):
    return [x for xs in xss for x in xs]


def get_page_of_events(username, page=1):
    format_url = 'https://api.github.com/users/%s/events?page=%d' % (
            username, page)
    response = urllib.request.urlopen(format_url)
    encoding = response.info().get_content_charset('utf8')
    return json.loads(response.read().decode(encoding))


def get_x_pages_of(numPages, username):
    pages = []
    for pageNum in range(numPages):
        page = get_page_of_events(username, 1+pageNum)
        newPage = []
        for p in page:
            # is a PR
            if "PullRequestEvent" != p['type']:
                continue
            # opened PR
            if "opened" != p['payload']['action']:
                continue
            # TODO in December '16
            newPage.append(p)
        pages.append(newPage)
    return flatten(pages)


def is_24pr_event(e):
    if "PullRequestEvent" != e['type']:
        return False
    if "opened" != e['payload']['action']:
        return False
    if not e['payload']['pull_request']['created_at'].startswith("2016-12-"):
        return False
    return True


def markdownify_repos(repos):
    regex = re.compile(r"https://github.com/", re.IGNORECASE)
    ret = ""
    for repo in repos:
        ret += "- [%s](%s)\n" % (
                regex.sub("", repo['repo']),
                repo['repo']
                )
        for e in repo['prs']:
            ret += "    - [%s](%s)\n" % (
                    e['payload']['pull_request']['title'],
                    e['payload']['pull_request']['html_url']
                    )
    return ret


def get_by_key(xs, keyName, key):
    for x in xs:
        if x[keyName] == key:
            return x
    return None


def sort_by_repo(events):
    regex = re.compile(r"/pull/.*$", re.IGNORECASE)
    ret = []
    # get the ret[?]['repo']
    # otherwise, create
    for e in events:
        repo = regex.sub("", e['payload']['pull_request']['html_url'])
        v = get_by_key(ret, 'repo', repo)
        if v:
            v['prs'].append(e)
        else:
            v = {}
            v['repo'] = repo
            v['prs'] = [e]
            ret.append(v)
    return ret


if __name__ == "__main__":
    if not os.path.isfile(JSON_PATH):
        with open(JSON_PATH, 'w') as f:
            data = get_x_pages_of(10, "jamietanna")
            # print(type(data))
            # print(type(json.dumps(data)))
            f.write(json.dumps(data))

    jsonData = {}
    with open(JSON_PATH, 'r') as f:
        jsonData = json.loads(f.read())

    events = []
    for e in jsonData:
        if not is_24pr_event(e):
            continue
        events.append(e)

    repos = sort_by_repo(events)
    print(markdownify_repos(repos))
