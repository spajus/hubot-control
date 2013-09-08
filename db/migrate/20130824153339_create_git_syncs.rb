class CreateGitSyncs < ActiveRecord::Migration
  def change
    create_table :git_syncs do |t|
      t.string :target, limit: 20
      t.integer :target_id

      t.string :repo
      t.string :branch

      t.string :user_name
      t.string :user_email

      t.string :user
      t.string :password

      t.index [:target, :target_id]

      t.timestamps
    end
  end
end
