def consolidate_cart(cart)
  con_cart = Hash.new
  
  cart.each { |item|
    product_name = item.keys[0]
    product_value = item.values[0]
  
    if con_cart.has_key?(product_name) then
      con_cart[product_name][:count] += 1
    else  
      con_cart[product_name] = product_value
      con_cart[product_name][:count] = 1
    end
  }
  
  print(con_cart)
  return con_cart
end

def apply_coupons(cart, coupons)
  coupons.each {|item_coupon|
    update_item = item_coupon.values[0]
    n_of_items = item_coupon.values[1]
    discount_cost = item_coupon.values[2]
    
    if cart.has_key?(update_item) && cart[update_item][:count] >= n_of_items then
      cart[update_item][:count] -= n_of_items 
      
      if cart.has_key?("#{update_item} W/COUPON") then
        cart["#{update_item} W/COUPON"][:count] += n_of_items 
      else   
        cart["#{update_item} W/COUPON"] = {}
        cart["#{update_item} W/COUPON"][:count] = n_of_items
        cart["#{update_item} W/COUPON"][:price] = discount_cost / n_of_items
        cart["#{update_item} W/COUPON"][:clearance] = cart[update_item][:clearance]
      end 
      
    end 
    
  } 
  return cart
end

def apply_clearance(cart)
  clearance_multiplier = 0.8
  cart.each_key { |item_name|
  
    if cart[item_name][:clearance] == true then
      cart[item_name][:price] *= clearance_multiplier
      cart[item_name][:price] = cart[item_name][:price].round(2)
    end
    
  }
  return cart
end

def checkout(cart, coupons)
  final_total = 0
  final_discount_multiplier = 0.9
  my_con_cart = consolidate_cart(cart)
  coup_d_cart = apply_coupons(my_con_cart, coupons)
  clear_d_cart = apply_clearance(coup_d_cart)
  
  clear_d_cart.each_key {|item|
    final_total += clear_d_cart[item][:price] * clear_d_cart[item][:count]
  }
  
  if final_total > 100.00 then
    (final_total *= final_discount_multiplier).round(2)
  end 
  
  return final_total
end
