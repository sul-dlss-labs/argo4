# frozen_string_literal: true

module BroadcastSupport
  extend ActiveSupport::Concern
  include Turbo::Broadcastable
  include SearchHelper

  included do
    def broadcast_result_documents(item_results:, result:)
      broadcast_update(
        partial: 'searches/results',
        locals: { item_results:, result:, search: self },
        target: 'search-results',
        channel: SearchChannel
      )
    end

    def broadcast_facet(facet:)
      broadcast_update(
        renderable: Search.facet_component(facet.key).new(facet:, search: self),
        target: facet_dom_id(facet.key),
        channel: SearchChannel
      )
    end

    def broadcast_facet_placeholder(facet_key:)
      broadcast_update(
        renderable: FacetPlaceholderComponent.new(facet_key:),
        target: facet_dom_id(facet_key),
        channel: SearchChannel
      )
    end

    def broadcast_search_remove
      broadcast_update(
        renderable: RemoveSearchComponent.new(search: self),
        target: 'search-remove',
        channel: SearchChannel
      )
    end
  end
end
