require "test_helper"

class XpGrantTest < ActiveSupport::TestCase
  test "record! creates grant and increments recipient xp" do
    rana = characters(:rana)
    assert_difference -> { rana.reload.xp_total }, 50 do
      XpGrant.record!(
        team: teams(:phoenix), granter: characters(:bimo),
        category: "task_large", amount: 50, note: "Big refactor",
        recipients: [ rana ]
      )
    end
  end

  test "cannot grant xp to yourself" do
    bimo = characters(:bimo)
    assert_raises ActiveRecord::RecordInvalid do
      XpGrant.record!(
        team: teams(:phoenix), granter: bimo,
        category: "assist", amount: 10, note: nil, recipients: [ bimo ]
      )
    end
  end

  test "requires at least one recipient" do
    assert_raises ActiveRecord::RecordInvalid do
      XpGrant.record!(
        team: teams(:phoenix), granter: characters(:bimo),
        category: "assist", amount: 10, note: nil, recipients: []
      )
    end
  end

  test "void! reverses the xp exactly once" do
    rana = characters(:rana)
    grant = XpGrant.record!(
      team: teams(:phoenix), granter: characters(:bimo),
      category: "bug_fix", amount: 15, note: nil, recipients: [ rana ]
    )
    before = rana.reload.xp_total
    grant.void!
    assert grant.voided_at?
    assert_equal before - 15, rana.reload.xp_total

    grant.void! # idempotent — must not subtract twice
    assert_equal before - 15, rana.reload.xp_total
  end
end
