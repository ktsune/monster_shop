require 'rails_helper'

RSpec.describe 'Admin User Index Page' do
  describe "As an Admin" do
    before :each do
      @megan = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @larry = User.create(name: "Larry Green", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, email: "green@gmail.com", password: "frogs", role: "admin")
      @user = User.create(name: "Tyler", address: "123 Clarkson St", city: "Denver", state: "CO", zip: 80209, email: "user@gmail.com", password: "cheetos", role: "user", enabled: true)
      @employee = User.create(name: "Merchant", address: "456 Market St", city: "Denver", state: "CO", zip: 80210, email: "employee@gmail.com", password: "taco_sauce", role: "employee", merchant_id: @megan.id)
      @merchant_admin = User.create(name: "Merchant Admin", address: "456 Market St", city: "Denver", state: "CO", zip: 80210, email: "merchant@gmail.com", password: "taco_sauce", role: "merchant", merchant_id: @megan.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@larry)
    end

    it "when I visit the user index page I see all users in the system" do
      visit root_path

      within "nav" do
        click_on 'Users'
      end

      expect(current_path).to eq(admin_users_path)

      within "#user-#{@user.id}" do
        expect(page).to have_link(@user.name, href: admin_user_path(@user.id))
        expect(page).to have_content(@user.created_at)
        expect(page).to have_content(@user.role.capitalize)
      end

      within "#user-#{@employee.id}" do
        expect(page).to have_link(@employee.name, href: admin_user_path(@employee.id))
        expect(page).to have_content(@employee.created_at)
        expect(page).to have_content(@employee.role.capitalize)
      end

      within "#user-#{@merchant_admin.id}" do
        expect(page).to have_link(@merchant_admin.name, href: admin_user_path(@merchant_admin.id))
        expect(page).to have_content(@merchant_admin.created_at)
        expect(page).to have_content(@merchant_admin.role.capitalize)
      end
    end

    it "I can toggle a button to enable or disable a user" do
      visit admin_users_path
      expect(@user.enabled).to eq(true)

      within "#disable-user-#{@user.id}" do
        click_button 'Disable User'
      end

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content("The account for #{@user.name} is now disabled.")

      expect(@user.reload.enabled).to eq(false)

      within "#disable-user-#{@user.id}" do
        click_button 'Enable User'
      end

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content("The account for #{@user.name} is now enabled.")
      expect(@user.reload.enabled).to eq(true)
    end

    it "A disabled user cannot log in" do
      visit admin_users_path
      expect(@user.enabled).to eq(true)

      within "#disable-user-#{@user.id}" do
        click_button 'Disable User'
        expect(@user.reload.enabled).to eq(false)
        expect(page).to have_no_link("Log In")
      end
    end

    it "The users city/state and orders should not be part of any statistics" do

    end
  end
end
