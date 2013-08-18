require 'spec_helper'

describe StatusController do

  let(:user) { create :user }
  before { sign_in :user, user }

  describe 'GET #show' do
    subject { get :show }

    it { should be_success }
  end
end
