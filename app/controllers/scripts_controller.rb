class ScriptsController < ApplicationController

  def index
  end

  def edit
    unless params[:script].match(/[a-z0-9_-]+/i) && params[:format].match(/(js|coffee)/)
      flash[:error] = "Unsupported script name or type"
      return redirect_to root_path
    end
    filename = "#{params[:script]}.#{params[:format]}"
    @script = Script.new(filename)
    if request.post?
      @script.write params[:content]
      flash[:success] = 'Script updated'
    end
  end

  def delete
    filename = "#{params[:script]}.#{params[:format]}"
    @script = Script.new(filename).delete
    flash[:notice] = "Script deleted: #{filename}"
    redirect_to scripts_path
  end
end
