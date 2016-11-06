#!/bin/env ruby
# encoding: utf-8

class Color

	def initialize data

		@data = data

	end

	def value

		if @data.to_s == "" then return "ffffff" end
		return @data

	end

	def template

		return "<a class='color' style='background-color:##{value}' href='/#{value}'></a>"
		
	end

end