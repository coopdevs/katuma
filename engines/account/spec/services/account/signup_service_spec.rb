require 'rails_helper'

describe Account::SignupService do
  describe '#create!' do
    subject { described_class.new.create!(email) }

    let(:email) { 'foo@bar.com' }

    before do
      allow(Account::SignupJob).to receive(:perform_later).with(kind_of(Integer))
    end

    context 'when there is a signup with the email' do
      let!(:signup) { FactoryGirl.create(:signup, email: email) }
      it { is_expected.to eq(signup) }
    end

    context 'when there is no signup with the email' do
      let(:signup) { FactoryGirl.build(:signup, email: email) }

      before do
        allow(Account::Signup)
          .to receive(:find_or_initialize_by).with(email: email)
          .and_return(signup)
      end

      it { is_expected.to eq(signup) }

      it 'sends the confirmation email async' do
        expect(Account::SignupJob).to receive(:perform_later).with(kind_of(Integer))
        described_class.new.create!(email)
      end
    end
  end

  describe '#complete!' do
    subject { described_class.new.complete!(signup, options) }

    let!(:signup) { FactoryGirl.create(:signup) }

    context 'when the user cannot be created' do
      let(:options) { {} }

      it 'does not remove the signup' do
        expect { described_class.new.complete!(signup, options) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when the user can be created' do
      let(:options) do
        {
          username: 'pep23',
          password: 'crypted_password',
          password_confirmation: 'crypted_password',
          first_name: 'pep',
          last_name: 'palau'
        }
      end
      let(:user) { FactoryGirl.build(:user) }

      before do
        allow(Account::User)
          .to receive(:create!)
          .with({ email: signup.email }.merge(options))
          .and_return(user)
      end

      it 'removes te signup' do
        expect { described_class.new.complete!(signup, options) }
          .to change { Account::Signup.count }.by(-1)
      end

      it { is_expected.to eq(user) }
    end
  end
end
