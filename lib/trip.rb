class Trip < ActiveRecord::Base
    belongs_to :user
    belongs_to :city_from, :class_name => "City"
    belongs_to :city_to, :class_name => "City"
end