# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_vlc_app'

describe Chef::Resource::VlcApp do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      exp = :vlc_app
      expect(resource.resource_name).to eq(exp)
    end

    it 'sets the correct supported actions' do
      expected = [:nothing, :install, :remove]
      expect(resource.allowed_actions).to eq(expected)
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:install])
    end

    it 'sets the installed status to nil' do
      expect(resource.installed).to eq(nil)
    end
  end

  [:installed, :installed?].each do |m|
    describe "##{m}" do
      context 'default unknown installed status' do
        it 'returns nil' do
          expect(resource.send(m)).to eq(nil)
        end
      end

      context 'app installed' do
        let(:resource) do
          r = super()
          r.instance_variable_set(:@installed, true)
          r
        end

        it 'returns true' do
          expect(resource.send(m)).to eq(true)
        end
      end

      context 'app not installed' do
        let(:resource) do
          r = super()
          r.instance_variable_set(:@installed, false)
          r
        end

        it 'returns false' do
          expect(resource.send(m)).to eq(false)
        end
      end
    end
  end

  describe '#version' do
    let(:version) { nil }
    let(:resource) do
      r = super()
      r.version(version) unless version.nil?
      r
    end

    context 'default' do
      let(:version) { nil }

      it 'returns nil' do
        expect(resource.version).to eq(nil)
      end
    end

    context 'a valid override' do
      let(:version) { '1.2.3' }

      it 'returns the override' do
        expect(resource.version).to eq('1.2.3')
      end
    end

    context 'an invalid override' do
      let(:version) { 'x.y.z' }

      it 'raises an error' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
