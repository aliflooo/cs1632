require 'minitest/autorun'
require_relative 'city.rb'

class CityTest < Minitest::Test
  # UNIT TESTS FOR METHOD initialize
  # Equivalence classes:
  # Valid city name
  # Valid number of max rubies
  # Valid number of fake rubies
  # Valid intialization of city
  def test_initialize
    test = Minitest::Mock.new
    city = City.new("Enumerable Canyon", 2, 3, test)
    assert_equal city.name, "Enumerable Canyon"
    assert city.maxrubies, 0
    assert city.maxfakes, 0
  end

  # UNIT TESTS FOR METHOD link_neighbors(cities)
  # Equivalence classes:
  # Valid Array
  # Non-valid Array

  # Test to see if valid array is created and placed into city array
  def test_valid
    test = Minitest::Mock.new
    city = City.new("Enumerable Canyon", 1, 2, test)
    city2 = City.new("Nil Town", 4, 2, test)
    city3 = City.new("Hash Crossing", 5, 1, test)
    Array cities = [city2, city3]
    city.link_neighbors cities
    assert_equal cities, city.cities
  end

  # Test to see if valid array is passed into city array
  def test_valid_city
    test = Minitest::Mock.new
    city = City.new("Enumerable Canyon", 1, 2, test)
    city2 = City.new("Nil Town", 4, 2, test)
    city3 = City.new("Hash Crossing", 5, 1, test)
    Array cities = [city2, city3]
    check = 0
    city.link_neighbors check
    assert_nil city.cities
  end
  # UNIT TESTS FOR METHOD next
  # Equivalence classes:
  # Neighbors
  # No neighbors

  # Test that a city has a positive number of neighbors
  def test_neighbors
    test = Minitest::Mock.new
    def test.rand(num); 1; end
    city = City.new("Enumerable Canyon", 1, 1, test)
    city2 = City.new("Nil Town", 0, 3, test)
    city3 = City.new("Hash Crossing", 2, 2, test)
    city.link_neighbors [city2, city3]
    city = city.next
    assert_includes [city2, city3], city
  end

  # If a city has no neighbors, return nil
  def test_no_neighbors
    test = Minitest::Mock.new
    city = City.new("Enumerable Canyon", 1, 1, test)
    city = city.next
    assert_nil city
  end

  # UNIT TESTS FOR METHOD found_rubies
  # Equivalence classes:
  # Max number of rubies

  # Test that the max number of rubies is a valid number within the given range
  def test_rubies
    test = Minitest::Mock.new
    def test.rand(num)
      0
    end
    city = City.new("Enumerable Canyon", 1, 2, test)
    check = city.found_rubies
    assert_includes (0..3), check
  end

  # UNIT TESTS FOR METHOD found_fake_rubies
  # Equivalence classes:
  # Max number of fake rubies
  def test_fakes
    test = Minitest::Mock.new
    def test.rand(num)
      0
    end
    city = City.new("Enumerable Canyon", 4, 1, test)
    check = city.found_fake_rubies
    assert_includes (0..3), check
  end
end
