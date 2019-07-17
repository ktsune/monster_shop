# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_length_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_length_of(:zip) }
    it { should validate_numericality_of(:zip) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe User do
    describe 'roles' do
      it 'can be created as an admin' do
        user = User.create(email: 'penelope', password: 'boom', role: 2)

        expect(user.role).to eq('admin')
        expect(user.admin?).to be_truthy
      end

      it 'can be created as a default user' do
        user = User.create(email: 'sammy', password: 'pass')

        expect(user.role).to eq('default')
        expect(user.default?).to be_truthy
      end
    end
  end
end
