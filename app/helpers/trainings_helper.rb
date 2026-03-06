module TrainingsHelper
  BANNER_IMAGES = %w[banner1.jpg banner2.jpg banner3.jpg banner4.jpg banner5.jpg].freeze

  def training_banner(training)
    BANNER_IMAGES[training.id % BANNER_IMAGES.length]
  end
end
