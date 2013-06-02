class CreateHubots < ActiveRecord::Migration
  def change
    create_table :hubots do |t|
      t.string :name
      t.string :location

      t.timestamps
    end
  end
end
