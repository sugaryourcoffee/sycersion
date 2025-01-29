# frozen_string_literal: true

module Sycersion
  SEMVER_REGEX = /
    ^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)
    (?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
    (?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?
    (?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$
  /x.freeze

  SEMVER_LAX_REGEX = /
    (0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)
    (?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
    (?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?
    (?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?
  /x.freeze

  SEMVER_PRE_RELEASE_REGEX = /
    ^((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
    (?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?$
  /x.freeze

  SEMVER_BUILD_REGEX = /
    ^([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*)$
  /x.freeze

  # Semver contains methods to support semver operations
  class Semver
    # semver_array is of the form ["major", "minor", "patch", "pre-release",
    # "build"]. version creates a version string in the form
    # major.minor.patch-per-release+build. If only a build is given it creates
    # major.minor.patch+build.
    def self.version(semver_array)
      semver = "#{semver_array[0]}.#{semver_array[1]}.#{semver_array[2]}"
      semver += "-#{semver_array[3]}" unless semver_array[3].to_s.empty?
      semver += "+#{semver_array[4]}" unless semver_array[4].to_s.empty?
      semver
    end
  end
end
