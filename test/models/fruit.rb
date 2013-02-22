class Fruit < ActiveRecord::Base

  attr_accessible :color

  define_reactor_callbacks :peel

  reactor FruitReactor

  def peel!
    run_callbacks :peel do
      self.peeled = true
    end
  end

end
