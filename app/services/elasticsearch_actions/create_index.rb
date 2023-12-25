# frozen_string_literal: true

module ElasticsearchActions
  # Deletes and regenerates an index.
  class CreateIndex < Base
    def call
      client.indices.delete(index:, ignore_unavailable: true)
      client.indices.create(index:, body: index_definition)
    end

    private

    def index_definition
      {
        mappings: {
          properties: {
            druid: { type: 'keyword' },
            title: { type: 'text' },
            object_type: { type: 'keyword' },
            content_type: { type: 'keyword' },
            project_tag: { type: 'keyword' },
            released_to_searchworks_date: { type: 'date', format: 'date_time_no_millis' }
          }
        }
      }
    end
  end
end
