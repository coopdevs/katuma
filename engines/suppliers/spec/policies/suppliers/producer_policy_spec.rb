require 'rails_helper'
require 'pundit/rspec'

module Suppliers
  describe ProducerPolicy do
    subject { described_class }

    permissions :create? do
      it 'is set to `true` by default' do
        expect(subject).to permit(instance_double(User), instance_double(Producer))
      end
    end

    permissions :show?, :update?, :destroy? do
      it 'is set to `false` by default' do
        expect(subject).to_not permit(instance_double(User), instance_double(Producer))
      end
    end
  end
end
