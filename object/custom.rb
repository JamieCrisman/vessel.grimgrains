#!/bin/env ruby
# encoding: utf-8

class Custom

	def initialize data

		@data = data

	end

	def id

		return @data[0].to_i

	end

	def title

		return @data[1]

	end

	def url

		return title.downcase.gsub(" ","+")

	end

	def file

		return title.downcase.gsub(" ",".")

	end

	def content

		return @data[2]

	end

	def isPromoted

		return @data[3].to_i

	end

	def isMenu
		return @data[4].to_i
	end

	def template

		return "#{content}"
	end

end