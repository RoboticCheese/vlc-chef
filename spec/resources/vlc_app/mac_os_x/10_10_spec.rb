require_relative '../../../spec_helper'
require_relative '../../../../libraries/helpers'

describe 'resource_vlc_app::mac_os_x::10_10' do
  let(:version) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'vlc_app',
      platform: 'mac_os_x',
      version: '10.10'
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

      it 'instals the VLC .dmg package' do
        s = "https://get.videolan.org/vlc/#{version || '1.2.3'}/macosx/" \
            "vlc-#{version || '1.2.3'}.dmg"
        expect(chef_run).to install_dmg_package('VLC')
          .with(source: s, volumes_dir: "vlc-#{version || '1.2.3'}")
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

    it 'deletes the main app dir' do
      d = '/Applications/VLC.app'
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end

    it 'deletes the Application Support dir' do
      d = File.expand_path('~/Library/Application Support/VLC')
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end

    it 'deletes the second support dir' do
      d = File.expand_path('~/Library/Application Support/org.videolan.vlc')
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end
  end
end
