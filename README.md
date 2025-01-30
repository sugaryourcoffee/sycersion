# Sycersion

**sycersion** is a command-line tool to manage application versions following
the guiding principles of _semantic versioning_ found at
[semver.org](https://semver.org).

**sycersion** has a default start version of 0.1.0. This can be activitated with
the initalization running `sycersion --init`. During this intialization another
version can be chosen. The version is saved to the _version-file_ and also the
_configuration-directory_ is created. While initialization **sycersion**
additionally searches for files that contain a version according to semantic
versioning and the user can select out of the list of files which version out of
that files to intially start with.

The _version-file_ and _configuration-directory_ are also created it the user is
setting an initial version with `sycersion --set 0.1.1`. 

If the version is updated the version is written into the _version-file_. Within
the application the version can be read from the file and displayed somewhere in
the application's UI.

**sycersion** evaluates version numbers provided that they comply to semantic
versioning.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sycersion'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sycersion

## Usage

* `--init`
  Initializes the **sycersion** environment with _version_ and _version-file_
* `-i`, `--info VERSION|SUMMARY`
  Shows the current _version_ (default) or additionally information about the
  _version-file_, the _configuration-directory_ and _code_ how to read the
  version within an application.
* `--inc MAJOR|MINOR|PATCH` 
  increments the major, minor, patch part of the version.
* `--set MAJOR.MINOR.PATCH[+BUILD|-PRE_RELEASE[+BUILD]]` 
  sets the version where all three version parts need to be provided,
  major.minor.patch with optionally adding a pre-release part and/or a build
  part.
* `--pre PRE-RELEASE`
  Set the pre-release part in the version
* `--build BUILD`
  Set the build part in the version
* `-c`, `--compare VERSION`
  Compares the current version with the version provided following the semver
  precedence guidline 
* `--help`
  Prints the command line help

## Examples

Initialize **sycersion**

    $ sycersion --init

Set the version with pre-release

    $ sycersion --set 0.1.1-beta.1.0

Set the version with a build

    $ sycersion --set 0.1.1+build-a.1

Set the version with a pre-release and a build

    $ sycersion --set 0.1.1-beta.1.0+build-a.1

Show the current version

    $ sycersion -i
    0.1.1-beta.1.0+build-a.1
    
Increment minor part of the version 0.1.1, which will lead to 0.2.0

    $ sycersion --inc minor
    $ sycersion -i
    0.2.0

When increasing one of major, minor or patch, the subsequent numbers are eather
reset to 0 or pre-release and build are removed.

Compare the assumed current version 0.1.1 to the provided version

    $ sycersion -c 0.1.1-alpha
    0.1.1 > 0.1.1-alpha

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake features` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number with `sycersion --set X.Y.Z` while the version is accessible in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sugaryourcoffee/sycersion. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sycersion project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sycersion/blob/master/CODE_OF_CONDUCT.md).
