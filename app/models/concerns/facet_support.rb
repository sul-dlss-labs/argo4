# frozen_string_literal: true

module FacetSupport
  extend ActiveSupport::Concern

  included do
    def facet_label(key)
      self.class.facet_label(key)
    end

    def facet_attribute_keys
      self.class.facet_attribute_keys
    end

    def facet_attribute(key)
      self.class.facet_attribute(key)
    end
  end

  class_methods do
    def facet_attribute(key)
      attribute_types[key]
    end

    def facet_attributes
      attribute_types.values.select { |value| value.is_a?(Type::Facet) }
    end

    def facet_attribute_keys
      attribute_types.keys.select { |key| attribute_types[key].is_a?(Type::Facet) }
    end

    def facet_label(key)
      attribute_types[key].label
    end

    def facet_component(key)
      attribute_types[key].component
    end
  end
end
