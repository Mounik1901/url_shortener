class UrlShortenersController < ApplicationController
  
  def index
  end

  def create
  	form_url = params[:url]
  	
  	if form_url.present? && ["http","https"].include?(URI.parse(form_url).scheme)
  		url_record = ShortenUrl.check_for_presence form_url
	  	if url_record
	  		render json: { short_url: "#{SHORT_DOMAIN}#{url_record.url_identifier}"}
	  	else
	  		identifier = ShortenUrl.generate_url_identifier
	  		shortned_url = ShortenUrl.create(url_identifier: identifier, original_url: form_url)
	  		render json: { short_url: "#{SHORT_DOMAIN}#{shortned_url.url_identifier}" }
	  	end
		else
			render :json => {:error_message => "Please provide valid URL" }, :status => :unprocessable_entity
		end	  
  end

  def redirect_to_original_url
    short_url = ShortenUrl.find_by(url_identifier: params[:identifier])
    if short_url.present?
      if short_url.expired?
        render "404"
      else
        short_url.update_analytics request
        redirect_to short_url.original_url
      end
    else
      flash[:notice] = "You have entered a bad link!"
      redirect_to root_path
    end
  end

  def stats
    @url_records = ShortenUrl.all
  end
end