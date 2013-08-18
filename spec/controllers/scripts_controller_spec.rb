require 'spec_helper'

describe ScriptsController do

  let(:user) { create :user }
  before { sign_in :user, user }

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
end
