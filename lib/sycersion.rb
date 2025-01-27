# frozen_string_literal: true

require_relative 'sycersion/version'
require_relative 'sycersion/options'
require_relative 'sycersion/version_environment'
require_relative 'sycersion/version_setter'
require_relative 'sycersion/version_changer'
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
        version_environment = Sycersion::VersionEnvironment.new
        version_environment.setup
      elsif @options[:set]
        Sycersion::VersionSetter.new(@options)
      elsif @options[:inc]
        Sycersion::VersionChanger.new(@options)
      elsif @options[:info]
        Sycersion::VersionInfo.new(@options)
      end
    end
  end
end
