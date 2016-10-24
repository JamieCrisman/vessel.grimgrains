#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpses","http")

require_relative "object/page.rb"
require_relative "object/ingredient.rb"
require_relative "object/color.rb"
require_relative "object/custom.rb"
require_relative "object/layout.rb"
require_relative "object/recipe.rb"

class Grimg

  include Vessel
  
  class Corpse

    include CorpseHttp

  end

  class Actions

    include ActionCollection

    def serve q = "Home"

      path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

      @searchRaw = q.to_s.gsub("-"," ")
      @search = @searchRaw
      @module = @searchRaw

      if @searchRaw.include? ':'
        @search = @searchRaw.split(':')[0]
        @module = @searchRaw.split(':')[1]
      end

      data = {
        "search"  => @search,
        "ingredients" => Memory_Hash.new("grim.ingredients",path),
        "recipes" => Memory_Hash.new("grim.recipes",path),
        "custom" => Memory_Hash.new("grim.custom",path)
      }

      $page = Page.new(data)
      layout = Layouts.new(@search,@module)

      # Corpse
      
      corpse = Corpse.new
      
      corpse.add_meta("description","Grim Grains is a vegan food blog featuring over a hundred colourful, healthy, nut-free, and experimental recipes.")
      corpse.add_meta("keywords","sailing, patreon, indie games, design, liveaboard")
      corpse.add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
      corpse.add_meta("apple-mobile-web-app-capable","yes")

      corpse.add_link("http://fonts.googleapis.com/css?family=Abel")
      corpse.add_link("http://fonts.googleapis.com/css?family=Amatic+SC")

      corpse.add_link("style.reset.css")
      corpse.add_link("style.main.css")

      corpse.add_link("shortcut icon","","http://grimgrains.com/favicon.ico")
      
      corpse.add_script("jquery.core.js")
      corpse.add_script("jquery.main.js")
      
      corpse.title = "Grimgrains | #{$page.title}"
      corpse.body  = layout.view

      corpse.add_footer(layout.googleAnalytics)
      corpse.add_footer(layout.sharePinterestSDK)
      corpse.add_footer(layout.shareFacebookSDK)
      corpse.add_footer(layout.googleAdsSDK)
      
      return corpse.result

    end

  end

  def actions ; return Actions.new(self,self) end

end