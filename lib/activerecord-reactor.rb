require 'active_record'
require 'active_record/reactor'
require 'active_record/reactor/callbacks'
require 'active_record/reactor/version'

ActiveRecord::Base.class_eval do
  include ActiveRecord::Reactor::Callbacks
end
