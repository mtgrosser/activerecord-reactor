module ActiveRecord

  class Reactor

    module Callbacks

      def self.included(base) # :nodoc:
        base.extend ClassMethods
        base.class_attribute :reactor_callbacks
        base.reactor_callbacks = ActiveRecord::Base::CALLBACKS.dup
      end

      module ClassMethods

        # Define a custom model callback, which is available to reactors registered with
        # that model. Works like <tt>ActiveModel::define_model_callbacks</tt>, but does not
        # define <tt>around</tt> callbacks by default.
        #
        # Make sure to define any custom callbacks before registering any reactors
        # with your model that should react on that callback.
        #
        def define_reactor_callbacks(*args)
          options = args.extract_options!
          options[:only] ||= [:before, :after] # TODO: implement around callbacks
          types = Array.wrap(options[:only])
          define_model_callbacks(*(args.dup << options))
          def args.combine(other, &block)
            return product(other) unless block_given?
            product(other).inject([]) { |result, ab| result << yield(ab.first, ab.last) }
          end
          self.reactor_callbacks = (reactor_callbacks + args.combine(types) { |arg, type| :"#{type}_#{arg}" }).uniq
        end

        # Register a reactor with the model. Note that only callbacks defined on the reactor at
        # the time of registration will be called.
        #
        # <tt>klass_or_name<tt> can be an actual reactor class, or a string or symbol.
        #
        #  class Banana < ActiveRecord::Base
        #    # register YummyReactor
        #    reactor :yummy
        #
        #    # register reactor CustomName
        #    reactor CustomName
        #  end
        #
        def reactor(klass_or_name)
          reactor = klass_or_name.is_a?(Class) ? klass_or_name : "#{klass_or_name.to_s.camelize}Reactor".constantize
          (reactor.callbacks & self.reactor_callbacks).each do |callback|
            send(callback) { |record| reactor.instance.send(callback, record) unless reactor.scrammed?; true }
          end
        end

      end

    end

  end

end
