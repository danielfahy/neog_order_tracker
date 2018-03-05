require 'rails_helper'

RSpec.describe OrderStatusUpdaterService, type: :model do
  let(:vendor) { Vendor.create(name: 'Jet') }
  subject {described_class.new.run}
  context 'when 1 order is not inside the normal duration' do
    let!(:not_normal_orders) do
      (0..100).map.with_index do |i|
        Order.create!(
          number: '12345',
          tracking_id: "a#{i}",
          vendor_id: vendor.id,
          created_at: 1.hour.ago,
          address_attributes: {
            "street"=>"94 3rd Avenue",
            "street2"=>nil,
            "city"=>"New York",
            "state"=>"NY",
            "zip_code"=>"10003"}
        )
      end
    end
    let!(:normal_orders) do
      (0..100).map.with_index do |i|
        Order.create!(
          number: '12345',
          tracking_id: "b#{i}",
          vendor_id: vendor.id,
          created_at: 1.minute.ago,
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
      (0..100).map.with_index do |i|
        Order.create!(
          number: '12345',
          tracking_id: "c#{i}",
          vendor_id: vendor.id,
          created_at: 2.hours.ago,
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
        dispatched: 3600,
        distribution: 3600,
        out_for_delivery: 7200,
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
        expect{subject}.to change { late_orders.first.reload.status }.from('normal').to('not_normal')
      end
    end
  end
end