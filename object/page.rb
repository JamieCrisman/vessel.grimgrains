#!/bin/env ruby
# encoding: utf-8

class Page

	def initialize data

		@search     = data["search"].force_encoding("UTF-8")
	    @ingredients = data["ingredients"]
	    @recipes    = data["recipes"]
	    @customs    = data["customs"]
	    @blogs       = data["blogs"]

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
		@recipes.reverse.each do |recipe|
			if recipe.isActive == false then next end
			array.push(recipe)
		end
		return array

	end

	# Recipe

	def isRecipe

		@recipes.each do |recipe|
			if recipe.title.downcase == @search.downcase then return recipe end
		end
		return nil

	end

	def isIngredient

		@ingredients.each do |ingredient|
			if ingredient.name.downcase == @search.downcase then return ingredient end
		end
		return nil

	end

	def isColor

		@ingredients.each do |ingredient|
			if ingredient.color.value.downcase == @search.downcase then return ingredient.color end
		end
		return false

	end

	def isTag

		@recipes.each do |recipe|
			if recipe.hasTag(@search) == true then return @search end
		end
		return nil

	end

	def isCustom

		@customs.each do |custom|
			if custom.title.downcase == @search.downcase then return custom end
		end
		return nil

	end

	def isBlog

		@blogs.each do |blog|
			if blog.title.downcase == @search.downcase then return blog end
		end
		return nil

	end

	def isTimeline

		return ($page.query.to_i > 0) ? true : nil

	end

	def isHome

		return (query == "Home") ? true : nil

	end

	# BLog

	def recipeWithId id

		@recipes.each do |recipe|
			if recipe.id.to_i != id.to_i then next end 
			return recipe
		end

	end

	def ingredientWithName nameTarget

		@ingredients.each do |ingredient|
			if ingredient.name.downcase == nameTarget.downcase then return ingredient end
		end
		return nil

	end

	def ingredientsWithColor colorTarget

		array = []
		@ingredients.each do |ingredient|
			if ingredient.color.value.downcase == colorTarget.value.downcase then return array.push(ingredient) end
		end
		return array

	end

	def recipesWithIngredient ingredientTarget

		array = []
		@recipes.each do |recipe|
			if !recipe.hasIngredient(ingredientTarget) then next end
			array.push(recipe)
		end
		return array.reverse

	end

	def recipesWithTag tagTarget

		array = []
		@recipes.each do |recipe|
			if !recipe.hasTag(tagTarget) then next end
			array.push(recipe)
		end
		return array.reverse

	end

	def recipesWithColor colorTarget

		array = []
		@recipes.each do |recipe|
			if !recipe.hasColor(colorTarget) then next end
			array.push(recipe)
		end
		return array.reverse

	end

	def similarRecipesToId id

		keywords = {}

		currentRecipe = recipeWithId(id)

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

	    @recipes.each do |recipe|

	    	if recipe.title == currentRecipe.title then next end
	    	if recipe.isActive == false then next end

	    	similarPoints[recipe.id] = 0

	    	recipe.title.split(" ").each do |word|
	    		if !keywords[word] then next end
		    	similarPoints[recipe.id] += 4
		    end
	    	recipe.tags.each do |tag|
	    		if !keywords[tag] then next end
		    	similarPoints[recipe.id] += 2
		    end
	    	recipe.ingredients.each do |ingredient|
	    		if !keywords[ingredient.name] then next end
		    	similarPoints[recipe.id] += 1
		    end

	    end

	    # Get recipes

	    similarOrdered = similarPoints.sort_by {|_key, value| value}.reverse
	    array = []
	    similarOrdered.each do |id,value|
	    	array.push(recipeWithId(id))
	    end

	    return array

	end

end