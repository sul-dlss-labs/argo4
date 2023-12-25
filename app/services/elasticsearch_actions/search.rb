# frozen_string_literal: true

module ElasticsearchActions
  # Perform a search, possibly including some aggregations.
  class Search < Base
    def initialize(client:, search:, aggs:)
      @search = search
      @aggs = aggs
      super(client:)
    end

    def call
      Rails.logger.info("Response: #{response}")
      ElasticsearchRepository::SearchResult.new(documents:, facets:, total_documents:)
    end

    private

    attr_reader :search, :aggs

    def response
      Rails.logger.info("Query: #{body}")
      @response ||= client.search(index:, body:)
    end

    def documents
      response['hits']['hits'].map { |hit| hit['_source'] }
    end

    def total_documents
      response['hits']['total']['value']
    end

    def facets
      aggregation_map = Array(response['aggregations']).to_h
      # => {project_tag: ['project_tag'], released_to_searchworks_date: ['released_to_searchworks_date', 'released_to_searchworks_date-missing']}
      base_key_map = aggregation_map.keys.group_by { |key| base_key(key) }
      base_key_map.map do |base_key, keys|
        facet_attribute = search.facet_attribute(base_key)
        values = keys.map do |key|
          facet_attribute.agg_response(key:, base_key:, result: aggregation_map[key])
        end.flatten
        ElasticsearchRepository::Facet.new(key: base_key, values:)
      end
    end

    def base_key(key)
      key.split('-').first
    end

    def body
      {
        query:,
        size: search.page_size,
        from: search.page_size * (search.page - 1),
        track_total_hits: true # This is slow. To speed up, perhaps make this a separate query / stream update.
      }.tap do |params|
        params[:aggs] = aggs if search.page == 1
      end
    end

    def query
      ElasticsearchQueries::Search.new(search:).call
    end
  end
end
