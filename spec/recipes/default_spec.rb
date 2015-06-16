# Encoding: UTF-8

require_relative '../spec_helper'

describe 'vlc::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs VLC' do
    expect(chef_run).to install_vlc_app('default')
  end
end
