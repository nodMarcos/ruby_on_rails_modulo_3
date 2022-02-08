class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Curso de Ruby on Rails - Jackson Pires [COOKIE]"
    session[:curso] = "Marquin Dj [SESSION]"
    @nome = params[:nome]
    @curso = params[:curso]
  end
end
