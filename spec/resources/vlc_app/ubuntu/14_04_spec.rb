require_relative '../../../spec_helper'

describe 'resource_vlc_app::ubuntu::14_04' do
  let(:version) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'vlc_app',
      platform: 'ubuntu',
      version: '14.04'
    ) do |node|
      node.set['vlc']['app']['version'] = version unless version.nil?
    end
  end
  let(:converge) { runner.converge("vlc_app_test::#{action}") }

  context 'the default action (:install)' do
    let(:action) { :default }

    shared_examples_for 'any attribute set' do
      it 'installs the VLC app' do
        expect(chef_run).to install_vlc_app('default')
      end

      it 'ensures the APT cache is up to date' do
        expect(chef_run).to include_recipe('apt')
      end

      it 'installs the VLC package' do
        expect(chef_run).to install_package('vlc').with(version: version)
      end
    end

    context 'no version attribute' do
      let(:version) { nil }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'a version attribute' do
      let(:version) { '4.5.6' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the VLC app' do
      expect(chef_run).to remove_vlc_app('default')
    end

    it 'removes the VLC package' do
      expect(chef_run).to remove_package('vlc')
    end
  end
end
