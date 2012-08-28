class Image
  include Mongoid::Document
  include Mongoid::Taggable
  include Mongoid::Timestamps

  tags_separator ' '

  field :artist, :type => String
  field :title, :type => String
  field :url, :type => String
  mount_uploader :image, ImageUploader

  scope :recent, desc(:created_at)
end
