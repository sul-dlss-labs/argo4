# frozen_string_literal: true

# Job to perform a search for a single facet and broadcast the results.
class FacetSearchJob < ApplicationJob
  queue_as :high
  sidekiq_options retry: false

  def perform(args)
    key = args.delete(:key)
    search = Search.new(args)
    facet_attribute = search.facet_attribute(key)

    result = ElasticsearchRepository.new.search(search:, aggs: facet_attribute.agg(key:))
    result.facets.each { |facet| search.broadcast_facet(facet:) }
  end
end
