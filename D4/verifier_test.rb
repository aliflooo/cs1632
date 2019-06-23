require 'minitest/autorun'
require_relative 'verifier_Methods'

# Class to test Verifier Methods class
class VerifierTest < MiniTest::Test
  # Use sample transaction from 
  def setup
    @VERIFY = VerifierMethods.new
    @test_line = "0|0|SYSTEM>569274(100)|1553184699.650330000|288d"
    @split_line = ["0", "0", "SYSTEM>569274(100)", "1553184699.650330000", "288d"]
    @transaction = ["735567>995917(1)", "577469>995917(1)", "735567>600381(1)", "SYSTEM>402207(100)"]
  end

  # Test user dialogue 
  def test_user_dialogue
    assert_equal false, @VERIFY.show_usage_and_exit
  end

  # Test valid billcoin results
  def test_valid_address_zero_balance_output
    assert_includes ["039873", 0], @VERIFY.read_file("sample.txt")
  end
  
  # Test valid billcoin address last transaction balance
  def test_valid_address_last_transaction_balance
    assert_equal 0, @VERIFY.read_file("sample.txt")
  end
  
  # Test correct line split
  def test_correct_line_split
    assert_equal @VERIFY.initial_split(@test_line), ["0", "0", "SYSTEM>569274(100)", "1553184699.650330000", "288d"]
  end

  # Test correct transcation split zero
  def test_correct_transaction_split_zero
    assert_equal ["0"], @VERIFY.split_transactions(@test_line)
  end

  # Test correct transcation split
  def test_correct_transaction_split
      test_line = "5|6|SYSTEM>569274(100)|1553184699.650330000|288d"
    assert_equal ["6"], @VERIFY.split_transactions(test_line)
  end

  # Test block with no negative balance
  def test_update_neg_check_no_negs
    @VERIFY.address_deposit("ABC", 5)
    assert_nil @VERIFY.update_neg_check("ABC")
  end

  # Test block with negative balance
  def test_bad_update
    @VERIFY.address_withdraw("12xx56", 12)
    assert_equal 1, @VERIFY.update_neg_check("12xx56")
  end

  # Test invalid TO address
  def test_bad_to_address
    assert_equal false, @VERIFY.validate_address(@transaction)
  end

  # Test for valid address pair
  def test_valid_address_pair
    transaction = ["123456", "654321"]
    assert_nil @VERIFY.validate_address(transaction)
  end

  # Test invalid FROM address
  def test_bad_from_address
    transaction = ["12345678", "1234567"]
    assert_equal false, @VERIFY.validate_address(transaction)
  end

  # Test for correct previous hash in current block    
  def test_verify_correct_hash
    split_line = ["","0","","","1"]
    assert_equal "1", @VERIFY.verify_hash(split_line)
  end

  # Test for incorrect previous hash in current block    
  def test_verify_incorrect_hash
    split_line = ["","0","","","1"]
    assert_equal "1", @VERIFY.verify_hash(split_line)
    split_line = ["3","0","","","1"]
    assert_equal false, @VERIFY.verify_hash(split_line)
  end

  # Test for current correct block order
  def test_verify_correct_count
    split_line = ["0"]
    assert_equal 1, @VERIFY.verify_count(split_line)
  end

  # Test for current correct block order seq
  def test_verify_correct_count_seq
    split_line = ["3"]
    assert_equal nil, @VERIFY.verify_count(split_line)
    split_line = ["4"]
    assert_equal nil, @VERIFY.verify_count(split_line)
  end

  # Test for correct hash calc (no errors)
  def test_verify_correct_hash
      split_line = ["123", "456", "SYSTEM>569274(100)", "1553184699.650330000", "f311"]
    assert_equal 0, @VERIFY.check_hash(split_line)
  end

  # Test for correct hash calc (no error)
  def test_verify_correct_hash2
      split_line = ["111", "222", "SYSTEM>569274(100)", "1553184699.650330000", "e7bf"]
    assert_equal 0, @VERIFY.check_hash(split_line)
  end

  # Test for correct line verify
  def test_verify_correct_line
    assert_equal "288d", @VERIFY.verify_line(@split_line)
  end
  
  # Test for correct line verify
  def test_verify_correct_line2
    split_line = ["0", "0", "SYSTEM>569274(100)", "1553184699.650330000", "f311"]
    assert_equal "f311", @VERIFY.verify_line(split_line)
  end

  # Test for correct timestamp seconds
  def test_verify_correct_timestamp_s
    split_line = ["","","","1234.0000"]
    assert_equal [1234, 0], @VERIFY.verify_timing(split_line)
  end

  # Test for correct timestamp ms
  def test_verify_correct_timestamp_ms
    split_line = ["","","","0000.4567"]
    assert_equal [0, 4567], @VERIFY.verify_timing(split_line)
  end

  # Test split invalid billcoin address
  def test_split_invalid_billcoin_address
    addresses = [nil, "402207(2)"]
    assert_nil @VERIFY.split_address_billcoin(addresses)
  end

  # Test for correct deposit for both new and existing address
  def test_address_withdraw_new_and_existing
    address = "123456"
    billcoins_sent = 5
    assert_equal [true, -5], @VERIFY.address_withdraw(address, billcoins_sent)
        
    assert_equal [false, -10], @VERIFY.address_withdraw(address, billcoins_sent)
  end

  # Test for correct deposit for both new and existing address
  def test_address_deposit_new_and_existing
    address = "123456"
    billcoins_sent = 11
    assert_equal [true, 11], @VERIFY.address_deposit(address, billcoins_sent)
        
    assert_equal [false, 22], @VERIFY.address_deposit(address, billcoins_sent)
  end

  # Test for correct withdraw and deposit new and existing address
  def test_address_withdraw_and_deposit
    address = "123456"
    billcoins_sent = 33
    assert_equal [true, -33], @VERIFY.address_withdraw(address, billcoins_sent)
        
    assert_equal [false, 0], @VERIFY.address_deposit(address, billcoins_sent)
  end

  # Test for correct back to back deposits
  def test_address_deposits
    address = "123456"
    billcoins_sent = 10
    assert_equal [true, 10], @VERIFY.address_deposit(address, billcoins_sent)
        
    assert_equal [false, 20], @VERIFY.address_deposit(address, billcoins_sent)
  end

  # Test for correct back to back withdraw from same address
  def test_address_withdraws
    address = "123456"
    billcoins_sent = 33
    assert_equal [true, -33], @VERIFY.address_withdraw(address, billcoins_sent)
        
    assert_equal [false, -66], @VERIFY.address_withdraw(address, billcoins_sent)
  end

  # Test for bad timestamp
  def test_verify_bad_timestamp
    split_line = ["","","","-12345.12345"]
    assert_nil @VERIFY.verify_timing(split_line)
  end

  # Test update from address 
  def test_update_from_address
    transaction = ["123456", "654321", 123]
    assert_equal 1, @VERIFY.update_from_address(transaction)
  end

  # Test update to address 
  def test_update_to_address
    transaction = ["654321", "123456", 321]
    assert_nil @VERIFY.update_to_address(transaction)
  end

  # Test split address billcoin 
  def test_split_address_billcoin
    addresses = ["577469", "402207(2)"]
    assert_nil @VERIFY.split_address_billcoin(addresses)
  end

  # Test split from to address 
  def test_split_from_to_address
    assert_equal @transaction, @VERIFY.split_from_to_address(@transaction)
  end

  # Test splitting the time 
  def test_time_split
    assert_equal [1553184699, 650330000], @VERIFY.verify_timing(@split_line)
  end

  # Test invalid timing 
  def test_invalid_timing
    assert_equal [1553184699, 650330000], @VERIFY.verify_timing(@split_line)
    split_line = ["0", "0", "SYSTEM>569274(100)", "1443184699.650330000", "288d"]
    assert_nil @VERIFY.verify_timing(split_line)
  end

end
