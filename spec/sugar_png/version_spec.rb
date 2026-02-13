# frozen_string_literal: true

require "spec_helper"

describe "SugarPNG::VERSION" do
  it "is a string" do
    expect(SugarPNG::VERSION).to be_a(String)
  end

  it "matches semver x.y.z" do
    expect(SugarPNG::VERSION).to match(/\A\d+\.\d+\.\d+/)
  end
end
