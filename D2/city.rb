class City
  attr_reader :name, :cities, :maxrubies, :maxfakes, :random
  def initialize(name, maxr, maxf, rand)
    @name = name
    @cities = nil
    @maxrubies = maxr
    @maxfakes = maxf
    @random = rand
  end

  def link_neighbors(cities)
    return nil unless cities.is_a? Array
    @cities = cities
  end

  def next
    return nil if @cities.nil?
    next_city = @random.rand(0..@cities.length - 1)
    @cities[next_city]
  end

  def found_rubies
    @random.rand(0..@maxrubies)
  end

  def found_fake_rubies
    @random.rand(0 .. @maxfakes)
  end
end
