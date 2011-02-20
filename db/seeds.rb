# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Area.create([{ :name => 'Skemp, Heffron, La Salle', :abbreviation => 'SKHELS'}, 
	{ :name => 'St. Edwards, Vlazny', :abbreviation => 'VLEDS'}, 
	{ :name => 'Watters, Ek Village, New Village', :abbreviation => 'Willages'}, 
	{ :name => 'Gilmore Creek, Benilde, St. Yons', :abbreviation => 'GCBY'}, 
	{ :name => 'St. Josephs, Pines, Hillside', :abbreviation => 'JPH'}])

Building.create([{ :name => 'Skemp Hall', :area_id => 1, :abbreviation => 'SK'}, 
	{ :name => 'Heffron Hall', :area_id => 1, :abbreviation => 'HE'},
	{ :name => 'La Salle Hall', :area_id => 1, :abbreviation => 'LS'},
	{ :name => 'St. Edward Hall', :area_id => 2, :abbreviation => 'SE'},
	{ :name => 'Vlazny Hall', :area_id => 2, :abbreviation => 'VL'},
	{ :name => 'Watters Hall', :area_id => 3, :abbreviation => 'WT'},
	{ :name => 'Ek Village', :area_id => 3, :abbreviation => 'EV'},
	{ :name => 'New Village', :area_id => 3, :abbreviation => 'NV'},
	{ :name => 'Gilmore Creek Hall', :area_id => 4, :abbreviation => 'GC'},
	{ :name => 'St. Benilde Hall', :area_id => 4, :abbreviation => 'SB'},
	{ :name => 'St. Yons Hall', :area_id => 4, :abbreviation => 'SY'},
	{ :name => 'St. Joseph Hall', :area_id => 5, :abbreviation => 'SJ'},
	{ :name => 'The Pines Hall', :area_id => 5, :abbreviation => 'PI'},
	{ :name => 'Hillside Hall', :area_id => 5, :abbreviation => 'HI'},
	{ :name => 'Off Campus', :area_id => 0, :abbreviation => 'OC'}])
	
Infraction.create([{ :description => 'Community Disruption'},
	{ :description => 'Smoking'},
	{ :description => 'Alcohol (Underage)'},
	{ :description => 'Alcohol (Of Age)'},
	{ :description => 'Intoxication'},
	{ :description => 'Paraphernalia (Alcohol)'},
	{ :description => 'Fire Safety'},
	{ :description => 'Vandalism'},
	{ :description => 'Privacy Hours'},
	{ :description => 'Non-Compliance'},
	{ :description => 'Hosted Large Party'},
	{ :description => 'Drugs'},
	{ :description => 'Paraphernalia (Drugs)'},
	{ :description => 'Mental Health Concern'},
	{ :description => 'Hosting of Minors'},
	{ :description => 'Binge Drinking Situation/Drinking Games'},
	{ :description => 'Weapon'},
	{ :description => 'Public Urination'},
	{ :description => 'Physical Fight/Assault'},
	{ :description => 'Threats/Harrassment'},
	{ :description => 'Other'},
	{ :description => 'FYI'}])

Student.create([{ :first_name => 'Chris', :last_name => 'Engesser', :home_phone => '555-666-7777', :cell_phone => '555-222-3333', :affiliation => 'SMU', :age => 21, :photo_id => 1, :building_id => 8, :room_number => 421},
	{ :first_name => 'Joseph', :last_name => 'Faber', :home_phone => '555-555-5555', :cell_phone => '555-555-5556', :affiliation => 'SMU', :age => 23, :photo_id => 2, :building_id => 15 , :room_number => 0 },
	{ :first_name => 'Emily', :last_name => 'Friedl', :home_phone => '522-555-6377', :cell_phone => '533-555-3322', :affiliation => 'SMU', :age => 21, :photo_id => 3, :building_id => 12, :room_number => 573},
	{ :first_name => 'Kelly', :last_name => 'John', :home_phone => '444-555-2252', :cell_phone => '666-555-2226', :affiliation => 'SMU', :age => 21, :photo_id => 4, :building_id => 7, :room_number => 255},
	{ :first_name => 'Kujtkowska', :last_name => 'Justyna', :home_phone => 'n/a', :cell_phone => '652-555-2341', :affiliation => 'SMU', :age => 20, :photo_id => 5, :building_id => 2, :room_number => 245},
	{ :first_name => 'Mitchell', :last_name => 'May', :home_phone => '653-555-3352', :cell_phone => '334-555-8824', :affiliation => 'SMU', :age => 20, :photo_id => 6, :building_id => 7, :room_number => 372},
	{ :first_name => 'Rebecca', :last_name => 'Sandager', :home_phone => '625-555-2623', :cell_phone => '734-555-6682', :affiliation => 'SMU', :age => 21, :photo_id => 7, :building_id => 1, :room_number => 533},
	{ :first_name => 'Jeffrey', :last_name => 'Thomas', :home_phone => '552-555-6276', :cell_phone => '668-555-9837', :affiliation => 'SMU', :age => 20, :photo_id => 8, :building_id => 5, :room_number => 346},
	{ :first_name => 'Stephanie', :last_name => 'Valentine', :home_phone => '555-555-6738', :cell_phone => '624-555-8362', :affiliation => 'SMU', :age => 21, :photo_id => 9, :building_id => 3, :room_number => 112},
	{ :first_name => 'Wildenborg', :last_name => 'Bradley', :home_phone => '507-555-7823', :cell_phone => '668-555-3234', :affiliation => 'SMU', :age => 20, :photo_id => 10, :building_id => 11, :room_number => 510}])

Participant.create([{ :first_name => 'Samantha', :last_name => 'Reynolds', :affiliation => 'Winona State', :age => 24},
	{ :first_name => 'Katelyn', :last_name => 'Barrachs', :affiliation => 'Winona Resident', :age => 20},
	{ :first_name => 'Keith', :last_name => 'Parce', :affiliation => 'University of Wisconsin At La Crosse', :age => 18},
	{ :first_name => 'Patricia', :last_name => 'Peterson', :affiliation => 'Winona State', :age => 21},
	{ :first_name => 'Carter', :last_name => 'Jacobey', :affiliation => 'Cotter High School', :age => 17}])

Photo.create([{ :url => '1.jpg'},
	{ :url => '2.jpg'},
	{ :url => '3.jpg'},
	{ :url => '4.jpg'},
	{ :url => '5.jpg'},
	{ :url => '6.jpg'},
	{ :url => '7.jpg'},
	{ :url => '8.jpg'},
	{ :url => '9.jpg'},
	{ :url => '10.jpg'}])

Staff.create([{ :first_name => 'Stephanie', :last_name => 'Valentine', :user_name => 'svalentine', :password => 'svalentine', :role => 'RA'},
	{ :first_name => 'Michelle', :last_name => 'Gossen', :user_name => 'mgossen', :password => 'mgossen', :role => 'RA'},
	{ :first_name => 'Samantha', :last_name => 'Herbst', :user_name => 'sherbst', :password => 'sherbst', :role => 'RA'},
	{ :first_name => 'Dongyang', :last_name => 'Xie', :user_name => 'dxie', :password => 'dxie', :role => 'RA'},
	{ :first_name => 'Catherine', :last_name => 'Rennie', :user_name => 'crennie', :password => 'crennie', :role => 'RA'},
	{ :first_name => 'Amanda', :last_name => 'VanLeeuwe', :user_name => 'avanleeuwe', :password => 'avanleeuwe', :role => 'RA'},
	{ :first_name => 'Jenny', :last_name => 'Schmidt', :user_name => 'jschmidt', :password => 'password', :role => 'Admin'},
	{ :first_name => 'Brendan', :last_name => 'Dolan', :user_name => 'bdolan', :password => 'password', :role => 'Admin'},
	{ :first_name => 'Stephen', :last_name => 'Craig', :user_name => 'scraig', :password => 'password', :role => 'Admin'}])


IncidentReport.create([{ :building_id => 5, :room_number => 332, :approach_time => '9:50 p.m.', :staff_id => 6, :annotation => 'This is a report. It will be pretty long. There were probably some interesting things that happened. Amanda handled them very well I am sure. She is a great RA. I believe that she will be a great teacher as well. She is an education major. I like her a lot. But there were probably people disrepsecting her. Or maybe the students were compliant. I have not decided yet. I have not made the reported infraction table yet, so I have not chosen whose wrongdoing caused this report. Is this long enough yet? I hope it is getting to be long enough. I am not sure how many more thoughts are going to come through my fingers to this screen...'}])








