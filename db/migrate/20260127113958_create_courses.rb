class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :duration
      t.string :status

      t.timestamps
    end
  end
end
