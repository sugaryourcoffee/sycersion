# frozen_string_literal: true

module Sycersion
  NORMAL_REGEX = /^(\d+)\.(\d+)\.(\d+)/.freeze

  # Increments the elements of a semantic version number major, minor, patch
  class VersionIncrementer
    def initialize
      @environment = Sycersion::VersionEnvironment.new
    end

    def increment(position)
      @environment.version = case position
                             when :major
                               increment_major
                             when :minor
                               increment_minor
                             when :patch
                               increment_patch
                             end
      @environment.save
    end

    def increment_major
      "#{current_version[0].to_i + 1}.0.0"
    end

    def increment_minor
      "#{current_version[0]}.#{current_version[1].to_i + 1}.0"
    end

    def increment_patch
      "#{current_version[0]}.#{current_version[1]}.#{current_version[2].to_i + 1}"
    end

    def current_version
      @environment.version.scan(NORMAL_REGEX).flatten
    end
  end
end
