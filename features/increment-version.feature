Feature: I can increment the parts of the core version
  When I increment an element of the core version, the subsequent elements will
  be set to 0 and pre-release and build will be deleted.

Scenario: I increment the minor version element, then patch will become 0
    When I successfully run `sycersion --set 1.1.1`
    When I successfully run `sycersion --inc minor`
    And I successfully run `sycersion -i`
    Then the stdout should contain "1.2.0"

Scenario: I increment the major version element, then minor and patch will become 0
    When I successfully run `sycersion --set 1.1.1`
    When I successfully run `sycersion --inc major`
    And I successfully run `sycersion -i`
    Then the stdout should contain "2.0.0"


