require 'rails_helper'

describe Suppliers::FrequencyType do
  let(:frequency_type) { described_class.new(type) }

  describe '#to_s' do
    subject { frequency_type.to_s }

    context 'when confirmation type is passed' do
      let(:type) { :confirmation }
      it { is_expected.to eq(0) }
    end

    context 'when delivery type is passed' do
      let(:type) { :delivery }
      it { is_expected.to eq(1) }
    end

    context 'when the passed type is not valid' do
      let(:type) { :invalid }
      it { is_expected.to eq(:invalid) }
    end
  end
end
