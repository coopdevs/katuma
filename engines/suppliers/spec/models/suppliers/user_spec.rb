require 'rails_helper'

module Suppliers
  describe User do
    describe 'Associations' do
      it { is_expected.to have_many(:memberships) }
      it do
        is_expected.to have_many(:producers)
          .through(:memberships)
          .source(:basic_resource_producer)
      end
    end
  end
end
