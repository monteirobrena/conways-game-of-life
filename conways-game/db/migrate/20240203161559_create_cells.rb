class CreateCells < ActiveRecord::Migration[7.1]
  def change
    create_table :cells do |t|
      t.references :board, null: false, foreign_key: true
      t.references :main_cell, foreign_key: { to_table: :cells }
      t.boolean :alive
      t.integer :x_position
      t.integer :y_position

      t.timestamps
    end
  end
end
