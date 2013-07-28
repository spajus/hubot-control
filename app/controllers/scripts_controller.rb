class ScriptsController < ApplicationController

  def index
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

  def destroy
    filename = params[:script]
    @script = Script.new(filename).delete
    flash[:notice] = "Script deleted: #{filename}"
    redirect_to scripts_path
  end

  private

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
