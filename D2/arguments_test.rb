require 'minitest/autorun'
require_relative 'arguments.rb'

class ArgumentsTest < Minitest::Test
  # UNIT TESTS FOR METHOD check_args(args)
  # Equivalence classes:
  # args = -INFINITY.. -1 -> returns false
  # args = INFINITY.. 1 -> returns true
  # args = (not a number) -> returns false
  # args = 0 -> returns false

  # Test that negative integers on the command line fail
  def test_negative
    args = Arguments.new
    assert_equal false, args.check_args(-3)
  end

  # Test that positive integers greater than 0 on the command line do not fail
  def test_positive
    args = Arguments.new
    assert_equal false, args.check_args(5)
  end

  # Test that command line inputs that are not integers fail
  def test_string
    args = Arguments.new
    assert_equal false, args.check_args("puppy")
  end

  # Test that 0 on the command line will fail
  def test_zero
    args = Arguments.new
    assert_equal false, args.check_args(0)
  end

  # Test that two integers on the command line will fail
  def test_two_ints
    args = Arguments.new
    assert_equal false, args.check_args([1, 2])
  end

  #Test that one integer on the command line will fail
  def test_one_ints
    args = Arguments.new
    assert_equal false, args.check_args([1])
  end

  # Test that three integers will not fail
  def test_three_ints
    args = Arguments.new
    assert_equal true, args.check_args([1, 2, 3])
  end
end
