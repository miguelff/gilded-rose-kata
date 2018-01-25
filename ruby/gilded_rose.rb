class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if item.name == SpecialItems::AGED_BRIE
        AgedBrieUpdater.new(item).update
      elsif item.name == SpecialItems::SULFURAS
        SulfurasUpdater.new(item).update
      elsif item.name == SpecialItems::BACKSTAGE_PASSES
        BackstagePassesUpdater.new(item).update
      else
        legacy_update_quality item
      end
    end
  end

  def legacy_update_quality(item)
    if item.name != SpecialItems::AGED_BRIE and item.name != SpecialItems::BACKSTAGE_PASSES
      if item.quality > 0
        if item.name != SpecialItems::SULFURAS
          item.quality = item.quality - 1
        end
      end
    else
      if item.quality < 50
        item.quality = item.quality + 1
        if item.name == SpecialItems::BACKSTAGE_PASSES
          if item.sell_in < 11
            if item.quality < 50
              item.quality = item.quality + 1
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              item.quality = item.quality + 1
            end
          end
        end
      end
    end
    if item.name != SpecialItems::SULFURAS
      item.sell_in = item.sell_in - 1
    end
    if item.sell_in < 0
      if item.name != SpecialItems::AGED_BRIE
        if item.name != SpecialItems::BACKSTAGE_PASSES
          if item.quality > 0
            if item.name != SpecialItems::SULFURAS
              item.quality = item.quality - 1
            end
          end
        else
          item.quality = item.quality - item.quality
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
        end
      end
    end
  end
end

module SpecialItems
   AGED_BRIE = "Aged Brie".freeze
   SULFURAS = "Sulfuras, Hand of Ragnaros".freeze
   BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert".freeze
end

class ItemUpdater
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
    [item.quality - 1, 0].max
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
