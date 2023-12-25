# frozen_string_literal: true

# Munges a search into form parameters that can be provided to a form button.
class SearchParamsSupport
  def self.to_params(search:, add_facet_value: nil, clear_facet_value: nil, page: nil, clear_query: false)
    search.serializable_hash.map do |key, values|
      next ['search[page]', page] if key == 'page' && page.present? && page > 1
      # Omit id and page
      next if %w[id page].include?(key)
      next if key == 'query' && clear_query
      # Query isn't an array
      next ['search[query]', values] if key == 'query'
      # Remove this value if clearing
      next ["search[#{key}]", values - [clear_facet_value.value]] if key == clear_facet_value&.facet_key
      # Add this value for this facet
      next ["search[#{key}]", values + [add_facet_value.value]] if key == add_facet_value&.facet_key

      # All other keys are arrays
      ["search[#{key}]", values]
    end.compact.to_h
  end
end
