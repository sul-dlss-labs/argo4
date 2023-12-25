# frozen_string_literal: true

module ElasticsearchAggregations
  # Generates aggregation DSL for terms.
  class Terms < Base
    def call
      {
        key => {
          terms: {
            field: key
          }
        }
      }
    end
  end
end
