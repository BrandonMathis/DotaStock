class HeroesController < ApplicationController
  respond_to :html
  helper_method :heroes

  def index
    @matches = params[:matches] || 100
    respond_with heroes
  end

  private
  def heroes
    Hero.all#.sort!{ |x, y| y.usage(@matches).count <=> x.usage(@matches).count }
  end
end
