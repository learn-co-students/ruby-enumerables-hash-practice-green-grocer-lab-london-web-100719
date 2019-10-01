def consolidate_cart(cart)
  result = Hash.new
  cart.each do |item|
    item.each_pair do |name, product|
      if result.has_key?(name)
        result[name][:count] += 1
      else
        new_item = {:price => product[:price], :clearance => product[:clearance], :count => 1 }
        result[name] = new_item
      end
    end
  end
  p result
end

def apply_coupons(cart, coupons)
  puts cart
  puts coupons
  result = Hash.new
  cart.each_pair do |name, product|
    item = result[name]
    if item == nil
      item = {:price => product[:price], :clearance => product[:clearance], :count => product[:count] }
      result[name] = item
    end
    coupons.each do |coupon|
      if coupon[:item] == name
        couponed_name = name + " W/COUPON"
        count = item[:count]
        if count >= coupon[:num]
          num = coupon[:num]
          if result.has_key?(couponed_name)
            result[couponed_name][:count] += num
          else
            price = coupon[:cost] / num
            couponed_item = {:price => price, :clearance => product[:clearance], :count => num }
            result[couponed_name] = couponed_item
          end
          item[:count] -= num
        end
      end
    end
  end
  puts cart
  p result
end

def apply_clearance(cart)
   cart.each_key { |item|

     if cart[item][:clearance] == true
       cart[item][:price] *= 0.8
       cart[item][:price] = cart[item][:price].round(2)
     end
   }
 cart
end

def checkout(cart, coupons)
    total = 0
  new_cart = consolidate_cart(cart)
  new_cart_coupons = apply_coupons(new_cart,coupons)
  new_cart_clearance = apply_clearance(new_cart_coupons)

  new_cart_clearance.keys.each do |item|
    total += (new_cart_clearance[item][:price] * new_cart_clearance[item][:count])
  end

  if total > 100
    total *= 0.9
  end

  total
end
