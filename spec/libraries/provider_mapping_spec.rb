# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_mapping'

describe 'vlc::provider_mapping' do
  let(:platform) { nil }
  let(:app_provider) do
    Chef::Platform.platforms[platform] && \
      Chef::Platform.platforms[platform][:default][:vlc_app]
  end

  context 'Mac OS X' do
    let(:platform) { :mac_os_x }

    it 'uses the OS X app provider' do
      expect(app_provider).to eq(Chef::Provider::VlcApp::MacOsX)
    end
  end

  context 'Windows' do
    let(:platform) { :windows }

    it 'returns nil' do
      expect(app_provider).to eq(nil)
    end
  end

  context 'Ubuntu' do
    let(:platform) { :ubuntu }

    it 'returns nil' do
      expect(app_provider).to eq(nil)
    end
  end
end
