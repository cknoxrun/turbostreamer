require 'bundler/setup'
require "bundler/gem_tasks"

require 'byebug'
require 'fileutils'
require "rake/testtask"

ENCODERS = %w(wankel oj)

# Test Task
ENCODERS.each do |encoder|
  namespace :test do
    Rake::TestTask.new(encoder => ["#{encoder}:env", "test:coverage"]) do |t|
      t.libs << 'lib' << 'test'
      t.test_files = FileList['test/**/*_test.rb']
      t.warning = true
      t.verbose = false
    end

    namespace encoder do
      task(:env) { ENV["TSENCODER"] = encoder }
    end
  end
end

namespace :test do

  task :coverage do
    require 'simplecov'
    require 'minitest'
    SimpleCov.start do
      add_group 'lib', 'lib'
      add_group 'ext', 'ext'
      add_filter "/test"
    end
  end

  desc "Run test with all encoders"
  task all: ENCODERS.shuffle.map{ |e| "test:#{e}" }

end

task :performance do
  require 'analyzer'
  
  base = File.expand_path("../performance/rolftimmermans", __FILE__)
  output_file = File.join(base, 'report.png')
  files = [
    'rabl/oj.rb',
    'jbuilder/oj.rb',
    'turbostreamer/oj.rb',
    'turbostreamer/wankel.rb',
  ].map{ |i| File.join(base, i) }
  analyzer = Analyzer.new(*files, lib: File.join(base, 'lib.rb'))
  analyzer.plot(output_file)



  base = File.expand_path("../performance/dirk", __FILE__)
  output_file = File.join(base, 'report.png')
  files = [
    'rabl/oj.rb',
    'jbuilder/oj.rb',
    'turbostreamer/oj.rb',
    'turbostreamer/wankel.rb',
  ].map{ |i| File.join(base, i) }
  analyzer = Analyzer.new(*files, lib: File.join(base, 'lib.rb'))
  analyzer.plot(output_file)


  base = File.expand_path("../performance/jb", __FILE__)
  output_file = File.join(base, 'report.png')
  files = [
    'jb/oj.rb',
    'turbostreamer/oj.rb',
    'turbostreamer/wankel.rb',
    'jbuilder/oj.rb'
  ].map{ |i| File.join(base, i) }
  analyzer = Analyzer.new(*files, lib: File.join(base, 'lib.rb'))
  analyzer.plot(output_file)
end

task test: "test:all"
