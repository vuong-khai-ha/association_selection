# frozen_string_literal: true

class Notice < ActiveRecord::Base
  belongs_to :department
end
