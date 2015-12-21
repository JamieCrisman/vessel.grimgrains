#!/bin/env ruby
# encoding: utf-8
class Layouts

  # Recipe view

  def formatRecipe recipe

    html = ""

    html += "<div itemscope itemtype='http://schema.org/Recipe'>"
    html += formatRecipeOverview(recipe)
    html += formatIngredientsList(recipe['ingredients'])
    html += formatInstructions(recipe)
    html += formatTagsList(recipe['tags'])
    # html += formatNutritional(recipe)
    html += commentDisqus
    html += formatSimilarRecipes(recipe)
    html += "</div>"

    return html

  end

  def formatRecipeOverview recipe

  	if recipe['title'].to_s == "" then return "" end

    html = ""
    html += "<content class='photo'><a href='/"+formatUrl(recipe['title'])+"'><img src='/img/recipes/"+recipe['id'].to_s+".jpg' itemprop='image'/></a></content>"
    html += "
    <h1 itemprop='name'><a href='/"+formatUrl(recipe['title'])+"'>"+recipe['title']+"</a> 
      <small>"+recipe['duration'].to_s+" minutes</small>
      <div class='right social'>"+shareFacebook(recipe['id'].to_s)+"</div>
      <div class='right social'>"+sharePinterest+"</div>
      <meta itemprop='prepTime' content='PT"+recipe['duration'].to_s+"M'>
      <meta itemprop='totalTime' content='PT"+recipe['duration'].to_s+"M'>
    </h1>"

    if recipe['description'].to_s != ""
      # short
      if @search.to_i != recipe['id'].to_i && formatUrl(@search) != formatUrl(recipe['title'])
        html += "<content class='description'><p>"+recipe['description'].force_encoding("utf-8").split("</p>")[0].to_s.sub("<p>","")+" <a href='/"+formatUrl(recipe['title'])+"'>Continue reading...</a></p></content>"
      # long
      else
        html += "<content class='description'>"+recipe['description']+"</content>"
      end
    end

    return "<content class='recipe'>"+html+"</content>"

  end

  # Ingredients

  def formatIngredientsList string

  	html = ""
    
  	string.lines.each do |k,v|

  		name = k.split("|")[0]
  		quantity = k.split("|")[1].to_s.rstrip

  		if name[0,1] == "="
  			html += "<h1 class='dashed'>"+name.gsub("=","")+"</h1>"
  		elsif name.length > 3
  			html += formatIngredient(name,quantity)
  		end

  	end

  	return "<content class='ingredients'>"+html+"</content>"

  end

  def formatIngredient name,quantity

    html = ""

    if File.exist?("img/ingredients/"+formatFileName(name)+".png")
      html += "<img src='/img/ingredients/"+formatFileName(name)+".png'/>"
    else
      html += "<img src='/img/ingredients/missing.png'/>"
    end
    html += "<name itemprop='ingredients'>"+name+"<small>"+quantity+"</small></name>"

    return "<content class='ingredient'><a href='/"+formatUrl(name)+"'></a>"+html+"</content>"

  end

  # Instructions

  def formatInstructions recipe

    html = ""
    html += "<h1 itemprop='recipeYield'>"+recipe['serving']+"</h1>"

    instructions = ""

    # List them

    recipe['instructions'].lines.each do |k,v|
      if k[0,1] == "="
        instructions += "</ul><h2>"+k.gsub("=","")+"</h2><ul>"
      elsif k.length > 4
        instructions += "<li itemprop='recipeInstructions'>"+k+"</li>"
      end
    end

    # Find ingredients
    ingredientsList = Hash.new
    recipe['ingredients'].lines.each do |k,v|
      name = k.split("|")[0].downcase
      quantity = k.split("|")[1].to_s.rstrip
      ingredientsList[name] = quantity
    end

    instructions = formatIngredientLookup(instructions,ingredientsList)

    # Find templates

    wordPrev = ""

    instructions.split(' ').each do |word,v|

      word = word.gsub(".","")

      if word[0..-2].to_i > 0 && word[-1,1] == "F"
        temperatureF = word[0..-2].to_i
        temperatureC = ((temperatureF-32)*5/90).to_i * 10
        instructions = instructions.gsub(word, "<span class='temperature'>"+word[0..-2]+"ºF</span>/<span class='temperature'>"+temperatureC.to_s+"ºC</span>")
      end

      if word.include?("minute")
        instructions = instructions.gsub(wordPrev+" "+word,"<span class='time'>"+wordPrev+" "+word+"</span>")
      end

      wordPrev = word

    end

    html += instructions

    return "<content class='instructions'><ul>"+html+"</ul></content>"

  end


  def formatTagsList string

  	html = ""

  	string.split("|").each do |tag,v|
  		html += "<a href='/"+tag+"'>#"+tag+"</a> "
  	end

  	return "<content class='tags'>"+html+"</content>"

  end

  def formatNutritional recipe

    html = ""

    nutritionalIngredients = []
    warnings = []

    # Find Ingredients with nutritional data
    recipe['ingredients'].lines.each do |k,v|
      name = k.split("|")[0].downcase
      if name.to_s.strip == "" then next end
      if name.to_s.strip[0,1] == "=" then next end
      quantity = k.split("|")[1].to_s.strip

      if quantity.split(" ").length < 2
        scale = "u"
        value = 1
      else
        scale = quantity.split(" ").last
        value = quantity.sub(scale,"").strip
      end

      ingredientSave = {}
      if !@lexicon[name]
        warnings.push("ingredient: "+name)
      elsif !@lexicon[name]['nutritional']
        warnings.push("nutritional: "+name)
      else
        ingredientSave['name'] = name
        ingredientSave['value'] = value
        ingredientSave['scale'] = scale
        nutritionalIngredients.push(ingredientSave)
      end
      
    end

    nutritionalSummary = {}

    # Display
    nutritionalIngredients.each do |k,v|

      if @lexicon[k['name'].to_s]['nutritional'].to_s == "" then next end

      name = k['name'].to_s
      value = k['value'].to_s
      scaleFrom = k['scale'].to_s
      scaleTo = @lexicon[name]['nutritional'].lines.first.split(" ").last

      if scaleFrom == "cups" then scaleFrom = "cup" end
      if scaleTo == "cups" then scaleTo = "cup" end

      multiplier = 1.0

      if scaleFrom == "tsp" && scaleTo == "tbsp"
        multiplier = 0.33
      elsif scaleFrom == "tbsp" && scaleTo == "tsp"
        multiplier = 3
      elsif scaleFrom == "tbsp" && scaleTo == "cup"
        multiplier = 0.0625
      elsif scaleFrom == scaleTo
        multiplier = 1
      elsif scaleTo == "u"
        multiplier = 1
      elsif scaleTo == "u"
        multiplier = 1
      else
        warnings.push("unknown conversion("+name.to_s+"), "+scaleFrom+" to "+scaleTo)
      end

      if value == "1/2"
        multiplier = multiplier/2
      elsif value == "1/4"
        multiplier = multiplier/4
      elsif value == "1/3"
        multiplier = multiplier/3
      elsif value == "3/4"
        multiplier = (multiplier*3)/4
      elsif value == "1 1/2"
        multiplier = multiplier * 1.5
      elsif value == "1 1/3"
        multiplier = multiplier * 1.3
      elsif value.include?("/")
        warnings.push("Unknown ratio of "+value)
      end  

      # Add each ingredient's value
      @lexicon[name]['nutritional'].lines.each do |k1,v1|
        nutName = k1.split(":")[0].to_s
        nutQuantity = k1.split("/")[0].split(":")[1].to_s.strip

        # Make everything in g
        if nutQuantity.strip.split(" ")[1] == "mg"
          nutQuantityValue = nutQuantity.strip.split(" ")[0].to_f / 1000
        else
          nutQuantityValue = nutQuantity.strip.split(" ")[0].to_f
        end
        nutritionalSummary[nutName] = nutritionalSummary[nutName].to_f + (multiplier * nutQuantityValue)
      end

    end

    html += "<ul>"
    nutritionalSummary.sort.each do |k,v|
      if k == "calories"
        html += "<li><b>"+k+"</b> <span class='right'>"+v.to_i.to_s+"</span></li>"
      else
        html += "<li><b>"+k+"</b> <span class='right'>"+v.to_s[0,5].to_s+"g</span></li>"
      end
    end
    html += "</ul>"

    html += "<p><span class='red'>*</span> This feature is still experimental.</p>"

    if warnings.length > 0 
      html += "<ul class='warnings'>"
      warnings.each do |k,v|
        html += "<li>"+k+"</li>"
      end
      html += "</ul>"
    end

    return "<content class='nutritional'>"+html+"</content>"

  end

  def formatColoursList

    html = ""
    coloursList = []

    @lexicon.each do |k,v|
      if v['colour'].to_s == "" then next end
      if v['colour'].to_s == "FFFFFF" then next end
      coloursList.push(v['colour'].to_s)
    end

    html += "<h1>Eat by colour</h1>"

    coloursList.uniq.sort.each do |k,v|
      html += "<a style='background:#"+k.to_s+"' href='/"+k.to_s+"'></a>"
    end

    return "<content class='colours'>"+html+"</content>"

  end

  def formatSidebarMenu

    html = ""

    # Gather Tags
    tags = Hash.new
    @recipes.each do |k,v|
      v['tags'].to_s.split("|").each do |k1,v1|
        tags[k1] = tags[k1].to_i + 1
      end
    end

    html += "<ul class='menu'>"
    html += "<li class='head'>Nutrition facts</li>"

    @pages.sort.each do |k,v|
      if v['isMenu'].to_i == 0 then next end
      html += "<li class='subs'><a href='/"+v['term']+"'>"+v['term']+"</a></li>"
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

    @pages.each do |k,v|

      if v['isPromoted'].to_i == 0 then next end

      return "<content class='banner'><a href='/"+v['term']+"'><img src='/img/interface/banners/"+v['term']+".png'/></a></content>"
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
  
  def formatBlogWidget

    @blog.sort.reverse.each do |k,blog|

      html = ""
      html += "<h1><a href='/"+formatUrl(blog['title'])+"'>"+blog['title']+"</a></h1>"
      html += "<a href='/"+formatUrl(blog['title'])+"'><content class='photo' style='background-image:url(/img/blog/"+blog['id']+".jpg)'></content></a>"
      html += blog['article'].to_s.split("</p>")[0].to_s+" <br /><a href='/Blog'>Continue reading</a></p>"

      return "<content class='blog widget'>"+html+"</content>"

      break
    end

  end

  def formatBlog blog

    html = ""
    html += "<content class='photo'><img src='/img/blog/"+blog['id']+".jpg'/></content>"
    html += "
    <h1><a href='"+formatUrl(blog['title'])+"'>"+blog['title']+"</a> 
      <small>"+formatDate(blog['date']).to_s+"</small>
      <div class='right social'>"+shareFacebook(formatUrl(blog['title']))+"</div>
      <div class='right social'>"+sharePinterest+"</div>
    </h1>"

    html += "<div class='description'>"+blog['article'].to_s+"</div>"

    return "<content class='blog'>"+html+"</content>"

  end

  def formatIngredientLookup text,ingredientsList

    ingredientsListSorted = []
    ingredientsListSorted = ingredientsList.collect { |k, v| k }.sort_by {|x| x.length}.reverse

    ingredientId = 0
    ingredientsListSorted.each do |name,qty|
      text = text.force_encoding("utf-8").gsub(name,"{{"+ingredientId.to_s+"}}")
      ingredientId += 1
    end

    templatesFound = text.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/)
    templatesFound.each do |k,v|
	    ingredientName = ingredientsListSorted[k.to_i]
		text = text.gsub("{{"+k+"}}","<a href='/"+formatUrl(ingredientName)+"'>"+ingredientName+"</a>")
    end

    return text
  end

  def formatRecipeRelated recipe

  	html = ""
  	html += "<content class='photo'><a href='/"+formatUrl(recipe['title'])+"'><img src='/img/recipes/"+recipe['id'].to_s+".jpg' itemprop='image'/></a></content>"
    html += "<h1 itemprop='name'><a href='/"+formatUrl(recipe['title'])+"'>"+recipe['title']+"</a></h1>"
	  html += "<p>"+recipe['description'].to_s.split("</p>")[0].to_s.split(".")[0].to_s.sub("<p>","").sub("</p>","")+".</p>"

    return "<content class='recipe'>"+html+"</content>"

  end

  def formatSimilarRecipes recipe

    html = ""

    keywords = {}

    recipe['title'].split(" ").each do |k,v|
    	keywords[k] = 0
    end
    recipe['tags'].split("|").each do |k,v|
    	keywords[k] = 0
    end
    recipe['ingredients'].lines.each do |k,v|
    	if !k.include?("|") then next end
    	keywords[k.split("|")[0]] = 0
    end

    similarPoints = {}

    @recipes.each do |id,recipe2|

    	if recipe2['title'] == recipe['title'] then next end
    	if recipe2['isActive'].to_i == 0 then next end

    	similarPoints[id] = 0

    	recipe2['title'].split(" ").each do |k,v|
    		if !keywords[k] then next end
	    	similarPoints[id] += 4
	    end
    	recipe2['tags'].to_s.split("|").each do |k,v|
    		if !keywords[k] then next end
	    	similarPoints[id] += 2
	    end
    	recipe2['ingredients'].lines.each do |k,v|
	    	if !k.include?("|") then next end
    		if !keywords[k.split("|")[0]] then next end
	    	similarPoints[id] += 1
	    end

    end

    count = 0

    similarPoints.sort_by {|_key, value| value}.reverse.each do |k,v|

    	html += formatRecipeRelated(@recipes[k])
    	count += 1
    	if count == 2 then break end
    end

    html += "<hr />"

    return "<content class='similar'>"+html+"</content>"

  end

end