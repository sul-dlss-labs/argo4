# frozen_string_literal: true

class SearchChannel < Turbo::StreamsChannel
  extend Turbo::Streams::StreamName
  extend Turbo::Streams::Broadcasts
  include Turbo::Streams::StreamName::ClassMethods

  def subscribed
    if (stream_name = verified_stream_name_from_params).present?
      stream_from stream_name
      # Perform the initial search now that the stream is connected.
      SearchService.new(search: Search.new(id: params['id'])).call
    else
      reject
    end
  end
end
