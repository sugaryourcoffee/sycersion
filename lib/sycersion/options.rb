# frozen_string_literal: true

require 'optparse'

# Creating and managing version following semver. Part commangline parsing
module Sycersion
  # Parses the commandline arguments provided by the user and provides them to
  # the calling class
  class Options
    attr_reader :options

    #    SEMVER_REGEX = /^(\d+\.\d+\.\d+)-?(beta|staging|\w*)?$/

    def initialize(argv)
      @options = {}
      parse(argv)
    end

    def parse(_argv)
      parser = OptionParser.new do |opts|
        opts.banner = banner

        opts.on('--init',
                'Setup the sycersion environment:',
                '* file where the app version is stored',
                '* initial version will be stored in version file',
                '* code that provides the version to the application') do |opt|
          @options[:init] = opt
        end

        opts.on('-i', '--info [VERSION|SUMMARY]', %i[version summary],
                'Print information about the application version and environment:',
                '* current version of the application (default)',
                '* file where the app version is stored',
                '* file where the version is read into the application') do |opt|
          @options[:info] = opt || :version
        end

        opts.on('--inc [MAJOR|MINOR|PATCH]', %i[major minor patch],
                'Increment the provided verion element (major, minor, patch)') do |opt|
          @options[:inc] = opt
        end

        opts.on('--set MAJOR.MINOR.PATCH[+BUILD|-PRE_RELEASE+BUILD]',
                Sycersion::SEMVER_REGEX,
                'Set the application version according to semver:',
                '* major.minor.patch optionally add a pre-release and/or build',
                '* major.minor.patch-prerelease+build or',
                '* major.minor.patch+build') do |opt|
          @options[:set] = opt
        end

        opts.on('-p', '--pre PRE_RELEASE', Sycersion::SEMVER_PRE_RELEASE_REGEX,
                'Set a pre-release suffix') do |opt|
          @options[:pre_release] = opt
        end

        opts.on('-b', '--build BUILD', Sycersion::SEMVER_BUILD_REGEX,
                'Set a build suffix') do |opt|
          @options[:build] = opt
        end

        opts.on('-h', '--help', 'Show this help') do
          puts opts
          exit(0)
        end
      end

      begin
        parser.parse!
      rescue OptionParser::ParseError => e
        warn e.message, "\n", options
        parser.opts if ENV['SYC_DEBUG']
        parser.parse(%w[--help])
        exit(1)
      end
    end

    def banner
      <<-CL_BANNER
        Usage: sycersion [options]

        sycersion supports applications to manage semantic versioning. Details
        can be found at https://semver.org

      CL_BANNER
    end
  end
end
