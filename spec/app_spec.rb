require "spec_helper"
before do
  @database_connection.sql("INSERT INTO users (username, password) VALUES ('cam', 'jam')")
  @database_connection.sql("INSERT INTO users (username, password) VALUES ('pete', 'butts')")
end
feature "Fish.ly" do
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
    visit "/users_alphabet"
    expect(page).to have_content("It's sorted alphabetically")
  end
  scenario "User can sort names" do
    visit "/users_descending"
    expect(page).to have_content("It's sorted in descending order")
  end
  scenario "logout button exists" do
    visit "/loggedin"
    click_button "Logout"
    expect(page).to have_content "Register"
  end
  scenario "logged in user can delete other users" do
    visit "/loggedin"
    fill_in "delete", with: "pete"
    expect(page).to have_no_content ("pete")

  end

end

