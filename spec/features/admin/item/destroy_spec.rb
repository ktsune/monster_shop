# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delete Item' do
  describe 'As a Merchant' do
    describe 'When I visit an items show page' do
      before :each do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
        @larry = User.create!(name: 'Larry Green', address: '345 Blue Lane', city: 'Blue City', state: 'CA', zip: 56_789, email: 'green@gmail.com', password: 'frogs', role: 3, merchant_id: @megan.id)
        @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
        @ogre.reviews.create!(title: 'Hi', description: 'Great', rating: 4)
        @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3)
        @hippo = @megan.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3)
        @meg = User.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'meg@gmail.com', password: 'fish')
        @order2 = @larry.orders.create!
        @order2.order_items.create!(item: @giant, price: @giant.price, quantity: 2)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@larry)
        visit admin_merchant_items_path(@megan)
      end

      it 'I can click a link to delete that item' do
        within "#item-#{@ogre.id}" do
          click_button 'Delete Item'
        end

        expect(current_path).to eq(admin_merchant_items_path(@megan))
        expect(page).to_not have_css("#item-#{@ogre.id}")
        expect(page).to have_css("#item-#{@hippo.id}")
        expect(page).to have_css("#item-#{@giant.id}")
      end

      it 'Deleting an item, deletes its reviews as well' do
        within "#item-#{@ogre.id}" do
          click_button 'Delete Item'
        end

        expect(Review.count).to eq(0)
      end

      describe 'If an item has orders' do
        before :each do
          jake = User.create!(name: 'Jake', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'jakeman@gmail.com', password: 'fish')
          order_1 = jake.orders.create!
          order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
        end

        it 'I can not see a delete button for items with orders' do
          expect(page).to_not have_link('Delete')
        end

        it 'I can not delete an item with orders through a direct request' do
          page.driver.submit :delete, admin_merchant_item_path(@megan,@giant), {}

          expect(page).to have_content("#{@giant.name} can not be deleted - it has been ordered!")
        end
      end
    end
  end
end
