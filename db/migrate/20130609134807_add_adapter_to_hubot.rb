class AddAdapterToHubot < ActiveRecord::Migration
  def change
    add_column :hubots, :adapter, :string
  end
end
