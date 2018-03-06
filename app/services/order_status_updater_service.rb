class OrderStatusUpdaterService
  def run
    # for each zip
    #   compare this orders current duration with average
    #   set all orders statuses
    vendor_ids.each do |vendor_id|
      zip_codes.each do |zip|
        aggregate(vendor_id,zip).present? ? set_statuses(vendor_id,zip) : nil # could implement checks via nearby aggs
        @aggregate = nil
      end
    end
  end

  def not_delivered_orders
    ndos ||= Order.where.not(
               tracking_status: TrackingEvent.statuses['delivered']
             ).includes(:vendor,:address)
  end

  def relevant_durations
    statuses = not_delivered_orders.map(&:tracking_status)
    durations.select{|dur,i| statuses.include? dur}
  end

  def vendor_ids
    not_delivered_orders.pluck(:vendor_id).uniq
  end

  def zip_codes
    not_delivered_orders.pluck(:zip_code).uniq
  end

  def set_statuses(vendor_id, zip)
    relevant_durations.each do |duration,tracking_status_int|
      # not normal
      not_delivered_for_vendor_zip_tracking_status(
        vendor_id,
        zip,
        tracking_status_int)
        .where("created_at < ?", normal_cut_off_time(duration))
        .update_all(status: 1)
      # very late
      not_delivered_for_vendor_zip_tracking_status(
        vendor_id,
        zip,
        tracking_status_int)
        .where("created_at < ?", late_cut_off_time(duration))
        .update_all(status: 2)
    end
  end

  def not_delivered_for_vendor_zip_tracking_status(vendor_id,zip,ts)
    not_delivered_orders
      .where(
        vendor_id: vendor_id,
        zip_code: zip,
        tracking_status: ts)
  end

  def aggregate(vendor_id,zip)
    @aggregate ||= VendorOrderDurationAggregate.where(
      vendor_id: vendor_id,
      zip_code: zip,
    )
  end

  def late_cut_off_time(stage)
    Time.now.utc - (avg_duration(stage) * 2.0)
  end

  def normal_cut_off_time(stage)
    Time.now.utc - (avg_duration(stage))
  end

  def avg_duration(status)
    a = @aggregate.first
    cumilative_duration =
      case status
        when "warehouse"
          a['warehouse']
        when "dispatched"
          a['warehouse'] + a["dispatched"]
        when "distribution"
          a['warehouse'] + a["dispatched"] + a['distribution']
        when "out_for_delivery"
          a['warehouse'] + a["dispatched"] + a['distribution'] + a['out_for_delivery']
      end
    cumilative_duration
  end

  def durations
    durations = TrackingEvent.statuses
    durations.delete('delivered')
    durations
  end
end