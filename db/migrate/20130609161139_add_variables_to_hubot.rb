class AddVariablesToHubot < ActiveRecord::Migration
  def change
    add_column :hubots, :variables, :text
  end
end
