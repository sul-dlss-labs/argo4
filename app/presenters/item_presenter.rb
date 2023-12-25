# frozen_string_literal: true

# Presenter that abstracts the attributes of an Item.
class ItemPresenter
  def initialize(elasticsearch_doc:)
    # For now this just uses an ES document.
    # In the future, would also take a Cocina item.
    @elasticsearch_doc = elasticsearch_doc.with_indifferent_access
  end

  def druid
    elasticsearch_doc[:druid]
  end

  def title
    elasticsearch_doc[:title]
  end

  private

  attr_reader :elasticsearch_doc
end
