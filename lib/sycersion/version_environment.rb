# frozen_string_literal: true

require 'yaml'
require 'fileutils'

module Sycersion
  VERSION_REGEX = /(\d+\.\d+\.\d+)-?(beta|staging|\w*)/.freeze

  # Creates a version and a version file where the version is stored to.
  class VersionEnvironment
    SYCERSION_DIR = '.sycersion'
    SYCERSION_ENV = '.sycersion/environment.yml'
    SYCERSION_VER = '.sycersion/version'

    def initialize
      return if load_environment

      determine_version_and_version_file
    end

    def setup
      puts 'Setup the version environment'
      puts '-----------------------------'
      puts
      prompt_version_and_version_file
      create_environment
      puts
      puts 'Your configuration'
      puts '------------------'
      puts
      puts "Version #{@version}"
      puts "Version-file #{@version_file}"
      puts
      puts create_code_snippet(@version_file)
    end

    def determine_version_and_version_file
      files = Dir.glob('**/*version*')
      files.each do |file|
        File.readlines(file, chomp: true).each do |line|
          scan_result = line.scan(VERSION_REGEX)
          if scan_result[0]
            @version_files[file] = [scan_result[0], line]
            break
          end
        end
      end
    end

    def prompt_version_and_version_file
      if File.exist?(SYCERSION_VER)
        print "Current version-file #{@version_file}. To keep hit RETURN otherwise specify new: "
        selection = gets.chomp
        @version_file = selection.empty? ? @version_file : selection
        print "Current version #{@version}. To keep hit RETURN otherwise enter new: "
        selection = gets.chomp
        @version = selection.empty? ? @version : selection
      elsif @version_files.empty?
        puts 'No version and version-file found'
        print "To use #{SYCERSION_VER} hit RETURN or specify own file: "
        selection = gets.chomp
        @version_file = selection.empty? ? SYCERSION_VER : selection
        print 'To use `0.0.1` as initial version or specify own version: '
        selection = gets.chomp.scan(VERSION_REGEX)
        @version = selection.empty? ? @version : selection
        @version_string = @version
      else
        if @version_files.size > 1
          puts 'Found version-files'
        else
          puts 'Found version-file'
        end
        @version_files.each_with_index do |entry, index|
          puts "#{index}: #{entry[0]} (version: #{version_string(entry[1][0])} in #{entry[1][1]}"
        end
        print 'Choose version-file and version with number or hit return for 0: '
        number = gets.chomp.to_i
        app_version_file = @version_files.keys[number]
        puts @version_files[app_version_file]
        @version = version_string(@version_files[app_version_file][0])
        @version_string = @version_files[@version_file[1]]
      end
    end

    def version_string(version_array)
      if version_array[1].empty?
        version_array[0]
      else
        version_array.join('-')
      end
    end

    def determine_version(version_file)
      if File.exist?(version_file)
        extract_version(File.read(version_file)) || '0.0.1'
      else
        '0.0.1'
      end
    end

    def extract_version(version_string)
      version_string.scan(VERSION_REGEX)[0]
    end

    def create_code_snippet(version_file)
      <<-CODE_SNIP
      In your application you can now access the version with

              File.read(#{version_file})

      If you application framework has a defined place to assign
      the version you could do like so

              version = File.read(#{version_file})
      CODE_SNIP
    end

    def create_environment
      FileUtils.mkdir(SYCERSION_DIR) unless Dir.exist?(SYCERSION_DIR)
      File.open(@version_file, 'w') do |f|
        f.write(@version)
      end
      File.open(SYCERSION_ENV, 'w') do |f|
        environment = [@version_file, @version]
        YAML.dump(environment, f)
      end
    rescue IOError => e
      puts e.message
    end

    def load_environment
      load_success = false
      if File.exist?(SYCERSION_ENV)
        @version_file, @version = YAML.load_file(SYCERSION_ENV)
        load_success = true
      else
        @version_file = SYCERSION_VER
        @version = '0.0.1'
      end
      @version_files = {}
      @version_string = ''
      load_success
    end
  end
end
