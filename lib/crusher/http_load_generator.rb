module Crusher
  
  class HttpLoadGenerator < LoadGenerator
    
    
    def initialize(crush_session, options)
      super(crush_session, options)
      @cookies = ::WebAgent::CookieManager.new 
    end
    
    def request(method, path, content = {}, &block)

      uri = URI.parse(path)

      http_args = content.keys.map do |key| 
        content[key] ? "#{URI.escape(key.to_s)}=#{URI.escape(content[key].to_s)}" : nil
      end
      
      qs, content = if method == :get
        [((uri.query || '').split('&') + http_args.compact).join("&"), nil]
      else
        [uri.query, http_args.join("&")] 
      end

      options = {
        :verb => method,
        :host => uri.host,
        :port => uri.port,
        :request => uri.path,
        :query_string => qs,
        :content => content,
        :contenttype => 'application/x-www-form-urlencoded',
        :cookie => @cookies.find(uri),
        :ssl => (uri.scheme == "https" ? true : false)
      }
      
      start_time = Time.now
      em_request(start_time, options)

    end
    
    private
    
    def em_request(start_time, options, times_to_retry=3)
      EM::Protocols::HttpClient.request(options).callback do |response|
        duration = ((Time.now - start_time) * 1000).to_i
        
        response[:headers].each do |header|
          matcher = /Set-Cookie:\s*(.*)/i.match(header)
          @cookies.parse(matcher[1], uri) if matcher
        end
        
        block.call(response, duration) if block
      end.errback do |deferred_args|
        unless times_to_retry <= 0
          em_request(start_time, options, (times_to_retry - 1))
        end
      end
    end
  end
  
end