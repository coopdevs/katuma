require 'rails_helper'

module Suppliers
  describe Membership do
    describe 'Associations' do
      it { is_expected.to belong_to(:group) }
      it { is_expected.to belong_to(:user) }
      it do
        is_expected.to belong_to(:basic_resource_producer)
          .with_foreign_key(:basic_resource_producer_id)
      end
    end
  end
end
