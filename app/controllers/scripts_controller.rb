class ScriptsController < ApplicationController

  def index
    @changed_files = git.changed_files
    @scripts = Script.list
  end

  def create
    redirect_to_edit
  end

  def edit
    unless valid_filename?(params[:script])
      flash[:error] = "Unsupported script name or type"
      return redirect_to scripts_path
    end

    @script = Script.new(params[:script])

    update_script
  end

  def git_sync
    if repo = params[:repo]
      git.repo = repo
      git.user_name = params[:user_name]
      git.user_email = params[:user_email]
      git.init
      git.save
      flash[:success] = "Will use #{repo} to control source code of your scripts"
    end
    redirect_to scripts_path
  end

  def git_pull
    if response = git.pull
      git_flash('Git pull success:', response)
    else
      flash[:error] = "Could not pull. Try committing your changes or inspect the repo at #{git.repo_dir} for merge conflicts or errors."
    end
    redirect_to scripts_path
  end

  def git_commit
    if msg = params[:message]
      description = params[:description].try(:strip)
      msg = "#{msg}\n#{description}" if description.present?
      git.commit(msg)
      flash[:success] = 'Git commit added and synced with remote repo'
    else
      flash[:error] = 'Please provide a commit message'
    end
    redirect_to scripts_path
  end

  def git_reset
    git.reset
    flash[:success] = 'Reverted local changes'
    redirect_to scripts_path
  end

  def git_unlink
    GitSync.for_scripts.destroy
    flash[:success] = 'Unlinked git repo'
    redirect_to scripts_path
  end

  def destroy
    filename = params[:script]
    @script = Script.new(filename).delete
    flash[:notice] = "Script deleted: #{filename}"
    redirect_to scripts_path
  end

  private

    def git_flash(msg, response)
      flash[:success] = "<p>#{msg}</p><pre>#{response}</pre>".html_safe
    end

    def git
      @git_sync ||= GitSync.for_scripts
    end

    def update_script
      return unless request.post?

      handle_rename

      @script.write params[:content]
      flash[:success] = 'Script updated'
    end

    def handle_rename
      return unless params[:filename] && params[:filename] != params[:script]
      unless valid_filename?(params[:filename])
        flash[:error] = "Filename should end with .js or .coffee"
        return
      end
      @script.delete
      @script.filename = params[:filename]
      redirect_to_edit
    end

    def redirect_to_edit
      redirect_to edit_scripts_path(script: params[:filename])
    end

    def valid_filename?(filename)
      filename.match(/^[a-z0-9_-]+\.(js|coffee)$/i)
    end
end
