# frozen_string_literal: true

module Sycersion
  SUFFIX_REGEX = /^[\d.]*(-\w*)$/.freeze

  # Sets the version
  class VersionSetter
    def initialize
      @environment = Sycersion::VersionEnvironment.new
    end

    # Sets the version provided by the version array. The version array is in
    # the form ["version-suffix", "version", "suffix"]
    def version=(version)
      @environment.version = if version[2].empty?
                               version[1]
                             else
                               "#{version[1]}-#{version[2]}"
                             end
      @environment.save
    end

    # Sets the suffix only
    def suffix=(suffix)
      version = @environment.version
      current_suffix = version.scan(SUFFIX_REGEX).flatten.first
      @environment.version = if current_suffix.nil?
                               "#{version}-#{suffix}"
                             else
                               version.sub(current_suffix, "-#{suffix}")
                             end
      @environment.save
    end
  end
end
