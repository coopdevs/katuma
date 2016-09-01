require 'rails_helper'

describe Producers::Membership do
  let(:user) do
    u = FactoryGirl.create(:user)
    ::Producers::User.new(u.attributes)
  end
  let(:group) do
    g = FactoryGirl.create(:group)
    ::Producers::Group.new(g.attributes)
  end

  describe 'Validations' do
    it 'has a valid factory' do
      expect(
        FactoryGirl.build(
          :producers_membership,
          group: group
        )
      ).to be_valid
    end

    it { is_expected.to validate_presence_of(:producer) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_inclusion_of(:role).in_array(::Producers::Membership::ROLES.values) }

    context 'setting no `group_id` or `user_id`' do
      subject { FactoryGirl.build(:producers_membership) }

      it 'is not valid' do
        expect(subject.valid?).to be_falsey
      end
    end

    context 'setting both `group_id` and `user_id`' do
      subject do
        FactoryGirl.build(
          :producers_membership,
          user: user,
          group: group
        )
      end

      it 'is not valid' do
        expect(subject.valid?).to be_falsey
      end
    end

    context 'setting only `group_id` and not `user_id`' do
      subject do
        FactoryGirl.build(
          :producers_membership,
          group: group
        )
      end

      it 'is not valid' do
        expect(subject.valid?).to be_truthy
      end
    end

    context 'setting only `user_id` and not `group_id`' do
      subject do
        FactoryGirl.build(
          :producers_membership,
          user: user
        )
      end

      it 'is not valid' do
        expect(subject.valid?).to be_truthy
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:producer) }
    it { should belong_to(:user) }
    it { should belong_to(:group) }
  end
end
