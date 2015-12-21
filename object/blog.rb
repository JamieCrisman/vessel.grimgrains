#!/bin/env ruby
# encoding: utf-8

class Blog

	def initialize data

		@data = data

	end

	def id

		return @data[0].to_i

	end

	def title

		return @data[2]

	end

	def url

		return title..downcase.gsub(" ","-")
		
	end

	def date

		return @data[1]

	end

	def article

		return @data[3]

	end

	def template
		return "missing blog template"
	end

end