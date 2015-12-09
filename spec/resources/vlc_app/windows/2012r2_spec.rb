require_relative '../../../spec_helper'
require_relative '../../../../libraries/helpers'

describe 'resource_vlc_app::windows::2012r2' do
  let(:version) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'vlc_app',
      platform: 'windows',
      version: '2012R2'
    ) do |node|
      node.set['vlc']['app']['version'] = version unless version.nil?
    end
  end
  let(:converge) { runner.converge("vlc_app_test::#{action}") }

  context 'the default action (:install)' do
    let(:action) { :default }
    let(:latest_version) { '1.2.3' }

    before(:each) do
      allow(Net::HTTP).to receive(:start).and_return(
        double(body: "<a href=\"#{latest_version}/\">")
      )
    end

    shared_examples_for 'any attribute set' do
      it 'installs the VLC app' do
        expect(chef_run).to install_vlc_app('default')
      end

      it 'installs the VLC Windows package' do
        s = "https://get.videolan.org/vlc/#{version || '1.2.3'}/win64/" \
            "vlc-#{version || '1.2.3'}-win64.exe"
        expect(chef_run).to install_windows_package('VLC media player')
          .with(source: s, installer_type: :nsis)
      end
    end

    context 'no version attribute' do
      let(:version) { nil }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'a version attribute' do
      let(:version) { '4.5.6' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the VLC app' do
      expect(chef_run).to remove_vlc_app('default')
    end

    it 'removes the VLC Windows package' do
      expect(chef_run).to remove_windows_package('VLC media player')
    end
  end
end
