class Hubot < ActiveRecord::Base

  def self.base_dir
    @@base_dir ||= Rails.root.join('hubots')
  end
end
