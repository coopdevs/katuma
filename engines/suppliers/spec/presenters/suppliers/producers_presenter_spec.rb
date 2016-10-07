require 'rails_helper'

module Suppliers
  describe ProducersPresenter do
    let(:user) { instance_double(User) }
    let(:first_producer) { instance_double(Producer, id: 666) }
    let(:second_producer) { instance_double(Producer, id: 667) }
    let(:producers) { [first_producer, second_producer] }
    let(:presenter) { described_class.new(producers, user) }

    describe '#build' do
      subject { presenter.build }

      its(:size) { is_expected.to eq(2) }

      describe 'first element' do
        subject { presenter.build.first }

        its(:id) { is_expected.to eq(first_producer.id) }
      end

      describe 'second element' do
        subject { presenter.build.last }

        its(:id) { is_expected.to eq(second_producer.id) }
      end
    end
  end
end
