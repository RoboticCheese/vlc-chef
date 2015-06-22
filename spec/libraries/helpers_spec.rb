# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/helpers'

describe Vlc::Helpers do
  let(:test_class) do
    Class.new do
      include Vlc::Helpers
    end
  end
  let(:test_obj) { test_class.new }

  describe '#latest_version' do
    it 'returns the most recent version string' do
      o = test_obj
      allow(o).to receive(:versions).and_return(%w(0.1.1 1.0.1 1.0.10 1.0.9))
      expect(o.latest_version).to eq('1.0.10')
    end
  end

  describe '#versions' do
    let(:vlc_site_body) do
      <<-EOH.gsub(/^ +/, '')
        <html>
        <head><title>Index of /videolan/vlc/</title></head>
        <body bgcolor="white">
        <h1>Index of /videolan/vlc/</h1><hr><pre><a href="../">../</a>
        <a href="0.1.99/">0.1.99/</a>        18-Aug-2010 20:56               -
        <a href="0.1.99a/">0.1.99a/</a>      18-Aug-2010 20:56               -
        <a href="0.1.99b/">0.1.99b/</a>      18-Aug-2010 20:56               -
        <a href="2.2.1/">2.2.1/</a>          16-Apr-2015 14:44               -
        <a href="eyetv/">eyetv/</a>          09-Feb-2012 12:50               -
        <a href="ipkg-feed/">ipkg-feed/</a>  18-Aug-2010 21:05               -
        <a href="last/">last/</a>            27-Feb-2015 16:51               -
        </pre><hr></body>
        </html>
      EOH
    end

    it 'returns an array of version strings' do
      o = test_obj
      allow(o).to receive(:vlc_site_body).and_return(vlc_site_body)
      expect(o.versions).to eq(%w(0.1.99 2.2.1))
    end
  end

  describe '#vlc_site_body' do
    let(:body) { 'a site body' }

    before(:each) do
      allow(Net::HTTP).to receive(:start)
        .with('get.videolan.org', 443, use_ssl: true, ca_file: nil)
        .and_return(double(body: body))
    end

    it 'returns the site body' do
      expect(test_obj.vlc_site_body).to eq(body)
    end
  end
end
