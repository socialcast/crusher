module Crusher
  
  class LoadGenerator
  
    def initialize(options)
      @options = options
      begin
        @log_file = File.open(options[:log_file], 'a') if options[:log_file] 
      rescue Errno::ENOENT
        log("Log file #{options[:log_file]} couldn't be opened; logging to STDOUT")
      end    
    end
  
    def start!
      log('Preparing...')
      prepare
      wait_time = [(@options[:start_time] - Time.now), 0].max + rand(@options[:start_up_jitter])
      log("Waiting #{wait_time} to begin load generation...")
      sleep(wait_time)
      log('Starting...')
      while running?
        act!
      end
      log('Finished')
    end
  
    def act!; end
  
    def prepare; end
    
    def running?
      Time.now < @options[:end_time]
    end
  
    def log(message)
      log_message = Time.now.strftime('%Y-%m-%d %H:%M:%S') + ' ' + @options[:process_name] + ' ' +  message + "\n"
      if @log_file
        @log_file.syswrite(log_message)
      else
        puts log_message
      end
      nil
    end
  
  end
  
end