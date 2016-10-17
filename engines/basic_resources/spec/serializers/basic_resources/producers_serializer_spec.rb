require 'rails_helper'

module BasicResources
  describe ProducersSerializer do
    let(:first_presenter) do
      instance_double(
        ProducerPresenter,
        id: 666,
        name: 'Producer #1',
        email: 'producer+1@katuma.org',
        address: 'c/ del Primer Productor',
        can_edit: true,
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end
    let(:second_presenter) do
      instance_double(
        ProducerPresenter,
        id: 667,
        name: 'Producer #2',
        email: 'producer+2@katuma.org',
        address: 'c/ del Segon Productor',
        can_edit: false,
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end
    let(:first_presenter_attributes) do
      {
        id: first_presenter.id,
        name: first_presenter.name,
        email: first_presenter.email,
        address: first_presenter.address,
        can_edit: true,
        created_at: first_presenter.created_at,
        updated_at: first_presenter.updated_at
      }
    end
    let(:second_presenter_attributes) do
      {
        id: second_presenter.id,
        name: second_presenter.name,
        email: second_presenter.email,
        address: second_presenter.address,
        can_edit: false,
        created_at: second_presenter.created_at,
        updated_at: second_presenter.updated_at
      }
    end

    subject { described_class.new([first_presenter, second_presenter]).to_hash }

    it do
      is_expected.to contain_exactly(
        match(first_presenter_attributes),
        match(second_presenter_attributes)
      )
    end
  end
end
