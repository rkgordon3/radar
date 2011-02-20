class SearchController < ApplicationController
  autocomplete :student, :first_name
  def search
  end

end
