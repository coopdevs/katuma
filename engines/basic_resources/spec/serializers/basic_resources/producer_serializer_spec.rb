require 'rails_helper'

module BasicResources
  describe ProducerSerializer do
    let(:user) { instance_double(User) }
    let(:producer) { FactoryGirl.create(:producer) }
    let(:presenter) { ProducerPresenter.new(producer, user) }
    let(:attributes) do
      {
        id: producer.id,
        name: producer.name,
        email: producer.email,
        address: producer.address,
        can_edit: true,
        created_at: producer.created_at,
        updated_at: producer.updated_at
      }
    end

    before { allow(presenter).to receive(:can_edit).and_return(true) }

    subject { described_class.new(presenter).to_hash }

    it { is_expected.to match(attributes) }
  end
end
