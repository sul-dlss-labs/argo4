# frozen_string_literal: true

module Type
  class Facet < ActiveModel::Type::Value
    attr_reader :label, :multi, :component

    def initialize(label:,
                   agg_proc: ElasticsearchAggregations::Terms,
                   filter_proc: ElasticsearchFilters::Terms,
                   agg_response_proc: ElasticsearchAggregationResponses::Value,
                   multi: true,
                   component: FacetComponent)
      @label = label
      # Multi means that it is included in the multi aggregration query
      # instead of having its own aggregration query.
      @multi = multi
      @component = component
      @agg_proc = agg_proc
      @filter_proc = filter_proc
      @agg_response_proc = agg_response_proc
    end

    # Generate the aggregration DSL for the provided key.
    def agg(key:)
      @agg_proc.new(key:).call
    end

    # Generate the query DSL for the provided key limited to the provided values.
    def filter(key:, values:)
      @filter_proc.new(key:, values:).call
    end

    # Extract the aggregration results.
    def agg_response(key:, base_key:, result:)
      @agg_response_proc.new(key:, base_key:, result:).call
    end

    def type
      :facet
    end

    # Facets are actually just arrays of values.
    def cast(value)
      case value
      when ::Array
        value
      when ::String
        JSON.parse(value)
      else
        if value.respond_to?(:to_a)
          value.to_a
        else
          cast_value(value.to_s)
        end
      end
    end

    def serialize(value)
      value.to_json
    end
  end
end
