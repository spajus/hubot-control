class AddAdminUser < ActiveRecord::Migration
  def change
    user = User.create(email: 'admin@hubot-control.org', password: 'hubot')
    user.save(validate: false)
  end
end
