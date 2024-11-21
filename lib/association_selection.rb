# frozen_string_literal: true

require_relative 'association_selection/version'
require_relative 'association_selection/querying'

module AssociationSelection
  def self.setup
    ActiveSupport.on_load(:active_record) do |base|
      base.extend AssociationSelection::Delegations
      ActiveRecord::Relation.include AssociationSelection::Querying

      if ActiveRecord.version >= Gem::Version.new('7.0')
        require_relative 'association_selection/v7/relation'
        ActiveRecord::Relation.prepend AssociationSelection::V7::Relation
      elsif ActiveRecord.version >= Gem::Version.new('6.0')
        require_relative 'association_selection/v6/relation'
        ActiveRecord::Relation.prepend AssociationSelection::V6::Relation
      else
        require_relative 'association_selection/v5/relation'
        require_relative 'association_selection/v5/preloader'
        ActiveRecord::Associations::Preloader.prepend AssociationSelection::V5::Preloader
        ActiveRecord::Relation.prepend AssociationSelection::V5::Relation
      end
    end
  end
end

AssociationSelection.setup
