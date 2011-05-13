module ActsAsApi
  module Mongoid
    extend ActiveSupport::Concern

    included do
      extend ActsAsApi::Base
    end
  end
end
