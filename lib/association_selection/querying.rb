# frozen_string_literal: true

module AssociationSelection
  module Querying
    attr_accessor :assoc_select_fields

    def assoc_select(**fields)
      spawn.tap { |s| s.assoc_select_fields = fields }
    end
  end

  module Delegations
    delegate :assoc_select, to: :all
  end
end
