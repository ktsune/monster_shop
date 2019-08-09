require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Show Order' do
  describe 'As a User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @alex = User.create!(name: "Alex Hennel", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, email: "straw@gmail.com", password: "fish", role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@alex)
    end

    it 'I can click a link to my order within my orders index page' do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'
      click_button 'Check Out'

      click_button 'Create Order'

      order = Order.last

      expect(current_path).to eq(profile_orders_path)
      click_link "Order ##{order.id}"
      expect(current_path).to eq(show_order_path(order.id))
      within "#order-#{order.id}" do
        expect(page).to have_content(order.id)
        expect(page).to have_content(order.created_at)
        expect(page).to have_content(order.updated_at)
        expect(page).to have_content(order.status)
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content(@ogre.name)
        expect(page).to have_content(@ogre.description)
        expect(page).to have_css("img[src*='#{@ogre.image}']")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
        expect(page).to have_content("Subtotal: #{number_to_currency(@ogre.price * 1)}")
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_content(@hippo.name)
        expect(page).to have_content(@hippo.description)
        expect(page).to have_css("img[src*='#{@hippo.image}']")
        expect(page).to have_content("Price: #{number_to_currency(@hippo.price)}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 2)}")
      end

      within "#totals" do
        expect(page).to have_content("Total Items: 3")
        expect(page).to have_content("Grand Total: $120")
      end
    end
  end
end
