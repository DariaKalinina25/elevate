# frozen_string_literal: true

# Base controller for handling common application-wide concerns.
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    redirect_to root_path, alert: t('errors.not_found')
  end

  def respond_with_success(redirect_path)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to redirect_path }
    end
  end
end
