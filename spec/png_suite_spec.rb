require 'spec_helper'

describe 'PNG testsuite' do

#  context 'Decoding broken images' do
#    png_suite_files(:broken).each do |fname|
#      it "should report #{File.basename(fname)} as broken" do
#        lambda { SugarPNG::Image.from_file(fname) }.should raise_error(SugarPNG::Exception)
#      end
#
#      it "should not report #{File.basename(fname)} as unsupported" do
#        lambda { SugarPNG::Image.from_file(fname) }.should_not raise_error(SugarPNG::NotSupported)
#      end
#    end
#  end

  context 'Decoding supported images' do
    png_suite_files(:basic, '*.png').each do |fname|

      reference = rgba_for(fname)
      if fname =~ /[in](\d)[apgc](\d\d)\.png$/
        color_mode, bit_depth = $1.to_i, $2.to_i
      else
        next
      end

      it "decodes #{File.basename(fname)} (color mode: #{color_mode}, bit depth: #{bit_depth}) exactly the same as the reference image" do
        decoded = SugarPNG::Canvas.from_file(fname)
        File.open(reference, 'rb') do |f|
          if decoded.to_rgba_stream != f.read
            File.open(reference+".my", 'wb') { |fo| fo<<decoded.to_rgba_stream }
          end
        end
        File.open(reference, 'rb') { |f| decoded.to_rgba_stream.should == f.read }
      end
    end
  end

  context 'Decoding text chunks' do

    it "should not find metadata in a file without text chunks" do
      image = SugarPNG::Image.from_file(png_suite_file(:metadata, 'cm0n0g04.png'))
      image.metadata.should be_empty
    end

    it "should find metadata in a file with uncompressed text chunks" do
      image = SugarPNG::Image.from_file(png_suite_file(:metadata, 'ct1n0g04.png'))
      image.metadata.should_not be_empty
      image.metadata.size.should == 6 # zzz
    end

    it "should find metadata in a file with compressed text chunks" do
      image = SugarPNG::Image.from_file(png_suite_file(:metadata, 'ctzn0g04.png'))
      image.metadata.should_not be_empty
      image.metadata.size.should == 6 # zzz
    end

    %w'cten0g04.png ctfn0g04.png ctgn0g04.png cthn0g04.png ctjn0g04.png'.each do |fname|
      it "should find metadata in a file with intl text chunks (#{fname})" do
        image = SugarPNG::Image.from_file(png_suite_file(:metadata, fname))
        image.metadata.should_not be_empty
        image.metadata.size.should == 6 # zzz
      end
    end
  end

  context 'Decoding filter methods' do
    png_suite_files(:filtering, '*_reference.png').each do |reference_file|
      fname = reference_file.sub(/_reference\.png$/, '.png')
      filter_method = fname.match(/f(\d\d)[a-z0-9]+\.png/)[1].to_i

      it "should decode #{File.basename(fname)} (filter method: #{filter_method}) exactly the same as the reference image" do
        decoded   = SugarPNG::Canvas.from_file(fname)
        reference = SugarPNG::Canvas.from_file(reference_file)
        decoded.to_rgba_stream.should == reference.to_rgba_stream
      end
    end
  end

  context 'Decoding different chunk splits' do
    it "should decode grayscale images successfully regardless of the data chunk ordering and splitting" do
      reference = SugarPNG::Datastream.from_file(png_suite_file(:chunk_ordering, 'oi1n0g16.png')).imagedata
      SugarPNG::Datastream.from_file(png_suite_file(:chunk_ordering, 'oi2n0g16.png')).imagedata.should == reference
      SugarPNG::Datastream.from_file(png_suite_file(:chunk_ordering, 'oi4n0g16.png')).imagedata.should == reference
      SugarPNG::Datastream.from_file(png_suite_file(:chunk_ordering, 'oi9n0g16.png')).imagedata.should == reference
    end

    it "should decode color images successfully regardless of the data chunk ordering and splitting" do
      reference = SugarPNG::Datastream.from_file(png_suite_file(:chunk_ordering, 'oi1n2c16.png')).imagedata
      SugarPNG::Datastream.from_file(png_suite_file(:chunk_ordering, 'oi2n2c16.png')).imagedata.should == reference
      SugarPNG::Datastream.from_file(png_suite_file(:chunk_ordering, 'oi4n2c16.png')).imagedata.should == reference
      SugarPNG::Datastream.from_file(png_suite_file(:chunk_ordering, 'oi9n2c16.png')).imagedata.should == reference
    end
  end

  context 'Decoding different compression levels' do
    it "should decode the image successfully regardless of the compression level" do
      reference = SugarPNG::Datastream.from_file(png_suite_file(:compression_levels, 'z00n2c08.png')).imagedata
      SugarPNG::Datastream.from_file(png_suite_file(:compression_levels, 'z03n2c08.png')).imagedata.should == reference
      SugarPNG::Datastream.from_file(png_suite_file(:compression_levels, 'z06n2c08.png')).imagedata.should == reference
      SugarPNG::Datastream.from_file(png_suite_file(:compression_levels, 'z09n2c08.png')).imagedata.should == reference
    end
  end

  context 'Decoding transparency' do
    png_suite_files(:transparency, 'tp0*.png').each do |file|
      it "should not have transparency in #{File.basename(file)}" do
        SugarPNG::Color.a(SugarPNG::Image.from_file(file)[0,0]).should == 255
      end
    end

    png_suite_files(:transparency, 'tp1*.png').each do |file|
      it "should have transparency in #{File.basename(file)}" do
        SugarPNG::Color.a(SugarPNG::Image.from_file(file)[0,0]).should == 0
      end
    end

    png_suite_files(:transparency, 'tb*.png').each do |file|
      it "should have transparency in #{File.basename(file)}" do
        SugarPNG::Color.a(SugarPNG::Image.from_file(file)[0,0]).should == 0
      end
    end
  end

  context 'Decoding different sizes' do
    png_suite_files(:sizes, '*n*.png').each do |fname|
      if fname =~ /s(\d\d)n\dp\d\d/
        dimension = $1.to_i
      else
        next
      end

      it "should create a canvas with a #{dimension}x#{dimension} size" do
        canvas = SugarPNG::Image.from_file(fname)
        canvas.width.should == dimension
        canvas.height.should == dimension
      end

      it "should decode the #{dimension}x#{dimension} interlaced image exactly the same the non-interlaced version" do
        interlaced_file = fname.sub(/n3p(\d\d)\.png$/, 'i3p\\1.png')
        SugarPNG::Image.from_file(interlaced_file).pixels.should ==
          SugarPNG::Image.from_file(fname).pixels
      end
    end
  end
end
