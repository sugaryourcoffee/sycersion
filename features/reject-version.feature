Feature: Uncompliant semver version will be rejected When I provide a
  uncompliant semver version it will be rejected and the orgiginally set version
  will stay unchanged. The default version is 0.0.1.

Scenario: The core version must be of the form X.Y.Z with non-negative numbers
    When I run `sycersion --set -1.1.0`
    And I successfully run `sycersion -i`
    Then the stdout should contain "0.0.1"

Scenario: The core version must be of the form X.Y.Z with numbers only
    When I run `sycersion --set v0.1.0`
    And I successfully run `sycersion -i`
    Then the stdout should contain "0.0.1"

Scenario: The core version must be of the form X.Y.Z without leading 0 to X
    When I run `sycersion --set 00.1.0`
    And I successfully run `sycersion -i`
    Then the stdout should contain "0.0.1"

Scenario: The core version must be of the form X.Y.Z without leading 0 to Y
    When I run `sycersion --set 0.01.0`
    And I successfully run `sycersion -i`
    Then the stdout should contain "0.0.1"

Scenario: The core version must be of the form X.Y.Z without leading 0 to Z
    When I run `sycersion --set 0.1.00`
    And I successfully run `sycersion -i`
    Then the stdout should contain "0.0.1"

Scenario: To set incompliant semver (core+build+build) should be rejected
    Given the file "./.sycersion/version" doesn't exist
    When I run `sycersion --set 0.1.0+build.0.1+alpha-1.0`
    Then I successfully run `sycersion -i`
    And the stdout should contain "0.0.1"

