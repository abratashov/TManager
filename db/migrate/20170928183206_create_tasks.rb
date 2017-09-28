class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :deadline
      t.integer :position
      t.boolean :done, default: false
      t.references :project, foreign_key: true
      t.integer :comments_count, default: 0

      t.timestamps
    end
  end
end
