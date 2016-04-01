ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def disrespect_privacy(object_or_class, &block)   # access private methods in a block
    raise ArgumentError, 'Block must be specified' unless block_given?
    yield Disrespect.new(object_or_class)
  end

  class Disrespect
    def initialize(object_or_class)
      @object = object_or_class
    end
    def method_missing(method, *args)
      @object.send(method, *args)
    end
  end

end

class ActionController::TestCase
  include Devise::TestHelpers
end
