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


# Create areas on campus
puts "creating areas on campus"
na = Area.find_by_name("Unspecified") || Area.create(:name=>'Unspecified', :abbreviation=>'NA')
skhe = Area.find_by_name("Skemp, Heffron") || Area.create(:name=>'Skemp, Heffron', :abbreviation=>'SKHE')
willages = Area.find_by_name("Watters, Ek Village") || Area.create(:name=>'Watters, Ek Village', :abbreviation=>'WILLAGES')
blrsm = Area.find_by_name("Brother Leopold, Residencia Santiago Miller") || Area.create(:name=>'Brother Leopold, Residencia Santiago Miller', :abbreviation=>'BLRSM')
higc = Area.find_by_name("Hillside, Gilmore Creek") || Area.create(:name=>'Hillside, Gilmore Creek', :abbreviation=>'HIGC')
bn = Area.find_by_name("Saint Benilde") || Area.create(:name=>'St. Benilde', :abbreviation=>'BN')
stjopi = Area.find_by_name("St. Josephs, Pines") || Area.create(:name=>'St. Josephs, The Pines', :abbreviation=>'STJOPI')
ls = Area.find_by_name("LaSalle") || Area.create(:name=>'LaSalle', :abbreviation=>'LS')
se = Area.find_by_name("St. Edwards") || Area.create(:name=>'St. Edwards', :abbreviation=>'SE')
sy = Area.find_by_name("Saint Yons Hall") || Area.create(:name=>'Saint Yons Hall', :abbreviation=>'SY')


# Create building
puts "creating buildings for specified areas"
Building.find_by_name("Unspecified") || Building.create(:name=>"Unspecified", :abbreviation=>"NA", :area_id => na.id)
Building.find_by_name("Off Campus") || Building.create(:name=>'Off Campus', :abbreviation=>'OFFCAM', :area_id=>na.id)
Building.find_by_name("Athletic Fields") || Building.create(:name=>'Athletic Fields', :abbreviation=>'ATHL', :area_id=>na.id)
Building.find_by_name("Jul Gernes Pool") || Building.create(:name=>'Jul Gernes Pool', :abbreviation=>'POOL', :area_id=>na.id)
Building.find_by_name("Gostomski Fieldhouse") || Building.create(:name=>'Gostomski Fieldhouse', :abbreviation=>'GF', :area_id=>na.id)
Building.find_by_name("Gym/Hall of Fame Room") || Building.create(:name=>'Gym/Hall of Fame Room', :abbreviation=>'GYM', :area_id=>na.id)
Building.find_by_name("Hendrickson Center") || Building.create(:name=>'Hendrickson Center', :abbreviation=>'HC', :area_id=>na.id)
Building.find_by_name("Ice Arena") || Building.create(:name=>'Ice Arena', :abbreviation=>'ICE', :area_id=>na.id)
Building.find_by_name("IHM Seminary") || Building.create(:name=>'IHM Seminary', :abbreviation=>'IHM', :area_id=>na.id)
Building.find_by_name("Fitzgerald Library") || Building.create(:name=>'Fitzgerald Library', :abbreviation=>'LIB', :area_id=>na.id)
Building.find_by_name("Pedestrian Overpass") || Building.create(:name=>'Pedestrian Overpass', :abbreviation=>'PED', :area_id=>na.id)
Building.find_by_name("Power Plan/Clock Tower") || Building.create(:name=>'Power Plant/Clock Tower', :abbreviation=>'PPL', :area_id=>na.id)
Building.find_by_name("Plaza") || Building.create(:name=>'Plaza', :abbreviation=>'PLZ', :area_id=>na.id)
Building.find_by_name("Performance Center") || Building.create(:name=>'Performance Center', :abbreviation=>'PC', :area_id=>na.id)
Building.find_by_name("RAC") || Building.create(:name=>'RAC', :abbreviation=>'RAC', :area_id=>na.id)
Building.find_by_name("Saint Marys Hall") || Building.create(:name=>'Saint Marys Hall', :abbreviation=>'SM', :area_id=>na.id)
Building.find_by_name("Saint Thomas More Chapel") || Building.create(:name=>'Saint Thomas More Chapel', :abbreviation=>'CHAP', :area_id=>na.id)
Building.find_by_name("St. Yons Valley/X-Country Trails") || Building.create(:name=>'St. Yons Valley/X-Country Trails', :abbreviation=>'XCT', :area_id=>na.id)
Building.find_by_name("Intramural Fields") || Building.create(:name=>'Intramural Fields', :abbreviation=>'INTF', :area_id=>na.id)
Building.find_by_name("Michael H. Toner Student Center") || Building.create(:name=>'Michael H. Toner Student Center', :abbreviation=>'TON', :area_id=>na.id)
Building.find_by_name("Skemp Hall") || Building.create(:name=>'Skemp Hall', :abbreviation=>'SK', :area_id=>skhe.id, :is_residence=>true)
Building.find_by_name("Heffron Hall") || Building.create(:name=>'Heffron Hall', :abbreviation=>'HE', :area_id=>skhe.id, :is_residence=>true)
Building.find_by_name("LaSalle Hall") || Building.create(:name=>'LaSalle Hall', :abbreviation=>'LS', :area_id=>ls.id, :is_residence=>true)
Building.find_by_name("St. Edwards Hall") || Building.create(:name=>'St. Edwards Hall', :abbreviation=>'SE', :area_id=>se.id, :is_residence=>true)
Building.find_by_name("Watters Hall") || Building.create(:name=>'Watters Hall', :abbreviation=>'WT', :area_id=>willages.id, :is_residence=>true)
Building.find_by_name("Ek Family Village") || Building.create(:name=>'Ek Family Village', :abbreviation=>'EV', :area_id=>willages.id, :is_residence=>true)
Building.find_by_name("Residencia Santiago Miller") || Building.create(:name=>'Residencia Santiago Miller', :abbreviation=>'RSM', :area_id=>blrsm.id, :is_residence=>true)
Building.find_by_name("Brother Leopold Hall") || Building.create(:name=>'Brother Leopold Hall', :abbreviation=>'BRO', :area_id=>blrsm.id, :is_residence=>true)
Building.find_by_name("Gilmore Creek Hall") || Building.create(:name=>'Gilmore Creek Hall', :abbreviation=>'GC', :area_id=>higc.id, :is_residence=>true)
Building.find_by_name("St. Benilde Hall") || Building.create(:name=>'St. Benilde Hall', :abbreviation=>'BN', :area_id=>bn.id, :is_residence=>true)
Building.find_by_name("St. Yons Hall") || Building.create(:name=>'St. Yons Hall', :abbreviation=>'SY', :area_id=>sy.id, :is_residence=>true)
Building.find_by_name("St. Josephs Hall") || Building.create(:name=>'St. Josephs Hall', :abbreviation=>'STJO', :area_id=>stjopi.id, :is_residence=>true)
Building.find_by_name("The Pines Hall") || Building.create(:name=>'The Pines Hall', :abbreviation=>'PI', :area_id=>stjopi.id, :is_residence=>true)
Building.find_by_name("Hillside Hall") || Building.create(:name=>'Hillside Hall', :abbreviation=>'HI', :area_id=>higc.id, :is_residence=>true)
Building.find_by_name("My Building Hall") || Building.create(:name=>'My Building', :abbreviation=>'MYB', :area_id=>na.id)
 