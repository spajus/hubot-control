require 'spec_helper'

describe GitSync do

  let(:git_sync_scripts) { create :git_sync_scripts }
  let(:git) { double(:git) }

  before do
    Git.stub(:open).and_return(git)
    GitSync.any_instance.stub(:update_repo)
    GitSync.any_instance.stub(:can_clone?).and_return(true)
  end

  describe '.for_scripts' do
    subject { GitSync.for_scripts }

    context 'does not exist' do
      it { should_not be_persisted }
      its(:repo) { should be_nil }
    end

    context 'exists' do
      before do
        GitSync.any_instance.should_receive(:update_repo)
        git_sync_scripts
      end
      it { should == git_sync_scripts }
    end
  end

  describe '#init' do
    subject { GitSync.for_scripts.init }

    context 'clean dir' do
      before do
        Dir.should_receive(:exist?).and_return(false)
        Git.should_receive(:clone)
      end

      specify { subject }
    end

    context 'dirty dir' do
      before do
        Shell.stub(:system)
        Dir.should_receive(:entries).with(anything()).and_return(['.', '..', 'script.coffee'])
        FileUtils.should_receive(:mkdir_p)
        GitSync.any_instance.unstub(:can_clone?)
        Dir.should_receive(:exist?).and_return(false)
        Git.should_receive(:clone)
      end

      after do
        Shell.system "rm #{git_sync_scripts.repo_dir}/foo-test.coffee"
      end

      specify { subject }

      context 'scripts moved back after git error' do
        before do
          Git.stub(:clone).and_raise('no permissions')
          expect(Shell).to receive(:system).exactly(4).times
        end

        specify do
          begin
            subject
            fail 'should have raised "no permissions"'
          rescue
            # expected
          end
        end
      end
    end
  end

  describe '#pull' do
    subject { git_sync_scripts.pull }

    before do
      git.should_receive(:pull)
    end

    specify { subject }
  end

  describe '#status' do
    subject { git_sync_scripts.status }

    before { git.should_receive(:status).and_return [] }

    it { should be_empty }
  end

  describe '#reset' do
    subject { git_sync_scripts.reset }

    before { git.should_receive(:reset_hard).and_return true }

    it { should be_true }
  end

  describe '#push' do
    subject { git_sync_scripts.push }

    before { git.should_receive(:push).with(:origin, :master).and_return true }

    it { should be_true }
  end
end
