#!/usr/bin/ruby
# -*- coding: euc-jp -*-

#テーマ：ISBNのチェックディジットを計算
#入力：ISBNコード,10桁
#出力：valid or invalid

require 'rspec'

ISBN_FORMAT_REGEXP = /\A\d{9}[\dX]\z/

def valid_isbn?(isbn)
  return false if isbn !~ ISBN_FORMAT_REGEXP
  
  sum = 0
  weight = 10
  (0..8).each {|index|
    sum += isbn[index, 1].to_i * weight
    weight -= 1
  }
  expected_check_digit = 11 - sum % 11
  actual_check_digit_character = isbn[9, 1]
  actual_check_digit = actual_check_digit_character == "X" ? 10 : actual_check_digit_character.to_i
 
  expected_check_digit == actual_check_digit
end


describe "ISBN validator" do
  it "should recognize 453578258X as valid" do
    valid_isbn?("453578258X").should be_true
  end

  it "should recognize 4797324295 as valid" do
    valid_isbn?("4797324295").should be_true
  end

  it "should recognize 4797324290 as invalid" do
    valid_isbn?("4797324290").should be_false
  end

  it "should recognize ISBN having not digit as invalid" do
    valid_isbn?("45357a258X").should be_false
  end

  it "should recognize Yasda as invalid" do
    valid_isbn?("Yasda").should be_false
  end

  it "should recognize 4797314087 as valid" do
    valid_isbn?("4797314087").should be_true
  end

  it "should recognize 4797314a87 as invalid" do
    valid_isbn?("4797314a87").should be_false
  end

  it "should recognize too short code as invalid" do
    valid_isbn?("479731408").should be_false
  end

  it "should recognize too long code as invalid" do
    valid_isbn?("479731408777").should be_false
  end

  it "should recognize ISBN ending with return code as invalid" do
    valid_isbn?("4797314087\n").should be_false
  end
  it "should recognize ISBN having space as invalid" do
    valid_isbn?("479731408 7").should be_false
  end
end
