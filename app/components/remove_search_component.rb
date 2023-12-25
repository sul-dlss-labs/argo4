# frozen_string_literal: true

# Renders the section for removing parts of the search.
class RemoveSearchComponent < ViewComponent::Base
  def initialize(search:)
    @search = search
  end

  attr_reader :search

  def facet_values
    search.facet_attribute_keys.map do |facet_key|
      Array(search.try(facet_key)).map do |value|
        ElasticsearchRepository::FacetValue.new(facet_key:, value:)
      end
    end.flatten
  end
end
