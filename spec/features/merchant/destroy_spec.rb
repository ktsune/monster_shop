require 'rails_helper'

RSpec.describe 'Destroy Existing Merchant' do
  describe 'As an admin' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @brian.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )

      @meg = User.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'meg@gmail.com', password: 'fish' )
      @order_1 = @meg.orders.create!
      @order_1.order_items.create(item: @ogre, quantity: 3, price: @ogre.price)

      @admin = User.create!(name: "Admin", address: "123 Cheese Lane", city: "Cheese City", state: "CO", zip: 12345, email: "admin@gmail.com", password: "rabbit", role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'I can click button to destroy merchant from database' do
      visit admin_merchant_path(@brian)

      click_button 'Delete'

      expect(current_path).to eq(merchants_path)
      expect(page).to_not have_content(@brian.name)
    end

    it 'When a merchant is destroyed, their items are also destroyed' do
      page.driver.submit :delete, merchant_path(@brian), {}

      visit items_path

      expect(page).to_not have_content(@giant.name)
    end

    describe 'If a merchant has items that have been ordered' do
      it 'I do not see a button to delete the merchant' do
        visit admin_merchant_path(@megan)

        expect(page).to_not have_button('Delete')
      end

      it 'I can not delete a merchant' do
        page.driver.submit :delete, merchant_path(@megan), {}

        expect(page).to have_content(@megan.name)
        expect(page).to have_content("#{@megan.name} can not be deleted - they have orders!")
      end
    end
  end
end
