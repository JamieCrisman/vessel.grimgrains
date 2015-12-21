def formatUrl string
	return string.to_s.downcase.gsub(" ","+")
end

def formatFileName string
	return string.downcase.gsub(" ",".")
end

def formatDate date

  if date == "" then return "" end

  day  = date[8,2].to_s.to_i
  year = date[0,4]
  month= date[5,2].to_i
  monthName = ""

  if month == 1
    monthName = "Jan"
  elsif month == 2
    monthName = "Feb"
  elsif month == 3
    monthName = "Mar"
  elsif month == 4
    monthName = "Apr"
  elsif month == 5
    monthName = "May"
  elsif month == 6
    monthName = "Jun"
  elsif month == 7
    monthName = "Jul"
  elsif month == 8
    monthName = "Aug"
  elsif month == 9
    monthName = "Sep"
  elsif month == 10
    monthName = "Oct"
  elsif month == 11
    monthName = "Nov"
  elsif month == 12
    monthName = "Dec"
  end
  
  if day > 0
    return monthName+" "+day.to_s+", "+year
  else
    return monthName+" "+year
  end
end

def isBlog title

  # @blog.each do |k,v|
  #   if formatUrl(v['title']) == formatUrl(title)
  #     return v
  #   end
  # end
  return nil

end

def isRecipe title

  @recipes.each do |k,v|
    if formatUrl(v['title'].force_encoding("UTF-8")) == formatUrl(title)
      return v
    end
    if k.to_i == @search.to_i && @search.to_i > 0
      return v
    end
  end
  return nil

end

