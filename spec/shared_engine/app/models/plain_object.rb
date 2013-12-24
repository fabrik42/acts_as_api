class PlainObject < Struct.new(:first_name, :last_name, :age, :active)
  extend ActsAsApi::Base

  def initialize(opts)
    opts.each do |k, v|
      send("#{k}=", v)
    end
  end

  def model_name
    'plain_object'
  end

  acts_as_api

  include SharedEngine::UserTemplate
end
