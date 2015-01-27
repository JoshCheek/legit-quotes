require 'nokogiri'
require 'quote_app'
require 'rack/test'

Internetz = Struct.new(:app) { include Rack::Test::Methods }

RSpec::Matchers.define :have_content do |expected_content, options|
  match do |response|
    parsed         = Nokogiri::HTML response.body
    actual_content = parsed.at_css options.fetch(:at)
    expect(actual_content.content).to eq expected_content
  end
end

RSpec.describe 'mah app' do
  before(:all)    { ENV['GOOGLE_PROPERTY_ID'] = google_property_id }
  let(:internetz) { Internetz.new QuoteApp }

  def google_property_id
    '1oisdnv0n232ono3nv09'
  end

  it 'has some sort of cool main page' do
    response = internetz.get '/'
    expect(response.body).to start_with '<!DOCTYPE html>'
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

  def http_escape(str)
    str.bytes.map { |byte| sprintf '%%%02x', byte }.join('')
  end

  it 'escapes html' do
    author_html  = '<zomg>'
    quote_html   = '<wat>'
    escaped_path = "/#{http_escape author_html}/#{http_escape quote_html}"
    response     = internetz.get escaped_path

    # ie will not affect the HTML it is in, but does display correctly
    expect(response.body).to     include '"&lt;wat&gt;"'
    expect(response.body).to_not include '"<wat>"'

    expect(response.body).to     include '&lt;zomg&gt;'
    expect(response.body).to_not include '<zomg>'
  end

  it 'has the google analytics' do
    expect(internetz.get('/').body)
      .to include "['_setAccount', '#{google_property_id}']"
  end
end
