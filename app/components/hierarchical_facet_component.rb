# frozen_string_literal: true

# Render a facet as a hierarchical list of facet buttons.
class HierarchicalFacetComponent < FacetComponent
  def value_style(value)
    level = value.count ':'
    "margin-left: #{level * 25}px;"
  end
end
