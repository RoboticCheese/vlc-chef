# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vlc_app_mac_os_x'

describe Chef::Provider::VlcApp::MacOsX do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::VlcApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'URL' do
    it 'returns the download page URL' do
      expected = 'http://get.videolan.org/vlc/2.2.1/macosx/vlc-2.2.1.dmg'
      expect(described_class::URL).to eq(expected)
    end
  end

  describe 'PATH' do
    it 'returns the app directory' do
      expected = '/Applications/VLC.app'
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '#install!' do
    it 'uses a dmg_package to install VLC' do
      p = provider
      expect(p).to receive(:dmg_package).with('VLC').and_yield
      expect(p).to receive(:source).with(described_class::URL)
      expect(p).to receive(:volumes_dir).with('vlc-2.2.1')
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'removes all the VLC directories' do
      p = provider
      [
        described_class::PATH,
        File.expand_path('~/Library/Application Support/VLC'),
        File.expand_path('~/Library/Application Support/org.videolan.vlc')
      ].each do |d|
        expect(p).to receive(:directory).with(d).and_yield
        expect(p).to receive(:recursive).with(true)
        expect(p).to receive(:action).with(:delete)
      end
      p.send(:remove!)
    end
  end
end
