require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  test "can get map" do
    loc = Location.first.get_map
    assert_not_predicate loc, :empty?
  end

end
