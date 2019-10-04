def consolidate_cart(cart)
  theHash = {}
  cart.map do |item|
    itemname = item.keys[0]
    details = item.values[0]
    if theHash[itemname] 
       theHash[itemname][:count] += 1 
     else
       theHash[itemname] = details
       theHash[itemname][:count] = 1
    end
  end
  return theHash
end 


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_item = coupon[:item]
    if cart[coupon_item]
      if coupon[:num] <= cart[coupon_item][:count]
        cart[coupon_item][:count] -= coupon[:num]
        new_key = "#{coupon_item} W/COUPON" 
        if !cart[new_key]
            cart[new_key] = {:count => 0}
        end
        cart[new_key][:count] += coupon[:num]
        cart[new_key][:clearance] = cart[coupon_item][:clearance]
        cart[new_key][:price] = coupon[:cost] / coupon[:num]
      end
    end 
  end
  return cart
end 
    

def apply_clearance(cart)
  cart.each do |k, item| 
    if item[:clearance]
       item[:price] = (item[:price] * 0.8).round(2)
    end
  end
  return cart 
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0 
  cart.each do |name, item|
      total += item[:price] * item[:count]
  end 
  if total > 100 
    total = (total * 0.9).round(2)
  end 
  return total
end