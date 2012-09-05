class ImagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :serve, :create]
  before_filter :authentication_required, :only => [:serve]
  before_filter :whitelist, :only => [:create]
  protect_from_forgery :except => [:create]

  def authentication_required
    render(:text => 'access denied', :status => :unauthorized) unless user_signed_in?
  end

  # GET /images
  # GET /images.json
  def index
    @tags = params[:tags] ? params[:tags].split(Image.tags_separator) : nil

    if @tags
      include_tags = @tags.reject {|t| t[0] == '-'}
      exclude_tags = @tags.select {|t| t[0] == '-'}
      exclude_tags.map! {|t| t[1..-1]}

      @images = Image.recent.tagged_with_all(include_tags)
      @images.reject! {|i| (i.tags_array & exclude_tags).size > 0}
    else
      @images = Image.recent
    end

    @images = Kaminari.paginate_array(@images).page(params[:page]).per(200)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @images }
      format.atom
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        Image.asc(:created_at).first.delete if Image.count > 1000

        format.html { redirect_to @image, :notice => 'Image was successfully created.' }
        format.json { render :json => @image, :status => :created, :location => @image }
      else
        format.html { render :action => "new" }
        format.json { render :json => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, :notice => 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  def serve
    gridfs_path = env["PATH_INFO"].gsub("/images/", "")
    begin
      gridfs_file = Mongo::GridFileSystem.new(Mongoid.database).open(gridfs_path, 'r')
      self.response_body = gridfs_file.read
      self.content_type = gridfs_file.content_type
    rescue
      self.status = :file_not_fount
      self.content_type = 'text/plain'
      self.response_body = ''
    end
  end
end
