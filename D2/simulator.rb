require_relative 'arguments.rb'
require_relative 'city.rb'

class Simulator
	attr_accessor :totalf, :totalr, :loc, :days
	def initialize(seed)
		@days = 0
		@totalf = 0
		@totalr = 0
		@loc = map(seed)
	end

	def map(seed)
		nseed = Random.new(seed.to_i)

		niltown = City.new('Nil Town', 0, 3, nseed)
  	monkeypatch = City.new('Monkey Patch City', 1, 1, nseed)
	  enumerable = City.new('Enumerable Canyon', 1, 1, nseed)
		ducktype = City.new('Duck Type Beach', 2, 2, nseed)
		matzburg = City.new('Matzburg', 3, 0, nseed)
		hcrossing = City.new('Hash Crossing', 2, 2, nseed)
	  palisades = City.new('Dynamic Palisades', 2, 2, nseed)

	  niltown.link_neighbors [monkeypatch, hcrossing]
		monkeypatch.link_neighbors [niltown, matzburg, enumerable]
		enumerable.link_neighbors [monkeypatch, ducktype]
	  ducktype.link_neighbors [enumerable, matzburg]
		matzburg.link_neighbors [monkeypatch, hcrossing, palisades, ducktype]
	  hcrossing.link_neighbors [matzburg, palisades, niltown]
		palisades.link_neighbors [hcrossing, matzburg]
		enumerable
	end

	def print_rubies(ruby, fakes)
		if ruby == 1
			puts "	Found #{ruby} ruby in #{@loc.name}. "
			if ruby > 1
				puts "	Found #{ruby} rubies in #{@loc.name}. "
			end
			if ruby < 1
				move
			end
		@totalr += ruby
		end

		if fakes == 1
			puts "	Found #{fakes} fake ruby in #{@loc.name}. "
				if fakes > 1
					puts "	Found #{fakes} fake rubies in #{@loc.name}. "
				end
			if fakes < 1
				move
			end
			@totalf += fakes
		elsif ruby.zero? && fakes.zero?
				move
		end
	end

	def move
		print "Heading from #{@loc.name} to "
		@loc = @loc.next
		puts "#{@loc.name}. "
	end

	def simulate(prospector_count, turns)
		prospector_count.times do |x|
		n = x + 1
		puts "Rubyist ##{n} starting in #{@loc.name}. "
		curr_turn = 0

		until curr_turn == turns
			ruby = 1
			fakes = 1
			while ruby != 0 && fakes != 0
				ruby = @loc.found_rubies
				fakes = @loc.found_fake_rubies
				@days += 1
				print_rubies(ruby, fakes)
				curr_turn +=1
				if curr_turn == turns
					break
				end
			end
		end

		puts "After #{@days} days, Rubyist ##{n} returned with:"
			if @totalr == 1
				puts "	#{@totalr} ruby. "
			else
				puts "	#{@totalr} rubies. "
			end

			if @totalr == 1
				puts "	#{@totalf} fake ruby. "
			else
				puts "	#{@totalf} fake rubies. "
			end

			if @totalr >= 10
			    puts "Going home victorious!"
		  elsif @totalr >= 1 && @totalr <= 9
			    puts "Going home sad."
		  elsif @totalr == 0
			    puts "Going home empty-handed."
		  end
		end
	end
end
