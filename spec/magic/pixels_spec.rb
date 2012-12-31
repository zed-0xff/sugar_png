require 'spec_helper'

describe SugarPNG do
  it "accept(s) range(s) as pixel(s) method(s)" do
    data = SugarPNG.new do
      dot 0..10, 0, :red
    end.to_s
    img = ZPNG::Image.new data
    img.width.should == 11
    img.height.should == 1
    img.each_pixel do |c|
      c.should == ZPNG::Color::RED
    end

    SugarPNG.new do
      pixels 10..20, 20..30, :blue
      save "out.png"
    end
    img = ZPNG::Image.load("out.png")
    img.width.should == 21
    img.height.should == 31
    img.each_pixel do |c,x,y|
      if (10..20).include?(x) && (20..30).include?(y)
        c.should == ZPNG::Color::BLUE
      else
        c.should == ZPNG::Color::TRANSPARENT
      end
    end
  end

  it "accept(s) array(s) as pixel(s) method(s)" do
    data = SugarPNG.new do
      bg 'white'
      dot [1,3,5,10], 0, :red
    end.to_s

    img = ZPNG::Image.new data
    img.width.should == 11
    img.height.should == 1
    img.each_pixel do |c,x,y|
      if [1,3,5,10].include?(x)
        c.should == ZPNG::Color::RED
      else
        c.should == ZPNG::Color::WHITE
      end
    end
  end

  it "accept(s) enum(s) as pixel(s) method(s)" do
    data = SugarPNG.new do
      dot 0.step(50,5), 0.step(30,3), :black
    end.to_s

    img = ZPNG::Image.new data
    img.width.should == 51
    img.height.should == 31
    img.each_pixel do |c,x,y|
      if 0.step(50,5).include?(x) && 0.step(30,3).include?(y)
        c.should == ZPNG::Color::BLACK
      else
        c.should == ZPNG::Color::TRANSPARENT
      end
    end
  end
end
