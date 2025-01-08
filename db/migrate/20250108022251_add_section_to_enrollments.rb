class AddSectionToEnrollments < ActiveRecord::Migration[8.0]
  def change
    add_reference :enrollments, :section, foreign_key: true
  end
end
