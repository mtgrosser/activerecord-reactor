require 'singleton'

module ActiveRecord
  # = Active Record Reactors
  #
  # ActiveRecord Reactors provide a defined way to react on default or custom <tt>ActiveRecord::Callbacks</tt>.
  # You may think of a Reactor as an <tt>Observer</tt> which is explicitly registered with one or more models,
  # and does not define any magic methods.
  #
  # When a Reactor is registered with a model, it checks which of the model's callbacks are also defined as
  # reactor instance methods, and adds these to the model's callback chain.
  #
  # Reactor callbacks will always return <tt>true</tt>, therefore it is not possible to halt the callback
  # chain from a reactor. If you want to do that, you should consider moving the code inside the model.
  #
  # Examples:
  #
  #   class YummyReactor < ActiveRecord::Reactor
  #     after_create(record)
  #       puts "Yummy, #{record.color} #{record.class.name} created!" if record.is_a?(Fruit)
  #     end
  #   end
  #
  #   class Fruit < ActiveRecord::Base
  #     attr_accessor :peel
  #
  #     # Connect your model to the reactor
  #     reactor :yummy
  #
  #     def color; end
  #   end
  #
  # == Reactor scramming
  #
  # Reactors can be halted temporarily using the <tt>scram</tt> class method.
  #
  #   class Apple < Fruit; end
  #
  #   YummyReactor.scram do
  #     Apple.create! # do not trigger reaction on YummyReactor
  #   end
  #
  class Reactor

    include Singleton

    class << self
      def callbacks # :nodoc:
        (self.public_instance_methods - ActiveRecord::Reactor.public_instance_methods).grep(/\A(before|around|after)_.+/)
      end
      
      def scrammed? # :nodoc:
        !!@scrammed
      end

      # Stops all reactions while inside the (required) block.
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
