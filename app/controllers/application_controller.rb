class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[padel_level age weight height hand_position gender username avatar_url])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[padel_level age weight height hand_position gender username avatar_url])
  end

  private

  def generate_chips(content)
    # Only analyse the question sentences to avoid false matches from echoed answers
    # e.g. "Got it, 2 players. Now what's the focus?" — ignore "2 players" part
    questions = content.scan(/[^.!\n]*\?/).join(" ")
    c = (questions.presence || content).downcase

    if c.match?(/how (much|long) (time|do)|how many (minutes|hours)|duration|heure|minute|combien de temps|quelle dur|temps (as|avez|avez-vous|disponible)|time (do you have|available)/)
      ["45 min", "1h", "1h30", "2h"]
    elsif c.match?(/\blevel\b|\bniveau\b|beginner|intermediate|competitive|compétiteur|intermédiaire|classement|\brank\b|expérience/)
      ["Beginner", "Intermediate", "Competitive"]
    elsif c.match?(/how many (player|people|person|are|will)|\bplayers?\b|\bjoueurs?\b|\bpersonnes?\b|\bformat\b|\bsolo\b|\bduo\b|\b2v2\b|avec combien|training (with|partner|alone)|\bseul\b|combien (sont|de joueur|de personne)/)
      ["Solo", "2 players", "4 players"]
    elsif c.match?(/equipment|matériel|have access (to|aux)|accès (aux|à)|cones?|targets?|panier|ball machine|filets|specific tools?|gear/)
      ["Standard field", "Balles + cones", "Balls basket"]
    elsif c.match?(/intensity|intensité|scale|échelle|1 to 10|1 à 10|\bscale\b.*10/)
      ["6/10", "7/10", "8/10", "9/10"]
    elsif c.match?(/bandeja|vollée|smash|vibora|fond de court|\bfocus\b|work on|travailler sur|objectif|aspect|skill|quoi travailler|what.*(work on|focus on|\btrain\b)/)
      ["Bandeja", "Volleys", "Smash / Vibora", "Physic"]
    else
      []
    end
  end
end
