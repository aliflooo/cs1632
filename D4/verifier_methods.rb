# frozen_string_literal: true

# Verifier module for billcoins
class VerifierMethods
  # class variables
  def initialize
    @line_cnt = 0
    @prev_hash = 0
    @prev_hash_x = 0
    @prev_time = [0, 0]
    @address = {}
    @neg_balances = 0
    @balance_is_neg = {}
    @execute = true
  end

  # usage dialogue
  def show_usage_and_exit
    puts "Usage:\truby verifier.rb <name_of_file>"
    puts "\tname_of_file = name of file to verify"
    @execute = false
  end

  # Read blockchain file
  def read_file(blockchain_file)
    File.readlines(blockchain_file).each do |line|
      split_line = initial_split line if @execute
      check_hash split_line
      transactions = split_transactions split_line if @execute
      split_from_to_address transactions if @execute

      if @neg_balances.positive? && @execute
        @address.sort.each do |addr, bcoins|
          puts "Line #{@line_cnt - 1}: Invalid block, address #{addr} has #{bcoins} billcoins!" if bcoins.negative?
          puts 'BLOCKCHAIN INVALID' if bcoins.negative?
          @execute = false if bcoins.negative?
        end
      end
    end

    # sort and print all positive billcoins totals for each eddress
    if @execute
      @address.sort.each do |addr, bcoins|
        puts "#{addr}: #{bcoins} billcoins" if bcoins.positive?
      end
      return 0
    else
      return 1
    end
  end

  # split transaction
  def initial_split(line)
    split_line = line.split('|')
    verify_line split_line if @execute
    split_line
  end

  # verify transaction line
  def verify_line(split_line)
    verify_count split_line if @execute
    verify_timing split_line if @execute
    verify_hash split_line if @execute
  end

  # verify timing order of block
  def verify_timing(split_line)
    time = split_line[3].split('.')
    time[0] = time[0].to_i
    time[1] = time[1].to_i
    if (@prev_time[0] > time[0]) || ((@prev_time[0] == time[0]) && @prev_time[1] > time[1])
      puts "Line #{@line_cnt - 1}: Previous timestamp #{@prev_time.join('.')} >= new time #{time.join('.')}"
      puts 'BLOCKCHAIN INVALID'
      @execute = false
      return
    end
    @prev_time = time
  end

  # verify line order
  def verify_count(split_line)
    if split_line[0].to_i != @line_cnt
      puts "Line #{@line_cnt}: Invalid block number #{split_line[0].to_i}, should be #{@line_cnt}"
      puts 'BLOCKCHAIN INVALID'
      @execute = false
      return
    end
    @line_cnt += 1
  end

  # verify current and previous hash match
  def verify_hash(split_line)
    if @prev_hash != split_line[1].to_i(16)
      puts "Line #{@line_cnt - 1}: Previous hash was #{split_line[1]}, should be #{@prev_hash_x}"
      puts 'BLOCKCHAIN INVALID'
      @execute = false
    else
      @prev_hash = split_line[4].delete("\n").to_i(16)
      @prev_hash_x = split_line[4].delete("\n")
    end
  end

  # split transactions in block
  def split_transactions(split_line)
    transactions = split_line[2].split(':')
    transactions
  end

  # Split from / to addresses in transaction block
  def split_from_to_address(transactions)
    transactions.each do |addresses|
      addresses = addresses.split('>')
      split_address_billcoin addresses
    end
  end

  # split transactions and update target addresses
  def split_address_billcoin(addresses)
    address1 = addresses[0]
    if addresses[0].nil? || addresses[1].nil?
      puts "Line #{@line_cnt - 1}: Could not parse transaction list '#{addresses.join('')}'"
      puts 'BLOCKCHAIN INVALID'
      @execute = false
      return
    end

    transaction_half = addresses[1].split('(') if @execute
    address2 = transaction_half[0] if @execute
    num_billcoins = transaction_half[1].split(')') if @execute
    transaction = [address1, address2, num_billcoins[0].to_i] if @execute
    validate_address transaction if @execute
    update_from_address transaction if @execute
    update_to_address transaction if @execute
  end

  # validate address (six numeric)
  def validate_address(transaction)
    if transaction[0].length > 6
      puts "Line #{@line_cnt - 1}: Invalid FROM address #{transaction[0]}"
      puts 'BLOCKCHAIN INVALID'
      @execute = false
    elsif transaction[1].length > 6
      puts "Line #{@line_cnt - 1}: Invalid TO address #{transaction[1]}"
      puts 'BLOCKCHAIN INVALID'
      @execute = false
    end
  end

  # withdraw billcoins
  def update_from_address(transaction)
    billcoins_sent = transaction[2]
    address_withdraw(transaction[0], billcoins_sent) if transaction[0] != 'SYSTEM'
    update_neg_check transaction[0] if transaction[0] != 'SYSTEM'
  end

  # deposit billcoins
  def update_to_address(transaction)
    billcoins_sent = transaction[2]
    address_deposit(transaction[1], billcoins_sent)
    update_neg_check transaction[1]
  end

  # add FROM address to array and update balance
  def address_withdraw(from_address, billcoins_sent)
    if @address[from_address].nil?
      @address[from_address] = -billcoins_sent
      [true, @address[from_address]]
    else
      @address[from_address] -= billcoins_sent
      [false, @address[from_address]]
    end
  end

  # verify end of block neg balance
  def update_neg_check(target_address)
    if (@address[target_address]).negative?
      @balance_is_neg[target_address] = true
      @neg_balances += 1
    elsif @balance_is_neg[target_address]
      @neg_balances -= 1
      @balance_is_neg[target_address] = false
    end
  end

  # add TO address to array and update balance
  def address_deposit(to_address, billcoins_sent)
    if @address[to_address].nil?
      @address[to_address] = billcoins_sent
      [true, @address[to_address]]
    else
      @address[to_address] += billcoins_sent
      [false, @address[to_address]]
    end
  end

  # check hash with previous block
  def check_hash(split_line)
    # Required since if @execute does not work for embedded call
    return unless @execute

    hash_val = 0
    x_values = "#{split_line[0]}|#{split_line[1]}|#{split_line[2]}|#{split_line[3]}".unpack('U*')
    # Perform calculation `((x**3000) + (x**x) - (3**x)) * (7**x)` for each x value
    x_values.each do |x|
      hash_val += ((x**3000) + (x**x) - (3**x)) * (7**x)
    end
    hash_val = hash_val % 65_536
    if hash_val.to_s(16) != split_line[-1].delete("\n")
      print "Line #{@line_cnt - 1}: String '"
      puts "#{split_line[0...4].join('|')}' hash set to #{split_line[-1].delete("\n")}, should be #{hash_val.to_s(16)}"
      puts 'BLOCKCHAIN INVALID'
      @execute = false
      return
    else
      hash_val = 0
    end
  end
end
