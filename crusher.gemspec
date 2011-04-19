spec = Gem::Specification.new do |s|
  s.name = 'crusher'
  s.version = '0.0.8'
  s.summary = 'A scriptable load generator'
  s.description = 'A scriptable, multiprocessing load generator designed to bring web applications to their knees'
  s.homepage = 'http://github.com/socialcast/crusher'
  
  s.add_dependency('httpclient')
  s.add_dependency('crusher-eventmachine')
  
  s.authors = ['phene', 'thatothermitch', 'scashin133']
  
  s.files = Dir['rails/init.rb', 'lib/**/*', 'bin/*', 'test/**/*',
      'extra/**/*', 'Rakefile', 'init.rb', '.yardopts']
  
  s.executables = ['crush']
  
  s.has_rdoc = false
end