# Setting up the project
We are creating an application that is creating versions for applications
following the semantic versioning as defined in [semver.org](sever.org).

## Development environment
The application is written in Ruby in a test driven development manner using
rspec. We are managing our source code in git.

To set up the environment we do

* create a working directory
* create a gemset for the application
* install rspec
* add the application directory to git

### Create the working directory
We setup a working directory structure

    $ mkdir ~/Work/sycversion
    $ cd ~/Work/sycversion
    $ mkdir bin
    $ mkdir doc
    $ mkdir lib
    $ touch README.rdoc

### Create the gemset
We select the ruby version we want to develop the application with and create
the gemset for that ruby version

    $ rvm 2.5.7
    $ rvm gemset create sycversion

Change to the gemset sycversion

    $ rvm ruby-2.5.7@sycversion

### Install rspec

    $ gem install rspec

Initialize test environment

    $ rspec --init

### Add the working directory to git

    $ git init
    $ git add .
    $ git commit -am "initial commit"

### Directory struckture after setup

    +-bin
    +-doc
      +-setup.md
    +-lib
    +-spec
      +-spec_helper.rb


