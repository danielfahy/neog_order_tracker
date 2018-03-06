require 'rails_helper'

RSpec.describe OrderStatusUpdaterService, type: :model do
  let(:vendor) { Vendor.create(name: 'Jet') }
  subject {described_class.new.run}
  context 'when 1 order is not inside the normal duration' do
    let!(:normal_orders) do
      (1..1).map.with_index do |i|
        Order.create!(
          number: '12345',
          tracking_id: "normal#{i}",
          vendor_id: vendor.id,
          created_at: 29.minute.ago,
          address_attributes: {
            "street"=>"94 3rd Avenue",
            "street2"=>nil,
            "city"=>"New York",
            "state"=>"NY",
            "zip_code"=>"10003"}
        )
      end
    end
    let!(:not_normal_orders) do
      (1..1).map.with_index do |i|
        Order.create!(
          number: '12345',
          tracking_id: "not_normal#{i}",
          vendor_id: vendor.id,
          created_at: 59.minutes.ago,
          address_attributes: {
            "street"=>"94 3rd Avenue",
            "street2"=>nil,
            "city"=>"New York",
            "state"=>"NY",
            "zip_code"=>"10003"}
        )
      end
    end
    let!(:late_orders) do
      (1..1).map.with_index do |i|
        Order.create!(
          number: '12345',
          tracking_id: "late#{i}",
          vendor_id: vendor.id,
          created_at: 60.minutes.ago,
          address_attributes: {
            "street"=>"94 3rd Avenue",
            "street2"=>nil,
            "city"=>"New York",
            "state"=>"NY",
            "zip_code"=>"10003"}
        )
      end
    end
    let!(:aggregate) do
      VendorOrderDurationAggregate.create!(
        warehouse: 1800,
        dispatched: 1,
        distribution: 1,
        out_for_delivery: 1,
        vendor: vendor,
        zip_code: '10003'
        )
    end
    describe 'run' do
      it ' does not change the normal orders status' do
        expect{subject}.to_not change { normal_orders.first.reload.status }
      end
      it 'changes the not normal orders status' do
        expect{subject}.to change { not_normal_orders.first.reload.status }.from('normal').to('not_normal')
      end
      it 'changes the very late orders status' do
        expect{subject}.to change { late_orders.first.reload.status }.from('normal').to('very_late')
      end
    end
  end
end