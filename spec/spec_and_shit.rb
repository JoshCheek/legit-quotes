require 'rspec/expectations'
require 'rest-client'
require 'nokogiri'
require 'rack'
require 'webrick'
require 'quote_app'

module ManageServer
  def start_server(port)
    @server_thread = Thread.new do
      Rack::Server.start app: QuoteApp.new, Port: port, server: 'webrick', AccessLog: [] , Logger: WEBrick::Log.new(StringIO.new)
    end
    sleep 2
  end

  def stop_server
    @server_thread.kill
  end
end

class Internetz < Struct.new(:url)
  class Response
    def initialize(response)
      @response = response
      @doc = Nokogiri::HTML response
    end

    def at_css(*args)
      @doc.at_css *args
    end

    def content
      @response
    end

    def [](*args)
      @response[*args]
    end

    def include?(text)
      @response.include? text
    end
  end

  def get(path)
    Response.new RestClient.get(url + path)
  end
end

RSpec::Matchers.define :have_content do |content, options|
  match { |doc| doc.at_css(options[:at]).content == content }
end

RSpec.describe 'mah app' do
  include ManageServer
  before(:all)             { ENV['GOOGLE_PROPERTY_ID'] = google_property_id }
  before(:all)             { start_server port }
  after(:all)              { stop_server  }
  let(:internetz)          { Internetz.new "http://0.0.0.0:#{port}/" }

  def port
    8080
  end

  def google_property_id
    '1oisdnv0n232ono3nv09'
  end

  it 'has some sort of cool main page' do
    response = internetz.get '/'
    expect(response).to start_with '<!DOCTYPE html>'
  end

  example '/a/b is a quote of a saying b' do
    response = internetz.get '/a/b'
    expect(response).to have_content '"b"', at: '.quote'
    expect(response).to have_content 'a',   at: '.author'
  end

  example 'spaces come through correctly' do
    response = internetz.get '/a%20b/b%20c'
    expect(response).to have_content '"b c"', at: '.quote'
    expect(response).to have_content 'a b',   at: '.author'
  end

  it 'escapes html' do
    response = internetz.get '/%3Cul%3E%3Cli%3Ea%3C%2Fli%3E%3C%2Ful%3E/%3Cul%3E%3Cli%3Ea%3C%2Fli%3E%3C%2Ful%3E'
    expect(response).to have_content '"&lt;ul&gt;&lt;li&gt;a&lt;/li&gt;&lt;/ul&gt;"', at: '.quote'
    expect(response).to have_content '&lt;ul&gt;&lt;li&gt;a&lt;/li&gt;&lt;/ul&gt;', at: '.author'
  end

  it 'has the google analytics' do
    expect(internetz.get '/').to include "['_setAccount', '#{google_property_id}']"
  end
end
