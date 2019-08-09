require 'rails_helper'

RSpec.describe 'Admin' do
  describe "I visit the merchant's index page and see their city and state" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
      @larry = User.create!(name: "Larry Green", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, email: "green@gmail.com", password: "frogs", role: "admin", merchant_id: @megan.id)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@larry)
      visit admin_merchants_path
    end

    it "I see merchant name, city, and state displayed on the page" do
      expect(page).to have_link("Megans Marmalades")
      expect(page).to have_content(@megan.city)
      expect(page).to have_content(@megan.state)
    end

    it "The merchant's name is a link to their merchant dashboard" do
      click_link "Megans Marmalades"

      expect(current_path).to eq(admin_merchant_path(@megan.id))
    end

    it "I can toggle a button to enable or disable a merchant" do
      expect(@megan.enabled).to eq(true)

      click_button 'Disable Merchant'

      expect(page).to have_content("The account for #{@megan.name} is now disabled.")
      expect(current_path).to eq(admin_merchants_path)

      expect(@megan.reload.enabled).to eq(false)
      expect(@giant.reload.active).to eq(false)
      expect(@ogre.reload.active).to eq(false)

      click_button 'Enable Merchant'

      expect(page).to have_content("The account for #{@megan.name} is now enabled.")
      expect(current_path).to eq(admin_merchants_path)
      expect(@ogre.reload.active).to eq(true)
      expect(@giant.reload.active).to eq(true)
      expect(@megan.reload.enabled).to eq(true)
    end
  end
end
