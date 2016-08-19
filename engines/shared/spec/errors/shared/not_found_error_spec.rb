require 'rails_helper'

describe Shared::NotFoundError do
  let(:not_found) { described_class.new }

  describe '#message' do
    subject { not_found.message }

    context 'when no item is provided' do
      it { is_expected.to eq('The item could not be found') }
    end

    context 'when an item is provided' do
      class Thing
        def model_name
          ::ActiveModel::Name.new(self.class)
        end
      end

      let(:id) { 1 }
      let(:item) { Thing.new }
      let(:not_found) { described_class.new(id, item) }

      it { is_expected.to eq('thing' => "Thing with id #{id} not found") }
    end

    context 'when an item with namespace is provided' do
      module Namespace
        class Thing
          def model_name
            ::ActiveModel::Name.new(self.class)
          end
        end
      end

      let(:id) { 1 }
      let(:item) { Namespace::Thing.new }
      let(:not_found) { described_class.new(id, item) }

      it { is_expected.to eq('thing' => "Thing with id #{id} not found") }
    end
  end

  describe '#status_code' do
    subject { not_found.status_code }

    it { is_expected.to eq(404) }
  end

  describe '#name' do
    subject { not_found.name }

    it { is_expected.to eq('Not Found') }
  end
end
