module UrlHelper

	# Checks if the url provided is valid
	def is_valid?(url)
		URI.parse(url).host.present? rescue false
	end

	# Cleans the url to strip any protocol (http/https) and "www" if present
	def clean_url(url)
		url.match(/(https|http)?(:\/\/)?(www.)?(.*$)/)[4].to_s
	end
end