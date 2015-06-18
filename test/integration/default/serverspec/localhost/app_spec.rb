# Encoding: UTF-8

require_relative '../spec_helper'

describe 'vlc::app' do
  describe file('/Applications/VLC.app'), if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end

  describe package('VLC media player'), if: os[:family] == 'windows' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe package('vlc'), if: !%w(darwin windows).include?(os[:family]) do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
