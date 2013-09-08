class GitSync < ActiveRecord::Base

  after_destroy :remove_repo
  before_save :update_repo

  def self.for_scripts
    where(target: 'scripts').first_or_initialize
  end

  def init
    return if cloned?
    if can_clone?
      Git.clone(repo, repo_name, path: repo_parent_dir)
    else
      temp = File.join(Dir.tmpdir, 'script_migrate')
      FileUtils.mkdir_p(temp)
      Shell.system "mv -f #{repo_dir}/* #{temp}"
      Git.clone(repo, repo_name, path: repo_parent_dir)
      Shell.system "mv -f #{temp}/* #{repo_dir}"
      Shell.system "rm -rf #{temp}"
    end
  end

  def status
    git.status
  rescue => e
    Rails.logger.error(e)
    false
  end

  def changed_files
    st = status
    if st == false
      Dir.entries(repo_dir).reject { |e| e.start_with?('.') }
    else
      st.changed.keys + st.untracked.keys
    end
  end

  def commit(message)
    pull
    git.add(all: true)
    git.commit(message)
    git.push(:origin, :master)
  end

  def pull
    git.pull
  rescue => e
    Rails.logger.error(e)
    false
  end

  def reset
    git.reset_hard
  end

  def push
    git.push(:origin, :master)
  end

  def repo_dir
    if target == 'scripts'
      Rails.root.join('scripts').to_s
    elsif target == 'hubot'
      Hubot.find(target_id).location.to_s
    end
  end

  private

  def can_clone?
    (Dir.entries(repo_dir) - ['.', '..']).empty?
  end

  def cloned?
    Dir.exist?(File.join(repo_dir, '.git'))
  end

  def git
    Git.open(repo_dir)
  end

  def repo_name
    Pathname.new(repo_dir).basename.to_s
  end

  def repo_parent_dir
    Pathname.new(repo_dir).dirname.to_s
  end

  def remove_repo
    Shell.system "rm -rf #{repo_dir}/.git"
  end

  def update_repo
    g = Git.open(repo_dir)
    g.config('user.name', user_name)
    g.config('user.email', user_email)
    g.remotes.first.remove
    g.add_remote(:origin, repo)
  end

end
