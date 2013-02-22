class PeelReactor < ActiveModel::Reactor

  class << self
    delegate :calls, to: :instance
  end

  def calls
    @calls ||= []
  end

  def before_peel(record)
    puts "#{self.class.name}#before_peel #{record.color} #{record.class.name}"
    calls << "before_peel #{record.color} #{record.class.name}"
  end

  def after_peel(record)
    puts "#{self.class.name}#after_peel #{record.color} #{record.class.name}"
    calls << "after_peel #{record.color} #{record.class.name}"
  end

end
