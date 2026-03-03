class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home temp]

  def home
  end

  def temp
  end
end
