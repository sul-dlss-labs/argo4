# frozen_string_literal: true

module ElasticsearchActions
  class Base
    def initialize(client:)
      @client = client
    end

    protected

    attr_reader :client

    def index
      Settings.elasticsearch.index
    end
  end
end
