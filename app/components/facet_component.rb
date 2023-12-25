# frozen_string_literal: true

# Renders a facet as a list of facet buttons.
class FacetComponent < ViewComponent::Base
  def initialize(facet:, search:)
    @facet = facet
    @search = search
  end

  attr_reader :facet, :search

  def render?
    facet.values.present?
  end

  def label
    search.facet_label(facet.key)
  end
end
