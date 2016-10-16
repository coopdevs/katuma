require 'rails_helper'

module Suppliers
  describe Group do
    describe 'Associations' do
      it { is_expected.to have_many(:suppliers) }
      it { is_expected.to have_many(:producers).through(:suppliers) }
    end
  end
end
