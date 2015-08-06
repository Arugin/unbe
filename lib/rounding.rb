module Rounding
  class << self
    SUFFIXES = {
        -12 => "p",
        -9 => "n",
        -6 => "u",
        -3 => "m",
        0 => "",
        3 => "K",
        6 => "M",
        9 => "G",
        12 => "T",
        15 => "P",
        18 => "E"
    }
    def round_with_precision(number, precision)
      result = (number * (10 ** precision)).round.to_f / (10 ** precision)
      if precision == 0
        result.to_i
      else
        result
      end
    end
    def humanize_number(number, precision = 2, suffix="", spacing="")
      k = 0
      original = number
      while number >= 1
        k += 3
        number /= 1000.0
      end
      k -= 3
      number = round_with_precision(number * 1000.0, precision)
      if number == 0
        "#{number}#{spacing}#{suffix}"
      else
        "#{number}#{spacing}#{get_suffix(k)}#{suffix}"
      end
    end

    def round_error(error)
      exp = - (Math::log(error) / Math::log(10)).round
      if (error * 10 ** exp).floor == 1 then
        exp += 1
      end
      exp
    end

    def humanize_number2(number, precision = 2, suffix="", spacing="")
      error = number[1]
      original = number[0]
      exp = round_error(number[1])
      "(#{(original * 10 ** exp).round} +- #{(error * 10 ** exp).round})*10^#{-exp} #{suffix}"
    end

    def round_order(number)
      k = 0
      number_i = number.to_i
      if number_i >= 1 then
        while number_i > 1
          number_i /= 1000
          k -= 3
        end
        return (k + 3)
      elsif number_i == 0 then
        return 0
      else
        while number_i <= 1
          number_i *= 1000
          k += 3
        end
        return k
      end
    end

    def get_suffix(order)
      if SUFFIXES[order].nil? then
        "10^#{order}"
      else
        SUFFIXES[order]
      end
    end

    def humanize_number3(number, precision = 2, suffix="", html=false)
      order = number.map { |n| round_order(n) }.max
      rounded = number.map do |n|
        round_with_precision(n.to_f * 10**order , precision)
      end
      ordersuffix = get_suffix(-order)
      if html then
        plusminus = "&plusmn;"
      else
        plusminus = "+-"
      end
      if precision != 0 then
        "#{rounded[0]} #{plusminus} #{rounded[1]} #{ordersuffix}#{suffix}"
      else
        "#{rounded[0].round} #{plusminus} #{rounded[1].round} #{ordersuffix}#{suffix}"
      end
    end
  end
end
