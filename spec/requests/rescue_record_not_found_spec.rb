# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rescue from RecordNotFound' do
  let(:user) { create(:user) }

  context 'when user tries to access a non-existent note' do
    before do
      login_as(user)
      get note_path(-1)
    end

    it 'redirects to the root path' do
      expect(response).to redirect_to(root_path)
    end

    it 'shows a not found alert message' do
      follow_redirect!
      expect(response.body).to include(t('errors.not_found'))
    end
  end
end
