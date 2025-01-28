# frozen_string_literal: true

require_relative 'sycersion/version'
require_relative 'sycersion/options'
require_relative 'sycersion/version_environment'
require_relative 'sycersion/version_setter'
require_relative 'sycersion/version_incrementer'
require_relative 'sycersion/version_info'
require_relative 'sycersion/semver'

module Sycersion
  class Error < StandardError; end

  # Runs the program based on the arguments provided at the commandline
  class Runner
    def initialize(argv)
      @options = Options.new(argv).options
      pp @options if ENV['SYC_DEBUGW']
    end

    def run
      environment_settings
      version_manipulation
      configuration_information
    end

    def environment_settings
      Sycersion::VersionEnvironment.new.setup if @options[:init]
    end

    def version_manipulation
      case @options
      when :set
        Sycersion::VersionSetter.new.version = (@options[:set])
      when :pre_release
        Sycersion::VersionSetter.new.pre_release = (@options[:pre_release])
      when :build
        Sycersion::VersionSetter.new.build = (@options[:build])
      when :inc
        Sycersion::VersionIncrementer.new.increment(@options[:inc])
      end
    end

    def configuration_information
      puts Sycersion::VersionInfo.new.process(@options) if @options[:info]
    end
  end
end
