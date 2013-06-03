class StatusController < ApplicationController
  def show
    # TODO run slow system calls via AJAX
    @node             = Status.node
    @npm              = Status.npm
    @coffee           = Status.coffee
    @hubot            = Status.hubot
    @hubots_dir       = Hubot.base_dir
    @hubots_dir_perms = Status.hubot_dir_writable?
    @sys_user         = Status.sys_user
    @not_root         = Status.not_root?
  end
end
