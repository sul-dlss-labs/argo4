# frozen_string_literal: true

class FacetButtonComponent < ViewComponent::Base
  def initialize(facet_key:, facet_value:, search:)
    @facet_key = facet_key
    @facet_value = facet_value
    @search = search
  end

  attr_reader :facet_value, :search, :facet_key

  def label
    if clear?
      "#{facet_value.value} X"
    else
      "#{facet_value.value} (#{facet_value.count})"
    end
  end

  def clear?
    Array(search.try(facet_key)).include?(facet_value.value)
  end

  def params
    clear_facet_value = clear? ? facet_value : nil
    add_facet_value = clear? ? nil : facet_value
    SearchParamsSupport.to_params(search:, clear_facet_value:, add_facet_value:)
  end
end
