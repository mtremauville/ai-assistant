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
    c = content.downcase
    if c.match?(/how (much|long)|how many (minutes|hours)|duration|heure|minute|combien de temps|quelle dur|temps (as|avez|avez-vous|disponible)|time (do you have|available)|long (is|will)/)
      ["45 min", "1h", "1h30", "2h"]
    elsif c.match?(/how many (player|people|person|are|will)|many (people|player|person)|player|joueur|personnes|format|solo|duo|2v2|avec combien|vous (êtes|serez)|training (with|partner|alone)|seul|combien (sont|de joueur|de personne)/)
      ["Solo", "2 joueurs", "4 joueurs"]
    elsif c.match?(/focus|work on|travailler|objectif|priorité|today|aujourd.hui|goal|improve|améliorer|want to (work|focus|train)|what.*(do|would).*(you|we).*(want|like)|quoi travailler/)
      ["Technique", "Physique", "Tactique", "Matchplay"]
    elsif c.match?(/equipment|matériel|have access|accès|panier|ball machine|filets|target|what.*(equipment|gear|material)/)
      ["Terrain standard", "Balles seulement", "Tout le matériel"]
    elsif c.match?(/level|niveau|experience|expérience|beginner|intermédiaire|compétiteur|classement|rank/)
      ["Débutant", "Intermédiaire", "Compétiteur"]
    elsif c.match?(/intensity|intensité|scale|échelle|1 to 10|1 à 10|effort/)
      ["6/10", "7/10", "8/10", "9/10"]
    else
      []
    end
  end
end
