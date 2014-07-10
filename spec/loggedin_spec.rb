require 'spec_helper'

describe "homepage_exsits" do
  it "returns homepage" do
    have_content "FISH.LY"
  end
end