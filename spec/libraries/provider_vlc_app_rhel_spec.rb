# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vlc_app_rhel'

describe Chef::Provider::VlcApp::Rhel do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::VlcApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    {
      'CentOS' => { platform: 'centos', version: '7.0' },
      'Red Hat' => { platform: 'redhat', version: '7.0' }
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
    let(:version) { nil }
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:new_resource) do
      r = super()
      r.version(version) if version
      r
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
      %i(include_recipe yum_repository package).each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    shared_examples_for 'any platform and attribute combination' do
      it 'configures EPEL' do
        p = provider
        expect(p).to receive(:include_recipe).with('yum-epel')
        p.send(:install!)
      end

      it 'configures Nux Dextop' do
        p = provider
        expect(p).to receive(:yum_repository).with('nux-dextop').and_yield
        expect(p).to receive(:description)
        expect(p).to receive(:baseurl).with(
          "http://li.nux.ro/download/nux/dextop/el#{platform[:version].to_i}" \
          '/$basearch/'
        )
        expect(p).to receive(:gpgkey).with('http://li.nux.ro/download/nux/' \
                                           'RPM-GPG-KEY-nux.ro')
        p.send(:install!)
      end

      it 'installs VLC' do
        p = provider
        expect(p).to receive(:package).with('vlc').and_yield
        if version
          expect(p).to receive(:version).with(version)
        else
          expect(p).to_not receive(:version)
        end
        p.send(:install!)
      end
    end

    %w(7.0 6.6).each do |pv|
      context "CentOS #{pv}" do
        let(:platform) { { platform: 'centos', version: pv } }

        context 'no version property' do
          let(:version) { nil }

          it_behaves_like 'any platform and attribute combination'
        end

        context 'a version property' do
          let(:version) { '1.2.3' }

          it_behaves_like 'any platform and attribute combination'
        end
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
