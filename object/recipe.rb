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
		ingredientCategory = "main"

		@data["INGR"].each do |category,ingredients|
			if ingredients.class.to_s != "Hash" then next end
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
		return @data["DESC"].runes
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
				<div class='right social'>#{template_facebook}</div>
				<div class='right social'>#{template_pinterest}</div>
				<meta itemprop='prepTime' content='PT#{duration}M'>
				<meta itemprop='totalTime' content='PT#{duration}M'>
		    </h1>
			#{template_colors}
		    <content class='description'>#{description}</content>
		</content>"

	end

	def template_preview

	   return "
	    <content class='recipe'>
		    #{template_photo}
		    <h1 itemprop='name'><a href='/#{url}'>#{title}</a> 
				<small>#{duration} minutes</small>
				<div class='right social'>#{template_facebook}</div>
				<div class='right social'>#{template_pinterest}</div>
				<meta itemprop='prepTime' content='PT#{duration}M'>
				<meta itemprop='totalTime' content='PT#{duration}M'>
		    </h1>
			#{template_colors}
		    <content class='description preview'>#{description_short}</content>
		</content>"

	end

	def template_ingredients

		html = ""
		categories = {}

		ingredients.each do |ingredient|
			if !categories[ingredient.category] then categories[ingredient.category] = [] end
			categories[ingredient.category].push(ingredient)
			html += ingredient.name+" -> "+ingredient.category+"<br />"
	  	end
	  	categories.each do |category,ingredients2|
	  		html += "! "+category+"<br />"
	  		ingredients2.each do |ingredient|
	  			html += ingredient.name+"<br />"

	  		end
	  		# html += category.like("main") ? "" : "<h3>#{category.capitalize}</h3>"
	  		# ingredients2.each do |ingredient|
	  		# 	html += ingredient.template
	  		# end
	  	end
	  	return "<content class='ingredients'>"+html+"</content>"

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

	    return "<content class='instructions'><ul>"+html+"</ul></content>"

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
	    	#{template_photo}
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
		return "<content class='photo'><a href='/#{url}'><img src='/img/recipes/#{title.gsub(" ",".").downcase}.jpg' itemprop='image'/></a></content>"
	end

	def template_facebook
		return '<div class="fb-like" data-href="http://grimgrains.com/'+url+'" data-layout="button_count" data-action="like" data-show-faces="false" data-share="false"></div>'
	end

	def template_pinterest
		return '<a href="//www.pinterest.com/pin/create/button/" data-pin-do="buttonBookmark" ><img src="//assets.pinterest.com/images/pidgets/pinit_fg_en_rect_gray_20.png" /></a>'
	end

end