require 'httpclient/include_client'
class Photo  < ActiveRecord::Base.extend HTTPClient::IncludeClient
	# belongs_to				:report
  	attr_accessible :description, :g3_id, :id, :owner_id, :title

  	def self.upload(path, name)
      include_http_client
      
  		clnt = HTTPClient.new
  		uri = URI.parse("http://140.190.71.125/gallery3/index.php/rest/create/photo/#{name}")
  		File.open(path) do |file|
  			body = { 'upload' => file, 'user' => 'nahi' }
  			res = clnt.post(uri, body)
        puts '*****************'
        puts res.inspect
        puts '*****************'
		  end
		puts "*File Uploaded*"
    # index.php/rest/create/photo/image1
    # file <= multipart
  	end
end