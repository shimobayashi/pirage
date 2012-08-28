CarrierWave.configure do |config|
  config.storage = :grid_fs
  config.grid_fs_connection = Mongoid.database
  config.grid_fs_access_url = "/images"
end

module CarrierWave
  module RMagick
    def quality(percentage)
      manipulate! do |img|
        img.write(current_path) {self.quality = percentage} if img.quality > percentage
        img = yield(img) if block_given?
        img
      end
    end
  end
end
