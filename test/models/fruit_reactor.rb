class FruitReactor < ActiveRecord::Reactor

  class << self
    delegate :calls, to: :instance
  end

  def calls
    @calls ||= []
  end

  def before_save(record)
    puts "#{self.class.name}#before_save #{record.color} #{record.class.name}"
    calls << "before_save #{record.color} #{record.class.name}"
  end

  def after_create(record)
    puts "#{self.class.name}#after_create #{record.color} #{record.class.name}"
    calls << "after_create #{record.color} #{record.class.name}"
  end

end
