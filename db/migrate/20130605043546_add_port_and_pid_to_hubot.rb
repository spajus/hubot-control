class AddPortAndPidToHubot < ActiveRecord::Migration
  def change
    add_column :hubots, :port, :integer
    add_column :hubots, :pid,  :integer
  end
end
