#!/bin/env ruby
# encoding: utf-8

class Page

	def initialize data

		@search = data["search"].force_encoding("UTF-8")
		@ingredients = {}
	    data["ingredients"].each do |name,content|
			@ingredients[name] = Ingredient.new(name,content)
		end
		@recipes = {}
	    data["recipes"].each do |name,content|
			@recipes[name] = Recipe.new(name,content)
		end
	    @custom = data["custom"]

	end

	def query
		
		return @search

	end

	def title

		return @search
	end

	def recipes

		return @recipes

	end

	def ingredients

		return @ingredients

	end

	def customs

		return @customs

	end

	def blog

		return @blog

	end

	def timeline

		array = []
		@recipes.sort.reverse.each do |name,recipe|
			array.push(recipe)
		end
		return array

	end

	# Recipe

	def isRecipe

		@recipes.each do |name,recipe|
			if name.like(@search) then return recipe end
		end
		return nil

	end

	def isIngredient

		@ingredients.each do |name,ingredient|
			if name.like(@search) then return ingredient end
		end
		return nil

	end

	def isColor

		@ingredients.each do |name,ingredient|
			if ingredient.color.value.downcase == @search.downcase then return ingredient.color end
		end
		return false

	end

	def isTag

		@recipes.each do |name,recipe|
			if recipe.hasTag(@search) == true then return @search end
		end
		return nil

	end

	def isTimeline

		return ($page.query.to_i > 0) ? true : nil

	end

	def isHome

		puts 

		return $page.query.like("home") ? true : nil

	end

	def isIngredientList

		return $page.query.like("ingredients") ? true : nil

	end

	def isCustom

		return @custom[$page.query.upcase] ? true : false

	end

	def content_custom

		return "<p>"+@custom[$page.query.upcase]["BREF"]+"</p>"+@custom[$page.query.upcase]["LONG"].parse2

	end

	def ingredientWithName nameTarget

		@ingredients.each do |name,ingredient|
			if ingredient.name.downcase == nameTarget.downcase then return ingredient end
		end
		return nil

	end

	def ingredientsWithColor colorTarget

		array = []
		@ingredients.each do |name,ingredient|
			if ingredient.color.value.downcase == colorTarget.value.downcase then return array.push(ingredient) end
		end
		return array

	end

	def recipesWithIngredient ingredientTarget

		array = []
		@recipes.each do |name,recipe|
			if !recipe.hasIngredient(ingredientTarget) then next end
			array.push(recipe)
		end
		return array.reverse

	end

	def recipesWithTag tagTarget

		array = []
		@recipes.each do |name,recipe|
			if !recipe.hasTag(tagTarget) then next end
			array.push(recipe)
		end
		return array.reverse

	end

	def recipesWithColor colorTarget

		array = []
		@recipes.each do |name,recipe|
			if !recipe.hasColor(colorTarget) then next end
			array.push(recipe)
		end
		return array.reverse

	end

	def recipeWithName target

		@recipes.each do |name,recipe|
			if !target.downcase.include?(name.downcase) then next end
			return recipe
		end
		return nil

	end

	def similarRecipesToName name

		keywords = {}

		currentRecipe = recipeWithName(query)

	    currentRecipe.title.split(" ").each do |word|
	    	keywords[word] = 0
	    end
	    currentRecipe.tags.each do |tag|
	    	keywords[tag] = 0
	    end
	    currentRecipe.ingredients.each do |ingredient|
	    	keywords[ingredient] = 0
	    end

	    similarPoints = {}

	    @recipes.each do |name,recipe|

	    	if recipe.title == currentRecipe.title then next end

	    	similarPoints[recipe.title] = 0

	    	recipe.title.split(" ").each do |word|
	    		if !keywords[word] then next end
		    	similarPoints[recipe.title] += 4
		    end
	    	recipe.tags.each do |tag|
	    		if !keywords[tag] then next end
		    	similarPoints[recipe.title] += 2
		    end
	    	recipe.ingredients.each do |ingredient|
	    		if !keywords[ingredient.name] then next end
		    	similarPoints[recipe.title] += 1
		    end

	    end

	    # Get recipes

	    similarOrdered = similarPoints.sort_by {|_key, value| value}.reverse
	    array = []
	    similarOrdered.each do |id,value|
	    	array.push(recipeWithName(query))
	    end

	    return array

	end

end