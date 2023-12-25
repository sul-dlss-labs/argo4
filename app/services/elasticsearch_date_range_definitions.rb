# frozen_string_literal: true

# Definitions of date ranges.
# This will provide aggregation DSL and query DSL for the ranges.
class ElasticsearchDateRangeDefinitions
  DateRangeDefinition = Struct.new(:key, :from, :to, keyword_init: true)

  DEFINITIONS = {
    'Last week' => { from: 'now-7d' },
    'Last month' => { from: 'now-1M' },
    'Last year' => { from: 'now-1y' }
  }.freeze

  def self.aggregation_definition(key:)
    DEFINITIONS.fetch(key).merge(key:)
  end

  def self.query_definition(key:, field_key:)
    definition = DEFINITIONS.fetch(key)
    {
      field_key => {
        "gte": definition[:from],
        "lte": definition[:to]
      }.compact
    }
  end

  def self.defined?(key:)
    DEFINITIONS.key?(key)
  end
end
