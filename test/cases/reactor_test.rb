require File.expand_path('../../test_helper', __FILE__)

class ReactorTest < ActiveSupport::TestCase

  setup do
    FruitReactor.calls.clear
    PeelReactor.calls.clear
  end

  test 'Callbacks are defined' do
    klass = Class.new(ActiveRecord::Base)
    assert_equal ActiveRecord::Base::CALLBACKS, klass.reactor_callbacks
    assert_equal ActiveRecord::Base::CALLBACKS + [:before_peel, :after_peel], Fruit.reactor_callbacks
    assert_equal ActiveRecord::Base::CALLBACKS + [:before_peel, :after_peel, :before_foo], Cherry.reactor_callbacks
    assert_equal ActiveRecord::Base::CALLBACKS + [:before_peel, :after_peel], Fruit.reactor_callbacks
  end

  test 'Callbacks are invoked' do
    b = Banana.create(color: 'blue')
    b.peel!
    c = Cherry.create(color: 'red')
    c.peel!
    assert_equal ['before_save blue Banana', 'after_create blue Banana', 'before_save red Cherry', 'after_create red Cherry'], FruitReactor.calls
    assert_equal ['before_peel blue Banana', 'after_peel blue Banana'], PeelReactor.calls
  end  

  test 'Scrammed reactors do not react' do
    FruitReactor.scram do
      Banana.create(color: 'blue')
      Cherry.create(color: 'red')
    end
    assert_empty FruitReactor.calls
    assert_equal false, FruitReactor.scrammed?
  end
  
  test 'Subclasses have their own mutex' do
    fruit_mutex = FruitReactor.send(:mutex)
    peel_mutex = PeelReactor.send(:mutex)
    assert_kind_of Mutex, fruit_mutex
    assert_kind_of Mutex, peel_mutex
    assert_not_equal fruit_mutex.object_id, peel_mutex.object_id
  end
  
  test 'Threading' do
    threads = 5.times.collect do
      Thread.new do
        100_000.times do
          FruitReactor.scram do
            #
          end
        end
      end
    end
    threads.each(&:join)
    assert_equal false, FruitReactor.scrammed?
  end
end
