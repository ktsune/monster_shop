require 'rails_helper'

RSpec.describe 'Package Order' do
  describe 'As a Merchant' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @alex = User.create!(name: "Alex Hennel", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, email: "straw@gmail.com", password: "fish", role: 0)
      @tyler = User.create!(name: "Tyler", address: "123 Bean Lane", city: "Bean City", state: "CO", zip: 12345, email: "tyler@gmail.com", password: "soup", role: 1, merchant_id: @megan.id)
      @roger = User.create!(name: "Roger", address: "123 Cheese Lane", city: "Cheese City", state: "CO", zip: 12345, email: "roger@gmail.com", password: "rabbit", role: 1, merchant_id: @brian.id)

      @alex.orders.create
      @alex.orders.last.order_items.create!(item_id: @giant.id, price: @giant.price, quantity: 2)
      @alex.orders.last.order_items.create!(item_id: @hippo.id, price: @hippo.price, quantity: 1)

      @order = Order.last
      expect(@order.status).to eq("pending")
      visit login_path

      within '#login' do
        fill_in "Email", with: @tyler.email
        fill_in "Password", with: @tyler.password
        click_on 'Login'
      end

      visit merchant_order_path(@order)
      click_on 'Fulfill'
      expect(@order.order_items.where(item_id: @giant.id).first.status).to eq("fulfilled")

      within 'nav' do
        click_on 'Logout'
      end
    end

    it 'an order status is updated to packaged when all items have been fulfilled' do
      visit login_path

      within '#login' do
        fill_in "Email", with: @roger.email
        fill_in "Password", with: @roger.password
        click_on 'Login'
      end

      visit merchant_order_path(@order)
      click_on 'Fulfill'
      expect(@order.order_items.where(item_id: @hippo.id).first.status).to eq("fulfilled")
      @order.reload
      expect(@order.status).to eq("packaged")
    end

    it 'an order status is not updated to packaged when all items have not been fulfilled' do
      @order.reload
      expect(@order.status).to eq("pending")
    end
  end
end
