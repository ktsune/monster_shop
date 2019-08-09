require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Update Item Page' do
  describe 'As a Merchant' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @larry = User.create!(name: 'Larry Green', address: '345 Blue Lane', city: 'Blue City', state: 'CA', zip: 56_789, email: 'green@gmail.com', password: 'frogs', role: 3, merchant_id: @megan.id)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@larry)
    end

    it 'I can click a link to get to an item' do
      visit admin_merchant_items_path(@megan)

      within "#item-#{@ogre.id}" do
        click_button 'Update Item'
      end

      expect(current_path).to eq(edit_admin_merchant_item_path(@megan,@ogre))
    end

    it 'I can edit the items information' do
      name = 'Giant'
      description = "I'm a Giant!"
      price = 25
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw'
      inventory = 12

      visit edit_admin_merchant_item_path(@megan,@ogre)

      fill_in 'Name', with: name
      fill_in 'Description', with: description
      fill_in 'Price', with: price
      fill_in 'Image', with: image
      fill_in 'Inventory', with: inventory
      click_button 'Update Item'

      expect(current_path).to eq(admin_merchant_items_path(@megan))
      expect(page).to have_link(name)
      expect(page).to have_content(description)
      expect(page).to have_content("Price: #{number_to_currency(price)}")
      expect(page).to have_button("Disable Item")
      expect(page).to have_content("Inventory: #{inventory}")
    end

    it 'I can not edit the item with an incomplete form' do
      name = 'Ogre'
      visit edit_admin_merchant_item_path(@megan,@ogre.id)
      fill_in 'Name', with: ''
      fill_in 'Description', with: ''
      fill_in 'Price', with: ''
      fill_in 'Image', with: ''
      fill_in 'Inventory', with: ''
      click_button 'Update Item'

      expect(page).to have_content("name: [\"can't be blank\"]")
      expect(page).to have_content("description: [\"can't be blank\"]")
      expect(page).to have_content("price: [\"can't be blank\"]")
      expect(page).to have_content("image: [\"can't be blank\"]")
      expect(page).to have_content("inventory: [\"can't be blank\"]")
      expect(page).to have_button('Update Item')
    end
  end
end
