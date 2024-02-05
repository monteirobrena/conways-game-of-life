class AddAttemptsPerformedToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :attempts_performed, :integer, default: 0
  end
end
