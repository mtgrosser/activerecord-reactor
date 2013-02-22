require 'active_record'

module ActiveRecord
  class Reactor < ActiveModel::Reactor
  end

  Base.class_eval do
    include ActiveModel::Reactor::Callbacks
    self.reactor_callbacks = Base::CALLBACKS.dup
  end
end

