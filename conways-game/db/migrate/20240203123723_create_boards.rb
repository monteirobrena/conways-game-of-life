class CreateBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :boards do |t|
      t.integer :size
      t.integer :attempts

      t.timestamps
    end
  end
end
