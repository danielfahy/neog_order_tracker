require 'rails_helper'

RSpec.describe TrackingEvent, type: :model do
  let!(:vendor) { Vendor.create!(name:'Jet')}
  let!(:order)  { Order.create!(tracking_id: 'ABC',number: '1', vendor: vendor) }
  subject { described_class.new(params) }
  context 'when it is in the warehouse' do
    let(:params) { {status: 0, tracking_id: 'ABC'} }
    it 'saveing does not trigger a job' do
      expect{subject.save}.to_not change {Delayed::Job.count}
    end
  end
  context 'when it is not in the warehouse' do
    let(:params) { {status: 1, tracking_id: 'ABC'} }
    it 'saving does trigger a job' do
      expect{subject.save}.to change {Delayed::Job.count}
    end
  end

  describe '#set_previous_duration' do
    context 'when there is a previous event' do
      let!(:previous_event) {described_class.create(tracking_id: 'ABC', created_at: 1.hour.ago)}
      subject {described_class.new(tracking_id: 'ABC', status: 1, created_at: Time.now)}
      it 'sets the previous events duration' do
        expect{subject.set_previous_duration_without_delay}.to change {previous_event.reload.duration}.to(3600)
      end
    end
    context 'when there is no previous event' do
      subject {described_class.new(tracking_id: 'ABC', status: 1, created_at: Time.now)}
      it 'sets the previous events duration' do
        expect{subject.set_previous_duration_without_delay}.to raise_error RuntimeError
      end
    end
  end

  describe '#update_order_tracking_status' do
    subject {described_class.new(tracking_id: 'ABC', status: 2, created_at: Time.now)}
    it 'updates its orders status' do
      expect{subject.update_order_tracking_status}.to change{order.reload.tracking_status}
    end
  end
end
