#!/bin/env ruby
# encoding: utf-8

class Recipe

	def initialize name,data
		@data = data
		@data["NAME"] = name
	end

	def title
		return @data["NAME"].capitalize
	end

	def date
		return @data["DATE"]
	end

	def ingredients

		array = []
		if !@data["INGR"] then return [] end
			
		ingredientCategory = "main"

		@data["INGR"].each do |category,ingredients|
			ingredients.each do |ingredient,quantity|
				ingredient = $page.ingredientWithName(ingredient)
				if !ingredient then next end
				ingredient.addQuantity(quantity)
				ingredient.addCategory(category)
				array.push(ingredient)
			end
		end
		return array

	end

	def instructions

		text = @data["INST"]

		return text

		# Add ingredients highlights

	    ingredients.each do |ingredient|
	      text = text.gsub(ingredient.name,"<a href='/#{ingredient.url}'>#{ingredient.name}</a>")
	    end

	    # Add Temperatures

		words = text.split(' ')
		wordPrev = ""

	    words.each do |word,v|

	      word = word.gsub(".","")
	      value = word[0..-2].to_i
	      units = word[-1,1]

	      if value > 0 && units == "F"
	        temperatureF = value
	        temperatureC = ((temperatureF-32)*5/90).to_i * 10
	        templated = "<span class='temperature'>#{value}ºF</span>/<span class='temperature'>#{temperatureC}ºC</span>"
	        text = text.gsub(word,templated)
	      end

	      if word.include?("minute")
	        text = text.gsub(wordPrev+" "+word,"<span class='time'>"+wordPrev+" "+word+"</span>")
	      end

	      wordPrev = word

	    end

		return text.lines

	end

	def tags
		return @data["TAGS"].to_s.split(" ")
	end

	def duration
		return @data["TIME"].to_i
	end

	def serving
		return @data["SERV"]
	end

	def description
		if !@data["DESC"] then return "" end
		return @data["DESC"].runes("recipes")
	end

	def description_short
		return description.split("</p>").first.to_s+"<br /><a href='/#{url}'>Continue Reading..</a></p>"
	end

	def colors
		return []
		array = []
		used = {}
		ingredients.each do |ingredient|
			if used[ingredient.color.value] then next end
			array.push(ingredient.color)
			used[ingredient.color.value] = 1
		end
		return array
	end

	def hasIngredient ingredientTarget

		ingredients.each do |ingredient|
			if ingredient.name.downcase != ingredientTarget.name.downcase then next end
			return true
		end
		return false

	end

	def hasTag tagTarget

		tags.each do |tag|
			if !tag || !tagTarget then next end
			if tag.downcase != tagTarget.downcase then next end
			return true
		end
		return false

	end

	def hasColor colorTarget

		ingredients.each do |ingredient|
			if ingredient.color.value.downcase != colorTarget.value.downcase then next end
			return true
		end
		return false

	end

	# Custom

	def url
		return title.downcase.gsub(" ","-")
	end

	# Templates

	def template_overview

	   return "
	    <content class='recipe'>
		    #{template_photo}
		    <h1 itemprop='name'><a href='/#{url}'>#{title}</a> 
				<small>#{duration} minutes</small>
				<meta itemprop='prepTime' content='PT#{duration}M'>
				<meta itemprop='totalTime' content='PT#{duration}M'>
		    </h1>
			#{template_colors}
		    <content class='description'>#{description}</content>
		</content>".markup

	end

	def template_preview

	   return "
	    <content class='recipe'>
		    <a href='#{url}'>#{template_photo}</a>
		    <h1 itemprop='name'><a href='/#{url}'>#{title}</a> 
				<small>#{duration} minutes</small>
				<meta itemprop='prepTime' content='PT#{duration}M'>
				<meta itemprop='totalTime' content='PT#{duration}M'>
		    </h1>
			#{template_colors}
		    <content class='description preview'>#{description_short}</content>
		</content>".markup

	end

	def template_ingredients

		html = ""
		categories = {}
		@data["INGR"].each do |category,ingredients|
			html += category.like("main") ? "" : "<h3>#{category.capitalize}</h3>"
			ingredients.each do |ingredient,quantity|
				ingredient = $page.ingredientWithName(ingredient)
				if ingredient == nil then next end
				ingredient.addQuantity(quantity)
				html += ingredient.template
			end
		end
	  	return "<content class='ingredients'>"+html.markup+"</content>"

	end

	def template_instructions

		html = ""
	    html += "<h1 itemprop='recipeYield'>#{serving}</h1>"

	    # List them

	    instructions.each do |instruction|
	      if instruction[0,1] == "*"
	        html += "</ul><h2>"+instruction.gsub("*","").strip+"</h2><ul>"
	      elsif instruction.length > 4
	        html += "<li itemprop='recipeInstructions'>#{instruction.sub("- ","").strip}</li>"
	      end
	    end

	    return "<content class='instructions'><ul>"+html.markup+"</ul></content>"

	end

	def template_tags

		html = ""
	  	tags.each do |tag|
	  		html += "<a href='/#{tag}'>##{tag}</a> "
	  	end
	  	return "<content class='tags'>#{html}</content>"

	end

	def template_similar

	    return "<content class='recipe'>
	    	<a href='#{url}'>#{template_photo}</a>
	    	<h1 itemprop='name'><a href='/#{url}'>#{title}</a></h1>
	    	#{template_tags}
	    </content>"

	end

	def template_colors

		html = ""

		colors.each do |color|
			if color.value.downcase == "ffffff" then next end
			if color.value.downcase == "efefef" then next end
			html += color.template
		end

		return "<content class='colors'>#{html}</content>"

	end

	def template_photo
		media = Media.new("recipes",title)
		return media
		return "<content class='photo'><a href='/#{url}'><img src='/img/recipes/#{title.gsub(" ",".").downcase}.jpg' itemprop='image'/></a></content>"
	end

end