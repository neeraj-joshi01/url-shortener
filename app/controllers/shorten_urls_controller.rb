class ShortenUrlsController < ApplicationController
	
	# Show the paginated list of Shortened URLs
	def index
		limit = params[:limit].present? ? params[:limit].to_i : 10
		@shortened_urls, @next_paging_state = ShortenedUrl.get_urls(limit, params[:next_paging_state])
		@show_next_page_button = @next_paging_state.present?
	end
	
	# Add a new Shortened URL
	def new
		@shortened_url = ShortenedUrl.new
		@url = shorten_urls_path
	end
	
	# Create the Shortened URL
	# Checks if the url is valid and responds with the appropriate status code and data
	def create
		@short_url = ''
		if shortened_url_params[:url].present?
			response = ShortenedUrl.generate_short_url(shortened_url_params[:url])
			if response[:valid]
				@short_url = response[:short_url]
				@message = 'Success'
				status = 200
			else
				@message = 'Invalid URL'
				status = 422
			end
		else
			@message = 'Error'
			status = 422
		end
		respond_to do |format|
			format.html  { render :json => {short_url: @short_url, message: @message}, status: status }
			format.json  { render :json => {short_url: @short_url, message: @message}, status: status }
			format.js
		end
	end
	
	# Redirect to the original url for any shortened url
	def show
		if params[:slug].present?
			record = ShortenedUrl.where(:short_url => params[:slug]).first
			if record.present?
				redirect_to "http://#{record.url}"
			end
		else
			render :json => {success: 0, message: 'Error'}, status: 422
		end
	end
	
	# Upload CSV of URLs to Shorten
	def upload_csv
		@shortened_url = ShortenedUrl.new
		@url = parse_csv_shorten_urls_path
	end
	
	# Parse CSV and Shorten each of the URL given in the CSV
	def parse_csv
		begin
			if params[:shortened_url][:csv_file].present?
				@shortened_urls = []
				CSV.parse(params[:shortened_url][:csv_file].read, :headers => true).each do |row|
					response = ShortenedUrl.generate_short_url(row['URL'])
					@shortened_urls << {original_url: row['URL'], short_url: response[:short_url]}
				end
				respond_to do |format|
					format.html {render 'csv_data.html.erb'}
				end
			else
				redirect_to upload_csv_shorten_urls_path
			end
		rescue
			redirect_to :back
		end
	end
	
	private
	
	def shortened_url_params
		params[:shortened_url].permit(:url)
	end
end