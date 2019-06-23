# frozen_string_literal: true

require_relative 'verifier_methods'
require 'benchmark'
require 'flamegraph'
require 'fast_stack'

# Verifier module for billcoins
class VerifierMethods
end

# Create the new instance
verify = VerifierMethods.new
bm_time = Benchmark.measure do

Flamegraph.generate('verifier_flamegrapher.html') do
  @return_value = 1
  # check file arg and if file exists
  if !ARGV.empty?
    if File.file?(ARGV[0])
      @return_value = verify.read_file ARGV[0]
    else
      abort("File [#{ARGV[0]}] does not exist")
    end
  else
    verify.show_usage_and_exit
  end
end
end

# Only provide benchmark stats if no issues
if @return_value.zero?
  # Show benchmark results
  bm_time_arr = bm_time.to_s.split(' ')
  bbm_time_arr_r = bm_time_arr[4].split(')')

  real_secs = bbm_time_arr_r[0].to_f
  user_secs = bm_time_arr[0].to_f
  sys_secs = bm_time_arr[1].to_f

  puts "\nreal\t#{format('%0u', ((real_secs / 60) % 60))}m#{format('%.3f', (real_secs % 60))}s"
  puts "user\t#{format('%0u', ((user_secs / 60) % 60))}m#{format('%.3f', (user_secs % 60))}s"
  puts "sys\t#{format('%0u', ((sys_secs / 60) % 60))}m#{format('%.3f', (sys_secs % 60))}s"
end
