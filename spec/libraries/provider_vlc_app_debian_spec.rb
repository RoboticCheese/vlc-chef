# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vlc_app_debian'

describe Chef::Provider::VlcApp::Debian do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::VlcApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    {
      'Debian' => { platform: 'debian', version: '7.6' },
      'Ubuntu' => { platform: 'ubuntu', version: '14.04' }
    }.each do |k, v|
      context k do
        let(:platform) { v }

        it 'returns true' do
          expect(res).to eq(true)
        end
      end
    end
  end

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
