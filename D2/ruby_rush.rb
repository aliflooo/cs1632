require_relative 'city.rb'
require_relative 'simulator.rb'
require_relative 'arguments.rb'

def show_usage # Requirement calls for usage to be shown if user-given arguments are invalid
  puts 'Usage:'
  puts 'ruby gold_rush.rb *seed* *num_prospectors* *num_turns'
  puts '*seed* should be an integer'
  puts '*num_prospectors* should be a nonnegative integer'
  puts '*num_turns* should be a nonnegative integer'
  exit 1
end

args = Arguments.new
valid_args = args.check_args ARGV

if valid_args
  seed = ARGV[0].to_i
  prospector_count = ARGV[1].to_i
  num_turns = ARGV[2].to_i
  run = Simulator.new ARGV[0]
  run.simulate(seed, num_turns)
else
  show_usage
end
