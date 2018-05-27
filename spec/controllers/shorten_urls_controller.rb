require "rails_helper"
RSpec.describe ShortenUrlsController, :type => :controller do
	before(:each) do
		ShortenedUrl.destroy_all
	end
	describe "Create Short URL #create" do
		it "responds successfully with a short url and an HTTP 200 status code" do
			post :create, {shortened_url: {url: 'https://www.google.com'}}
			expect(response).to be_success
			expect(response).to have_http_status(200)
			parsed_body = JSON.parse(response.body)
			expect(parsed_body["short_url"]).to be_present
			expect(parsed_body["message"]).to eq('Success')
		end
		
		it "should not create a short url if the url provided is not valid" do
			post :create, {shortened_url: {url: 'https:/google.com'}}
			expect(response).to have_http_status(422)
			parsed_body = JSON.parse(response.body)
			expect(parsed_body["message"]).to eq('Invalid URL')
		end
		
		it "should not create a short url if the url is not provided" do
			post :create, {shortened_url: {}}
			expect(response).to have_http_status(422)
			parsed_body = JSON.parse(response.body)
			expect(parsed_body["message"]).to eq('Error')
		end
	end
	
	describe "Show Short URL #show" do
		it "should redirect to the original website if correct short_url is provided" do
			ShortenedUrl.create(:url => 'google.com', :short_url => 'test')
			get :show, slug: 'test'
			expect(response).to redirect_to('http://google.com')
		end
	end
end