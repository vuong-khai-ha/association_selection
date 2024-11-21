# frozen_string_literal: true

module AssociationSelection
  module V6
    module Relation
      def preload_associations(records) # :nodoc:
        preload = preload_values
        preload += includes_values unless eager_loading?
        preloader = nil

        any_specified_fields = assoc_select_fields.is_a?(Hash)
        indexed_reflections = model.reflections.map { |k, r| [k, r.class_name] }.to_h if any_specified_fields
        preload.each do |associations|
          preloader ||= build_preloader
          if any_specified_fields && indexed_reflections.key?(associations.to_s)
            preloader.preload(
              records,
              associations,
              indexed_reflections[associations.to_s].constantize.select(assoc_select_fields[associations])
            )
          else
            preloader.preload records, associations
          end
        end
      end
    end
  end
end
