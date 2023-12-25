# frozen_string_literal: true

module ElasticsearchAggregationResponses
  # Extract values from an aggregation response.
  # The value is the aggregration result's key.
  class Value < Base
    def call
      result['buckets'].map do |aggregration_item|
        ElasticsearchRepository::FacetValue.new(value: aggregration_item['key'], count: aggregration_item['doc_count'],
                                                facet_key: base_key)
      end
    end
  end
end
