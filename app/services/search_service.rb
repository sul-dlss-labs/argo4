# frozen_string_literal: true

# Executes a search.
# This involves broadcasting placeholders, starting search jobs, and
# broadcasting the query part remove buttons.
class SearchService
  def initialize(search:)
    @search = search
  end

  def call
    if search.page == 1
      call_search
    else
      call_search_page
    end
  end

  private

  attr_reader :search

  def call_search_page
    SearchJob.perform_later(search_hash)
  end

  def call_search
    send_placeholders
    SearchJob.perform_later(search_hash)
    single_facet_attribute_keys.each do |key|
      FacetSearchJob.perform_later(search_hash.merge(key:))
    end
    search.broadcast_search_remove
  end

  def search_hash
    @search_hash ||= search.serializable_hash
  end

  def send_placeholders
    search.facet_attribute_keys.each do |facet_key|
      search.broadcast_facet_placeholder(facet_key:)
    end
  end

  def single_facet_attribute_keys
    search.facet_attribute_keys.reject do |key|
      search.facet_attribute(key).multi
    end
  end
end
