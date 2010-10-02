require 'rubygems'
require 'httpclient'

class WebUser
  
  def initialize(uri_root, email, password)
    id = rand(2000)
    @uri_root = uri_root
    @email = email
    @password = password
    @client = HTTPClient.new @uri_root
    @client.set_cookie_store "cookie-#{id}.dat"
    login
  end
  
  def login
    @client.post "#{@uri_root}/sso/login", {'email' => @email, 'password' => @password}
  end
  
end