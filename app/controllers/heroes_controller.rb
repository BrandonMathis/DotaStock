class HeroesController < ApplicationController
  respond_to :html
  helper_method :heroes

  def index
    respond_with heroes
  end

  private
  def heroes
    Hero.all.sort!{ |x, y| y.player_ids.count <=> x.player_ids.count }
  end
end
