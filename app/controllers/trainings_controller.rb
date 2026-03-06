class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :destroy]

  def index
    @trainings = current_user.trainings.order(created_at: :desc)
  end

  def show
  end

  def destroy
    @training.destroy
    count = current_user.trainings.count
    label = "#{count} session#{count != 1 ? 's' : ''}"
    render turbo_stream: [
      turbo_stream.remove("training-card-#{@training.id}"),
      turbo_stream.update("training-count", label)
    ]
  end

  private

  def set_training
    @training = current_user.trainings.find(params[:id])
  end
end
