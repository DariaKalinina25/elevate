# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET #index' do
    it 'returns a response (200 OK)' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
