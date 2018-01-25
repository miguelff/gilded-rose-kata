class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if item.name == SpecialItems::AGED_BRIE
        AgedBrieUpdater.new(item).update
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

class AgedBrieUpdater

  def initialize(item)
    @item = item
  end

  def update
    update_sell_in_value(@item)
    update_quality(@item)
  end

  def update_sell_in_value(item)
    item.sell_in = [item.sell_in - 1, 0].max
  end

  def update_quality(item)
    item.quality = [item.quality + 1, 50].min
  end
end

module SpecialItems
   AGED_BRIE = "Aged Brie".freeze
   SULFURAS = "Sulfuras, Hand of Ragnaros".freeze
   BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert".freeze
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
