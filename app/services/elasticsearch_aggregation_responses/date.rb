# frozen_string_literal: true

module ElasticsearchAggregationResponses
  # Extract date responses from a range aggregation.
  class Date < Base
    def call
      # For example, missing value aggregation
      if result['doc_count'].present?
        value = key.split('-').last
        ElasticsearchRepository::FacetValue.new(value:, count: result['doc_count'], facet_key: base_key)
      else
        result['buckets'].map do |aggregration_item|
          ElasticsearchRepository::FacetValue.new(value: aggregration_item['key'],
                                                  count: aggregration_item['doc_count'], facet_key: base_key)
        end
      end
    end
  end
end
