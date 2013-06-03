class Hubot < ActiveRecord::Base

  validates :name, uniqueness: true, presence: true

  before_create :install
  before_destroy :uninstall

  def self.base_dir
    @@base_dir ||= Rails.root.join('hubots')
  end

  private

    def install
      self.location = File.join(Hubot.base_dir, name.parameterize)
      # TODO installation code
    end

    def uninstall
      # TODO removal code
    end
end
