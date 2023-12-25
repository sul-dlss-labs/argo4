# frozen_string_literal: true

module ElasticsearchActions
  # Indexes multiple documents with a single call.
  class BulkIndex < Base
    def initialize(client:, documents:)
      @documents = documents
      super(client:)
    end

    def call
      client.bulk({ body: ingest_docs })
    end

    private

    attr_reader :documents

    def ingest_docs
      documents.map { |doc| { index: { _index: index, data: doc, _id: doc[:druid] } } }
    end
  end
end
