class GitSync < ActiveRecord::Base

  after_destroy :remove_repo

  def self.for_scripts
    where(target: 'scripts').first_or_initialize
  end

  def init
    Git.clone(repo, repo_name, path: repo_parent_dir)
  end

  def fetch
    g = Git.open(repo_dir)
    g.fetch
  end

  def repo_name
    Pathname.new(repo_dir).basename.to_s
  end

  def repo_parent_dir
    Pathname.new(repo_dir).dirname.to_s
  end

  def repo_dir
    if target == 'scripts'
      Rails.root.join('scripts').to_s
    elsif target == 'hubot'
      Hubot.find(target_id).location.to_s
    end
  end

  def remove_repo
    Shell.system "rm -rf #{repo_dir}/.git"
  end

end
