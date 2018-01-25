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
  end
end
