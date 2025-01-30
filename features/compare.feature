Feature: I can compare two versions
  Two versions can be compared regarding precedence. The semver guiding
  principle defines how versions are compared.

Scenario: A valid comparison is 1.0.0-alpha = 1.0.0-alpha 
    When I successfully run `sycersion --set 1.0.0-alpha`
    When I successfully run `sycersion --c 1.0.0-alpha`
    Then the stdout should contain "1.0.0-alpha = 1.0.0-alpha"

Scenario: A valid comparison is 1.0.0-alpha < 1.0.0-alpha.1 
    When I successfully run `sycersion --set 1.0.0-alpha`
    When I successfully run `sycersion --c 1.0.0-alpha.1`
    Then the stdout should contain "1.0.0-alpha < 1.0.0-alpha.1"

Scenario: A valid comparison is 1.0.0-alpha.1 < 1.0.0-alpha.beta 
    When I successfully run `sycersion --set 1.0.0-alpha.1`
    When I successfully run `sycersion --c 1.0.0-alpha.beta`
    Then the stdout should contain "1.0.0-alpha.1 < 1.0.0-alpha.beta"

Scenario: A valid comparison is 1.0.0-alpha.beta < 1.0.0-beta 
    When I successfully run `sycersion --set 1.0.0-alpha.beta`
    When I successfully run `sycersion --c 1.0.0-beta`
    Then the stdout should contain "1.0.0-alpha.beta < 1.0.0-beta"

Scenario: A valid comparison is 1.0.0-beta < 1.0.0-beta.2
    When I successfully run `sycersion --set 1.0.0-beta`
    When I successfully run `sycersion --c 1.0.0-beta.2`
    Then the stdout should contain "1.0.0-beta < 1.0.0-beta.2"

Scenario: A valid comparison is 1.0.0-beta.2 < 1.0.0-beta.11
    When I successfully run `sycersion --set 1.0.0-beta.2`
    When I successfully run `sycersion --c 1.0.0-beta.11`
    Then the stdout should contain "1.0.0-beta.2 < 1.0.0-beta.11"

Scenario: A valid comparison is 1.0.0-beta.11 < 1.0.0-rc.1
    When I successfully run `sycersion --set 1.0.0-beta.11`
    When I successfully run `sycersion --c 1.0.0-rc.1`
    Then the stdout should contain "1.0.0-beta.11 < 1.0.0-rc.1"

Scenario: A valid comparison is 1.0.0-rc.1 < 1.0.0
    When I successfully run `sycersion --set 1.0.0-rc.1`
    When I successfully run `sycersion --c 1.0.0`
    Then the stdout should contain "1.0.0-rc.1 < 1.0.0"

Scenario: A valid comparison is 1.0.0 < 1.1.0
    When I successfully run `sycersion --set 1.0.0`
    When I successfully run `sycersion --c 1.1.0`
    Then the stdout should contain "1.0.0 < 1.1.0"


