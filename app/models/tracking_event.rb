class TrackingEvent < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :order, :foreign_key => 'tracking_id', :class_name => "Order"
  enum status: ['warehouse',
                'dispatched',
                'distribution',
                'out_for_delivery',
                'delivered']

  after_create :set_previous_duration, :if => Proc.new {|t| !t.warehouse?}
  after_create :update_order_tracking_status

  validates :tracking_id,  uniqueness: { case_sensitive: false, scope: :status }, presence: true

  def update_order_tracking_status
    # dont know why helper method 'order' isn't working
    Order.where(tracking_id: tracking_id).update_all(tracking_status: read_attribute('status'))
  end

  def set_previous_duration # should really be in a TrackingEventCreator service not callback
    prev_event = TrackingEvent.where(tracking_id: tracking_id, status: (read_attribute('status') - 1)).first
    raise 'MISSING EVENT' unless prev_event.present?
    prev_event.duration = (created_at - prev_event.created_at)
    prev_event.save
  end
  handle_asynchronously :set_previous_duration
end
