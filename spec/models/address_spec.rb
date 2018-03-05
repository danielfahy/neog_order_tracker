require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    subject { described_class.new(params) }
    context 'with valid params' do
      let(:params) do
        {
          street: '94 3rd Avenue',
          city: 'New York',
          state: 'NY',
          zip_code: '10003'
        }
      end
      it 'is valid' do
        expect(subject.valid?).to eq true
      end
    end
    context 'when it gets bad input ' do
      let(:params) do
        {
          street: '',
          city: '',
          state: 'PP',
          zip_code: 'banana'
        }
      end
      it 'is invalid' do
        expect(subject.valid?).to eq false
        # add more tests for error messages
      end
    end
  end
end
