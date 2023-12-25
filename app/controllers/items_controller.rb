# frozen_string_literal: true

class ItemsController < ApplicationController
  def show
    @item = item_presenter
  end

  private

  def druid
    "druid:#{params[:id].delete_prefix('druid:')}"
  end

  def item_presenter
    elasticsearch_doc = ElasticsearchRepository.new.find(druid:)
    ItemPresenter.new(elasticsearch_doc:)
  end
end
