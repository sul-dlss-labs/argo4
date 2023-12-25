# frozen_string_literal: true

module ElasticsearchAggregationResponses
  class Base
    def initialize(result:, key:, base_key:)
      @result = result
      @key = key
      @base_key = base_key
    end

    protected

    attr_reader :result, :key, :base_key
  end
end
