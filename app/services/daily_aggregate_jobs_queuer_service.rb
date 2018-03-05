class DailyAggregateJobsQueuerService

  def initialize(date: Time.now.utc.yesterday.to_date)
    @date = date
  end

  def run
    queue_jobs
  end

  attr_reader :date

  def queue_jobs
    TrackingEvent.where(
      created_at: date.at_beginning_of_day..date.at_end_of_day
    ).group([:vendor_id,:zip_code])
     .pluck(:vendor_id,:zip_code).each do |vendor_id, zip_code|
        DailyAggregateCalculatorService.new(
          zip: zip_code,
          vendor_id: vendor_id,
          date: date
        ).delay.run
     end
  end
end