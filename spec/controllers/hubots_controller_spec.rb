require 'spec_helper'

describe HubotsController do

  let(:user) { create :user }
  let(:hubot) { create :hubot }
  let(:pty) { double(:pty) }

  before do
    PTY.stub(:open).and_return([pty, pty])
    pty.stub(:raw!)
    pty.stub(:close)
    pty.stub(:gets).and_return('stuff')
    sign_in :user, user
  end

  describe 'GET #index' do
    subject { get :index }

    it { should be_success }
  end

  describe 'GET #new' do
    subject { get :new }

    it { should be_success }
  end

  describe 'GET #show' do
    subject { get :show, id: hubot.id }

    it { should be_success }
  end

  describe 'POST #create' do
    let(:hubot_params) { {
      title: 'New Hubot',
      name: 'new_hubot',
      adapter: 'shell',
      port: 10101,
      test_port: 10102,
    }}
    subject { post :create, hubot: hubot_params }

    specify do
      expect { subject }.to change { Hubot.count }.by(1)
    end
  end

  describe 'PATCH #update' do
    let(:old_title) { hubot.title }
    let(:new_title) { 'New Hubot Title' }
    subject { patch :update, id: hubot.id, hubot: { title: new_title } }

    specify do
      expect { subject }.to change { hubot.reload.title }.from(old_title).to(new_title)
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_hubot) { delete :destroy, id: hubot.id }
    before { destroy_hubot }

    it { should redirect_to root_path }

    specify { flash[:notice].should be_present }

    specify { Hubot.where(id: hubot.id).count.should == 0 }
  end

  describe '#log' do

    context 'GET' do
      subject { get :log, id: hubot.id }

      it { should be_success }
    end

    context 'POST' do
      subject { post :log, id: hubot.id }

      it { should be_success }
    end
  end

  describe 'POST #truncate' do
    subject { post :log_truncate, id: hubot.id }

    it { should redirect_to hubot_path(hubot) }
  end

  describe '#configure' do

    before do
      HubotConfig.any_instance.stub(:read_file)
      HubotConfig.any_instance.stub(:write_file)
    end

    context 'GET' do
      subject { get :configure, id: hubot.id }

      it { should be_success }
    end

    context 'POST' do
      let(:params_hash) { {
        id: hubot.id,
        variables:        '{}',
        package:          '{}',
        hubot_scripts:    '[]',
        external_scripts: '[]',
        before_start:     '',
      } }

      subject { post :configure, params_hash }

      it { should be_success }
      its(:body) { should include('Updated all') }
    end
  end

  describe 'POST #start' do
    subject { post :start, id: hubot.id }

    before { Hubot.any_instance.should_receive(:install_packages) }

    it { should redirect_to hubot }
  end

  describe 'POST #stop' do
    let(:hubot) { create :hubot, pid: 123 }
    subject { post :stop, id: hubot.id }

    before do
      Hubot.any_instance.should_receive(:running?).and_return(true)
      Shell.should_receive(:kill_tree).with(hubot.pid)
    end

    it { should redirect_to hubot }
  end

  describe '#interact' do

    context 'GET' do
      subject { get :interact, id: hubot.id }

      before { Hubot.any_instance.should_receive(:install_packages) }

      it { should be_success }
    end

    context 'DELETE' do
      subject { delete :interact, id: hubot.id }

      before do
        hubot.start_shell
        Shell.any_instance.should_receive(:close)
      end

      it { should redirect_to hubot }
    end
  end

  describe '#interact_stream' do
    let(:pty) { double(:pty) }

    before do
      PTY.stub(:open).and_return([pty, pty])
      pty.stub(:gets).and_return("Some line")
    end

    context 'GET' do
      subject { get :interact_stream, id: hubot.id }

      it { should be_success }
    end

    context 'POST' do
      subject { get :interact_stream, id: hubot.id }

      it { should be_success }
    end

  end
end
