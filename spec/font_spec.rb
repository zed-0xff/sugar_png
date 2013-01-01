#coding: utf-8
require 'spec_helper'

describe SugarPNG::Font do
  subject(:font){ SugarPNG::Font.new }

  it "should get 'R'" do
    char = <<-EOF.strip.split("\n").map(&:strip).join("\n")
       ........
       ........
       ........
       ........
       .#####..
       .#....#.
       .#....#.
       .#....#.
       .#####..
       .#..#...
       .#...#..
       .#...#..
       .#....#.
       .#....#.
       ........
       ........
    EOF
    font['R'].to_s(".#").should == char
  end

  it "should get '水'" do
    char = <<-EOF.strip.split("\n").map(&:strip).join("\n")
       .......#........
       .......#........
       .......#........
       .......#....#...
       .......#....#...
       .#####.##..#....
       .....#.##.#.....
       ....#..#.#......
       ....#..#.#......
       ...#...#..#.....
       ...#...#...#....
       ..#....#....#...
       .#.....#.....##.
       #......#........
       .....#.#........
       ......#.........
    EOF
    font['水'].to_s(".#").should == char
    font['水'].width.should == 16
    font['水'].ord.should == '水'.ord
  end

  it "should get identical glyphs from int/string" do
    font['A'].should == font['A'.ord]
  end

  %w'A Z 0 Ж'.each do |char|
    describe "glyph '#{char}'" do
      subject(:glyph){ font[char] }

      it { should_not be_nil   }
      it { should_not be_blank }

      its(:width) { should == 8 }
      its(:height){ should == 16 }
      its(:data)  { should_not be_empty }
      its(:ord)   { should == char.ord }
    end
  end

  describe "glyph ' ' (space)" do
    subject(:glyph){ font[' '] }

    it { should_not be_nil   }
    it { should     be_blank }

    its(:width) { should == 8 }
    its(:height){ should == 16 }
    its(:data)  { should_not be_empty }
    its(:ord)   { should == ' '.ord }
  end
end
