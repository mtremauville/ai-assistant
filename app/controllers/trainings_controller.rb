class TrainingsController < ApplicationController
  before_action :set_training, only: :show

  def index
    @trainings = current_user.trainings.order(created_at: :desc)
  end

  def show
  end

  private

  def set_training
    @training = current_user.trainings.find(params[:id])
  end
end
