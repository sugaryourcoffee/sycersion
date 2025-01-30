# frozen_string_literal: true

Given(/^the file "([^"]*)" doesn't exist$/) do |file|
  FileUtils.rm(file) if File.exist? file
end
