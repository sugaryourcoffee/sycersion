# frozen_string_literal: true

require 'yaml'
require 'fileutils'

module Sycersion
  SYCERSION_DIR = '.sycersion'
  SYCERSION_ENV = '.sycersion/environment.yml'
  SYCERSION_VER = '.sycersion/version'

  # Creates a version and a version file where the version is stored to.
  class VersionEnvironment
    attr_accessor :version

    def initialize
      return if load_environment

      determine_version_and_version_file
    end

    def setup
      puts "\nSetup the version environment"
      puts "=============================\n"
      prompt_version_and_version_file
      create_environment
      summary
    end

    def summary
      summary_of_configuration
      summary_of_environment
    end

    def summary_of_configuration
      puts "\nYour configuration"
      puts "------------------\n"
      puts "\nVersion #{@version}"
      puts "Version-file #{@version_file}\n"
      puts create_code_snippet(@version_file)
    end

    def summary_of_environment
      puts "\nWhere to find the configuration files"
      puts "-------------------------------------\n"
      puts "\nDirectory:          #{SYCERSION_DIR}"
      puts "Configuration file: #{SYCERSION_ENV}\n"
      puts "\nChange the configuration file only if you know what you are doing."
      puts 'Otherwise run `sycersion --init` again.'
    end

    def determine_version_and_version_file
      files = Dir.glob('**/*version*')
      files.each do |file|
        File.readlines(file, chomp: true).each do |line|
          scan_result = line.scan(Sycersion::SEMVER_LAX_REGEX)
          if scan_result[0]
            @version_files[file] = [scan_result[0], line]
            break
          end
        end
      end
    end

    def prompt_version_and_version_file
      if File.exist?(SYCERSION_VER)
        resume_version_and_version_file
      elsif @version_files.empty?
        define_version_and_version_file
      else
        select_version_and_version_file
      end
    end

    def resume_version_and_version_file
      print "Current version-file #{@version_file}. To keep hit RETURN otherwise specify new: "
      selection = gets.chomp
      @version_file = selection.empty? ? @version_file : selection
      print "Current version #{@version}. To keep hit RETURN otherwise enter new: "
      selection = gets.chomp
      @version = selection.empty? ? @version : selection
    end

    def define_version_and_version_file
      puts 'No version and version-file found'
      print "To use #{SYCERSION_VER} hit RETURN or specify own file: "
      selection = gets.chomp
      @version_file = selection.empty? ? SYCERSION_VER : selection
      print 'To use `0.0.1` as initial version hit RETURN or specify own version: '
      selection = gets.chomp.scan(Sycersion::SEMVER_REGEX)
      @version = selection.empty? ? @version : selection
      @version_string = @version
    end

    def select_version_and_version_file
      puts "\nFound version-files\n"
      puts "-------------------\n"
      list_versions_and_version_files
      print "\nChoose version-file and version with number or hit return for [0]: "
      selection = gets.chomp.to_i
      app_version_file = @version_files.keys[selection]
      @version = Sycersion::Semver.version(@version_files[app_version_file][0])
      @version_string = @version_files[@version_file[1]]
    end

    def list_versions_and_version_files
      digits = digit_counter(@version_files)
      filler = filler_string(' ', digits + 2)
      @version_files.each_with_index do |entry, index|
        choice = "[#{index.to_s.rjust(digits, ' ')}]"
        print_line(choice, 'file:   ', entry[0])
        print_line(filler, 'version:', Sycersion::Semver.version(entry[1][0]))
        print_line(filler, 'line:   ', (entry[1][1]).strip)
      end
    end

    def digit_counter(object)
      object.size.to_s.length
    end

    def filler_string(fill_char, size)
      fill_char * size
    end

    def print_line(prescriptor, descriptor, value)
      puts "#{prescriptor} #{descriptor} #{value}"
    end

    def create_code_snippet(version_file)
      <<-CODE_SNIP

      In your application you can now access the version with

      > File.read(#{version_file})

      If you application framework has a defined place to assign
      the version you could do like so

      > version = File.read(#{version_file})
      CODE_SNIP
    end

    def save
      create_environment
    end

    def create_environment
      FileUtils.mkdir(SYCERSION_DIR) unless Dir.exist?(SYCERSION_DIR)
      File.open(@version_file, 'w') { |f| f.write(@version) }
      File.open(SYCERSION_ENV, 'w') do |f|
        YAML.dump([@version_file, @version], f)
      end
    rescue IOError => e
      puts e.message
    end

    def load_environment
      if File.exist?(SYCERSION_ENV)
        @version_file, @version = YAML.load_file(SYCERSION_ENV)
        true
      else
        @version_file = SYCERSION_VER
        @version = '0.0.1'
        @version_files = {}
        @version_string = ''
        false
      end
    end
  end
end
