# Setting up the project
We are creating an application that is creating versions for applications
following the semantic versioning as defined in [semver.org](sever.org).

## Development environment
The application is written in Ruby in a test driven development manner using
rspec and cucumber with aruba. We are managing our source code in git.

There are two ways of setting up the development environment.

1. Using bundler to create a standard directory structure with most of the
   files or
2. Set up the structure manually

### Setup with bundler
To use bundler we just go into our working directory, select the Ruby version
we want to work with and then issue the bundle command

    $ cd ~/Work
    $ rvm ruby-2.5.7
    $ rvm gemset create sycersion
    $ rvm ruby-2.5.7@sycersio
    $ bundle gem sycersion

This will create a directory `~/Work/sycersion` with a directory structure

    +-- bin
    |   +-- console
    |   +-- setup
    +-- CODE_OF_CONDUCT.md
    +-- Gemfile
    +-- Gemfile.lock
    +-- lib
    |   +-- sycersion
    |   |   +-- version.rb
    |   +-- sycersion.rb
    +-- LICENSE.txt
    +-- Rakefile
    +-- README.md
    +-- spec
    |   +-- spec_helper.rb
    |   +-- sycersion_spec.rb
    +-- sycersion.gemspec

The `bundle gem sycersion` is also installing rspec and intializtion our git
repository. To also install _aruba_ we add it as an development dependency
to `sycersion.gemspec and run "bundle install".

In order to use _aruba_ with _cucumber_ we have to run

    $ cucumber --init
      create   features
      create   features/step_definitions
      create   features/support
      create   features/support/env.rb

### Setup manually
To set up the environment manually we do

* create a working directory
* create a gemset for the application
* install rspec and aruba
* add the application directory to git

    $ mkdir ~/Work/sycversion
    $ cd ~/Work/sycversion
    $ mkdir bin
    $ mkdir doc
    $ mkdir lib
    $ touch README.rdoc

We select the ruby version we want to develop the application with and create
the gemset for that ruby version

    $ rvm 2.5.7
    $ rvm gemset create sycversion

Change to the gemset sycversion

    $ rvm ruby-2.5.7@sycversion

Install respec and aruba for tests

    $ gem install rspec
    $ gem install aruba

Initialize test environment

    $ rspec --init

Add the working directory to git

    $ git init
    $ git add .
    $ git commit -am "initial commit"

Directory struckture after setup

    +-bin
    +-doc
      +-setup.md
    +-lib
    +-spec
      +-spec_helper.rb


