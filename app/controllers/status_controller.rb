class StatusController < ApplicationController
  def show
    @node   = `node -v`
    @npm    = `npm -v`
    @coffee = `coffee -v`
    @hubot  = `hubot -v`
    @hubots_dir = Rails.root.join('hubots')
    @hubots_dir_perms = File.writable? @hubots_dir
  end
end
