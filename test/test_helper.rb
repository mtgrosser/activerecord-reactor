ENV["RAILS_ENV"] = "test"

require 'pathname'

if RUBY_VERSION >= '1.9'
  require 'simplecov'
  SimpleCov.start do
    if artifacts_dir = ENV['CC_BUILD_ARTIFACTS']
      coverage_dir Pathname.new(artifacts_dir).relative_path_from(Pathname.new(SimpleCov.root)).to_s
    end
    add_filter '/test/'
    add_filter 'vendor'
  end

  SimpleCov.at_exit do
    SimpleCov.result.format!
    if result = SimpleCov.result
      File.open(File.join(SimpleCov.coverage_path, 'coverage_percent.txt'), 'w') { |f| f << result.covered_percent.to_s }
    end
  end
end

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'active_support/testing/autorun'
require 'active_support/test_case'

require 'active_record'
require 'activerecord-reactor'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

require File.expand_path('../schema', __FILE__)
require File.expand_path('../support/custom_assertions', __FILE__)

require File.expand_path('../models/fruit_reactor', __FILE__)
require File.expand_path('../models/peel_reactor', __FILE__)
require File.expand_path('../models/fruit', __FILE__)
require File.expand_path('../models/banana', __FILE__)
require File.expand_path('../models/cherry', __FILE__)

class ActiveSupport::TestCase
  include CustomAssertions
end
