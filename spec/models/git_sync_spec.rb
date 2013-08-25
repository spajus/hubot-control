require 'spec_helper'

describe GitSync do

  let(:git_sync_scripts) { create :git_sync_scripts }

  describe '.for_scripts' do
    subject { GitSync.for_scripts }

    context 'does not exist' do
      it { should_not be_persisted }
      its(:repo) { should be_nil }
    end

    context 'exists' do
      before { git_sync_scripts }
      it { should == git_sync_scripts }
    end
  end

  describe '#init_repo' do
    subject { GitSync.for_scripts.init }

    before { Git.should_receive(:clone) }

    specify { subject }
  end

  describe '#fetch' do
    subject { git_sync_scripts.fetch }
    let(:git) { double(:git) }

    before do
      Git.should_receive(:open).and_return(git)
      git.should_receive(:fetch)
    end

    specify { subject }
  end
end
