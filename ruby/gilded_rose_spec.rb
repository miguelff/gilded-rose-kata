require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  def update_quality(*items)
    GildedRose.new(items).update_quality
  end

  describe "General requirements:" do
    it "Does not change the name" do
      item = Item.new("foo", 0, 0)
      update_quality item
      expect(item.name).to eq("foo")
    end

    it "At the end of the day, the system lowers both quality and and sell-in values" do
      item = Item.new("foo", 10, 20)
      update_quality item
      expect(item.sell_in).to eq(9)
      expect(item.quality).to eq(19)
    end

    it "Once the sell by date has passed, quality degrades twice as fast" do
      item = Item.new("foo", 0, 20)
      update_quality item
      expect(item.quality).to eq(18)
    end

    it "The quality of an item is never negative" do
      item = Item.new("foo", 10, 0)
      update_quality item
      expect(item.quality).to be >= 0
    end

    it "The quality of an item is never more than 50" do
      item = Item.new("foo", 10, 60)
      update_quality item
      expect(item.quality).to be <= 50
    end
  end

  describe "Corner cases:" do
    it "'Aged Brie' actually increases in quality the older it gets" do
      aged_brie = Item.new(SpecialItems::AGED_BRIE, 5, 10)
      update_quality aged_brie
      expect(aged_brie.quality).to eq(11)
    end

    it "'Sulfuras' never has to be sold or decreases in quality"
    describe "'Backstage passes'" do
      it "increases quality by 2 when there are 10 days or less of sell-in value"
      it "increases quality by 3 when there are 5 days or less of sell-in value"
      it "drops to 0 after the concert"
    end
  end
end
