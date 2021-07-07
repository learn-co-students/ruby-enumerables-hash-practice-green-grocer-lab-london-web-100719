
def consolidate_cart(cart)
  # code here
  consolidated_cart = {}

  cart.each do |item|
    item_name = item.keys.first
    item_content = item.values[0]
   

    #puts item.keys.first
    #puts item_content
    if consolidated_cart[item_name]
      consolidated_cart[item_name][:count] += 1
    else 
      consolidated_cart[item_name] = item_content
      consolidated_cart[item_name][:count] = 1
    end

  end

  consolidated_cart
  
  
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |coupon|
    coupon_item = coupon[:item]
    # check if coupon item exist in cart, if not exit
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
  cart
end

def apply_clearance(cart)
  # code here

  cart.each do |i, item|
    # check if item clearance exist
    if !!item[:clearance]
      item[:price] = (item[:price] * 0.8).round(2)
    end
  end

  cart
end

#work

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  total = cart.reduce(0) {| memo, (i, item)| memo + (item[:price] * item[:count])}

  total > 100 ? (total - (total * 0.1)).round(2) : total.round(2)
end
