class User < ActiveRecord::Base
  has_many :logs, :class_name => 'Log'
end
