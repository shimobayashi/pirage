atom_feed(:language => 'ja-JP') do |feed|
  feed.title(params[:tags] ? "Pirage - \"#{params[:tags]}\"" : "Pirage")
  feed.updated((@images.first.created_at)) if @images.first

  @images.each do |image|
    options = (image.url and image.url != '') ? {:url => image.url} : {}
    feed.entry(image, options) do |item|
      item.title("#{image.artist} - #{image.title}")
      content = "<p>#{image.tags}</p>"
      content += link_to(image_tag((request.protocol + request.host_with_port) + image.image_url), image.url) if image.image?
      item.content(content, :type => 'html')
      item.author do |author|
        author.name(image.artist)
      end
    end
  end
end

