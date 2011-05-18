ENV['RACK_ENV'] = 'test'
ENV['REDIRECT_HOST'] = "http://example.com"
ENV['RESOURCE_NAME'] = "posts"
require './shortener'
require 'test/unit'
require 'rack/test'

class Test::Unit::TestCase
  include Rack::Test::Methods
end

class ShortenerTest < Test::Unit::TestCase
  def app
    Shortener
  end
  def redirect_host
    ENV['REDIRECT_HOST']
  end
  def resource
    ENV['RESOURCE_NAME']
  end
  context "when someone visits root" do
    should "be redirected to chatterplug.com/" do
      get '/'
      assert_redirected_to "#{redirect_host}/"
    end
  end
  
  Shortener::PATH_MAPS.each do |short, path|
    context "an anonymous user visits #{short}" do
      should "be redirected to chatterplug.com/#{path}" do
        get "/#{short}"
        assert_redirected_to "#{redirect_host}/#{path}"
      end
    end
  end
  
  context "a request to /ayUyqjP" do
    should "be redirected to resource/2100234243407" do
      get '/ayUyqjP'
      assert_redirected_to "#{redirect_host}/#{resource}/2100234243407"
    end
  end
  
  context "a request to /sdD" do
    should "be redirected to resource/210007" do
      get '/sdD'
      assert_redirected_to "#{redirect_host}/#{resource}/210007"
    end
  end
  
  context "the url api" do
    should "return sdD for 210007" do
      get '/api/short_location/210007'
      assert_equal("sdD",last_response.body)
    end
    # 145017 encodes to biz and that conflicts with the biz path
    should "return !biz for 145017" do
      get '/api/short_location/145017'
      assert_equal("!biz",last_response.body)
    end
  end
  
  context "the resultant url from the api" do
    should "redirect correctly for 145017" do
      get '/api/short_location/145017'
      get "/#{last_response.body}"
      assert_redirected_to "#{redirect_host}/#{resource}/145017"
    end
    
    should "redirect correctly for 210007" do
      get '/api/short_location/210007'
      get "/#{last_response.body}"
      assert_redirected_to "#{redirect_host}/#{resource}/210007"
    end
  end
  
  
  def assert_redirected_to(path)
    assert_equal 302,last_response.status, "Expected redirect but was #{last_response.status}"
    location = last_response.headers['location']
    assert location == path, "Expected redirect to #{path} but was #{location}"
  end
end