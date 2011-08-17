class NotesController < ReportsController
  load_and_authorize_resource
  
	def new
    @report = Note.new(:staff_id => current_staff.id)
    super
	end

  def index
    @report = @note
    super
  end

  def show
    @report = @note
    super
  end

  def edit
    @report = @note
    super
  end

  def update
    @report = @note
    super
  end

  def destroy
    @report = @note
    super
  end

end
