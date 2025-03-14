# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration' do
  let(:user) { build(:user) }
  let!(:existing_user) { create(:user) }

  def fill_registration_form(email, password, password_confirmation)
    visit new_user_registration_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation

    click_link_or_button 'Sign up'
  end

  shared_examples 'stays on registration page' do
    it 'stays on the registration page', :js do
      expect(page).to have_current_path(new_user_registration_path, ignore_query: true)
    end
  end

  context 'when user submits valid data' do
    before { fill_registration_form(user.email, user.password, user.password) }

    it 'shows successful registration message' do
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    # Add when root page will exist
    # it 'redirects to the homepage' do
    #   expect(page).to have_current_path(root_path)
    # end
  end

  context 'when user submits empty fields' do
    before { fill_registration_form('', '', '') }

    include_examples 'stays on registration page'

    it 'shows an error message about blank email' do
      expect(page).to have_content "Email can't be blank"
    end

    it 'shows an error message about blank password' do
      expect(page).to have_content "Password can't be blank"
    end
  end

  context 'when user uses an already taken email' do
    before { fill_registration_form(existing_user.email, existing_user.password, existing_user.password) }

    include_examples 'stays on registration page'

    it 'shows email already taken message' do
      expect(page).to have_content 'Email has already been taken'
    end
  end

  context 'when user submits an invalid email' do
    before { fill_registration_form('invalid_email', user.password, user.password) }

    include_examples 'stays on registration page'

    it 'shows an error message about invalid email' do
      expect(page).to have_content 'Email is invalid'
    end
  end

  context 'when short password or wrong confirmation' do
    before { fill_registration_form(user.email, '123', user.password) }

    include_examples 'stays on registration page'

    it 'shows password confirmation mismatch message' do
      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    it 'shows minimum password length message' do
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
  end
end
