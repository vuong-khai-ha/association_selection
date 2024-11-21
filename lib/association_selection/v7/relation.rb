# frozen_string_literal: true

module AssociationSelection
  module V7
    module Relation
      def preload_associations(records) # :nodoc:
        preload = preload_values
        preload += includes_values unless eager_loading?
        scope = strict_loading_value ? StrictLoadingScope : nil
        any_specified_fields = scope.nil? && assoc_select_fields.is_a?(Hash)
        indexed_reflections = model.reflections.map { |k, r| [k, r.class_name] }.to_h if any_specified_fields
        preload.each do |associations|
          if any_specified_fields && indexed_reflections.key?(associations.to_s)
            scope = indexed_reflections[associations.to_s].constantize.select(assoc_select_fields[associations])
          end
          ActiveRecord::Associations::Preloader.new(records: records, associations: associations, scope: scope).call
        end
      end
    end
  end
end
