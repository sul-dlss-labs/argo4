# frozen_string_literal: true

# Job to perform a search and broadcast the results.
# The search includes items and facets marked as multi.
# Multi facets are intended to be fast.
class SearchJob < ApplicationJob
  queue_as :high
  sidekiq_options retry: false

  def perform(args)
    search = Search.new(args)
    result = ElasticsearchRepository.new.search(search:, aggs:)
    item_results = result.documents.map { |doc| ItemResultPresenter.new(elasticsearch_doc: doc) }
    search.broadcast_result_documents(item_results:, result:)
    result.facets.each { |facet| search.broadcast_facet(facet:) }
  end

  def multi_facet_attribute_keys
    Search.facet_attribute_keys.select do |key|
      Search.facet_attribute(key).multi
    end
  end

  def aggs
    # Only request aggregations that are marked as multi.
    {}.tap do |params|
      multi_facet_attribute_keys.each do |key|
        facet_attribute = Search.facet_attribute(key)
        params.merge!(facet_attribute.agg(key:))
      end
    end
  end
end
