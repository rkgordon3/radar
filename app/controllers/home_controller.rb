class HomeController < ApplicationController
  def landingpage
  @reports = Report.all
  end

end
