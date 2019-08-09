require 'rails_helper'

RSpec.describe 'Merchant' do
  describe 'I visit an order show page from my dashboard' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @brian.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @megan.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )

      @larry = User.create!(name: "Larry Green", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, email: "green@gmail.com", password: "frogs", role: 2, merchant_id: @megan.id)
      @customer = User.create!(name: "Customer McCustomer", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, email: "customer@gmail.com", password: "shopper", role: 0)

      @order_1 = @customer.orders.create!

      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @giant, price: @giant.price, quantity: 1)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@larry)
      visit merchant_dashboard_path
    end

    it 'I see the order details' do
      click_link "Order ##{@order_1.id}"

      within '#order-header' do
        expect(page).to have_content("For: #{@customer.name}")
        expect(page).to have_content("Address: #{@customer.address}")
        expect(page).to have_content("#{@customer.city} #{@customer.state} #{@customer.zip}")
      end

      expect(page).to_not have_content(@giant.name)

      within "#item-#{@ogre.id}" do
        expect(page).to have_link(@ogre.name)
        expect(page).to have_css("img[src*='#{@ogre.image}']")
        expect(page).to have_content("Price: $#{@ogre.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_link("Fulfill")
      end
      expect(@ogre.order_items.first.status).to eq("unfulfilled")

      within "#item-#{@hippo.id}" do
        expect(page).to have_link(@hippo.name)
        expect(page).to have_css("img[src*='#{@hippo.image}']")
        expect(page).to have_content("Price: $#{@hippo.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to_not have_link("Fulfill")
        expect(page).to have_content("Item cannot be fulfilled.")
      end
      expect(@hippo.order_items.first.status).to eq("unfulfilled")

      click_link "Fulfill"

      expect(@ogre.reload.order_items.first.status).to eq("fulfilled")
      expect(current_path).to eq(merchant_order_path(@order_1))
      expect(page).to have_content("#{@ogre.name} has been fulfilled.")
      expect(@ogre.inventory).to eq(3)
      within "#item-#{@ogre.id}" do
        expect(page).to have_content("Item Fulfilled")
        expect(page).to_not have_link("Fulfill")
      end
    end
  end
end
