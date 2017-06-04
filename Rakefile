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

task default: ['test']
