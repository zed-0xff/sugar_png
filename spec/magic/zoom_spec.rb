require 'spec_helper'

describe SugarPNG do
  describe "zoom" do
    it "zooms 1x1 => 2x2" do
      SugarPNG.new do |img|
        img[0,0] = ZPNG::Color::RED
        img.zoom = 2

        img = ZPNG::Image.new(img.to_s)
        img.width.should == 2
        img.height.should == 2
        img.pixels.each do |c|
          c.should == ZPNG::Color::RED
        end
      end
    end

    it "zooms 2x1 => 4x2" do
      SugarPNG.new do |img|
        img[0,0] = ZPNG::Color::RED
        img[1,0] = ZPNG::Color::GREEN
        img.zoom = 2

        img = ZPNG::Image.new(img.to_s)
        img.width.should == 4
        img.height.should == 2
        img.each_pixel do |c,x,y|
          if x < 2
            c.should == ZPNG::Color::RED
          else
            c.should == ZPNG::Color::GREEN
          end
        end
      end
    end
  end
end
