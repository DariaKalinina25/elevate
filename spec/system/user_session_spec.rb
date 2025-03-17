# spec/system/user_session_spec.rb

require 'rails_helper'

RSpec.describe 'User session' do
  let(:user) { create(:user) }

  def login_as_user(email, password)
    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password

    click_button 'Log in'
  end

  shared_examples 'remains on the login page' do
    it 'remains on the login page' do
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end
  end

  context 'when user submits valid data' do
    before { login_as_user(user.email, user.password) }

    it 'shows a message about successful login' do
      expect(page).to have_content 'Signed in successfully'
    end

    # it 'redirects to the homepage' do
    #   expect(page).to have_current_path(root_path)
    # end
  end

  context 'when email is empty' do
    before { login_as_user('', user.password) }

    include_examples 'remains on the login page'

    it 'shows invalid email or password error' do
      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  context 'when password is empty' do
    before { login_as_user(user.email, '') }

    include_examples 'remains on the login page'

    it 'shows invalid email or password error' do
      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  context 'when email does not exist in database' do
    before { login_as_user('invalid_email@example.com', user.password) }

    include_examples 'remains on the login page'

    it 'shows invalid email or password error' do
      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  context 'when the password is not correct' do
    before { login_as_user(user.email, 'invalid_password') }

    include_examples 'remains on the login page'

    it 'shows invalid email or password error' do
      expect(page).to have_content 'Invalid Email or password.'
    end
  end
end
