# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'active_record'
require 'minitest/autorun'
require 'association_selection'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :departments do |t|
    t.integer  :creator
    t.string   :name
  end

  create_table :notices do |t|
    t.integer  :department_id
    t.string   :title
    t.string   :content
  end

  create_table :employees do |t|
    t.integer  :department_id
    t.string   :name
    t.string   :email
    t.integer  :gender
  end
end

require_relative 'models/department'
require_relative 'models/employee'
require_relative 'models/notice'
