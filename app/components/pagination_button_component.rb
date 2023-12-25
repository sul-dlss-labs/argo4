# frozen_string_literal: true

# Renders a labeled button for search result pagination.
class PaginationButtonComponent < ViewComponent::Base
  def initialize(search:, label:, page:, render: true)
    @search = search
    @label = label
    @page = page
    @render = render
  end

  attr_reader :search, :label, :page

  def params
    SearchParamsSupport.to_params(search:, page:)
  end

  def render?
    @render
  end
end
