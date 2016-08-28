#!/bin/env ruby
# encoding: utf-8

require_relative "object/page.rb"
require_relative "object/ingredient.rb"
require_relative "object/color.rb"
require_relative "object/custom.rb"
require_relative "object/layout.rb"
require_relative "object/recipe.rb"

class Grimg

	include Vessel

	def http q = "Home"

		@searchRaw = q.to_s.gsub("-"," ")
		@search = @searchRaw
		@module = @searchRaw

		if @searchRaw.include? ':'
			@search = @searchRaw.split(':')[0]
			@module = @searchRaw.split(':')[1]
		end

		data = {
			"search"  => @search,
			"ingredients" => En.new("grim.ingredients").to_h,
			"recipes" => En.new("grim.recipes").to_h,
			"custom" => En.new("grim.custom").to_h
		}

		$page = Page.new(data)
		layout = Layouts.new(@search,@module)

		return "
		<!DOCTYPE html>
		<html> 
			<head>
			<meta charset='UTF-8'>
			<meta property='og:GrimGrains' content='grimgrains.com' />
			<meta name='description' content='Grim Grains is a vegan food blog featuring over a hundred colourful, healthy, nut-free, and experimental recipes.'/>

			<link rel='apple-touch-icon-precomposed' 	 href='../../img/interface/phone_xxiivv.png'/>
			<link href='http://fonts.googleapis.com/css?family=Abel' rel='stylesheet' type='text/css'>
			<script src='https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js' ></script>
			<link rel='shortcut icon' href='http://grimgrains.com/favicon.ico' />
			<link href='http://fonts.googleapis.com/css?family=Amatic+SC' rel='stylesheet' type='text/css'>

			<link rel='stylesheet'           type='text/css'                 href='inc/style.reset.css?v=1' />
			<link rel='stylesheet'           type='text/css'                 href='inc/style.main.css?v=1' />
			<script 														 src='inc/jquery.main.js?v=1'></script>

			<title>Grimgrains | #{$page.title}</title>

			<script>
			(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

			ga('create', 'UA-53987113-1', 'auto');
			ga('send', 'pageview');
			</script>

		</head>
			<body>"+layout.view+"</body>
			"+layout.googleAnalytics+"
			"+layout.sharePinterestSDK+"
			"+layout.shareFacebookSDK+"
			"+layout.googleAdsSDK+"
			</html>
			"

		end

	end