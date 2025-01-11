class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.string :grade
      t.references :subject, null: false, foreign_key: true
      t.references :student, type: :uuid, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end

    add_index :enrollments, [:student_id, :subject_id, :section_id], unique: true, name: "index_enrollments_on_student_subject_and_section"
  end
end
