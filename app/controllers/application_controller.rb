class ApplicationController < ActionController::Base
  around_action :use_user_time_zone

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def use_user_time_zone(&action)
    requested_zone = cookies[:timezone]
    user_time_zone = requested_zone.present? ? Time.find_zone(requested_zone) : nil

    Time.use_zone(user_time_zone || Rails.application.config.time_zone, &action)
  end
end
