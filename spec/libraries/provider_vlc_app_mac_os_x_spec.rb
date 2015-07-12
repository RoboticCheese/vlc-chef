# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vlc_app_mac_os_x'

describe Chef::Provider::VlcApp::MacOsX do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::VlcApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = '/Applications/VLC.app'
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.10' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('https://example.com/vlc.dmg')
      allow_any_instance_of(described_class).to receive(:version)
        .and_return('1.2.3')
    end

    it 'uses a dmg_package to install VLC' do
      p = provider
      expect(p).to receive(:dmg_package).with('VLC').and_yield
      expect(p).to receive(:source).with('https://example.com/vlc.dmg')
      expect(p).to receive(:volumes_dir).with('vlc-1.2.3')
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

  describe '#remote_path' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:version)
        .and_return('1.2.3')
    end

    it 'returns a download URL' do
      expected = 'https://get.videolan.org/vlc/1.2.3/macosx/vlc-1.2.3.dmg'
      expect(provider.send(:remote_path)).to eq(expected)
    end
  end

  describe '#version' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:latest_version)
        .and_return('2.3.4')
    end

    context 'no resource version override' do
      it 'returns the latest version' do
        expect(provider.send(:version)).to eq('2.3.4')
      end
    end

    context 'a resource version override' do
      let(:new_resource) do
        r = super()
        r.version('1.2.3')
        r
      end

      it 'returns the overridden version' do
        expect(provider.send(:version)).to eq('1.2.3')
      end
    end
  end
end
