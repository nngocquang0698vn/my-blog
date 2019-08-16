---
title: "Easily Parsing Failed Cucumber Scenarios from the JSON Report"
description: "How to parse a Cucumber JSON report to display the failed scenarios and their causes."
tags:
- blogumentation
- cucumber
- ruby
- cli
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-16T15:20:35+01:00
slug: "cucumber-json-failed-scenarios"
image: /img/vendor/cucumber.png
---
Every so often, I have to deal with failing Cucumber tests. And even with [the best visualisations (as per my article _Prettier HTML Reports for Cucumber-JVM_)]({{< ref "2019-04-07-prettier-cucumber-jvm-html-reports" >}}), it can still be a pain to pick through the reporting to work out what's failing, and why.

So I decided instead I would script the parsing of the Cucumber JSON report, which can help me more easily determine what's wrong.

```ruby
#!/usr/bin/env ruby
require 'json'

report = JSON.parse(ARGF.read)
failed = []

report.each do |feature|
  feature['elements'].each do |scenario|
    next unless %w(scenario background).include? scenario['type']

    if scenario.key? 'before'
      scenario['before'].each do |step|
        if %w(failed undefined).include? step['result']['status']
          f = {
            feature: feature['name'],
            scenario: scenario['name'],
            step: 'Before hook',
            failure: step['result']['error_message']
          }

          f[:step] += ": #{step['match']['location']}" if step.key? 'match'

          failed << f
          break
        end
      end
    end

    scenario['steps'].each do |step|
      next unless step.key? 'result'
      if 'failed' == step['result']['status']
        failed << {
          feature: feature['name'],
          scenario: scenario['name'],
          step: step['keyword'] + step['name'],
          failure: step['result']['error_message']
        }
        break
      end
    end
  end
end

failed.each do |failure|
  puts "#{failure[:feature]}: #{failure[:scenario]}: #{failure[:step]}:"
  puts failure[:failure]
  puts ''
end
```

This can then be run, i.e. as:

```
# i.e. https://github.com/damianszczepanik/cucumber-reporting/raw/master/src/test/resources/json/sample.json
$ ruby cucumber-failures.rb sample.json
Second feature: Account may not have sufficient funds: Before hook: MachineFactory.wait():

Second feature: Account may not have sufficient funds: And the card is valid:

```

However, these steps don't have any errors to show, so the output is empty. But if we do have errors thrown that get caught by the Cucumber run, we would see i.e.

```
List: When I append to a list, it appends: Then the list has 1 item in it:
java.lang.RuntimeException: BOO
	at me.jvt.hacking.Steps.theListHasItemsInIt(Steps.java:41)
	at ✽.the list has 1 item in it(features/List.feature:6)
```
