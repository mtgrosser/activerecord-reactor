require 'active_record'
require_relative 'active_record/reactor'
require_relative 'active_record/reactor/callbacks'
require_relative 'active_record/reactor/version'

ActiveRecord::Base.include ActiveRecord::Reactor::Callbacks

