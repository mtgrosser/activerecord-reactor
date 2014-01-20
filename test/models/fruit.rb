class Fruit < ActiveRecord::Base
  define_reactor_callbacks :peel

  reactor FruitReactor

  def peel!
    run_callbacks :peel do
      self.peeled = true
    end
  end

end
