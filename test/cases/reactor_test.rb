# encoding: utf-8

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
      b = Banana.create(color: 'blue')
      c = Cherry.create(color: 'red')
    end
    assert_empty FruitReactor.calls
    assert_equal false, FruitReactor.scrammed?
  end
end
