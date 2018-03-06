class Address < ActiveRecord::Base
  has_many :orders
  validates :street, presence: true
  validates :city, presence: true
  validates :state, inclusion: { in: US_STATES.keys }
  validates :zip_code, numericality: true, length: { is: 5 }

  def state_zip
    "#{state}-#{zip_code}"
  end
end
