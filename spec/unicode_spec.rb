# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe TwitterText::Unicode do

  it "should lazy-init constants" do
    TwitterText::Unicode.const_defined?(:UFEB6).should == false
    TwitterText::Unicode::UFEB6.should_not be_nil
    TwitterText::Unicode::UFEB6.should be_kind_of(String)
    TwitterText::Unicode.const_defined?(:UFEB6).should == true
  end

  it "should return corresponding character" do
    TwitterText::Unicode::UFEB6.should == [0xfeb6].pack('U')
  end

  it "should allow lowercase notation" do
    TwitterText::Unicode::Ufeb6.should == TwitterText::Unicode::UFEB6
    TwitterText::Unicode::Ufeb6.should === TwitterText::Unicode::UFEB6
  end

  it "should allow underscore notation" do
    TwitterText::Unicode::U_FEB6.should == TwitterText::Unicode::UFEB6
    TwitterText::Unicode::U_FEB6.should === TwitterText::Unicode::UFEB6
  end

  it "should raise on invalid codepoints" do
    lambda { TwitterText::Unicode::FFFFFF }.should raise_error(NameError)
  end

end
