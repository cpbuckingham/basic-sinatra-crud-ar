require "spec_helper"
before do
  @database_connection.sql("INSERT INTO users (username, password) VALUES ('cam', 'jam')")
end
feature "See Homepage" do
  scenario "A anonymous user can see the register button on homepage" do
    visit "/"
    click_link "Register"
    expect(page).to have_content('Register')
  end
  scenario "A anonymous user cannot login with both a Username or Password" do
    visit "/registration"
    fill_in "Username", with: ""
    fill_in "Password", with: ""
    click_button "Login"
    expect(page).to have_content('No username or password entered')
  end
  scenario "A anonymous user cannot login without a Username" do
    visit "/registration"
    fill_in "Username", with: ""
    fill_in "Password", with: "blah"
    click_button "Login"
    expect(page).to have_content('No username entered')
  end
  scenario "A anonymous user cannot login without a Passowrd" do
    visit "/registration"
    fill_in "Username", with: "blah"
    fill_in "Password", with: ""
    click_button "Login"
    expect(page).to have_content('No password entered')
  end
  scenario "If we try to register a name that's already taken, we get an error" do
    visit "/registration"
    fill_in "Username", with: "cam"
    fill_in "Password", with: "jam"
    click_button "Login"
    expect(page).to have_content('Username already taken')
  end
  scenario "registered user can log in" do
    visit "/"
    fill_in "Username", with: "cam"
    fill_in "Password", with: "jam"
    click_button "Login"
    expect(page).to have_content('Welcome, cam')


  end
  scenario "User can sort names" do
    visit "/loggedin"
    click_button 'List users alphabetically'
  end


end


#     #scenario "User can sort names" do
#     visit "/"
#     click_link "Register"
#     fill_in "username", with: "zeta"
#     fill_in "password", with: "zeta"
#     click_button "Register"
#
#     click_link "Register"
#     fill_in "username", with: "alpha"
#     fill_in "password", with: "alpha"
#     click_button "Register"
#     visit "/"
#
#     #can login
#     fill_in "username", with: "blah"
#     fill_in "password", with: "blah"
#     click_button "Sign In"
#
#     #sees logged-in homepage
#     expect(page).to have_content("blah", count: 1)
#     expect(page).to have_content("Welcome, blah")
#     expect(page).to have_content("zeta")
#
#     #can alphabetize userlist
#     click_button "Order"
#
#     expect(page).to have_selector("table tr:nth-child(2)", :text => "alpha")
#
#     #can delete users
#     click_link("delete", options={href: "/delete/zeta"})
#     expect(page).to_not have_content("zeta")
#
#     #user can create a fish
#     click_link("Create a Fish!")
#     fill_in "fishname", with: "Goldfish"
#     click_button "Create"
#     expect(page).to have_link("Wikipedia", options={href: "http://en.wikipedia.org/wiki/Goldfish"})
#
#     #scenario "I can log out of homepage" do
#     click_button "Log Out"
#     expect(page).to have_content("Sign In")
#
#     #user only sees their fish
#     fill_in "username", with: "alpha"
#     fill_in "password", with: "alpha"
#     click_button "Sign In"
#     click_link("Create a Fish!")
#     fill_in "fishname", with: "Trout"
#     click_button "Create"
#     expect(page).to_not have_link("Wikipedia", options={href: "http://en.wikipedia.org/wiki/Goldfish"})
#
#
#     #scenario "I can see other users fish when I click on their names"
#     click_link "blah"
#     expect(page).to have_link("Goldfish")
#
#     #user can favorite fish
#     click_button "favorite Goldfish"
#     expect(page).to have_link("Wikipedia", options={href: "http://en.wikipedia.org/wiki/Goldfish"})
#   end
# end


