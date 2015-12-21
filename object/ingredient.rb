#!/bin/env ruby
# encoding: utf-8

class Ingredient

	def initialize data

		@data = data
		@quantity = ""

	end

	def name
		return @data[1].to_s
	end

	def definition
		return @data[2].to_s
	end

	def color
		return Color.new(@data[3].to_s)
	end

	def image

		if File.exist?("img/ingredients/#{file}.png")
	      return "<img src='/img/ingredients/#{file}.png' class='ingredient icon'/>"
	    end
	    return nil

	end

	def file
		return name.downcase.gsub(" ",".")
	end

	def url
		return name.downcase.gsub(" ","-")
	end

	def template

		html = ""
	    if File.exist?("img/ingredients/#{file}.png")
	      html += "<img src='/img/ingredients/#{file}.png'/>"
	    else
	      html += "<img src='/img/ingredients/missing.png'/>"
	    end
	    html += "<name itemprop='ingredients'>#{name}<small>#{@quantity}</small></name>"
	    return "<content class='ingredient'><a href='/#{url}'></a>"+html+"</content>"

	end

	def addQuantity data
		@quantity = data
	end

	def template_badge
		return "<content class='ingredient_badge'>
	      <content class='image'>#{image}</content>
	      <content class='description'>
	        <h1>#{name}</h1>
	        <p