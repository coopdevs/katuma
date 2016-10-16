module Suppliers
  class ProducersPresenter
    # @param producers [ActiveRecord::Collection<Producer>]
    # @param user [User]
    def initialize(producers, user)
      @producers = producers
      @user = user
    end

    # @return [Array<ProducerPresenter>]
    def build
      producers.map { |producer| ::BasicResources::ProducerPresenter.new(producer, user) }
    end

    private

    attr_reader :producers, :user
  end
end
