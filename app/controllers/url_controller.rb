class UrlController < ApplicationController

  def create
    @comparison = Url.create!(params[:url])
    # Alert = "Got it!"
  end

end
