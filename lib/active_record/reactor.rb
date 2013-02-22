require 'singleton'

module ActiveRecord

  class Reactor

    include Singleton

    class << self
      def callbacks
        (self.public_instance_methods - ActiveRecord::Reactor.public_instance_methods).grep(/\A(before|around|after)_.+/)
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
