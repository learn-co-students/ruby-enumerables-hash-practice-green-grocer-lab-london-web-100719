=begin

For some reason, the consolidate_cart method I built works fine in irb, and it's outputs look up to spec, but it does not pass the learn tests.

def consolidate_cart(cart)
  
  # Let's start by exploring how to get deeper and deeper into this nested data.
  # cart.map { |memo| memo.map { |key, value| p key; value.map { |value| value[0]; p value[1] }}}
  
  #Tricky nesting! We want to do three things:
  # 1) Count all of the duplicate items in the cart.
  # 2) Simplify the cart, so it is only a list of items and their properties.
  # 2) Add :count as a property to the items in the simplified cart.
  
  item_counter = {}
  cart.map { |items| items.map { |item, properties| item_counter[item] ? item_counter[item] += 1 : item_counter[item] = 1 }}
  
  cart.map { |items| items.map { |item, properties| properties[:count] = item_counter[item] }}
    
  cart.uniq
  
end


I broke this one, too. I lost track of my solution, and began to fix point problems rather than think from first principles.

def apply_coupons(cart, coupons)
  
  # 1) Check if our item has a coupon && enough items
  # 1a) If the item earns the coupon, apply the coupon then add discounted items to checkout
  # 1b) If the item has no coupon, add items to checkout
  
  discounted_cart = {}
  cart.each do |item| #look at each item in the cart
    coupons.each do |coupon| #for each item in cart, look at each coupon
 #{coupon[:num]}"
      if (item[0] == coupon[:item]) && (item[1][:count] >= coupon[:num])
        #apply the coupon
        
        #Code below is causing a TypeError; no implicit conversion of Symbol into Integer... everything until this point works fine
        cart.push(
          {"#{item[0]} W/COUPON" => {
            :price => (coupon[:cost] / coupon[:num]), 
            :count => coupon[:num], 
            :clearance => item[0][:clearance]
          }})
        item[0][:count] -= coupon[:num]
      else
        puts "The coupon did not match"
      end
    end
  end
  cart
end
=end

def consolidate_cart(cart)
  new_hash = {}
  cart.each do |item|
    if new_hash[item.keys[0]]
      new_hash[item.keys[0]][:count] += 1
    else
      new_hash[item.keys[0]] = {
        count: 1,
        price: item.values[0][:price],
        clearance: item.values[0][:clearance]
      }
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include? coupon[:item]
      if cart[coupon[:item]][:count] >= coupon[:num]
        discount_name = "#{coupon[:item]} W/COUPON"
        if cart[discount_name]
          cart[discount_name][:count] += coupon[:num]
        else
          cart[discount_name] = {
            price: coupon[:cost]/coupon[:num],
            clearance: cart[coupon[:item]][:clearance],
            count: coupon[:num]
          }
        end
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.keys.each do |item|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price]*0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  
  total = 0.0
  clearance_cart.keys.each do |item|
    total += clearance_cart[item][:price] * clearance_cart[item][:count]
  end
  if total > 100
    total = (total * 0.90).round(2)
  end
  total
end
