require 'spec_helper'

describe SugarPNG::Color do
  it "creates color from string" do
    SugarPNG::Color.new('blue').should == SugarPNG::Color::BLUE
    SugarPNG::Color.new('Blue').should == SugarPNG::Color::BLUE
    SugarPNG::Color.new('BLUE').should == SugarPNG::Color::BLUE
  end
  it "creates color from symbol" do
    SugarPNG::Color.new(:blue).should == SugarPNG::Color::BLUE
    SugarPNG::Color.new(:blue, :depth => 16).should == SugarPNG::Color::BLUE.to_depth(16)
  end
  it "creates color from hex" do
    SugarPNG::Color.new(0x0000ff).should == SugarPNG::Color::BLUE
    SugarPNG::Color.new(0x00f, :depth => 4).should == SugarPNG::Color::BLUE.to_depth(4)
  end
  it "creates color from html" do
    SugarPNG::Color.new("#0000ff").should == SugarPNG::Color::BLUE
    SugarPNG::Color.new("#00f").should == SugarPNG::Color::BLUE
  end
  it "creates color from r,g,b" do
    SugarPNG::Color.new(0,0,255).should == SugarPNG::Color::BLUE
  end
  it "creates color from long hash" do
    SugarPNG::Color.new(:red => 0, :green => 0, :blue => 0xff).should == SugarPNG::Color::BLUE
  end
  it "creates color from short hash" do
    SugarPNG::Color.new(:r => 0, :g => 0, :b => 0xff).should == SugarPNG::Color::BLUE
  end

  it "raises exception on invalid number of params" do
    lambda{
      SugarPNG::Color.new(1,2,3,4,5,6)
    }.should raise_error(SugarPNG::ArgumentError)
  end

  it "raises exception on invalid number of params" do
    lambda{
      SugarPNG::Color.new(1,2)
    }.should raise_error(SugarPNG::ArgumentError)
  end

  it "raises exception on invalid key" do
    lambda{
      SugarPNG::Color.new( :foo => :bar )
    }.should raise_error(SugarPNG::ArgumentError)
  end

  it "raises exception on invalid HTML color" do
    lambda{ SugarPNG::Color.new( "#12" ) }.should raise_error(SugarPNG::ArgumentError)
    lambda{ SugarPNG::Color.new( "#1234" ) }.should raise_error(SugarPNG::ArgumentError)
  end

  it "raises exception on invalid color name" do
    lambda{ SugarPNG::Color.new( "bzzz" ) }.should raise_error(SugarPNG::ArgumentError)
  end

  it "raises exception on invalid depth" do
    expect{ SugarPNG::Color.new( :depth => 0 ) }.to raise_error(SugarPNG::ArgumentError)
  end
  it "raises exception on invalid depth" do
    expect{ SugarPNG::Color.new( :depth => -1 ) }.to raise_error(SugarPNG::ArgumentError)
  end
  it "raises exception on invalid depth" do
    expect{ SugarPNG::Color.new( :depth => 17 ) }.to raise_error(SugarPNG::ArgumentError)
  end
  it "raises exception on invalid depth" do
    expect{ SugarPNG::Color.new( :depth => "foo" ) }.to raise_error(SugarPNG::ArgumentError)
  end

  it "raises exception on invalid channel value" do
    expect{ SugarPNG::Color.new( :red => 1000 ) }.to raise_error(SugarPNG::ArgumentError)
    expect{ SugarPNG::Color.new( :red => -1 ) }.to raise_error(SugarPNG::ArgumentError)
  end

  it "raises exception on invalid argument type" do
    expect{ SugarPNG::Color.new( 1.25  ) }.to raise_error(SugarPNG::ArgumentError)
    expect{ SugarPNG::Color.new( false ) }.to raise_error(SugarPNG::ArgumentError)
    expect{ SugarPNG::Color.new( true  ) }.to raise_error(SugarPNG::ArgumentError)
  end
end
