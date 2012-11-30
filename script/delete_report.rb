$LOAD_PATH << "."

require File.join(File.dirname(__FILE__), "..", "config", "boot")
require File.join(File.dirname(__FILE__), "..", "config", "environment")

for i in 0...ARGV.length
     tag = ARGV[i].split("-")
     id = tag.pop
     tag = tag[0] + "-"
     report = Report.find(:all, :conditions => {:tag => tag, :id => id})
     if report[0] != nil
          report[0].destroy 
     end
end
