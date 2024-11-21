# frozen_string_literal: true

module AssociationSelection
  module V5
    module Relation
      def build_preloader
        ActiveRecord::Associations::Preloader.new.tap do |new_preloader|
          new_preloader.assoc_select_fields = assoc_select_fields
          new_preloader.relation_klass = model
        end
      end
    end
  end
end
