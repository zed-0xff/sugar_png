require 'spec_helper'

describe SugarPNG do
  describe "border" do
    it "draws image entirely of border" do
      SugarPNG.new do |img|
        img.border 10

        img = ZPNG::Image.new(img.to_s)
        img.width.should == 20
        img.height.should == 20
        img.pixels.each do |c|
          c.should == ZPNG::Color::TRANSPARENT
        end
      end
    end

    it "draws image of 2 borders" do
      SugarPNG.new do |img|
        img.border 1, :red
        img.border 1, :blue

        img = ZPNG::Image.new(img.to_s)
        img.width.should == 4
        img.height.should == 4
        img.each_pixel do |c,x,y|
          if x==0 || x==3 || y == 0 || y == 3
            c.should == ZPNG::Color::RED
          else
            c.should == ZPNG::Color::BLUE
          end
        end
      end
    end
  end
end
