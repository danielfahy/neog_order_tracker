require 'rails_helper'

RSpec.describe DailyAggregateCalculatorService, type: :model do
  let!(:vendor) { Vendor.create(name: 'Argos') }
  let!(:events) do
    4.times do |i|
      TrackingEvent.create(
        vendor: vendor,
        tracking_id: 'ABC123',
        zip_code: '10003',
        duration: 3600,
        status: i)
    end

    4.times do |i|
      TrackingEvent.create(
        vendor: vendor,
        tracking_id: 'ABC321',
        zip_code: '10003',
        duration: 1800,
        status: i)
    end

  end
  context 'when there are events' do
    subject { described_class.new(params).run }
    let(:params) do
      {
        zip: '10003',
        vendor_id: vendor.id,
        date: Time.now.utc.to_date
      }
    end
    describe 'run' do
      it 'creates an aggregation record' do
        expect{subject}.to change { DailyVendorOrderDurationAgg.count }.from(0).to(1)
      end
    end
  end
end