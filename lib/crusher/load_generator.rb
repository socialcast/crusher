module Crusher
  
  class LoadGenerator
  
    def initialize(crush_session, options)
      @crush_session = crush_session
      @options = options
      begin
        @log_file = File.open(options[:log_file], 'a') if options[:log_file] 
      rescue Errno::ENOENT
        log("Log file #{options[:log_file]} couldn't be opened; logging to STDOUT")
      end    
    end
    
    def act!; end
  
    def prepare; end
        
    def log(message)
      @crush_session.log(message)
    end
    
    def log_stats(event_type, data)
      keys, values = data.map{|k,v| [k.to_s,v.to_s] }.transpose
      stats_log_file(event_type).syswrite "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')},#{values.join(',')}\n"
    end
    
    def stats_log_file(event_type)
      event_type = event_type.to_sym
      @stats_logs ||= {}
      @stats_logs[event_type] ||= File.open(File.join(@options[:stats_log_dir], "#{event_type}.csv"), 'a')
    end
  
  end
  
end