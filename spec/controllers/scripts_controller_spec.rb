require 'spec_helper'

describe ScriptsController do

  let(:user) { create :user }
  let(:git) { double(:git) }

  before do
    sign_in :user, user
    FileUtils.mkdir_p(Rails.root.join('scripts'))
  end

  describe 'GET #index' do
    subject { get :index }

    it { should be_success }
  end

  describe 'POST #create' do
    subject { post :create, filename: 'foo.coffee' }

    it { should redirect_to edit_scripts_path(script: 'foo.coffee') }
  end

  describe 'GET #edit' do
    subject { get :edit, script: 'foo.coffee' }

    it { should be_success }
  end

  describe 'POST #git_sync' do
    subject { post :git_sync, repo: 'foo@bar.git', user_name: 'foo', user_email: 'foo@foo.bar' }

    let(:git) { double(:git) }

    before do
      Git.should_receive(:open).and_return(git)
      git.should_receive(:config).with('user.name', 'foo')
      git.should_receive(:config).with('user.email', 'foo@foo.bar')
      git.stub_chain(:remotes, :first, :remove)
      git.should_receive(:add_remote).with(:origin, 'foo@bar.git')
    end

    it { should redirect_to scripts_path }
  end

  describe 'POST #git_pull' do
    subject { post :git_pull }

    before do
      Git.should_receive(:open).and_return(git)
      git.should_receive(:pull).and_return('ok')
    end

    specify do
      subject.should redirect_to scripts_path
      flash[:success].should include('ok')
    end
  end

  describe 'POST #git_commit' do
    subject { post :git_commit, message: 'foo', description: 'bar' }

    before { GitSync.any_instance.should_receive(:commit).with("foo\nbar") }

    specify do
      subject.should redirect_to scripts_path
      flash[:success].should be_present
    end
  end

  describe 'DELETE #git_reset' do
    subject { delete :git_reset }

    before { GitSync.any_instance.should_receive(:reset) }

    specify do
      subject.should redirect_to scripts_path
      flash[:success].should be_present
    end
  end

  describe 'DELETE #git_unlink' do
    subject { delete :git_unlink }

    specify do
      subject.should redirect_to scripts_path
      GitSync.for_scripts.should_not be_persisted
      flash[:success].should be_present
    end
  end
end
