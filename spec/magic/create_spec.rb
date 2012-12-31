require 'spec_helper'

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
end
