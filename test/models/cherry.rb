class Cherry < Fruit
  define_reactor_callbacks :foo, only: :before
end
