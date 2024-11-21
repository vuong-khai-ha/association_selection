# frozen_string_literal: true

class Department < ActiveRecord::Base
  has_many :employees
  has_many :notices

  accepts_nested_attributes_for :employees, :notices
end
