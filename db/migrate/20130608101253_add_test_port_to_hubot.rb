class AddTestPortToHubot < ActiveRecord::Migration
  def change
    add_column :hubots, :test_port, :integer
  end
end
