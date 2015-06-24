# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vlc_app_debian'

describe Chef::Provider::VlcApp::Debian do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::VlcApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    context 'default resource attributes' do
      it 'uses an package to install VLC' do
        p = provider
        expect(p).to receive(:include_recipe).with('apt')
        expect(p).to receive(:package).with('vlc').and_yield
        expect(p).to receive(:version).with(nil)
        expect(p).to receive(:action).with(:install)
        p.send(:install!)
      end
    end

    context 'a resource version attribute' do
      let(:new_resource) do
        r = super()
        r.version('1.2.3')
        r
      end

      it 'installs a specific version of VLC' do
        p = provider
        expect(p).to receive(:include_recipe).with('apt')
        expect(p).to receive(:package).with('vlc').and_yield
        expect(p).to receive(:version).with('1.2.3')
        expect(p).to receive(:action).with(:install)
        p.send(:install!)
      end
    end
  end

  describe '#remove!' do
    it 'uses a package to remove VLC' do
      p = provider
      expect(p).to receive(:package).with('vlc').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end
end
