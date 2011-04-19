# Crushfile DSL

The Crushfile provides a ruby DSL for configuring Crusher with targets and load generation scenarios.

Here's an annotated example:
<code>
  
      target :test do |t|
        # Sets the base URI of the target to crush
        t.uri 'http://www.test.com'
      end
      
      scenario :normal do |s|
        
        # Launch commands create load generators; the blocks should return new 
        # load generator objects
        s.launch 250, 'test.com-user' do |target, scenario, options, job_id| do
          WebUser.new(...)
        end
      
        # Multiple launch commands can be used to launch other types of generators
        s.launch 3, 'test.com-admin' do |target, scenario, options, job_id| do
          AdminUser.new(...)
        end
        
        # Phase commands slowly iterate the set of launched load generators and issue commands
        s.phase :spinup, :over => 10.minutes do |load_generator|
          load_generator.prepare!
        end
        
        # Phase commands are executed sequentially in time, and can be used to inject
        # a scheduled period of inactivity.
        s.phase :cool, :wait => 1.minute
        
        s.phase :start, :over => 5.minutes do |load_generator|
          load_generator.start!
        end
        
        # Log entries are clearly marked with phase names for easy grepping
        s.phase :run, :wait => 20.minutes
        
        # Phases without timespans are executed as fast as possible
        s.phase :stop do |load_generator|
          load_generator.stop!
        end
      
      end
      
</code>

# crush command

Reads the Crushfile in the CWD for targets and scenarios, <strike>invoke</strike> unleash like this:

<code>
    $ crush _target\_name_ _scenario\_name_ _[log\_file]_
</code>

# Eventmachine dependency

Crusher currently requires a non-standard version of the eventmachine gem.  See http://github.com/socialcast/eventmachine for now.

# Copyright

Copyright (c) 2011 Socialcast, Inc. See LICENSE for details.