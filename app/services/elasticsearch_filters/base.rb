# frozen_string_literal: true

module ElasticsearchFilters
  class Base
    def initialize(key:, values:)
      @key = key
      @values = values
    end

    protected

    attr_reader :key, :values
  end
end
