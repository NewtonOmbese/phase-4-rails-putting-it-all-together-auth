class RecipesController < ApplicationController

  before_action :authorize

    def index
      user = User.find_by(id: session[:user_id])
      recipes = Recipe.all
      render json: recipes, status: :created
    end

    def create
      user = User.find_by(id: session[:user_id])
        if user
          recipe = user.recipes.new(recipe_params)
          if recipe.valid?
            recipe.save!
            render json: recipe, status: :created
          else
            render json: {errors: recipe.errors.full_messages} , status: :unprocessable_entity
          end
        else
          render json: { errors:["You must be logged in to access this content"]}, status: :unauthorized
        end
    end

    private
    def recipe_params
      params.permit(:id, :title, :instructions, :minutes_to_complete)
    end
    def authorize
      return render json: {errors: ["Not authorized"]}, status: :unauthorized unless session.include? :user_id
    end

end
