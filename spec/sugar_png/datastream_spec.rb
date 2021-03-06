require 'spec_helper'

describe SugarPNG::Datastream do

  describe '.from_io'do
    it "should raise an error when loading a file with a bad signature" do
      filename = resource_file('damaged_signature.png')
      lambda { SugarPNG::Datastream.from_file(filename) }.should raise_error(ZPNG::NotSupported)
    end

    it "should NOT raise an error if the CRC of a chunk is incorrect" do
      filename = resource_file('damaged_chunk.png')
      lambda { SugarPNG::Datastream.from_file(filename) }.should_not raise_error
    end
  end

  describe '#metadata' do
    it "should load uncompressed tXTt chunks correctly" do
      filename = resource_file('text_chunk.png')
      ds = SugarPNG::Datastream.from_file(filename)
      ds.metadata['Title'].should  == 'My amazing icon!'
      ds.metadata['Author'].should == "Willem van Bergen"
    end

    it "should load compressed zTXt chunks correctly" do
      filename = resource_file('ztxt_chunk.png')
      ds = SugarPNG::Datastream.from_file(filename)
      ds.metadata['Title'].should == 'PngSuite'
      ds.metadata['Copyright'].should == "Copyright Willem van Schaik, Singapore 1995-96"
    end
  end
end
