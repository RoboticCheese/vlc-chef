# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vlc_app_freebsd'

describe Chef::Provider::VlcApp::Freebsd do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::VlcApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    it 'installs the VLC package' do
      p = provider
      expect(p).to receive(:include_recipe).with('freebsd::portsnap')
      expect(p).to receive(:package).with('vlc').and_yield
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'removes the VLC package' do
      p = provider
      expect(p).to receive(:package).with('vlc').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end
end
