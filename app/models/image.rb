class Image
  include Mongoid::Document
  include Mongoid::Taggable

  tags_separator ' '

  field :artist, :type => String
  field :title, :type => String
  field :url, :type => String
  mount_uploader :image, ImageUploader
end
