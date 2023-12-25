# frozen_string_literal: true

module ElasticsearchFilters
  # Generates query DSL for the released to searchworks date facet.
  class ReleasedToSearchworksDate < Base
    def call
      ElasticsearchQueries::BoolClause.new(filters: date_filters + exists_filters, must_nots:)
    end

    private

    # The dates are range queries.
    def date_filters
      values.select { |value| ElasticsearchDateRangeDefinitions.defined?(key: value) }.map do |value|
        {
          range: ElasticsearchDateRangeDefinitions.query_definition(key: value, field_key: key)
        }
      end
    end

    # Released is an exists query.
    def exists_filters
      values.select { |value| value == 'Released' }.map do |_value|
        {
          exists: {
            field: key
          }
        }
      end
    end

    # Not released is a must not exists query.
    def must_nots
      values.select { |value| value == 'Not released' }.map do |_value|
        {
          exists: {
            field: key
          }
        }
      end
    end
  end
end
