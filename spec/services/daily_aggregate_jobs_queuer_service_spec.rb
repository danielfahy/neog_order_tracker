require 'rails_helper'
# should really use Timecop to freeze time
RSpec.describe DailyAggregateJobsQueuerService, type: :model do
  let!(:vendor) { Vendor.create(name: 'Argos') }
  let!(:vendor2) { Vendor.create(name: 'Wallmart') }
  let!(:events) do
    4.times do |i|
      TrackingEvent.create!(
        vendor: vendor,
        tracking_id: 'ABC123',
        zip_code: '10002',
        duration: 3600,
        status: i,
        created_at: Time.now.utc.yesterday.to_date)
    end

    4.times do |i|
      TrackingEvent.create!(
        vendor: vendor2,
        tracking_id: 'ABC124',
        zip_code: '10002',
        duration: 3600,
        status: i,
        created_at: Time.now.utc.yesterday.to_date)
    end

    4.times do |i|
      TrackingEvent.create!(
        vendor: vendor,
        tracking_id: 'ABC321',
        zip_code: '10003',
        duration: 1800,
        status: i,
        created_at: Time.now.utc.yesterday.to_date)
    end
  end
  context 'when there are events' do
    subject { described_class.new.run }
    describe 'run' do
      it 'queues an aggregate job for every vendor and zip_code' do
        expect{subject}.to change { Delayed::Job.count }.by(3)
      end
    end
  end
end