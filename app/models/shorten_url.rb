class ShortenUrl < ApplicationRecord

	def self.generate_url_identifier
		character_set = [('a'..'z'),('A'..'Z'),(0..9)].map{|value| value.to_a}.flatten
		new_url_identifier = (0..5).map{ character_set[rand(character_set.length)] }.join
		self.generate_url_identifier if ShortenUrl.find_by(url_identifier: new_url_identifier).present?
		new_url_identifier
	end

	def self.check_for_presence url
		ShortenUrl.find_by(original_url: url)
	end

	def expired?
		(Date.today - self.created_at.to_date) > EXPIRY_DURATION_IN_DAYS
	end

	def update_analytics request
		if self.ips.nil?
			self.ips = request.remote_ip
		else
			self.ips << ",#{request.remote_ip}"
		end
		results = Geocoder.search(request.remote_ip)
		if self.countries.nil?
			self.countries = results.first.country
		else
			self.countries << ",#{results.first.country}"
		end
		self.clicks += 1
		self.save
	end
end
