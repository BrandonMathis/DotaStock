class HeroesController < ApplicationController
  respond_to :html
  helper_method :heroes

  def index
    respond_with heroes
  end

  private
  def heroes
    Hero.all
  end
end
