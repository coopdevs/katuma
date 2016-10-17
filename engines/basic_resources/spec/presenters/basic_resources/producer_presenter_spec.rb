require 'rails_helper'

module BasicResources
  describe ProducerPresenter do
    let(:user) { instance_double(User) }
    let(:producer) { instance_double(Producer) }
    let(:presenter) { described_class.new(producer, user) }

    describe '#can_edit' do
      subject { presenter.can_edit }

      context 'when the user is directly associated to the producer' do
        context 'as `admin`' do
          before { allow(producer).to receive(:admin?).with(user).and_return(true) }

          it { is_expected.to be_truthy }
        end
      end

      context 'when the user is associated to the producer through a group' do
        let(:group) { instance_double(Group) }

        before { allow(producer).to receive(:admin?).with(user).and_return(false) }
        before { allow(producer).to receive(:groups).and_return([group]) }

        context 'and is a group `admin`' do
          before { allow(group).to receive(:admin?).with(user).and_return(true) }

          it { is_expected.to be_truthy }
        end

        context 'and is not a group `admin`' do
          before { allow(group).to receive(:admin?).with(user).and_return(false) }

          it { is_expected.to be_falsey }
        end
      end
    end
  end
end
