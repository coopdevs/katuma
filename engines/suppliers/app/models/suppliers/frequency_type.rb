module Suppliers
  class FrequencyType
    TYPES = { confirmation: 0, delivery: 1 }.freeze

    def initialize(input_type)
      @type = type_for(input_type)
    end

    def to_s
      @type
    end

    private

    def type_for(key)
      TYPES.fetch(key, key)
    end
  end
end
