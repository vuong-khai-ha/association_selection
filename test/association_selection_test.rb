# frozen_string_literal: true

require_relative 'test_helper'

class AssociationSelectionTest < Minitest::Test
  EMPLOYEE_SELECT_FIELDS = %w[id department_id name].freeze
  NOTICE_SELECT_FIELDS = %w[id department_id title].freeze

  def setup
    ::Department.create!([
      {
        name: 'HR',
        employees_attributes: [
          { name: 'Ha', email: 'inki.personal@gmail.com', gender: 1 },
          { name: 'Vuong Khai', email: 'inki.personal+1@gmail.com', gender: 0 }
        ],
        notices_attributes: [
          { title: 'First notice', content: 'First notice content' },
          { title: 'Second notice', content: 'Second notice content' }
        ]
      },
      {
        name: 'Developer',
        employees_attributes: [
          { name: 'Ha inKi', email: 'inki.personal+2@gmail.com', gender: 1 }
        ],
        notices_attributes: [
          { title: 'Third notice', content: 'Third notice content' }
        ]
      }
    ])
  end

  def test_assoc_select_adds_specify_fields
    assert_equal(
      { employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS },
      ::Department
        .includes(:employees)
        .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
        .assoc_select_fields
    )
    assert_equal(
      { employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS },
      ::Department
        .where(id: 1..2)
        .includes(:employees)
        .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
        .assoc_select_fields
    )

    assert_equal(
      { employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS },
      ::Department
        .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
        .includes(:employees)
        .assoc_select_fields
    )
    assert_equal(
      { employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS },
      ::Department
        .where(id: 1..2)
        .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
        .includes(:employees)
        .assoc_select_fields
    )
  end

  def test_preload_with_specify_fields
    assert_func = lambda do |departments|
      departments.each do |department|
        department.employees.each do |employee|
          assert_equal employee.attributes.keys, EMPLOYEE_SELECT_FIELDS
        end
        department.notices.each do |notice|
          assert_equal notice.attributes.keys, NOTICE_SELECT_FIELDS
        end
      end
    end

    assert_func.call(
      ::Department
        .includes(:employees, :notices)
        .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
    )
    assert_func.call(
      ::Department
        .where(id: 1..2)
        .includes(:employees, :notices)
        .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
    )
    assert_func.call(
      ::Department
        .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
        .includes(:employees, :notices)
    )
    assert_func.call(
      ::Department
        .where(id: 1..2)
        .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
        .includes(:employees, :notices)
    )
  end

  def test_assoc_select_does_not_affect_other_queries
    ::Department
      .includes(:employees, :notices)
      .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
    ::Department
      .where(id: 1..2)
      .includes(:employees, :notices)
      .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
    ::Department
      .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
      .includes(:employees, :notices)
    ::Department
      .where(id: 1..2)
      .assoc_select(employees: EMPLOYEE_SELECT_FIELDS, notices: NOTICE_SELECT_FIELDS)
      .includes(:employees, :notices)
    departments = ::Department.includes(:employees)
    assert_nil departments.assoc_select_fields
    departments.each do |department|
      department.employees.each do |employee|
        refute_empty employee.attributes.keys - EMPLOYEE_SELECT_FIELDS
      end
    end
  end
end
