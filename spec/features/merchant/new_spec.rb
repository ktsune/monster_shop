require 'rails_helper'

RSpec.describe 'New Merchant Creation' do
  describe 'I try to click on a New Merchant button' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    end

    it 'A visitor cannot create a new merchant' do
      visit '/merchants'
      expect(page).to_not have_link('New Merchant')
    end

    it 'A regular user cannot create a new merchant' do
      reg_user = User.create!(name: "Alex Hennel", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, email: "straw@gmail.com", password: "fish", role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(reg_user)

      visit '/merchants'
      expect(page).to_not have_link('New Merchant')
    end

    it 'A merchant cannot create a new merchant' do
      employee = User.create!(name: "Tyler", address: "123 Bean Lane", city: "Bean City", state: "CO", zip: 12345, email: "employee@gmail.com", password: "soup", role: 1, merchant_id: @megan.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)

      visit '/merchants'
      expect(page).to_not have_link('New Merchant')
    end

    it 'A merchant cannot create a new merchant' do
      merchant = User.create!(name: "Tyler", address: "123 Bean Lane", city: "Bean City", state: "CO", zip: 12345, email: "employee@gmail.com", password: "soup", role: 1, merchant_id: @megan.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit '/merchants'
      expect(page).to_not have_link('New Merchant')
    end

    it 'I can use the new merchant form to create a new merchant' do
      admin = User.create!(name: "Admin", address: "123 Cheese Lane", city: "Cheese City", state: "CO", zip: 12345, email: "admin@gmail.com", password: "rabbit", role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit root_path
      click_link 'Merchants'

      expect(page).to have_content('Admin Merchant Index')
      expect(current_path).to eq(admin_merchants_path)

      click_link 'New Merchant'
      expect(current_path).to eq(new_admin_merchant_path)
      name = 'Megans Marmalades'
      address = '123 Main St'
      city = "Denver"
      state = "CO"
      zip = 80218
      fill_in 'Name', with: name
      fill_in 'Address', with: address
      fill_in 'City', with: city
      fill_in 'State', with: state
      fill_in 'Zip', with: zip

      click_button 'Create Merchant'

      expect(current_path).to eq('/merchants')
      expect(page).to have_link(name)
    end

    it 'I can not create a merchant with an incomplete form' do
      admin = User.create!(name: "Admin", address: "123 Cheese Lane", city: "Cheese City", state: "CO", zip: 12345, email: "admin@gmail.com", password: "rabbit", role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit root_path
      click_link 'Merchants'

      expect(page).to have_content('Admin Merchant Index')
      expect(current_path).to eq(admin_merchants_path)

      click_link 'New Merchant'
      expect(current_path).to eq(new_admin_merchant_path)
      name = 'Megans Marmalades'
      fill_in 'Name', with: name
      click_button 'Create Merchant'

      expect(page).to have_content("address: [\"can't be blank\"]")
      expect(page).to have_content("city: [\"can't be blank\"]")
      expect(page).to have_content("state: [\"can't be blank\"]")
      expect(page).to have_content("zip: [\"can't be blank\"]")
      expect(page).to have_button('Create Merchant')
    end
  end
end
