def consolidate_cart(cart)
  new = {}
  cart.map do |i|
    if new[i.keys[0]]
      new[i.keys[0]][:count] += 1
    else
      new[i.keys[0]] = {
        count: 1,
        price: i.values[0][:price],
        clearance: i.values[0][:clearance]
      }
    end
  end
  new
end

def apply_coupons(cart, coupons)
  coupons.map do |coupon|
    if cart.keys.include? coupon[:item]
      if cart[coupon[:item]][:count] >= coupon[:num]
        new_name = "#{coupon[:item]} W/COUPON"
        if cart[new_name]
          cart[new_name][:count] += coupon[:num]
        else
          cart[new_name] = {
            count: coupon[:num],
            price: coupon[:cost]/coupon[:num],
            clearance: cart[coupon[:item]][:clearance]
          }
        end
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.map do |i|
    if cart[i][:clearance]
      cart[i][:price] = (cart[i][:price]*0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  co_cart = consolidate_cart(cart)
  cart_with_coupons_applied = apply_coupons(co_cart, coupons)
  cart_with_discounts_applied = apply_clearance(cart_with_coupons_applied)

  total = 0.0
  cart_with_discounts_applied.keys.each do |i|
    total += cart_with_discounts_applied[i][:price]*cart_with_discounts_applied[i][:count]
  end
  total > 100.00 ? (total * 0.90).round : total
end