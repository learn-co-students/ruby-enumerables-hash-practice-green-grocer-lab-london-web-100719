def consolidate_cart(cart)
  hashed_cart = {}
  cart.each do |cart_items|
    cart_items.each do |key, value|
      hashed_cart[key] ||= value 
      if hashed_cart[key][:count]
        hashed_cart[key][:count] += 1
      else 
        hashed_cart[key][:count] = 1
      end 
    end 
  end 
  return hashed_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |c|
    item_name = c[:item]
    if cart[item_name] && (c[:num] <= cart[item_name][:count])
      if cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] += c[:num]
      else 
        cart["#{item_name} W/COUPON"] = {:price => c[:cost]/c[:num], :clearance => cart[item_name][:clearance], :count => c[:num]}
      end 
      cart[item_name][:count] -= c[:num]
    end 
  end 
  return cart
end


def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance] == true 
      value[:price] = (value[:price] * 0.8).round(2)
    end 
  end 
  return cart 
end 


def checkout(cart, coupons)
  first = consolidate_cart(cart)
  second = apply_coupons(first, coupons)
  third = apply_clearance(second)
  total = 0 
  third.each do |item, hash|
    total += (hash[:price] * hash[:count])
  end 
  if total > 100 
    final_total = total * 0.9
  else 
    final_total = total 
  end 
  return final_total 
end 
