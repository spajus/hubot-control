class StatusController < ApplicationController
  def show
    # TODO run slow system calls via AJAX
    @node              = Status.node
    @npm               = Status.npm
    @coffee            = Status.coffee
    @hubot             = Status.hubot
    @yo                = Status.yo
    @hubots_dir        = Hubot.base_dir
    @scripts_dir       = Script.base_dir
    @hubots_dir_perms  = Status.hubot_dir_writable?
    @scripts_dir_perms = Status.scripts_dir_writable?
    @sys_user          = Status.sys_user
  end
end
