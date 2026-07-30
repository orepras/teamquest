require "test_helper"

class CharacterTest < ActiveSupport::TestCase
  test "level curve matches PRD §3.4" do
    c = characters(:rana)
    { 0 => 1, 99 => 1, 100 => 2, 299 => 2, 300 => 3, 600 => 4, 1000 => 5 }.each do |xp, expected|
      c.xp_total = xp
      assert_equal expected, c.level, "#{xp} XP should be level #{expected}"
    end
  end

  test "point buy budget enforced at creation" do
    c = Character.new(
      user: User.new(email_address: "x@example.com", password: "password"),
      name: "Maxed", character_class: "artificer", avatar: "🧙",
      strength: 8, intellect: 8, wisdom: 8, dexterity: 8, charisma: 8, constitution: 8
    )
    assert_not c.valid?
    assert_match(/exceed the budget/, c.errors.full_messages.join)
  end

  test "stat cap only applies at creation" do
    c = characters(:rana)
    c.strength = 10
    assert c.valid?, "existing characters may grow stats past the creation cap"
  end

  test "xp_in_team sums only that team's grants" do
    assert_equal 25, characters(:rana).xp_in_team(teams(:phoenix))
  end
end
