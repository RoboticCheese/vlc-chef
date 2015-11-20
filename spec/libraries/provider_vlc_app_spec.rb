# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vlc_app'

describe Chef::Provider::VlcApp do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::VlcApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_install' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:install!)
    end

    it 'calls the child `install!` method ' do
      expect_any_instance_of(described_class).to receive(:install!)
      provider.action_install
    end

    it 'sets the resource installed status' do
      p = provider
      p.action_install
      expect(p.new_resource.installed?).to eq(true)
    end
  end

  describe '#action_remove' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remove!)
    end

    it 'calls the child `remove!` method ' do
      expect_any_instance_of(described_class).to receive(:remove!)
      provider.action_remove
    end

    it 'sets the resource installed status' do
      p = provider
      p.action_remove
      expect(p.new_resource.installed?).to eq(false)
    end
  end

  [:install!, :remove!].each do |a|
    describe "##{a}" do
      it 'raises an error' do
        expect { provider.send(a) }.to raise_error(NotImplementedError)
      end
    end
  end
end
