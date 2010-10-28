module Crusher
  class CrushSession
    
    attr_reader :target, :scenario, :log_file
    
    def initialize(target, scenario, options = {})
      @target = target
      @scenario = scenario
      @queued_jobs = []
      @running_jobs = []
      @options = options
      @current_phase = "booting"
      
      @scenario.launch_jobs.each do |job|
        job_id = 0
        puts job.keys.inspect
        puts "Launching #{job[:count]} #{job[:type]}(s)..."
        job[:count].times do
          queue_job(job, job_id)
          job_id += 1
        end
      end

      launch_queued_jobs
      
    end
    
    def log(message)
      log_message = Time.now.strftime('%Y-%m-%d %H:%M:%S') + ' ' + @current_phase + ' ' +  message + "\n"
      if @log_file
        @log_file.syswrite(log_message)
      else
        puts log_message
      end
      nil
    end
    
    private 
    
    def queue_job(job, id)
      @queued_jobs << [job, id]
    end

    def run_next_phase
      if @scenario.phases.length == 0
        shutdown 
      else
        next_phase = @scenario.phases.shift
        @current_phase = next_phase[:name].to_s

        if next_phase[:wait]
          EM::Timer.new(next_phase[:wait].to_i) do
            run_next_phase
          end
        elsif next_phase[:over]
          seconds_per_job = next_phase[:over].to_f / @running_jobs.count.to_f
          next_job = 0

          slow_iterator = EM::PeriodicTimer.new(seconds_per_job) do
            next_phase[:proc].call(@running_jobs[next_job])
            next_job += 1

            if next_job >= @running_jobs.length
              slow_iterator.cancel
              run_next_phase
            end
          end
        end
      end
    end


    def launch_queued_jobs
      return nil if @queued_jobs.length == 0

      fork do
        
        @log_file = File.open(@options.delete(:log_file), 'a') if @options[:log_file]
        
        # Reseed the pseudorandom number generator with the process's PID file, otherwise
        # we'll inherit our sequence of random numbers from the parent process
        Kernel.srand(Process.pid)

        EM.run do
          @queued_jobs.each do |settings|
            job, job_id = settings
            options = @options.merge(:process_name => "#{job[:type]} #{job_id}")
            @running_jobs << job[:proc].call(self, options, job_id)
          end
          run_next_phase
        end

      end

      @queued_jobs = []

      nil
    end
    
    def shutdown
      EM::stop_event_loop
    end
    
  end
  
end