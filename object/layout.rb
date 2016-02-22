#!/bin/env ruby
# encoding: utf-8

class Layouts

  def initialize
  end

  def sidebar

    html = ""

    html += "<a href='/' class='logo'><img src='/img/interface/grim.grains.logo.png'/></a>"

    html += formatSidebarSocial
    html += "<center style='margin-bottom:30px'>Dark plant-based and nut-free cookery.</center>"
    html += sidebar_menu
    html += mailinglist
    html += sidebar_colors

    return "<content class='sidebar'>"+html+"</content>"

  end

  def sidebar_colors

    html = ""
    array = []

    $page.ingredients.each do |ingredient|
      if !ingredient.color then next end
      array.push(ingredient.color.value)
    end

    array.uniq.sort.each do |k,v|
      html += "<a style='background:#"+k.to_s+"' href='/"+k.to_s+"'></a>"
    end

    return "<content class='colors'>"+html+"</content>"

  end

  def sidebar_menu

    html = ""

    # Gather Tags
    tags = {}
    $page.recipes.each do |recipe|
      recipe.tags.each do |tag|
        tags[tag] = tags[tag].to_i + 1
      end
    end

    html += "<ul class='menu'>"
    html += "<li class='head'>Nutrition facts</li>"

    $page.customs.each do |custom|
      if !custom.isMenu then next end
      html += "<li class='subs'><a href='/#{custom.url}'>#{custom.title}</a></li>"
    end

    limit = 0
    tags.sort_by {|_key, value| value}.reverse.each do |k,v|
      if limit > 5 then break end
      html += "<li><a href='/"+k+"'>#"+k+"<span class='right'>"+v.to_s+"%</span></a></li>"
      limit += 1
    end
    html += "<li class='search'><input class='search' placeholder='#Search'/></li>"
    html += "</ul>"

    return html

  end

  def formatBanner

    $page.customs.each do |custom|
      if !custom.isPromoted then next end
      return "<content class='banner'><a href='/#{custom.url}'><img src='/img/interface/banners/#{custom.file}.png'/></a></content>"
      break
    end
    return "Banner Error: Nothing promoted"

  end

  def formatSidebarSocial

    html = ""

    html += "<a href='https://www.facebook.com/grimgrains'><img src='img/interface/social/facebook.png'/></a>"
    html += "<a href='http://grimgrains.tumblr.com'><img src='img/interface/social/tumblr.png'/></a>"
    html += "<a href='https://twitter.com/grimgrains'><img src='img/interface/social/twitter.png'/></a>"
    html += "<a href='http://www.pinterest.com/rekkabellum/'><img src='img/interface/social/pinterest.png'/></a>"
    html += "<a href='http://www.instagram.com/grimgrains/'><img src='img/interface/social/instagram.png'/></a>"

    return "<content class='social'>"+html+"</content>"

  end

  def footer

    html = ""

    return "<content class='footer'><a href='http://grimgrains.com'>GRIMGRAINS</a> © 2014 <a href='https://twitter.com/grimgrains'>Twitter</a> &bull; <a href='https://instagram.com/grimgrains'>Instagram</a> &bull; <a href='https://www.facebook.com/grimgrains'>Facebook</a> &bull; <a href='https://www.pinterest.com/rekkabellum/'>Pinterest</a></content>"

  end

  def view

    html = ""

    if $page.isRecipe
      html = recipe($page.isRecipe)
    elsif $page.isIngredient
      html = ingredient($page.isIngredient)
    elsif $page.isColor
      html = color($page.isColor)
    elsif $page.isTag
      html = tag($page.isTag)
    elsif $page.isCustom
      html = custom($page.isCustom)
    elsif $page.isBlog
      html = custom($page.isBlog)
    elsif $page.isTimeline
      html = timeline($page.timeline)
    elsif $page.isHome
      html = timeline($page.timeline)
    else
      html = search($page.query)
    end

    return "<wrapper style='min-height:900px'>"+sidebar.force_encoding("utf-8")+"<core>"+html.force_encoding("utf-8")+"</core><hr /></wrapper>"+footer.force_encoding("utf-8")
  end

  def recipe recipeObject

    html =  ""
    html += "<div itemscope itemtype='http://schema.org/Recipe'>"
    html += recipeObject.template_overview 
    html += recipeObject.template_ingredients
    html += recipeObject.template_instructions 
    html += recipeObject.template_tags 
    html += commentDisqus
    similarRecipes = $page.similarRecipesToId($page.isRecipe.id)
    html += "<content class='similar'>"+similarRecipes.first.template_similar+" "+similarRecipes[1].template_similar+"</content>"
    html += "</div>"

  end

  def ingredient ingredientObject

    html = ""

    assocRecipes = $page.recipesWithIngredient(ingredientObject)

    html += ingredientObject.template_badge
    if assocRecipes.length > 0 then html += "<h1>Found #{assocRecipes.length} recipes with #{ingredientObject.name}</h1>" end
    count = 0
    assocRecipes.each do |recipe|
      if count > 10 then break end
      html += recipe.template_preview
      count += 1
    end
    return "<content class='ingredients'>"+html+"</content>"

  end

  def color colorObject

    html = "<h1 style='color:##{colorObject.value}'>Recipes</h1>"

    html += $page.ingredientsWithColor(colorObject).sample.template_badge

    assocRecipes = $page.recipesWithColor(colorObject)
    count = 0
    assocRecipes.each do |recipe|
      if count > 10 then break end
      html += recipe.template_preview
      count += 1
    end
    return html
    
  end

  def tag tagString

    html = "<h1>#{tagString} Recipes</h1>"
    assocRecipes = $page.recipesWithTag(tagString)
    count = 0
    assocRecipes.each do |recipe|
      if count > 10 then break end
      html += recipe.template_preview
      count += 1
    end
    return html
    
  end

  def custom customObject

    return customObject.template
    
  end

  def bog blogObject

    return blogObject.template
    
  end

  def timeline timelineArray

    html = ""

    currentPage = $page.query.to_i

    if currentPage == 0 then currentPage = 1 end
    perPage = 10

    from = (currentPage * perPage) - perPage
    to = from+perPage

    count = from
    while count < to && timelineArray[count]
      html += timelineArray[count].template_preview
      count += 1
    end

    # Pagination

    html += "<content class='pagination'>"
    html += currentPage != 1 ? "<a href='/"+(currentPage-1).to_s+"' class='left'>Previous Page</a>" : ""
    html += "<a href='/"+(currentPage+1).to_s+"' class='right'>Next Page</a>"
    html += "<hr />"
    html += "</content>"

    return html

  end

  def search word

    return "Searching for <i>#{word}</i>."

  end

end

