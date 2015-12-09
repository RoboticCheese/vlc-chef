require_relative '../../../spec_helper'

describe 'resource_vlc_app::centos::7_0' do
  let(:version) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'vlc_app',
      platform: 'centos',
      version: '7.0'
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

      it 'configures EPEL' do
        expect(chef_run).to include_recipe('yum-epel')
      end

      it 'configures Nux Dextop' do
        expect(chef_run).to create_yum_repository('nux-dextop').with(
          description: 'Nux Dextop desktop and multimedia packages',
          baseurl: 'http://li.nux.ro/download/nux/dextop/el7/$basearch/',
          gpgkey: 'http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro'
        )
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
