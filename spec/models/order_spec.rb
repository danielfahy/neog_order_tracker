require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    subject { described_class.new(params) }
    let(:vendor) {Vendor.create(name: 'Argos')}
    context 'with valid params' do
      let(:params) do
        {
          number: '12345',
          tracking_id: '1264597abnama',
          vendor_id: vendor.id
        }
      end
      it 'is valid' do
        expect(subject.valid?).to eq true
      end
    end
    context 'when it gets bad input' do
      let(:params) do
        {
          number: '',
          tracking_id: '',
          vendor_id: 10
        }
      end
      it 'is invalid' do
        expect(subject.valid?).to eq false
        # add more tests for error messages
      end
    end
  end
end
