require 'rails_helper'

describe Shared::UnprocessableEntity do
  let(:unprocessable_entity) { described_class.new }

  describe '#message' do
    subject { unprocessable_entity.message }

    context 'when no item is provided' do
      it { is_expected.to eq('The request could not be processed') }
    end

    context 'when an item is provided' do
      class Thing
        def errors
          { stuff_id: "can't be empty" }
        end
      end

      let(:id) { 1 }
      let(:item) { Thing.new }
      let(:unprocessable_entity) { described_class.new(item) }

      it { is_expected.to eq(stuff_id: "can't be empty") }
    end
  end

  describe '#status_code' do
    subject { unprocessable_entity.status_code }
    it { is_expected.to eq(422) }
  end

  describe '#name' do
    subject { unprocessable_entity.name }
    it { is_expected.to eq('Unprocessable Entity') }
  end
end
