# spec/models/order_spec.rb
require 'spec_helper'

describe Order do

  describe "Validations" do
    it "has valid factory" do
      expect(FactoryGirl.build(:order)).to be_valid
    end
  end

  describe "Associations" do
    xit { should have_many(:order_lines) }
    it { should belong_to(:customer) }
    xit { should belong_to(:provider) }
  end

  pending "More validations" do
    # ToDo:
    # check provider_is_not_customer and
    # customer_is_member_of_provider
    # validations
  end
end
