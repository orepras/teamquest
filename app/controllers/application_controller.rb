class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_character

  def current_character
    Current.user&.character
  end

  private

  # Most pages need a character sheet to exist first.
  def require_character
    redirect_to new_my_character_path unless current_character
  end
end
