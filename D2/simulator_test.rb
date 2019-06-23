require 'minitest/autorun'
require_relative 'simulator.rb'
require_relative 'city.rb'

class SimulatorTest < Minitest::Test
  # UNIT TESTS FOR METHOD initialize(seed)
  # Equivalence classes:
  # Valid number of days
  # Valid number of locations
  # Valid number of total rubies
  # Valid number of total fake rubies

  # Test that all variables are instantiated to 0
  def test_intialize
    test = Simulator.new(0)
    assert_equal test.days, 0
    assert_equal test.totalr, 0
    assert_equal test.totalf, 0
  end
  #
  # # UNIT TESTS FOR METHOD map(seed)
  # # Equivalence classes:
  # Map names

  # Test that the starting point for the program is correct in Enumerable Canyon
  def test_map
    test = Simulator.new(0)
    assert_equal test.loc.name, 'Enumerable Canyon'
  end


  # UNIT TESTS FOR METHOD print_rubies(ruby, fakes)
  # Equivalence classes:
  # Number of rubies > 1 || = 0
  # Number of fake rubies > 1 || = 0
  # Number of rubies = 1
  # Number of fakes rubies = 1

  # Test that the correct form of 'ruby' is used
  def test_print_ruby
    test = Simulator.new(0)
    test.totalr = 1
    assert_output(/\tFound 1 ruby in Enumerable Canyon. /) {test.print_rubies(test.totalr, test.totalf)}
  end

  # Test that the correct form of 'ruby' is used for fake rubies
  def test_print_fake
    test = Simulator.new(0)
    test.totalf = 1
    assert_output(/\tFound 1 fake ruby in Enumerable Canyon. /) {test.print_rubies(test.totalr, test.totalf)}
  end

  # Meant to test that more than 1 ruby was found, and total number of rubies were updated
  def test_print_rubies # Failure
    test = Simulator.new(0)
    test.totalr = 3
    assert_output(/\tFound 2 rubies in Enumerable Canyon. /) {test.print_rubies(test.totalr, test.totalf)}
  end

  # Meant to test that 0 rubies would trigger move method
  def test_print_fakes # Failure
    test = Simulator.new(0)
    test.totalf = 0
    assert_output(/\tFound 0 fake rubies in Enumerable Canyon. /) {test.print_rubies(test.totalr, test.totalf)}
  end

  # UNIT TESTS FOR METHOD move
  # Equivalence classes:
  # No movement

  # Test that ensures that if no rubies were found, the total would still be 0
  def test_no_movement
    test = Simulator.new(0)
    curr_rubies = test.totalr
    curr_fakes = test.totalf
    test.print_rubies(0,0)
    assert_equal curr_rubies, 0
    assert_equal curr_fakes, 0
  end

  # UNIT TESTS FOR METHOD simulate(prospector_count, turns)
  # Equivalence classes:
  # One simulation

  # Test that the simulation runs with the right output
  def test_simulate
    test = Simulator.new(0)
    test.days = 2
    test.totalf = 1
    test.totalr = 3
    assert_output(//) {test.simulate(1,2)}
  end
end
