# frozen_string_literal: true

module Sycersion
  # Comparisson of two versions regarding semver guiding principles
  class VersionCompare
    COMPARATORS = ['=', '>', '<'].freeze
    SUFFIX_REGEX = /([A-Za-z\-|\d]+)/.freeze
    NUMBER_REGEX = /\A\d+\z/.freeze

    def initialize
      @current_version = Sycersion::VersionEnvironment.new.version
    end

    def compare(comparer, current = @current_version)
      comparer.shift
      current = current.scan(Sycersion::SEMVER_REGEX).flatten
      result = compare_core(current[0..2], comparer[0..2])
      result = compare_pre_release(current[3], comparer[3]) if result.zero?
      result_string(current, COMPARATORS[result], comparer)
    end

    def compare_core(core1, core2)
      3.times do |_i|
        result = less_equal_greater(core1.shift.to_i, core2.shift.to_i)
        return result unless result == 1
      end
      1
    end

    def compare_pre_release(version1, version2)
      result = compare_on_nil(version1, version2)
      return result unless result.zero?
      return 0 if version1.nil? && version2.nil?

      parts1 = version1.scan(SUFFIX_REGEX).flatten
      parts2 = version2.scan(SUFFIX_REGEX).flatten

      [parts1.size, parts2.size].min.times do |_i|
        value1 = parts1.shift
        value2 = parts2.shift
        v1_is_number = value1.match(NUMBER_REGEX)
        v2_is_number = value2.match(NUMBER_REGEX)
        result = compare_numerically(value1, value2) if v1_is_number && v2_is_number
        return result unless result.zero?
        return 1 if v2_is_number
        return -1 if v1_is_number

        result = compare_lexically(value1, value2)
        return result unless result.zero?
      end
      compare_pre_release_field_size(parts1, parts2)
    end

    def compare_pre_release_field_size(value1, value2)
      value1.size <=> value2.size
    end

    def compare_lexically(value1, value2)
      value1 <=> value2
    end

    def compare_numerically(value1, value2)
      value1.to_i <=> value2.to_i
    end

    def compare_on_nil(value1, value2)
      return 1 if value1.nil? && !value2.nil?
      return -1 if !value1.nil? && value2.nil?

      0
    end

    def less_equal_greater(value1, value2)
      return 0 if value1 == value2
      return 1 if value1 >  value2

      -1 if value1 < Value2
    end

    def result_string(value1, comparator, value2)
      "#{Sycersion::Semver.version(value1)} #{comparator} #{Sycersion::Semver.version(value2)}"
    end
  end
end
