require 'rails_helper'

RSpec.describe 'Admin' do
  describe 'when I visit my dashboard' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @admin = User.create!(name: "Admin", address: "123 Cheese Lane", city: "Cheese City", state: "CO", zip: 12345, email: "admin@gmail.com", password: "rabbit", role: 3)
      @reg_user = User.create!(name: "Alex Hennel", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, email: "straw@gmail.com", password: "fish", role: 0)
      @employee = User.create!(name: "Tyler", address: "123 Bean Lane", city: "Bean City", state: "CO", zip: 12345, email: "employee@gmail.com", password: "soup", role: 1, merchant_id: @megan.id)
      @packaged = @reg_user.orders.create
      @packaged.order_items.create!(item_id: @giant.id, price: @giant.price, quantity: 2)
      @packaged.order_items.create!(item_id: @hippo.id, price: @hippo.price, quantity: 1)
      @pending = @employee.orders.create
      @pending.order_items.create!(item_id: @ogre.id, price: @ogre.price, quantity: 2)
      @pending.order_items.create!(item_id: @hippo.id, price: @hippo.price, quantity: 1)
      @shipped = @reg_user.orders.create
      @shipped.order_items.create!(item_id: @giant.id, price: @giant.price, quantity: 3)
      @canceled = @employee.orders.create
      @canceled.order_items.create!(item_id: @hippo.id, price: @hippo.price, quantity: 1)
      @packaged.update(status: "packaged")
      @shipped.update(status: "shipped")
      @canceled.update(status: "canceled")
      @packaged.reload
      @shipped.reload
      @canceled.reload
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path
    end

    it 'I can see all orders in the system sorted by status' do
      within "#order-#{@packaged.id}" do
        expect(page).to have_link(@reg_user.name, href: admin_user_path(@reg_user.id))
        expect(page).to have_content("Order: ##{@packaged.id}")
        expect(page).to have_content("Created: #{@packaged.created_at}")
      end

      within "#order-#{@pending.id}" do
        expect(page).to have_link(@employee.name, href: admin_user_path(@employee.id))
        expect(page).to have_content("Order: ##{@pending.id}")
        expect(page).to have_content("Created: #{@pending.created_at}")
      end

      within "#order-#{@shipped.id}" do
        expect(page).to have_link(@reg_user.name, href: admin_user_path(@reg_user.id))
        expect(page).to have_content("Order: ##{@shipped.id}")
        expect(page).to have_content("Created: #{@shipped.created_at}")
      end

      within "#order-#{@canceled.id}" do
        expect(page).to have_link(@employee.name, href: admin_user_path(@employee.id))
        expect(page).to have_content("Order: ##{@canceled.id}")
        expect(page).to have_content("Created: #{@canceled.created_at}")
      end

      within '#orders' do
        expect(page.all('li')[0]).to have_content(@packaged.id)
        expect(page.all('li')[1]).to have_content(@pending.id)
        expect(page.all('li')[2]).to have_content(@shipped.id)
        expect(page.all('li')[3]).to have_content(@canceled.id)
      end
    end

    describe 'I see packaged orders ready to ship with a button to "ship" the order' do
      describe 'When I click that button, the status of that order changes to "shipped"' do
        it 'And the user can no longer "cancel" the order' do
          within "#order-#{@pending.id}" do
            expect(page).to_not have_button("Ship Order")
          end

          within "#order-#{@packaged.id}" do
            expect(page).to have_button("Ship Order")
            click_button "Ship Order"
            @packaged.reload
            expect(@packaged.status).to eq("shipped")
          end
        end
      end
    end
  end
end
