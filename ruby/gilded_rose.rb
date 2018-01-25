class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      ItemUpdater.for(item).update
    end
  end
end

module SpecialItems
   AGED_BRIE = "Aged Brie".freeze
   SULFURAS = "Sulfuras, Hand of Ragnaros".freeze
   BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert".freeze
   CONJURED = "Conjured".freeze
end

class ItemUpdater
  def self.for(item)
    strategies = { SpecialItems::AGED_BRIE        => AgedBrieUpdater,
                   SpecialItems::SULFURAS         => SulfurasUpdater,
                   SpecialItems::BACKSTAGE_PASSES => BackstagePassesUpdater }

    (strategies[item.name] || self).new(item)
  end

  def initialize(item)
    @item = item
  end

  def update
    duplicate = @item.dup
    new_sell_in = update_sell_in(duplicate)
    new_quality = update_quality(duplicate)

    @item.sell_in = new_sell_in
    @item.quality = new_quality
  end

  def update_sell_in(item)
    [item.sell_in - 1, 0].max
  end

  def update_quality(item)
    quality_decrease = item.sell_in <= 0 ? 2 : 1
    [item.quality - quality_decrease, 0].max
  end
end

class AgedBrieUpdater < ItemUpdater
  def update_quality(item)
    [item.quality + 1, 50].min
  end
end

class BackstagePassesUpdater < ItemUpdater
  def update_quality(item)
    sell_in     = item.sell_in
    quality     = item.quality

    new_quality = if sell_in <= 0
                    0
                  elsif sell_in > 0 && sell_in <= 5
                    quality + 3
                  elsif sell_in > 5 && sell_in <= 10
                    quality + 2
                  else
                    quality + 1
                  end

    [new_quality, 50].min
  end
end

class SulfurasUpdater < ItemUpdater
  def update
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
