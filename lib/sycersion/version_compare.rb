# frozen_string_literal: true

module Sycersion
  # Comparisson of two versions regarding semver guiding principles
  class VersionCompare
    COMPARATORS = ['=', '>', '<'].freeze
    SUFFIX_REGEX = /([A-Za-z\-|\d]+)/.freeze
    NUMBER_REGEX = /\A\d+\z/.freeze

    def initialize
      @current_version = Sycersion::VersionEnvironment.new
                                                      .version
                                                      .scan(Sycersion::SEMVER_REGEX)
                                                      .flatten
    end

    # Compares two semantic versions. The expected representation of the versions is:
    # ["major", "minor", "patch", "pre-release", "build"]
    def compare(comparer, current = @current_version)
      result = compare_core(current[0..2], comparer[0..2])
      result = compare_pre_release(current[3], comparer[3]) if result.zero?
      result_string(current, COMPARATORS[result], comparer)
    end

    def compare_core(core1, core2)
      3.times do |_i|
        result = core1.shift.to_i <=> core2.shift.to_i
        return result unless result.zero?
      end
      0
    end

    def compare_pre_release(version1, version2)
      result = compare_on_nil(version1, version2)
      return result unless result.zero? && !(version1.nil? && version2.nil?)

      parts1 = version1.scan(SUFFIX_REGEX).flatten
      parts2 = version2.scan(SUFFIX_REGEX).flatten

      result = compare_parts(parts1, parts2)
      return result unless result.zero?

      compare_pre_release_field_size(parts1, parts2)
    end

    def compare_parts(parts1, parts2)
      [parts1.size, parts2.size].min.times do |_i|
        value1 = parts1.shift
        value2 = parts2.shift

        result = compare_numerically(value1, value2)
        return result unless result.zero?

        result = compare_lexically(value1, value2)
        return result unless result.zero?
      end
      0
    end

    def compare_pre_release_field_size(value1, value2)
      value1.size <=> value2.size
    end

    def compare_lexically(value1, value2)
      value1 <=> value2
    end

    def compare_numerically(value1, value2)
      v1_is_number = value1.match(NUMBER_REGEX)
      v2_is_number = value2.match(NUMBER_REGEX)
      result = value1.to_i <=> value2.to_i if v1_is_number && v2_is_number
      return result unless result.nil? || result.zero?
      return 1 if v2_is_number
      return -1 if v1_is_number

      0
    end

    def compare_on_nil(value1, value2)
      return 1 if value1.nil? && !value2.nil?
      return -1 if !value1.nil? && value2.nil?

      0
    end

    def result_string(value1, comparator, value2)
      "#{Sycersion::Semver.version(value1)} #{comparator} #{Sycersion::Semver.version(value2)}"
    end
  end
end
