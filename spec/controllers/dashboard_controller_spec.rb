require 'spec_helper'

describe DashboardController do

  describe 'GET #index' do
    subject { get :index }

    context 'without auth' do
      it { should redirect_to new_user_session_path }
    end

    context 'with auth' do
      let(:user) { create :user }
      before { sign_in :user, user }

      it { should be_success }
    end
  end

end
