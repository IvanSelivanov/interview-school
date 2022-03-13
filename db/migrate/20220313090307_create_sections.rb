class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.references :teacher_subject, null: false, foreign_key: true

      # could be enum (if SQLite supports enums) but used string for simplicity
      # also, enums could be difficult to modify later
      t.string :weekdays, null: false
      t.references :classroom, null: false, foreign_key: true
      t.time :start_at
      t.time :end_at

      t.timestamps
    end
  end
end
