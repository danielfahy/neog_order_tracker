namespace :aggregate do
  desc "Aggregate all yesterdays tracking events"
  task daily: :environment do
    date = Date.yesterday
    events = TrackingEvent.where(
      created_at: date.at_beginning_of_day..date.at_end_of_day
    ).group([:vendor_id,:zip_code])

    events.each do |e|
      DailyAggregateCalculatorService.new(zip: e.zip_code, vendor_id: e.vendor_id, date: date).run
    end
  end
end
