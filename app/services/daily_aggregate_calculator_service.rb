class DailyAggregateCalculatorService
  def initialize(zip:, vendor_id:, date:)
    @zip = zip
    @vendor = Vendor.find(vendor_id)
    @date = date
  end

  attr_reader :zip, :vendor, :date

  def run
    params = days_aggregates.merge(
      'zip_code' => zip,
      'vendor_id' => vendor.id,
      'date' => date,
      'lat' => average_lat,
      'lng' => average_lng
      )
    DailyVendorOrderDurationAgg.create(params)
  end

  private

  def days_tracking_events
    @tracking_events ||= TrackingEvent.where(
      zip_code: zip,
      vendor: vendor,
      created_at: date.at_beginning_of_day..date.at_end_of_day)
  end

  def tracking_ids
    days_tracking_events.pluck(:tracking_id).uniq
  end

  def days_aggregates
    aggregates = {}
    TrackingEvent.statuses.keys.map do |status|
      # in real world would raise or error handle if any durations were missing
      aggregates[status] = days_tracking_events.send(status).average(:duration).to_i
    end
    aggregates.delete('delivered') # will never have duration
    aggregates
  end

  def average_lat
    #TODO get all orders via tracking_ids and average lat
    0
  end

  def average_lng
    #TODO get all orders via tracking_ids and average lng
    0
  end
end