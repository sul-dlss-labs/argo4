# frozen_string_literal: true

module ElasticsearchAggregations
  # Generate aggregation DSL for tags.
  # Note that this requests the maximum number of buckets
  # and orders the results alphabetically.
  class Tags < Base
    def call
      {
        key => {
          terms: {
            field: key,
            size: 65_536, # max_buckets
            order: { "_key": 'asc' }
          }
        }
      }
    end
  end
end
