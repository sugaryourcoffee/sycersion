# frozen_string_literal: true

require_relative 'sycersion/version'
require_relative 'sycersion/options'
require_relative 'sycersion/version_environment'
require_relative 'sycersion/version_setter'
require_relative 'sycersion/version_incrementer'
require_relative 'sycersion/version_info'

module Sycersion
  class Error < StandardError; end

  # Runs the program based on the arguments provided at the commandline
  class Runner
    def initialize(argv)
      @options = Options.new(argv).options
      pp @options
    end

    def run
      if @options[:init]
        Sycersion::VersionEnvironment.new.setup
      elsif @options[:set]
        Sycersion::VersionSetter.new.version = (@options[:set])
      elsif @options[:suffix]
        Sycersion::VersionSetter.new.suffix = (@options[:suffix])
      elsif @options[:inc]
        Sycersion::VersionIncrementer.new.increment(@options[:inc])
      elsif @options[:info]
        puts Sycersion::VersionInfo.new.process(@options)
      end
    end
  end
end
