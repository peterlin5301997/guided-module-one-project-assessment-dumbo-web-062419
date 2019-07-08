class User < ActiveRecord::Base
    has_many :trips
    has_many :cities, through: :trips
end