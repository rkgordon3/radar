class MainController < ApplicationController
  def welcome
  	  @num_cars = Corvette.count
  end

  def result
  	  @year1 = params[:year1].to_i
  	  @year2 = params[:year2].to_i
  	  @body = params[:body]
  	  /*hello this is a comment/
  	  @selected_cars = Corvette.find(:all, :conditions => ["year >= ? and year <= ? and body_style = ?",
  	  	  @year1, @year2, @body])
  end

end
