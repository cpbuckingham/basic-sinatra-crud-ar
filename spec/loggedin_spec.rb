require 'spec_helper'

feature "Homepage" do
  scenario "should contain site title" do
    visit "/"
    expect(page).to have_content("FISH.LY")
  end
end

feature "Registration" do
  scenario "should have forms to register user" do
    visit "/"
    click_on "Register"
    expect(page).to have_content("Username:")
  end
end



