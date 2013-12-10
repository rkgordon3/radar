

load "#{Rails.root}/db/seeds_helper.rb"

include SeedsHelper

puts "creating ASC Organization"
asc = Organization.find_by_display_name("Academic Skills Center") ||
       AcademicSkillsCenterOrganization.create(
                                       :display_name => "Academic Skills Center",
                                       :abbreviation => "ASC")


puts "Creating 'other' reason for ASC"
other = RelationshipToReport.find_by_description_and_organization_id("Other", asc.id) ||
        RelationshipToReport.create(:description=>"Other", :organization_id=>asc.id)


puts "creating ResLife Organization"
rl = Organization.find_by_display_name("Residence Life") ||
       ResidenceLifeOrganization.create(
                                       :display_name => "Residence Life",
                                       :abbreviation => "RL")

rl.type ||= "ResidenceLifeOrganization"
rl.save


fyi = RelationshipToReport.find_by_description_and_organization_id("FYI", rl.id) ||
        RelationshipToReport.create(:description=>"FYI", :organization_id=>rl.id)

 

create_asc_reports(asc, other)
create_rl_reports(rl, fyi)












