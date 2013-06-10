class HubotsController < ApplicationController

  before_filter :find_hubot, except: [:index, :interact_stream, :new, :create]

  def index
  end

  def show
  end

  def edit
  end

  def update
    @hubot.update_attributes(hubot_params)
    @hubot.save
    if @hubot.errors.any?
      flash[:error] = @hubot.errors.messages.collect { |k, v| "#{k} #{v.join(', ')}".capitalize }
    else
      flash[:success] = "#{@hubot.name} updated!"
    end
    render :edit
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
    flash[:notice] = "Destroyed #{@hubot.name} :("
    redirect_to root_path
  end

  def start
    return redirect_to root_path unless request.post?
    @hubot = Hubot.find(params[:id])
    unless @hubot.running?
      @hubot.install_packages
      @hubot.start
    end
    redirect_to @hubot
  end

  def stop
    return redirect_to '/' unless request.post?
    @hubot = Hubot.find(params[:id])
    @hubot.stop if @hubot.running?
    redirect_to @hubot
  end

  def interact
    @hubot = Hubot.find(params[:id])
    if request.get?
      @shell = @hubot.start_shell
      gon.hubot_stream_url = url_for(action: :interact_stream)
    elsif request.delete?
      @hubot.stop_shell
      redirect_to @hubot
    end
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

  def log
    @log = @hubot.log_tail(500)
    return render text: @log if request.post?
    gon.log_stream_url = url_for(action: :log)
  end

  def configure
    @config = @hubot.config
    if request.post?
      variables = params[:variables]
      package = params[:package]
      hubot_scripts = params[:hubot_scripts]
      external_scripts = params[:external_scripts]

      if validate_json({'variables' => variables,
                        'package.json' => package,
                        'hubot-scripts.json' => hubot_scripts,
                        'external-scripts.json' => external_scripts})
        @config.variables = variables
        @config.package = package
        @config.hubot_scripts = hubot_scripts
        @config.external_scripts = external_scripts
        flash[:success] = 'Updated all configuration files'
      end

    end
  end

  private

    def validate_json(files = {})
      errors = []
      files.each do |name, val|
        errors << name unless HubotConfig.valid_json?(val)
      end
      if errors.any?
        flash[:error] = "Invalid JSON in #{errors.join(',')}"
        return false
      end
      true
    end

    def find_hubot
      @hubot = Hubot.find params[:id] if params[:id]
    end

    def hubot_params
      params.require(:hubot).permit(:name, :adapter, :port, :test_port)
    end

end
