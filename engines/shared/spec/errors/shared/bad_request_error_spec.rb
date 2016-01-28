require 'rails_helper'

describe Shared::BadRequestError do
  let(:bad_request) { described_class.new }

  describe '#message' do
    subject { bad_request.message }

    context 'when no item is provided' do
      it { is_expected.to eq('Malformed request') }
    end

    context 'when an item is provided' do
      class Thing
        def name; 'Thing'; end
        def errors
          { stuff_id: "can't be empty" }
        end
      end

      let(:id) { 1 }
      let(:item) { Thing.new }
      let(:bad_request) { described_class.new(item) }

      it { is_expected.to eq(stuff_id: "can't be empty") }
    end
  end

  describe '#status_code' do
    subject { bad_request.status_code }
    it { is_expected.to eq(400) }
  end

  describe '#name' do
    subject { bad_request.name }
    it { is_expected.to eq('Bad Request') }
  end
end
