[![Gem Version](https://badge.fury.io/rb/activerecord-reactor.png)](http://badge.fury.io/rb/activerecord-reactor) [![Code Climate](https://codeclimate.com/github/mtgrosser/activerecord-reactor.png)](https://codeclimate.com/github/mtgrosser/activerecord-reactor)

ActiveRecord::Reactor - Controlled reactions on ActiveRecord callbacks
======================================================================

ActiveRecord Reactors provide a defined way to react on default or custom Active Record callbacks. You may think of them as Observers without the magic, and without the hassle.

## Install
```
# In your Gemfile
gem 'activerecord-reactor'
```

## Usage

Define a custom reactor class, where you would use an Observer:

```ruby
class YummyReactor < ActiveRecord::Reactor
  after_create(record)
    puts "Yummy, #{record.color} #{record.class.name} created!" if record.is_a?(Fruit)
  end
end
```

Connect your models to the reactor:

```ruby
class Fruit < ActiveRecord::Base
  attr_accessor :peel
  
  reactor :yummy

  def color; end
end
```

You can also use custom model callbacks:

```ruby

class Tidy < ActiveRecord::Reactor
  def before_peel(record)
    record.wash!
  end

  def after_peel(record)
    GarbageCollector.dispose(record.peel)
  end
end

class Banana < Fruit
  # Use instead of define_model_callbacks if you want to register
  # the callback with reactors
  define_reactor_callbacks :peel

  # You can use the actual class if you do not want the reactor name end with 'Reactor'
  reactor Tidy

  def color
    'yellow'
  end

  def peel!
    run_callbacks :peel do
      self.peel = Object.new
    end
  end
end
```

