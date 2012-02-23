class TutorStudyTableReportsController < TutorReportsController

  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource

end
