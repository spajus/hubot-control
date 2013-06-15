class AddTitleToHubots < ActiveRecord::Migration
  def change
    add_column :hubots, :title, :string
    Hubot.find_each { |h| h.update_attributes!(title: h.name) }
  end
end
