class NotesController < ReportsController
  load_and_authorize_resource
  
  def new
    @report = Note.new(:staff_id => current_staff.id)
    super
  end
end
