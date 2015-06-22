# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vlc_app_windows'

describe Chef::Provider::VlcApp::Windows do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::VlcApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = File.expand_path('/Program Files/VideoLAN/VLC')
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '#install!' do
    before(:each) do
      [:download_package, :install_package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'downloads the package' do
      p = provider
      expect(p).to receive(:download_package)
      p.send(:install!)
    end

    it 'installs the package' do
      p = provider
      expect(p).to receive(:install_package)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'uses a windows_package to uninstall VLC' do
      p = provider
      expect(p).to receive(:windows_package).with('VLC media player').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end

  describe '#install_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/vlc.exe')
    end

    it 'uses a windows_package to install the package' do
      p = provider
      expect(p).to receive(:windows_package).with('VLC media player').and_yield
      expect(p).to receive(:source).with('/tmp/vlc.exe')
      expect(p).to receive(:installer_type).with(:nsis)
      expect(p).to receive(:action).with(:install)
      p.send(:install_package)
    end
  end

  describe '#download_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('https://example.com/vlc.exe')
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/vlc.exe')
    end

    it 'uses a remote_file to download the package' do
      p = provider
      expect(p).to receive(:remote_file).with('/tmp/vlc.exe').and_yield
      expect(p).to receive(:source).with('https://example.com/vlc.exe')
      expect(p).to receive(:action).with(:create)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:download_package)
    end
  end

  describe '#download_path' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('https://example.com/vlc-2.2.1-win64.exe')
    end

    it 'returns a path in the Chef cache dir' do
      expected = "#{Chef::Config[:file_cache_path]}/vlc-2.2.1-win64.exe"
      expect(provider.send(:download_path)).to eq(expected)
    end
  end

  describe '#remote_path' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:latest_version)
        .and_return('1.2.3')
    end

    it 'returns a download URL' do
      expected = 'https://get.videolan.org/vlc/1.2.3/win64/vlc-1.2.3-win64.exe'
      expect(provider.send(:remote_path)).to eq(expected)
    end
  end
end
