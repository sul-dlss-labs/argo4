# frozen_string_literal: true

# Renders a button for removing the query from the search.
class RemoveQueryButtonComponent < ViewComponent::Base
  def initialize(search:)
    @search = search
  end

  attr_reader :search

  delegate :query, to: :search

  def label
    "#{query} X"
  end

  def params
    SearchParamsSupport.to_params(search:, clear_query: true)
  end

  def render?
    query.present?
  end
end
