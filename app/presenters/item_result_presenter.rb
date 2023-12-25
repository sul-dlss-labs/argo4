# frozen_string_literal: true

# Presenter that abstracts the attributes of an Item for rendering in a results list.
class ItemResultPresenter
  def initialize(elasticsearch_doc:)
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
