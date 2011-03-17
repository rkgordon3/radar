class TempIncidentController < ApplicationController



def index

    @buildings = Building.all
    respond_to do |format|
      format.html { render :layout => false}
      format.xml  { render :xml => @buildings }
      #format.iphone # index.iphone.erb
    end


  end



end
