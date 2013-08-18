require 'spec_helper'

describe HubotsController do

  let(:user) { create :user }
  before { sign_in :user, user }

  describe 'GET #index' do
    subject { get :index }

    it { should be_success }
  end

  describe 'GET #new' do
    subject { get :new }

    it { should be_success }
  end
end
