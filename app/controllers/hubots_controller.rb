class HubotsController < ApplicationController

  def index

  end

  def show
    @hubot = Hubot.find params[:id]
  end

  def new
    @creating_hubot = true
    @hubot = Hubot.new
  end

  def create
    @hubot = Hubot.create(hubot_params)
    if @hubot.errors.any?
      flash[:error] = @hubot.errors.messages.collect { |k, v| "#{k} #{v.join(', ')}".capitalize }
      render :new
    end
  end

  def destroy
    @hubot = Hubot.find(params[:id])
    @hubot.destroy
  end

  def interact
    @hubot = Hubot.find(params[:id])
    @shell = @hubot.start_shell
    gon.hubot_stream_url = url_for(action: :interact_stream)
  end

  def interact_stream
    @shell = Hubot.shell(params[:id])
    puts "shell: #{@shell}"
    if request.get? && @shell
      return render text: @shell.readlines
    elsif request.post? && @shell
      @shell.write params[:message]
    end
    render nothing: true
  end

  private

    def hubot_params
      params.require(:hubot).permit(:name, :port, :test_port)
    end

end
