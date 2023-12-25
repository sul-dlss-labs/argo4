# frozen_string_literal: true

class SearchesController < ApplicationController
  def update
    @search = Search.new(**search_params, id: params[:id])
    SearchService.new(search: @search).call
  end

  def index
    @search = Search.new
  end

  private

  def search_params
    params.require(:search).permit(:query, :id, :page, :page_size, object_type: [], content_type: [], project_tag: [],
                                                                   released_to_searchworks_date: [])
  end
end
