class Order < ActiveRecord::Base
  belongs_to :address
  belongs_to :vendor
  has_many :tracking_events, :foreign_key => 'tracking_id', :class_name => "TrackingEvent"

  enum status: ['normal', 'not_normal', 'very_late']
  enum tracking_status: TrackingEvent.statuses.keys

  validates :number, presence: true
  validates :tracking_id,  uniqueness: { case_sensitive: false }, presence: true
  validates_presence_of :vendor
  accepts_nested_attributes_for :address

  before_save :copy_zip_from_address

  def copy_zip_from_address
    self.zip_code = address.zip_code if address.present?
  end


  # should be in presenter

  def dollar_total
    total / 100
  end

  def color_indicator
    if status == 'very_late'
      'danger'
    elsif status == 'not_normal'
      'warning'
    else
      ''
    end
  end
end
