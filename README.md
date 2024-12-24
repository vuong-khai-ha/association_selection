# AssociationSelection

`AssociationSelection` is a gem that allows you to specify which fields to select when preloading associations. It offers finer control over database queries, optimizing memory usage and enhancing performance by fetching only the necessary fields.

Features
---

- Select specific fields for associated records when using `includes` or `preload`.
- Seamlessly integrates with ActiveRecord.
- Reduces memory overhead and improves query efficiency.

Installation
---

Add this line to your application's Gemfile:

```ruby
gem 'association_selection'
```

And then execute:

```ruby
bundle install
```

Or install it yourself as:

```
gem install association_selection
```

Usage
===


Quick Start
---

1. Include the gem in your Rails application.
2. Use the `assoc_select` method to specify the fields to fetch for associated records.

Example
---
#### Schema
```ruby
ActiveRecord::Schema.define do
  create_table :departments do |t|
    t.string :name
  end

  create_table :employees do |t|
    t.integer :department_id
    t.string :name
    t.string :email
    t.integer :gender
  end
end
```

#### Models
```ruby
class Department < ActiveRecord::Base
  has_many :employees
end

class Employee < ActiveRecord::Base
  belongs_to :department
end
```


#### Query
**Without** `assoc_select`
```ruby
departments = Department.includes(:employees).to_a
departments.each do |department|
  department.employees.each do |employee|
    puts employee.name
  end
end
```
The generated SQL commands will be:
```sql
Department Load (0.1ms)  SELECT "departments".* FROM "departments"
Employee Load (0.2ms)  SELECT "employees".* FROM "employees" WHERE "employees"."department_id" IN (1, 2, 3, 4, 5, 6)
```

**With** `assoc_select`
```ruby
departments = Department.assoc_select(employees: %i[id name department_id]).includes(:employees)
departments.each do |department|
  department.employees.each do |employee|
    puts employee.name
  end
end
```

The generated SQL commands will be:
```sql
Department Load (0.1ms)  SELECT "departments".* FROM "departments"
Employee Load (0.1ms)  SELECT "employees"."id", "employees"."name", "employees"."department_id" FROM "employees" WHERE "employees"."department_id" IN (1, 2, 3, 4, 5, 6)
```

Specifying the fields of associations is particularly useful in cases where associations have many fields or the data of unnecessary fields is too large.

How It Works
---
The assoc_select method modifies the query to include only the specified fields for the given association. It works seamlessly with ActiveRecord's includes, preload, and eager_load methods.

Compatibility
---
This gem is tested with ActiveRecord versions 5, 6, 7, and newer

Bug reports & suggested improvements
---
If you have found a bug or want to suggest an improvement, please use our issue tracked at:

https://github.com/vuong-khai-ha/association_selection

If you want to contribute, fork the project, code your improvements and make a pull request on Github. Please don't forget to add tests.
If your contribution is fixing a bug it would be better if you could submit a failing test, illustrating the issue.
