#!/bin/env ruby
# encoding: utf-8
class Layouts

  def initialize(data)

    @search     = data["search"].force_encoding("UTF-8")
    @lexicon    = data["lexicon"]
    @recipes    = data["recipes"]
    @pages      = data["pages"]
    @blog       = data["blog"]

  end

  #----------------
  # Layout View
  #----------------

  def homeView

    html = ""

    currentPage = @search[4,4].to_i

    if currentPage == 0 then currentPage = 1 end
    perPage = 6

    from = (currentPage * perPage) - perPage
    to = from+6

    count = 0
    @recipes.sort.reverse.each do |id,recipe|

      if recipe['isActive'].to_i == 0 then next end

      count += 1

      if count > from && count < to+1
        html += formatRecipeOverview(recipe)
        if count % 6 == 0 then html += formatSimilarRecipes(recipe) end
      end

    end

    # Pagination

    html += "<content class='pagination'>"
    if currentPage != 1
      html += "<a href='/page"+(currentPage-1).to_s+"' class='left'>Previous Page</a>"
    end
    if currentPage * perPage < count
      html += "<a href='/page"+(currentPage+1).to_s+"' class='right'>Next Page</a>"
    end
    html += "<hr />"
    html += "</content>"

    return html

  end

  def lexiconView

    html = ""

    imageFile = "img/ingredients/"+@search.downcase.gsub(" ",".")+".png"

    if File.exist?(imageFile)
      html += "<img src='/"+imageFile+"'/>"
    end

    html += "<h1>"+@search+"</h1>"
    html += "<p>"+@lexicon[@search.downcase]['definition'].to_s+"</p>"
    
    @recipes.each do |id,recipe|
      if recipe['ingredients'].to_s.downcase.include?(@search.downcase)
        html += formatRecipeOverview(recipe)
      end
    end

    return "<content class='lexicon'>"+html+"</content>"

  end

  def pageView
    
    html = ""
    
    if !@pages[@search.downcase] then return "Something went wrong" end

    html += @pages[@search.downcase]["content"]
    
    return html
    
  end

  def searchView

    html = ""

    html += "<h1>#"+@search+"</h1>"

    if @pages[@search.downcase].to_s != ""
      html += "<p>"+@pages[@search.downcase]['content'].to_s+"</p>"
    else
      html += "<p>This page shows the recipies including \""+@search+"\".</p>"
    end

    needle = @search.downcase
    results = {}

    @recipes.each do |id,recipe|

    	if recipe['isActive'].to_i != 1 then next end
		if !results[recipe['id'].to_i] then results[recipe['id'].to_i] = 0 end

		if recipe['title'].to_s.downcase.include?(needle) then results[recipe['id'].to_i] += 5 end
		if recipe['tags'].to_s.downcase.include?(needle) then results[recipe['id'].to_i] += 4 end
		if recipe['ingredients'].to_s.downcase.include?(needle) then results[recipe['id'].to_i] += 3 end
		if recipe['instructions'].to_s.downcase.include?(needle) then results[recipe['id'].to_i] += 2 end
		if recipe['description'].to_s.downcase.include?(needle) then results[recipe['id'].to_i] += 1 end

    end

    # Ingredients by colour

    @lexicon.each do |id,ingredient|
      if ingredient['colour'].to_s.downcase != @search.to_s.downcase then next end
      html += formatIngredient(ingredient['term'],"")
    end

    count = 0
    results.sort_by {|_key, value| value}.reverse.each do |k,v|
    	if v == 0 then next end
    	html += formatRecipeOverview(@recipes[k])
    	count += 1
    	if count > 10 then break end
    end

    return "<content class='lexicon'>"+html+"</content>"

  end

  def sideView

    html = ""

    html += "<a href='/' class='logo'><img src='/img/interface/grim.grains.logo.png'/></a>"

    html += formatSidebarSocial
    html += "<center style='margin-bottom:30px'>Dark plant-based and nut-free cookery.</center>"
    html += formatSidebarMenu
    html += formatColoursList
    html += mailinglist
    html += formatBanner
    html += widgetInstagram
    html += googleAdSidebar3
    

    return "<content class='sidebar'>"+html+"</content>"

  end

  def listView

    html = ""
    if @pages[@search.downcase].to_s != ""
      html += "<p>"+@pages[@search.downcase]['content'].to_s+"</p>"
    end

    @lexicon.sort.each do |id,ingredient|
      html += formatIngredient(ingredient['term'],"")
    end

    return html

  end

  def blogView

    html = ""

    @blog.each do |k,v|
      html += formatBlog(v)
    end

    return "<content class='blog'>"+html+"</content>"

  end

  def footerView

    html = ""

    return "<content class='footer'><a href='http://grimgrains.com'>GRIMGRAINS</a> © 2014 <a href='https://twitter.com/grimgrains'>Twitter</a> &bull; <a href='https://instagram.com/grimgrains'>Instagram</a> &bull; <a href='https://www.facebook.com/grimgrains'>Facebook</a> &bull; <a href='https://www.pinterest.com/rekkabellum/'>Pinterest</a></content>"

  end

  def view

    html = ""
    
    if @lexicon[@search.downcase]
      html = lexiconView
    elsif @search == "Home" || @search[0,4].downcase == "page"
      html = homeView
    elsif @search == "Rejects"
      html = blogView
    elsif @search == "About"
      html = pageView
    elsif @search == "Shop"
      html = pageView
      require_relative "page.shop.rb"       # system | database
      html += shopView
    elsif isRecipe(@search)
      html = formatRecipe(isRecipe(@search))
      html += commentDisqus
    elsif isBlog(@search)
      html = formatBlog(isBlog(@search))
      html += commentDisqus
    elsif @search == "Ingredients list"
      html = listView
    else
      html = searchView
    end

    return "<wrapper style='min-height:900px'>"+sideView.force_encoding("utf-8")+"<core>"+html.force_encoding("utf-8")+"</core><hr /></wrapper>"+footerView.force_encoding("utf-8")
  end

end