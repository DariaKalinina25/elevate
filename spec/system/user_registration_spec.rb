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

    # Uncomment when root page is ready
    # it 'redirects to the homepage' do
    #   expect(page).to have_current_path(root_path)
    # end
  end

  context 'when email is empty' do
    before { fill_registration_form('', user.password, user.password) }

    include_examples 'stays on registration page'

    it 'shows email blank error' do
      expect(page).to have_content "Email can't be blank"
    end
  end

  context 'when password is empty' do
    before { fill_registration_form(user.email, '', '') }

    include_examples 'stays on registration page'

    it 'shows password blank error' do
      expect(page).to have_content "Password can't be blank"
    end
  end

  context 'when email is already taken' do
    before { fill_registration_form(existing_user.email, existing_user.password, existing_user.password) }

    include_examples 'stays on registration page'

    it 'shows email already taken message' do
      expect(page).to have_content 'Email has already been taken'
    end
  end

  context 'when email is invalid' do
    before { fill_registration_form('invalid_email', user.password, user.password) }

    include_examples 'stays on registration page'

    it 'shows email invalid error' do
      expect(page).to have_content 'Email is invalid'
    end
  end

  context 'when password confirmation does not match' do
    before { fill_registration_form(user.email, user.password, 'invalid_confirmation') }

    include_examples 'stays on registration page'

    it 'shows password confirmation mismatch error' do
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  context 'when password is too short' do
    before { fill_registration_form(user.email, 'short', 'short') }

    include_examples 'stays on registration page'

    it 'shows password too short error' do
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
  end
end
