require 'active_model'
require 'singleton'

module ActiveModel

  class Reactor

    module Callbacks

      def self.included(base)
        base.extend ClassMethods
        base.class_attribute :reactor_callbacks
        base.reactor_callbacks = []
      end

      module ClassMethods

        def define_reactor_callbacks(*args)
          options = args.extract_options!
          options[:only] ||= [:before, :after] # TODO: implement around callbacks
          types = Array.wrap(options[:only])
          define_model_callbacks(*(args << options))
          def args.combine(other, &block)
            return product(other) unless block_given?
            product(other).inject([]) { |result, ab| result << yield(ab.first, ab.last) }
          end
          self.reactor_callbacks = (reactor_callbacks + args.combine(types) { |arg, type| :"#{type}_#{arg}" }).uniq
        end

        def reactor(klass_or_name)
          reactor = klass_or_name.is_a?(Class) ? klass_or_name : "#{klass_or_name.to_s.camelize}Reactor".constantize
          (reactor.callbacks & self.reactor_callbacks).each do |callback|
            send(callback) { |record| reactor.instance.send(callback, record) unless reactor.scrammed?; true }
          end
        end

      end

    end

    include Singleton

    class << self
      def callbacks
        (self.public_instance_methods - ActiveModel::Reactor.public_instance_methods).grep(/\A(before|around|after)_.+/)
      end

      def scrammed?
        !!@scrammed
      end

      def scram(&block)
        previously_scrammed = @scrammed
        @scrammed = true
        yield
      ensure
        @scrammed = previously_scrammed
      end
    end
  end

end
