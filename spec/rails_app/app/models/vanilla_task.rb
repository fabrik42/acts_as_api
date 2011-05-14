class VanillaTask
  extend ActsAsApi::Base

  attr_accessor :user, :heading, :description, :time_spent, :done, :created_at, :updated_at

  def initialize(opts)
    opts.each do |k,v|
      self.send :"#{k}=", v
    end
  end  
  
  def model_name
    'task'
  end

end