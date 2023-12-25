# frozen_string_literal: true

# Job to perform a search and broadcast the results.
# The search includes items only.
class SearchPageJob < ApplicationJob
  queue_as :high
  sidekiq_options retry: false

  def perform(args)
    search = Search.new(args)
    result = ElasticsearchRepository.new.search(search:)
    item_results = result.documents.map { |doc| ItemResultPresenter.new(elasticsearch_doc: doc) }
    search.broadcast_result_documents(item_results:, result:)
  end
end
