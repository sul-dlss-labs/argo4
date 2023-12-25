# frozen_string_literal: true

module ElasticsearchAggregations
  # Generate aggregation DSL for the release to Searchworks date facet.
  class ReleasedToSearchworksDate < Base
    def call
      {
        key => {
          date_range: {
            field: key,
            ranges: [
              ElasticsearchDateRangeDefinitions.aggregation_definition(key: 'Last week'),
              ElasticsearchDateRangeDefinitions.aggregation_definition(key: 'Last month'),
              ElasticsearchDateRangeDefinitions.aggregation_definition(key: 'Last year')
            ]
          }
        },
        agg_key(key:, suffix: 'Not released') => {
          missing: {
            field: key
          }
        },
        agg_key(key:, suffix: 'Released') => {
          filter: {
            exists: {
              field: key
            }
          }
        }
      }
    end
  end
end
