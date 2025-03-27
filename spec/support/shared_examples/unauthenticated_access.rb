# frozen_string_literal: true

RSpec.shared_examples 'denies access to unauthenticated user' do |path|
  before { visit path }

  it 'redirects unauthenticated user to login' do
    expect(page).to have_current_path(new_user_session_path, ignore_query: true)
  end

  it 'shows a flash alert for unauthenticated user' do
    expect(page).to have_css('.custom-alert', text: I18n.t('devise.failure.unauthenticated'))
  end
end
