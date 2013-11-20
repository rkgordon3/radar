class Photo < ActiveRecord::Base
	# belongs_to				:report
  	attr_accessible :description, :g3_id, :id, :owner_id, :title

  	def self.upload(path)
  		clnt = HTTPClient.new
  		uri = "http://140.190.71.125/gallery3/"
  		File.open(path) do |file|
        puts file
  			body = { 'upload' => file, 'user' => 'nahi' }
  			res = clnt.post(uri, body, { 'Content-Type' => 'image/jpeg'})
		  end
		puts "*File Uploaded*"
  	end
end