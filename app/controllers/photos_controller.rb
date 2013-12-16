class PhotosController < ApplicationController
  protect_from_forgery
  respond_to :js, :only => :create

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    # This path within filesystem to which uploaded
    # file will be copied. Server can not write to
    # assets directory
    directory = "public/staging"
    # grab the ActionDispath::Http:UploadedFile object
    file = params[:photo][:file]
    #
    orig_name = file.original_filename
    # This is "path" for image per image_tag and asset
    # naming policy
    @image="/staging/#{orig_name}"

    if request.post?
      path = File.join(directory, orig_name)
      # copy tmp file into public
      FileUtils.copy(file.tempfile.path, path)
    end

  end

  def upload
    directory = "public/staging"

    if request.post?
      name = params[:upload][:file].original_filename
      @path = File.join(directory, name)
      File.open(@path, "wb") { |f| f.write(params[:upload][:file].read) }
      # send_file path, :type => 'image/jpeg', :disposition => 'inline'
    end

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end


  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_params
      params[:photo]
    end
end