class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.integer :duration, null: false, default: 0
      t.integer :days_of_week, null: false, default: 50
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true

      t.timestamps
    end
  end
end
