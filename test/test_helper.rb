ENV["RAILS_ENV"] = "test"

require 'pathname'

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
