ActiveAdmin.register Advertisement do
  form :partial => "form"

  controller do
    # POST /adbertisements
    # POST /adbertisements.xml
    def create
      @advertisement = Advertisement.new(params[:advertisement])
      coordinates = Geocoder.coordinates(@advertisement.location)
      @advertisement.latitude = coordinates[0]
      @advertisement.longitude = coordinates[1]

      @image = Image::AdvertisementImage.new(params[:image])

      respond_to do |format|
        if @advertisement.save
          @advertisement.images << @image
          flash[:notice] = 'Advertisement was successfully created.'
          format.html { redirect_to admin_advertisement_path(@advertisement) }
          format.xml  { render :xml => @advertisement, :status => :created, :location => @advertisement }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @advertisement.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /advertisements/1
    # PUT /advertisements/1.json
    def update
      @advertisement = Advertisement.find(params[:id])
      coordinates = Geocoder.coordinates(@advertisement.location)
      params[:advertisement][:latitude] = coordinates[0]
      params[:advertisement][:longitude] = coordinates[1]

      @image = Image::AdvertisementImage.new(params[:image]) if params[:image]

      respond_to do |format|
        if @advertisement.update_attributes(params[:advertisement])
          @advertisement.images << @image if @image
          format.html { redirect_to admin_advertisements_path, notice: t("activerecord.models.advertisement") + t("message.updated") }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @advertisement.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  index do
    column :id
    column :name
    column :youtube_videoid
    column :location
    column :latitude
    column :longitude
    column "image" do |advertisement|
      image_tag advertisement.images.last.image.url(:thumb) if advertisement.images.last
    end
    actions
  end

  show do |advertisement|
    attributes_table do
      row :id
      row :name
      row :youtube_videoid
      row :location
      row :latitude
      row :longitude
      row :image do
        image_tag(advertisement.images.last.image.url(:thumb))
      end
    end
    active_admin_comments
  end
end
