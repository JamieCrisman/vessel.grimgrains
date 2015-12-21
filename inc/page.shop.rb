class Layouts

	def shopView

		html = ""

		items = Oscean.new("").shop.sort

		items.each do |k,item|

			html += "<div style='width:300px; display:inline-block; margin-right:50px'>"

				html += "<img src='img/shop/"+item["name"].to_s.gsub(" ",".").downcase+".jpg'/>"
				
				html += "<div>"
				html += "<h3 style='font-family:Helvetica,arial; position:relative; margin:20px 0px; line-height:20px'>"
				html += item["name"]+" <span style='color:#999'>"+item["size"]+"</span><br />"
				html += "<span style='font-weight:bold; font-size:14px'>"+item["description"]+"</span>"
				html += "<span style='position:absolute; top:0; right:0; '>"+item["price"]+"$CAD</span>"
				html += "</h3>"
				html += item["button"].to_s+"<br />"
				html += "</div>"

			html += "</div>"

		end

		return html
	end


end
