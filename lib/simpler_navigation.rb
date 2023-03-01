# frozen_string_literal: true

require "simpler_navigation/configuration"
require "simpler_navigation/item"
require "simpler_navigation/railtie"
require "simpler_navigation/renderers/breadcrumb"
require "simpler_navigation/renderers/list"
require "simpler_navigation/version"

module SimplerNavigation
  class Error < StandardError; end

  class << self
    attr_accessor :config
  end
end
