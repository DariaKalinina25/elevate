# frozen_string_literal: true

module SystemHelpers
  def login_as(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end

  def find_test(id, **options)
    find("[data-testid='#{id}']", **options)
  end
end
