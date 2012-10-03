class HeroesController < ApplicationController
  respond_to :html
  helper_method :heroes

  def index
    @matches = params[:matches] || 100
    @heros_json = heroes.map do |hero|
      {
        "name" => hero.name,
        "usage" => hero.usage(params[:matches]).count
      }
    end.to_json
    respond_with heroes
  end

  private
  def heroes
    Hero.all
  end
end
