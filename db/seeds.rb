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

Student.create([{ :first_name => 'Chris', :last_name => 'Engesser', :home_phone => '555-666-7777', :cell_phone => '555-222-3333', :affiliation => 'SMU', :age => 21, :url => 'Chris.gif', :building_id => 8, :room_number => 421},
	{ :first_name => 'Joseph', :last_name => 'Faber', :home_phone => '555-555-5555', :cell_phone => '555-555-5556', :affiliation => 'SMU', :age => 23, :url => 'Joe.gif', :building_id => 15 , :room_number => 0 },
	{ :first_name => 'Emily Ann', :last_name => 'Friedl', :home_phone => '522-555-6377', :cell_phone => '533-555-3322', :affiliation => 'SMU', :age => 21, :url => 'Emily.gif', :building_id => 12, :room_number => 573},
	{ :first_name => 'Kelly', :last_name => 'John', :home_phone => '444-555-2252', :cell_phone => '666-555-2226', :affiliation => 'SMU', :age => 21, :url => 'John.gif', :building_id => 7, :room_number => 255},
	{ :first_name => 'Kujtkowska', :last_name => 'Justyna', :home_phone => 'n/a', :cell_phone => '652-555-2341', :affiliation => 'SMU', :age => 20, :url => 'Justyna.png', :building_id => 2, :room_number => 245},
	{ :first_name => 'Mitchell', :last_name => 'May', :home_phone => '653-555-3352', :cell_phone => '334-555-8824', :affiliation => 'SMU', :age => 20, :url => 'Mitchell.png', :building_id => 7, :room_number => 372},
	{ :first_name => 'Rebecca', :last_name => 'Sandager', :home_phone => '625-555-2623', :cell_phone => '734-555-6682', :affiliation => 'SMU', :age => 21, :url => 'Becca.gif', :building_id => 1, :room_number => 533},
	{ :first_name => 'Jeffrey', :last_name => 'Thomas', :home_phone => '552-555-6276', :cell_phone => '668-555-9837', :affiliation => 'SMU', :age => 20, :url => 'Jeff.png', :building_id => 5, :room_number => 346},
	{ :first_name => 'Stephanie', :last_name => 'Valentine', :home_phone => '555-555-6738', :cell_phone => '624-555-8362', :affiliation => 'SMU', :age => 21, :url => 'Stephanie.jpg', :building_id => 3, :room_number => 112},
	{ :first_name => 'Wildenborg', :last_name => 'Bradley', :home_phone => '507-555-7823', :cell_phone => '668-555-3234', :affiliation => 'SMU', :age => 20, :url => 'brad.jpeg', :building_id => 11, :room_number => 510}])

Participant.create([{ :first_name => 'Samantha', :last_name => 'Reynolds', :affiliation => 'Winona State', :age => 24},
	{ :first_name => 'Katelyn', :last_name => 'Barrachs', :affiliation => 'Winona Resident', :age => 20},
	{ :first_name => 'Keith', :last_name => 'Parce', :affiliation => 'University of Wisconsin At La Crosse', :age => 18},
	{ :first_name => 'Patricia', :last_name => 'Peterson', :affiliation => 'Winona State', :age => 21},
	{ :first_name => 'Carter', :last_name => 'Jacobey', :affiliation => 'Cotter High School', :age => 17}])



IncidentReport.create([{ :building_id => 5, :room_number => 332, :approach_time => '9:50 p.m.', :staff_id => 6, :annotation => 'This is a report. It will be pretty long. There were probably some interesting things that happened. Amanda handled them very well I am sure. She is a great RA. I believe that she will be a great teacher as well. She is an education major. I like her a lot. But there were probably people disrepsecting her. Or maybe the students were compliant. I have not decided yet. I have not made the reported infraction table yet, so I have not chosen whose wrongdoing caused this report. Is this long enough yet? I hope it is getting to be long enough. I am not sure how many more thoughts are going to come through my fingers to this screen...'},
	{ :building_id => 7, :room_number => 332, :approach_time => '9:50 p.m.', :staff_id => 5, :annotation => 'Pride and Prejudice is a novel by Jane Austen, first published in 1813. The story follows the main character Elizabeth Bennet as she deals with issues of manners, upbringing, morality, education and marriage in the society of the landed gentry of early 19th-century England. Elizabeth is the second of five daughters of a country gentleman, living near the fictional town of Meryton in Hertfordshire, near London.Though the story is set at the turn of the 19th century, it retains a fascination for modern readers, continuing near the top of lists of most loved books such as The Big Read. It has become one of the most popular novels in English literature, and receives considerable attention from literary scholars. Modern interest in the book has resulted in a number of dramatic adaptations and an abundance of novels and stories imitating Austens memorable characters or themes. To date, the book has sold some 20 million copies worldwide.'},
	{ :building_id => 5, :room_number => 533, :approach_time => '11:50 p.m.', :staff_id => 3, :annotation => 'The plot of the novel is driven by a particular situation of the Bennet family: The Longbourn estate where they reside is entailed to one of Mr Bennets collateral relatives - male only in this case - by the legal terms of fee tail. Having had no sons, this means that if Mr Bennet dies soon, his wife and five daughters will be left without home or income. Mrs Bennet worries about this predicament, and wishes to find husbands for her five daughters quickly. The father doesnt seem to be worried at all. The narrative opens with Mr Bingley, a wealthy young gentleman and a very eligible bachelor, renting a country estate near the Bennets called Netherfield. He arrives accompanied by his fashionable sisters and his good friend, Mr Darcy. Attending the local assembly (dance) Bingley is well received in the community, while Darcy begins his acquaintance with smug condescension and proud distaste for all the country locals. After Darcys haughty rejection of her at the dance, Elizabeth resolves to match his coldness and pride, his prejudice against country people, with her own prideful anger - in biting wit and sometimes sarcastic remarks - directed towards him. (Elizabeths disposition leads her into prejudices regarding Darcy and others, such that she is unable to sketch their characters accurately. Soon, Bingley and Elizabeths older sister Jane begin to grow close. Elizabeths best friend, Charlotte, advises that Jane should show her affection to Bingley more openly, as he may not realise that she is indeed interested in him. Elizabeth flippantly dismisses the opinion - replying that Jane is shy and modest, and that if Bingley cant see how she feels, he is a simpleton - and she doesnt tell Jane of Charlottes warning. Later Elizabeth begins a friendship with Mr Wickham, a militia officer who is of long personal acquaintance with Darcy - they grew up together. Wickham tells her he has been seriously mistreated by the proud man; Elizabeth seizes on this news as further reason to dislike Darcy. Ironically, Darcy begins to find himself drawn to Elizabeth, unbeknownst to her.'},
	{ :building_id => 12, :room_number => 222, :approach_time => '21:58 p.m.', :staff_id => 2, :annotation => 'Jane pays a visit to the Bingley mansion. On her journey to the house she is caught in a downpour and catches ill, forcing her to stay at Netherfield for several days. In order to tend to Jane, Elizabeth hikes through muddy fields and arrives with a spattered dress, much to the disdain of the snobbish Miss Bingley, Charles Bingleys sister. Miss Bingleys spite only increases when she notices that Darcy, whom she is pursuing, pays quite a bit of attention to Elizabeth. Mr Collins, the male relative who is to inherit Longbourn, makes an appearance and stays with the Bennets. Recently ordained a clergyman, he is employed as parish rector by the wealthy and patronising Lady Catherine de Bourgh of Kent. Mr Bennet and Elizabeth are amused by his self-important and pedantic behaviour. Though his stated reason for visiting is to reconcile with the Bennets, Collins soon confides to Mrs Bennet that he wishes to find a wife from among the Bennet sisters. He first offers to pursue Jane; however, Mrs Bennet mentions that her eldest daughter is soon likely to be engaged, and redirects his attentions to Elizabeth. At a ball given by Bingley at Netherfield, Elizabeth intends to deepen her acquaintance with Mr Wickham, who, however, fails to appear. She is asked to dance by Mr Darcy; here she raises Wickhams fate with him, causing their harmonious dance to fall into a testy discussion. The ball proceeds as spectacle: the arriviste Sir William Lucas shocks Darcy, alluding to Jane and Bingley and a certain desirable event; Mr. Collins behaves fatuously; now Mrs Bennet talks loudly and indiscreetly of her expectation of marriage between Jane and Bingley, and, in general, cousin Collins and the Bennet family - save Jane and Elizabeth - combine in a public display of poor manners and upbringing that clearly disgusts Darcy and embarrasses Elizabeth.'},
	{ :building_id => 9, :room_number => 784, :approach_time => '10:50 p.m.', :staff_id => 5, :annotation => 'The next morning, Mr Collins proposes marriage to Elizabeth, who refuses him, much to her mothers distress. Collins handily recovers and, within three days, proposes to Elizabeths close friend, Charlotte Lucas, who immediately accepts. Once marriage arrangements are settled, Charlotte persuades Elizabeth to come for an extended visit to her new bridal home. Though appearing at the point of proposing marriage to Jane, Mr Bingley abruptly quits Netherfield and returns to London, leaving the lady confused and upset. Elizabeth is convinced that Darcy and Bingleys sister have conspired to separate Jane and Bingley. In the spring, Elizabeth joins Charlotte and her cousin in Kent. The parsonage is adjacent to Rosings Park - the grand manor of Lady Catherine de Bourgh, Mr Darcys aunt - where Elizabeth and her hosts are frequently invited to socialize. After Mr Darcy and his cousin Colonel Fitzwilliam arrive to visit Lady Catherine, Elizabeth renews her project of teasing Darcy - while his admiration for her grows in spite of his intentions otherwise. Now Elizabeth learns from Fitzwilliam that Darcy prides himself on having separated Bingley from Jane; and, with the poorest of timing, Darcy chooses this moment to admit his love for Elizabeth, and he proposes to her. Incensed by his high-handed and insulting manner, she abruptly refuses him. When he asks why - so uncivil her reply - Elizabeth confronts him with his sabotage of Jane and Bingleys budding relationship and with Wickhams account of Darcys mistreatment of him, among other complaints.'},
	{ :building_id => 8, :room_number => 421, :approach_time => '9:12 p.m.', :staff_id => 3, :annotation => 'Deeply shaken by Elizabeths vehemence and accusations, Darcy writes her a letter which reveals the true history between Wickham and himself. Wickham had renounced his legacy - a clergymans living in Darcys patronage - for a cash payment; only to return after gambling away the money to again claim the position. After Darcy refused, Wickham attempted to elope with Darcys fifteen-year-old sister Georgiana, and thereby secure her part of the Darcy family fortune. He was found out and stopped only a day before the intended elopement. Regarding Bingley and Jane, Darcy justifies his interference: he had observed in Jane no reciprocal interest for Bingley; thus he aimed to separate them to protect his friend from heartache. In the letter Darcy admits his repugnance for the total want of propriety of her (Elizabeths) family, especially her mother and three younger sisters. After reading the letter, Elizabeth begins to question both her familys behaviour and Wickhams credibility. She also concludes: Wickham is not as trustworthy as his easy manners would indicate; that he had lied to her previously; and that her early impressions of Darcys character might not have been accurate. Soon, Elizabeth returns home.'},
	{ :building_id => 3, :room_number => 583, :approach_time => '9:48 p.m.', :staff_id => 8, :annotation => 'Some months later, during a northern tour, Elizabeth and her Aunt and Uncle Gardiner visit Pemberley, Darcys estate, while hes away. The elderly housekeeper has known Darcy since childhood, and presents a flattering and benevolent impression of his character to Elizabeth and the Gardiners. As they tour the grounds Darcy unexpectedly returns home. Though shocked - as is Elizabeth - he makes an obvious effort to be gracious and welcoming, and treats the Gardiners - whom before he would have dismissed as socially inferior - with remarkable politeness. Later he introduces Elizabeth to his sister, a high compliment to Elizabeth. Elizabeth is surprised and hopeful of a possible new beginning with Darcy.'},
	{ :building_id => 3, :room_number => 592, :approach_time => '2:50 a.m.', :staff_id => 5, :annotation => 'Elizabeth and Darcys renewed acquaintance is cut short by news that Lydia, her youngest (and most frivolous) sister, has run away with Wickham. Initially, the family (wishfully) believe they have eloped, but they soon learn that Wickham has no plans to marry Lydia. Lydias antics threaten her family - especially the remaining Bennet sisters - with social ruin. Elizabeth and her aunt and uncle hurriedly leave for home; Elizabeth is anguished, and convinced that Darcy will avoid her from now on. Soon, thanks apparently to Elizabeths uncle, Lydia and Wickham are found and married. Afterwards, they visit Longbourn; while bragging to Elizabeth, Lydia discloses that Darcy was present at the wedding. Surprised, Elizabeth sends an inquiry to her aunt, from whom she learns that Darcy himself was responsible for both finding the couple and arranging their marriage, at great expense to himself.'},
	{ :building_id => 1, :room_number => 639, :approach_time => '4:50 a.m.', :staff_id => 3, :annotation => 'Bingley returns to Longbourn and proposes marriage to Jane who immediately accepts. Now Lady Catherine surprisingly visits Longbourn. She sternly tells Elizabeth she has heard rumours of Darcy proposing to her; she came with determined resolution to confront Elizabeth and to demand that she never accept such a proposal because Darcy is supposed to marry her daughter. Elizabeth refuses to bow to Lady Catherines demands. Furious, Lady C charges off and tells Darcy of Elizabeths obstinacy - which convinces him that Elizabeths opinion of him may have changed. He now visits Longbourn, and once again proposes marriage. Elizabeth accepts, and the two become engaged.'},
	{ :building_id => 7, :room_number => 181, :approach_time => '12:50 a.m.', :staff_id => 5, :annotation => 'The novels final chapters establish the futures of the characters: Elizabeth and Darcy settle at Pemberley, where Mr Bennet visits often; Mrs Bennet remains frivolous and silly - she often visits the new Mrs Bingley and talks of the new Mrs Darcy; Jane and Bingley eventually move to locate near the Darcys in Derbyshire. Elizabeth and Jane teach Kitty who had always been badly influenced by Lydia better social graces, and Mary who had been the most reclusive learns to mix more with the outside world at Meryton. Lydia and Wickham continue a life of frivolity which keeps them from accumulating any wealth and leads them to have to move often, leaving debts for Jane and Elizabeth to pay. At Pemberley, Elizabeth and Georgiana grow close; Georgiana is surprised by Elizabeths playful treatment of Darcy, and she grows more comfortable with her brother. Lady Catherine holds out, indignant and abusive, over her nephews marriage, but eventually Darcy is prevailed upon to reconcile with her sufficiently that she condescends to visit. Elizabeth and Darcy remain close to her Uncle and Aunt Gardiner - the agents of their reconciling and uniting.'}])

ReportedInfraction.create([{ :infraction_id => 12, :participant_id => 5, :incident_report_id =>1 },
	{ :infraction_id => 13, :participant_id => 5, :incident_report_id =>1 },
	{ :infraction_id => 12, :participant_id => 6, :incident_report_id =>1 },
	{ :infraction_id => 13, :participant_id => 6, :incident_report_id =>1 },
	{ :infraction_id => 4, :participant_id => 10, :incident_report_id =>2 },
	{ :infraction_id => 4, :participant_id => 3, :incident_report_id =>2 },
	{ :infraction_id => 11, :participant_id => 3, :incident_report_id =>2 },
	{ :infraction_id => 4, :participant_id => 11, :incident_report_id =>2 },
	{ :infraction_id => 19, :participant_id => 2, :incident_report_id =>3 },
	{ :infraction_id => 19, :participant_id => 7, :incident_report_id =>3 },
	{ :infraction_id => 15, :participant_id => 1, :incident_report_id =>4 },
	{ :infraction_id => 11, :participant_id => 1, :incident_report_id =>4 },
	{ :infraction_id => 4, :participant_id => 1, :incident_report_id =>4 },
	{ :infraction_id => 4, :participant_id => 2, :incident_report_id =>4 },
	{ :infraction_id => 4, :participant_id => 3, :incident_report_id =>4 },
	{ :infraction_id => 4, :participant_id => 4, :incident_report_id =>4 },
	{ :infraction_id => 3, :participant_id => 5, :incident_report_id =>4 },
	{ :infraction_id => 3, :participant_id => 6, :incident_report_id =>4 },
	{ :infraction_id => 4, :participant_id => 7, :incident_report_id =>4 },
	{ :infraction_id => 3, :participant_id => 8, :incident_report_id =>4 },
	{ :infraction_id => 4, :participant_id => 9, :incident_report_id =>4 },
	{ :infraction_id => 3, :participant_id => 10, :incident_report_id =>4 },
	{ :infraction_id => 3, :participant_id => 14, :incident_report_id =>4 },
	{ :infraction_id => 14, :participant_id => 9, :incident_report_id =>5 },
	{ :infraction_id => 9, :participant_id => 4, :incident_report_id =>6 },
	{ :infraction_id => 9, :participant_id => 7, :incident_report_id =>6 },
	{ :infraction_id => 1, :participant_id => 4, :incident_report_id =>7 },
	{ :infraction_id => 1, :participant_id => 13, :incident_report_id =>7 },
	{ :infraction_id => 1, :participant_id => 7, :incident_report_id =>7 },
	{ :infraction_id => 17, :participant_id => 8, :incident_report_id =>8 },
	{ :infraction_id => 2, :participant_id => 6, :incident_report_id =>22 }])
	
	

