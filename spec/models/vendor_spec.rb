require 'rails_helper'

RSpec.describe Vendor, type: :model do
  subject { described_class.new(params) }
  describe 'validations' do
    context 'when name is not present' do
      let(:params) { { name: '' } }
      it 'wont save' do
        expect(subject.save).to eq false
      end
    end
    context 'when name has been taken' do
      let!(:vendor) { Vendor.create(name: 'Jet') }
      let(:params) { { name: 'jet' } }
      it 'wont save' do
        expect(subject.save).to eq false
        expect(subject.errors).to include :name
      end
    end
  end
end
