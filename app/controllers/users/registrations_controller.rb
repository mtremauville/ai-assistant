class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_update_path_for(resource)
    pages_profile_path
  end

  def update_resource(resource, params)
    email_unchanged = params[:email].blank? || params[:email] == resource.email
    password_unchanged = params[:password].blank?

    if email_unchanged && password_unchanged
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      super
    end
  end
end
