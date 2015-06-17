# Encoding: UTF-8

require_relative '../spec_helper'

describe 'vlc::app' do
  describe file('/Applications/VLC.app'), if: os[:family] == 'darwin' do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end

  describe package('VLC media player'), if: os[:family] == 'windows' do
    it 'is not installed' do
      expect(subject).not_to be_installed
    end
  end
end
