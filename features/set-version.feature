Feature: I can set the version 
  When I create a new application, I want to set the intitial version following
  the semver guiding principles. A fresh install won't have a .sycersion/version file.

Scenario: The default version is shown
    Given the file "./.sycersion/version" doesn't exist
    When I successfully run `sycersion -i`
    Then the stdout should contain "0.0.1"

Scenario: Set the version core
    When I successfully run `sycersion --set 0.1.1`
    Then I successfully run `sycersion -i`
    And the stdout should contain "0.1.1"

Scenario: Set the version with a pre-release
    When I successfully run `sycersion --set 0.1.0-beta-1.0`
    Then I successfully run `sycersion -i`
    And the stdout should contain "0.1.0-beta-1.0"
    
Scenario: Set the version with a pre-release and build
    When I successfully run `sycersion --set 0.1.0-beta-1.0+build.0.1`
    Then I successfully run `sycersion -i`
    And the stdout should contain "0.1.0-beta-1.0+build.0.1"

Scenario: Set the version with a build
    When I successfully run `sycersion --set 0.1.0+build.0.1`
    Then I successfully run `sycersion -i`
    And the stdout should contain "0.1.0+build.0.1"

