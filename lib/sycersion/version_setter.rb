# frozen_string_literal: true

module Sycersion
  # Sets the version
  class VersionSetter
    def initialize
      @environment = Sycersion::VersionEnvironment.new
    end

    # Sets the version provided by the version array. The version array is in
    # the form ["version", "major", "minor", "patch", "pre-release", "build"]
    def version=(version)
      @environment.version = version[0]
      @environment.save
    end

    # Sets the pre-release part only. The pre-release parameter is of the form
    # ["pre-release", "pre-release"]
    def pre_release=(pre_release)
      create_version(3, pre_release[0])
    end

    # Sets the build part only. The build parameter is of the form
    # ["build", "build"]
    def build=(build)
      create_version(4, build[0])
    end

    # Helper method for build= and pre_release=
    def create_version(position, value)
      version = @environment.version
      semver_array = version.scan(Sycersion::SEMVER_REGEX).flatten
      semver_array[position] = value
      @environment.version = Sycersion::Semver.version(semver_array)
      @environment.save
    end
  end
end
