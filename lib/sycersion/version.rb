# frozen_string_literal: true

module Sycersion
  VERSION = File.exist?('.sycersion/version') ? File.read('.sycersion/version') : '0.1.0'
end
