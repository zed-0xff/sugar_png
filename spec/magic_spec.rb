require 'spec_helper'
require 'sugar_png'

describe SugarPNG do
  it "has some yield magic" do
    r = SugarPNG.new do |img|
      img.width      = 200
      img.height     = 100
      img.background = :red
      img.bg         = :blue
      10.times do |i|
        img[i,i] = :green
      end
    end
    r.width.should  == 200
    r.height.should == 100
  end

  it "has some instance_eval magic" do
    r = SugarPNG.new do
      width  200
      height 100
      background "#ffeeff"
      background_color "#ff0000"
      dot   10, 10, 'red'
      pixel  0, 12, '#ffee00'
      point  0,  0, 0
    end
    r.width.should  == 200
    r.height.should == 100
    r.bg.should == "#ff0000"
  end

  it "can also eat boring non-magic hash" do
    r = SugarPNG.new :width => 55, :height => 111, :bg => :transparent
    r.width.should  == 55
    r.height.should == 111
  end

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
