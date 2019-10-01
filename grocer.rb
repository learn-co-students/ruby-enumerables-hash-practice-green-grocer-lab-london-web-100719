def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item|
    name = item.keys[0]
    details = item.values[0]
    if cart_hash[name] 
       cart_hash[name][:count] += 1 
     else
       cart_hash[name] = details
       cart_hash[name][:count] = 1
    end
  end
  return cart_hash
end 


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_item = coupon[:item]
    if cart[coupon_item]
      # do something to apply the discount
      
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
