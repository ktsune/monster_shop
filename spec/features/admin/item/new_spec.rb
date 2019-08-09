require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'New Merchant Item' do
  describe 'As an Admin' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @larry = User.create!(name: 'Larry Green', address: '345 Blue Lane', city: 'Blue City', state: 'CA', zip: 56_789, email: 'green@gmail.com', password: 'frogs', role: 3, merchant_id: @megan.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@larry)
    end

    it 'I can click a link to a new item form page' do
      visit admin_merchant_items_path(@megan)

      click_button 'New Item'

      expect(current_path).to eq(new_admin_merchant_item_path(@megan))
    end

    it 'I can create an  item for a merchant' do
      name = 'Ogre'
      description = "I'm an Ogre!"
      price = 20
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw'
      inventory = 5

      visit new_admin_merchant_item_path(@megan)

      fill_in 'Name', with: name
      fill_in 'Description', with: description
      fill_in 'Price', with: price
      fill_in 'Image', with: image
      fill_in 'Inventory', with: inventory
      click_button 'Create Item'

      expect(current_path).to eq(admin_merchant_items_path(@megan))
      expect(page).to have_link(name)
      expect(page).to have_content(description)
      expect(page).to have_content("Price: #{number_to_currency(price)}")
      expect(page).to have_button("Disable Item")
      expect(page).to have_content("Inventory: #{inventory}")
    end

    it 'I can not create an item for a merchant with an incomplete form' do
      name = 'Ogre'

      visit new_admin_merchant_item_path(@megan)

      fill_in 'Name', with: name
      click_button 'Create Item'

      expect(page).to have_content("description: [\"can't be blank\"]")
      expect(page).to have_content("price: [\"can't be blank\"]")
      expect(page).to have_content("image: [\"can't be blank\"]")
      expect(page).to have_content("inventory: [\"can't be blank\"]")
      expect(page).to have_button('Create Item')
    end
  end
end
