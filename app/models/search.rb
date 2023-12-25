# frozen_string_literal: true

class Search
  include ActiveModel::API
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  include ActiveModel::Conversion
  include FacetSupport
  include BroadcastSupport

  attribute :id, :string, default: -> { "search-#{SecureRandom.uuid}" }
  attribute :page, :integer, default: 1
  attribute :page_size, :integer, default: 15
  attribute :query, :string

  # The facets
  attribute :object_type, Type::Facet.new(
    label: 'Object Type'
  ), default: []
  attribute :content_type, Type::Facet.new(
    label: 'Content Type'
  ), default: []
  attribute :project_tag, Type::Facet.new(
    label: 'Project Tag',
    multi: false,
    agg_proc: ElasticsearchAggregations::Tags,
    component: HierarchicalFacetComponent
  ), default: []
  attribute :released_to_searchworks_date, Type::Facet.new(
    label: 'Released to Searchworks',
    agg_proc: ElasticsearchAggregations::ReleasedToSearchworksDate,
    agg_response_proc: ElasticsearchAggregationResponses::Date,
    filter_proc: ElasticsearchFilters::ReleasedToSearchworksDate
  ), default: []

  def persisted?
    true
  end
end
