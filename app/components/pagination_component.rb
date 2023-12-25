# frozen_string_literal: true

# Renders buttons for navigating search results.
class PaginationComponent < ViewComponent::Base
  def initialize(search:, result:)
    @search = search
    @result = result
  end

  attr_reader :search, :result

  delegate :total_documents, to: :result
  delegate :page, :page_size, to: :search

  def page_start
    ((page - 1) * page_size) + 1
  end

  def page_end
    [page * page_size, total_documents].min
  end

  def previous_page?
    page > 1
  end

  def next_page?
    (total_documents.to_f / page_size).ceil > page
  end
end
