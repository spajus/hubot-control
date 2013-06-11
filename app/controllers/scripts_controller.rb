class ScriptsController < ApplicationController

  def index
  end

  def create
    redirect_to edit_scripts_path(script: params[:filename])
  end

  def edit

    filename = params[:script]

    unless valid_filename?(filename)
      flash[:error] = "Unsupported script name or type"
      return redirect_to scripts_path
    end

    @script = Script.new(filename)
    if request.post?

      if params[:filename] && params[:filename] != filename
        if valid_filename?(params[:filename])
          @script.delete
          @script.filename = params[:filename]
          redirect_to edit_scripts_path(params[:filename])
        else
          flash[:error] = "Filename should end with .js or .coffee"
        end
      end

      @script.write params[:content]
      flash[:success] = 'Script updated'
    end
  end

  def destroy
    filename = params[:script]
    @script = Script.new(filename).delete
    flash[:notice] = "Script deleted: #{filename}"
    redirect_to scripts_path
  end

  private

    def valid_filename?(filename)
      filename.match(/^[a-z0-9_-]+\.(js|coffee)$/i)
    end
end
