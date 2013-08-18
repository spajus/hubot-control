require 'spec_helper'

describe DashboardController do

  describe 'GET #index' do
    subject { get :index }
    let!(:hubot) { create :hubot }

    context 'without auth' do
      it { should redirect_to new_user_session_path }
      its(:body) { should_not include(hubot.title) }
    end

    context 'with auth' do
      let(:user) { create :user }
      before { sign_in :user, user }

      it { should be_success }
      its(:body) { should include(hubot.title) }
    end
  end

end
