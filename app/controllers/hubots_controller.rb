class HubotsController < ApplicationController

  include ActionController::Live

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
    @hubot.start
  end

  def interact_stream
    @hubot = Hubot.find(params[:id])

  end

  private

    def hubot_params
      params.require(:hubot).permit(:name, :port)
    end

end
