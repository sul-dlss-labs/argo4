# frozen_string_literal: true

module ElasticsearchQueries
  BoolClause = Struct.new(:filters, :must_nots, keyword_init: true)

  # Generates query DSL.
  class Search < Base
    def call
      {}.tap do |params|
        if bool.present?
          params[:bool] = bool
        else
          # Match everything.
          params[:match_all] = {}
        end
      end
    end

    private

    def bool
      # A boolean query is constructed of must (for the query),
      # filter (for facets) and must nots (for facets).
      @bool ||= {}.tap do |bool_params|
        bool_params[:must] = matches if matches.present?
        bool_params[:filter] = filters if filters.present?
        bool_params[:must_not] = must_nots if must_nots.present?
      end
    end

    def matches
      @matches ||= {}.tap do |match_params|
        match_params[:match] = { title: search.query } if search.query.present?
      end
    end

    def bool_clauses
      @bool_clauses ||= search.facet_attribute_keys.map do |key|
        facet_attribute = ::Search.facet_attribute(key)
        values = search.send(key)

        next if values.blank?

        # Invoking filter returns a BoolClause (which may have filters or must_nots).
        facet_attribute.filter(key:, values:)
      end.flatten.compact
    end

    def filters
      @filters ||= bool_clauses.map(&:filters).flatten.compact
    end

    def must_nots
      @must_nots ||= bool_clauses.map(&:must_nots).flatten.compact
    end
  end
end
