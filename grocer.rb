 require "pry"

def consolidate_cart(cart)
  consolidate = Hash.new # create hash, default value = nil
  
  cart.each do |array| # {AVO..AVO..KALE}
    array.each do |item, attribute| # avocado => :price =>, etc.
    
      if !consolidate[item] # check if avo hash exists...
        consolidate[item] = Hash.new # if not, create hash for item
        consolidate[item] = {:count => 1} # avocado => :count..
      else # if avo hash exists
        consolidate[item][:count] += 1 # increment
      end
      consolidate[item].merge!(attribute) # merge price, clearance
    end            
  end
  
  return consolidate
end


  # need to check cases, ex: if coupons (:item => "item") matches any key ("item") in the cart
  # if no, then return item
  # if yes, then do the following...
  
def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_item = coupon[:item]
    if cart[coupon_item]
      if coupon[:num] <= cart[coupon_item][:count] &&
      !cart.has_key?("#{coupon_item} W/COUPON")
      
        cart["#{coupon_item} W/COUPON"] = {
          :price => (coupon[:cost] / coupon[:num]),
          :clearance => cart[coupon_item][:clearance],
          :count => coupon[:num]
        }
        cart[coupon_item][:count] -= coupon[:num]
        
      elsif coupon[:num] <= cart[coupon_item][:count] &&
      cart.has_key?("#{coupon_item} W/COUPON")
        
        cart["#{coupon_item} W/COUPON"][:count] += coupon[:num]
        cart[coupon_item][:count] -= coupon[:num]
        
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item, attribute|
    if attribute[:clearance] == true
      original_price = cart[item][:price]
      discount = 0.2
      discounted_price = original_price * (1.00 - discount)
      cart[item][:price] = discounted_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  
  current_cart = consolidate_cart(cart)
  
  discount_cart = apply_coupons(current_cart, coupons)
  
  clearance_cart = apply_clearance(discount_cart)

  clearance_cart.each do |item, attribute|
    count = clearance_cart[item][:count]
    price = clearance_cart[item][:price]
    total += count * price
  end
  
  if total > 100
    total_discount = 0.1
    discounted_total = total * (1.00 - total_discount)
    discounted_total.round(2)
  else
    total
  end
end
