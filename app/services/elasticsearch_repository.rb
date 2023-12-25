# frozen_string_literal: true

# Repository service for Elasticsearch.
class ElasticsearchRepository
  # Model for a single value for a facet.
  FacetValue = Struct.new(:value, :count, :facet_key, keyword_init: true)
  # Model for a facet.
  Facet = Struct.new(:key, :values, keyword_init: true)
  # Model for a search result.
  SearchResult = Struct.new(:documents, :facets, :total_documents, keyword_init: true)

  def client
    @client ||= Elasticsearch::Client.new(
      host: Settings.elasticsearch.host,
      user: Settings.elasticsearch.username,
      password: Settings.elasticsearch.password,
      transport_options: { ssl: { ca_file: Settings.elasticsearch.ca_file } }
    )
  end

  def create_index
    ElasticsearchActions::CreateIndex.new(client:).call
  end

  def index(document:)
    response = client.index(index:, body: document, id: document[:druid])
    response['_id']
  end

  def find(druid:)
    response = client.get(index:, id: druid)
    response['_source'].with_indifferent_access
  end

  def search(search:, aggs:)
    ElasticsearchActions::Search.new(client:, search:, aggs:).call
  end

  def bulk_index(documents:)
    ElasticsearchActions::BulkIndex.new(client:, documents:).call
  end

  private

  def index
    Settings.elasticsearch.index
  end
end
