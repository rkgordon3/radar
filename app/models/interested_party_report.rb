class InterestedPartyReport < ActiveRecord::Base
  belongs_to    :report
  belongs_to    :interested_party
end
