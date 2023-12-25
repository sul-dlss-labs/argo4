# frozen_string_literal: true

# Renders buttons for removing a facet term from the search.
class RemoveFacetTermButtonComponent < ViewComponent::Base
  with_collection_parameter :facet_value

  def initialize(facet_value:, search:)
    @facet_value = facet_value
    @search = search
  end

  attr_reader :facet_value, :search

  def label
    "#{search.facet_label(facet_value.facet_key)}: #{facet_value.value} X"
  end

  def params
    SearchParamsSupport.to_params(search:, clear_facet_value: facet_value)
  end
end
