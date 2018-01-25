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
      aged_brie = Item.new(SpecialItems::AGED_BRIE, 10, 50)
      update_quality aged_brie
      expect(aged_brie.quality).to be <= 50
    end
  end

  describe "Corner cases:" do
    it "'Aged Brie' actually increases in quality the older it gets" do
      aged_brie = Item.new(SpecialItems::AGED_BRIE, 5, 10)
      update_quality aged_brie
      expect(aged_brie.quality).to eq(11)
      expect(aged_brie.sell_in).to eq(4)
    end

    it "'Sulfuras' never has to be sold or decreases in quality" do
      sulfuras = Item.new(SpecialItems::SULFURAS, 5, 10)
      expect { update_quality(sulfuras) }.to_not change{ sulfuras.quality }
      expect { update_quality(sulfuras) }.to_not change{ sulfuras.sell_in }
    end

    describe "'Backstage passes'" do
      it "increases quality by 1 when there are more than 10 days of sell-in value" do
        backstage_passes = Item.new(SpecialItems::BACKSTAGE_PASSES, 11, 5)
        update_quality backstage_passes
        expect(backstage_passes.quality).to eq(6)
        expect(backstage_passes.sell_in).to eq(10)
      end

      it "increases quality by 2 when there are 10 days or less of sell-in value" do
        backstage_passes = Item.new(SpecialItems::BACKSTAGE_PASSES, 10, 5)
        update_quality backstage_passes
        expect(backstage_passes.quality).to eq(7)
        expect(backstage_passes.sell_in).to eq(9)

        backstage_passes = Item.new(SpecialItems::BACKSTAGE_PASSES, 6, 5)
        update_quality backstage_passes
        expect(backstage_passes.quality).to eq(7)
        expect(backstage_passes.sell_in).to eq(5)
      end

      it "increases quality by 3 when there are 5 days or less of sell-in value" do
        backstage_passes = Item.new(SpecialItems::BACKSTAGE_PASSES, 5, 10)
        update_quality backstage_passes
        expect(backstage_passes.quality).to eq(13)
        expect(backstage_passes.sell_in).to eq(4)

        backstage_passes = Item.new(SpecialItems::BACKSTAGE_PASSES, 1, 10)
        update_quality backstage_passes
        expect(backstage_passes.quality).to eq(13)
        expect(backstage_passes.sell_in).to eq(0)
      end

      it "drops to 0 after the concert" do
        backstage_passes = Item.new(SpecialItems::BACKSTAGE_PASSES, 0, 10)
        update_quality backstage_passes
        expect(backstage_passes.quality).to eq(0)
      end
    end
  end
end
