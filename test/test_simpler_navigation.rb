# frozen_string_literal: true

require "test_helper"

class TestSimplerNavigation < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SimplerNavigation::VERSION
  end
end
