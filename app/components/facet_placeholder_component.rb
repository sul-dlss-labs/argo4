# frozen_string_literal: true

# Renders a facet as loading.
class FacetPlaceholderComponent < ViewComponent::Base
  def initialize(facet_key:)
    @facet_key = facet_key
  end

  attr_reader :facet_key

  def label
    Search.facet_label(facet_key)
  end
end
