# frozen_string_literal: true

module AssociationSelection
  module V5
    module Preloader
      attr_accessor :relation_klass, :assoc_select_fields

      NULL_RELATION = Struct.new(:values, :where_clause, :joins_values)
                            .new({}, ::ActiveRecord::Relation::WhereClause.empty, [])

      def preload(records, associations, preload_scope = nil)
        records       = Array.wrap(records).compact.uniq
        associations  = Array.wrap(associations)
        preload_scope ||= nil

        return [] if records.empty?

        any_specified_fields = relation_klass.present? && assoc_select_fields.is_a?(Hash)
        indexed_reflections = relation_klass.reflections.map { |k, r| [k, r.class_name] }.to_h if any_specified_fields
        associations.flat_map do |association|
          if any_specified_fields && indexed_reflections.key?(association.to_s)
            preloaders_on(
              association,
              records,
              indexed_reflections[association.to_s].constantize.select(assoc_select_fields[association])
            )
          else
            preloaders_on association, records, preload_scope
          end
        end
      end
    end
  end
end
