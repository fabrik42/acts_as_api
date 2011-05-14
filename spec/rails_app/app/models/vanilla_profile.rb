class VanillaProfile
  extend ActsAsApi::Base
  
  attr_accessor :user, :avatar, :homepage, :created_at, :updated_at
  
  def initialize(opts)
    opts.each do |k,v|
      self.send :"#{k}=", v
    end
  end
  
  def model_name
    'profile'
  end
  
end