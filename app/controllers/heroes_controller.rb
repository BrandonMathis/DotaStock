class HeroesController < ApplicationController
  respond_to :html
  helper_method :heroes

  def index
    @matches = params[:matches] || 100
    @sort = params[:sort] || "DESC"
    @heros_json = heroes.map do |hero|
      {
        name:  hero.localized_name,
        usage: hero.matches.count,
      }
    end.to_json
    respond_with heroes
  end

  private
  def heroes
    Hero.all - Hero.where(hero_id: 0)
  end
end
