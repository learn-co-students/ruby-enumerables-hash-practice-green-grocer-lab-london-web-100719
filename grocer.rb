def consolidate_cart(cart)

  cons_hash = {}

  cart.map {|item| item.values[0][:count] = 1}

  x = 0

  while x < cart.size

    if cons_hash.key?(cart[x].keys[0])

      cons_hash.values[cons_hash.keys.index(cart[x].keys[0])][:count] += 1

    else

      cons_hash = cons_hash.merge(cart[x])

    end

    x += 1

  end

  return cons_hash

end


def apply_coupons(cart, coupons)

  coupons_hash = {}
  coupons_used = []

  coupons.flatten.each_with_index {|item, index|
  #p  "#{coupons[index]} is Index #{index}"

      #if coupons_hash.keys.any? {|key| coupons_hash[key] == key}
     # if  !!coupons_hash.keys[index] == coupons_hash.keys.any? {|key| coupons_used.include? (key) }
  #p item
  #p item[:item]

    if coupons_used.include? (item[:item])

        #p "I should run second and double the coupon if it's the same"
        coupons_hash.each {|item|

          #Blocking out the next line fixed "can increment coupon count if two are applied" for some reason. My understanding was that it had to double the coupon i.e. apply the same discount twice so it would go from 2 for 5.00 to 2 for 4.00 etc.
          #coupons_hash[item[0]][:cost] -= (cart[item[0]][:price] * coupons_hash[item[0]][:num] - coupons_hash[item[0]][:cost])

        }
        #p coupons_hash.keys[index]
        #p coupons_used
        #p index

      else

        #p "I should run first and add each unique coupon"
        coupons_hash[item[:item]] = {num: item[:num], cost: item[:cost]}
        coupons_used.push(coupons_hash.keys[index])
        #p coupons_hash.keys[index]
        #p coupons_used
        #p index
        #p coupons

      end

    }
     #transforms the coupons array into a nested hash where the item name becomes the new key and the rest of the that array item becomes the value; should work for multiple coupons so coupons_hash ends up looking like
# {
#   "AVOCADO" => {:num => 2, :cost => 5.00},
#   "KALE" => {:num => 2, :cost => 4.00},
#   "BUTTER" => {:num => 2, :cost => 6.00}
# }

    if cart.keys.any? {|key| !!coupons_hash[key]}

       coupons_hash.each_with_index {|item, index|
          temp_var = 0
          hoisted_var = cart[item[0]][:count] / coupons_hash[item[0]][:num]
          hoisted_var.times do

            cart[item[0]][:count] -= coupons_hash[item[0]][:num]
            cart["#{coupons_hash.keys[index]} W/COUPON"] = {price: (coupons_hash[item[0]][:cost]/ coupons_hash[item[0]][:num] * 1.0), clearance: cart[item[0]][:clearance], count: (temp_var += coupons_hash[item[0]][:num])}

       end
       }

    end

  return cart

end

def apply_clearance(cart)

  cart.values.each {|value|

    if value[:clearance] == true

      value[:price] *= 0.8
      value[:price] = value[:price].round(2)

    end

    }

  return cart

end

def checkout(cart, coupons)


  cart_after_cons = consolidate_cart(cart)
  cart_total = 0
  cart_after_cons.each {|item| cart_total += item[1][:price] * item[1][:count]}

  cart_after_coupons = apply_coupons(cart_after_cons, coupons)

  cart_after_clearance = apply_clearance(cart_after_coupons)

  cart_total = 0
  cart_after_clearance.each {|item| cart_total += item[1][:price] * item[1][:count]}

  cart_total > 100 ? cart_total *= 0.9 : cart_total

  return cart_total

end
