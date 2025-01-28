# frozen_string_literal: true

# Managing the application's version according semver
module Sycersion
  # Provides information about the `sycersion` settings and the current version
  class VersionInfo
    def initialize
      @environment = Sycersion::VersionEnvironment.new
    end

    def process(options)
      case options[:info]
      when :version
        print @environment.version
      when :summary
        @environment.summary
      end
    end
  end
end
