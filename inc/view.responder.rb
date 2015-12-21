#!/bin/env ruby
# encoding: utf-8

begin
#----------------
# Init
#----------------

@searchRaw = ARGV[0].to_s.gsub("-"," ")
@search = @searchRaw
@module = @searchRaw

if @searchRaw.include? ':'
	@search = @searchRaw.split(':')[0]
	@module = @searchRaw.split(':')[1]
end

# Imports
require "mysql"

# Core
require_relative "../../envr/database.rb"

require_relative "../object/page.rb"
require_relative "../object/ingredient.rb"
require_relative "../object/color.rb"
require_relative "../object/custom.rb"
require_relative "../object/blog.rb"
require_relative "../object/layout.rb"

require_relative "view.modules.rb"

#----------------
# Setup
#----------------

db        = Oscean.new(@search)
db.connect

data = {
  "search"  => @searchRaw,
  "ingredients" => db.ingredients,
  "recipes" => db.recipes,
  "customs" => db.customs,
  "blogs" => db.blogs
}

layout = Layouts.new()
$page = Page.new(data)

puts "
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

rescue Exception

	error = $@
	errorCleaned = error.to_s.gsub(", ","<br />").gsub("`","<b>").gsub("'","</b>").gsub("\"","").gsub("/var/www/wiki.xxiivv/public_html/","")
	errorCleaned = errorCleaned.gsub("[","\n").gsub("]","")

	puts "<pre><b>Error</b>     "+$!.to_s.gsub("`","<b>").gsub("'","</b>")+"<br/><b>Location</b>  "+errorCleaned+"<br /><b>Report</b>    Please, report this error to <a href='https://twitter.com/aliceffekt'>@aliceffekt</a><br /><br />CURRENTLY UPDATING XXIIVV, COME BACK SOON</pre>"

end