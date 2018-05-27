class ShortenedUrl
	include Cequel::Record
	extend UrlHelper
	key :id, :timeuuid, auto: true, partition: true
	column :url, :text, index: true
	column :short_url, :text, index: true
	column :original_url, :text, index: true

	# Generate a short url for a given original url
	def self.generate_short_url(url)
		short_url = ''
		if is_valid?(url)
			# Cleans the url to strip protocol (http/https) and "www" if present
 			cleaned_url = clean_url(url)
		  # Checks if any entry is already present for the original url
			shortened_url = ShortenedUrl.where(:url => cleaned_url).first
			if shortened_url.present?
				short_url = shortened_url.short_url
			else
				# Converts current time to Base62 using the chars (0-9, A-Z, a-z)
				short_url = Time.now.to_i.base62_encode
				ShortenedUrl.create(:url => cleaned_url, :original_url => url, :short_url => short_url)
			end
			valid = true
		else
			valid = false
		end
		{valid: valid, short_url: short_url}
	end
	
	# Get a list of URLs from Cassandra Model (with pagination)
	def self.get_urls(limit = 10, paging_state = nil)
		data = ShortenedUrl.select(:original_url, :url, :short_url).page_size(limit)
		if paging_state.present?
			# Decrypt paging state to query Cassandra
			decrypted_paging_state = $crypt.decrypt_and_verify(paging_state)
			if decrypted_paging_state.present?
				data = data.paging_state(decrypted_paging_state)
			end
		end
		
		if data.next_paging_state.present?
			paging_state = $crypt.encrypt_and_sign(data.next_paging_state)
		else
			paging_state = nil
		end
		[data.as_json, paging_state]
	end
end

