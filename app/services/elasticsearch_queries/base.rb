# frozen_string_literal: true

module ElasticsearchQueries
  class Base
    def initialize(search:)
      @search = search
    end

    protected

    attr_reader :search
  end
end
