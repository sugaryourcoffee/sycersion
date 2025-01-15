require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Cucumber::Rake::Task.new(:features) do |task|
  task.cucumber_opts = "features --format pretty -x"
  task.fork = false
end
