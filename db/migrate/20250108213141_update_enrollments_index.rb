class UpdateEnrollmentsIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :enrollments, [:student_id, :subject_id]
    add_index :enrollments, [:student_id, :subject_id, :section_id], unique: true, name: "index_enrollments_on_student_subject_and_section"
  end
end
