require 'rails_helper'

RSpec.describe 'Admin' do
  describe "I visit a user's profile page ('/admin/users/5') and see the" do
      before :each do
        @larry = User.create(name: "Larry Green", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, email: "green@gmail.com", password: "frogs", role: "admin")
        @user = User.create(name: "Tyler", address: "123 Clarkson St", city: "Denver", state: "CO", zip: 80209, email: "user@gmail.com", password: "cheetos", role: "user")
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@larry)
        visit admin_user_path(@user)
      end

      it "I see the same information the user would see themselves" do
        within("#user-#{@user.id}") do
          expect(page).to have_content("Name: #{@user.name}")
          expect(page).to have_content("Email: #{@user.email}")
          expect(page).to have_content("Address: #{@user.address}")
          expect(page).to have_content("City: #{@user.city}")
          expect(page).to have_content("State: #{@user.state}")
          expect(page).to have_content("Zip: #{@user.zip}")
        end
      end

      it "I see a link to edit their profile" do
        click_on 'Edit Profile'
        expect(current_path).to eq(edit_admin_user_path(@user.id))

        expect(page).to_not have_content("Password")
        fill_in "Name", with: "Roger Rabbit"

        within "#admin_only" do
          select "employee", :from => "Role"
          select "Megans Marmalades", :from => 'user[merchant_id]'
        end

        click_on "Update Profile"

        expect(page).to have_content("This user has been updated")
        expect(current_path).to eq(admin_user_path(@user))

        @user.reload

        expect(@user.name).to eq("Roger Rabbit")
        expect(@user.role).to eq("employee")
        expect(@user.merchant_id).to eq(@megan.id)
      end

      it "I see a flash when I dont edit the user properly" do
        click_on 'Edit Profile'
        expect(current_path).to eq(edit_admin_user_path(@user.id))

        expect(page).to_not have_content("Password")
        fill_in "Name", with: "Roger Rabbit"

        within "#admin_only" do
          select "employee", :from => "Role"
        end

        click_on "Update Profile"

        expect(page).to have_content("merchant_id: [\"can't be blank\"")
      end
    end
  end
