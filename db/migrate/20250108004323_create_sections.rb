class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration, default: 50
      t.integer :days_of_week
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true

      t.timestamps
    end
  end
end
