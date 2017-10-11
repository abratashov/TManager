class AddExtraIndices < ActiveRecord::Migration[5.1]
  def change
    add_index :tasks, [:project_id, :position], unique: true
  end
end
