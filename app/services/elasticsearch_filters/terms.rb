# frozen_string_literal: true

module ElasticsearchFilters
  # Generates query DSL for terms.
  class Terms < Base
    def call
      ElasticsearchQueries::BoolClause.new(filters: [filter])
    end

    private

    def filter
      {
        terms: {
          key => values
        }
      }
    end
  end
end
