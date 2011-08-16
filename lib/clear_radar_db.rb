AccessLevel.all.each { |l|  l.destroy }

Area.all.each { |a|  a.destroy }

Building.all.each  { |b| b.destroy }

InterestedParty.all.each   {  | p | p.destroy }

Organization.all.each { | o | o.destroy }

RelationshipToReport.all.each  { |r| r.destroy }

ReportType.all.each  {|r| r.destroy }

Staff.all.each   { |s| s.destroy }
StaffArea.all.each  { |s| s.destroy }
StaffOrganization.all.each  { |s| s.destroy }

Task.all.each  {|t|  t.destroy }





