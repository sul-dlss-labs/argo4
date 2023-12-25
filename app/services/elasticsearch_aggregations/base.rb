# frozen_string_literal: true

module ElasticsearchAggregations
  class Base
    def initialize(key:)
      @key = key
    end

    protected

    attr_reader :key

    def agg_key(key:, suffix:)
      "#{key}-#{suffix}"
    end
  end
end
