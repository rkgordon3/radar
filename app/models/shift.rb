class Shift < ActiveRecord::Base
  belongs_to  	:staff
  has_many :rounds
  belongs_to :area
  
end
