require "test_helper"

class CoreFlowTest < ActionDispatch::IntegrationTest
  test "sign up, forge character, create team, grant xp" do
    # Sign up
    post registration_path, params: { user: {
      email_address: "dimas@example.com", password: "secret123", password_confirmation: "secret123"
    } }
    # Registration lands on root, which forwards character-less users to the forge
    assert_redirected_to root_url
    get root_path
    assert_redirected_to new_my_character_path

    # Forge character
    post my_character_path, params: { character: {
      name: "Dimas", character_class: "sentinel", avatar: "🦉",
      strength: 5, intellect: 5, wisdom: 5, dexterity: 5, charisma: 5, constitution: 5
    } }
    dimas = Character.find_by!(name: "Dimas")
    assert_redirected_to character_path(dimas)

    # Create a team
    post teams_path, params: { team: { name: "Project Hydra", description: "New client portal", crest: "🌊" } }
    team = Team.find_by!(name: "Project Hydra")
    assert team.admin?(dimas)

    # Another member joins and receives XP
    post join_team_path(teams(:phoenix))
    assert teams(:phoenix).member?(dimas)

    post team_xp_grants_path(teams(:phoenix)), params: { xp_grant: {
      category: "task_small", amount: "", note: "First quest", recipient_ids: [ characters(:rana).id ]
    } }
    assert_redirected_to team_path(teams(:phoenix))
    grant = XpGrant.order(:created_at).last
    assert_equal 10, grant.amount, "blank amount falls back to category default"
    assert_equal 35, characters(:rana).reload.xp_total
  end

  test "roster requires a character" do
    post registration_path, params: { user: {
      email_address: "noob@example.com", password: "secret123", password_confirmation: "secret123"
    } }
    get characters_path
    assert_redirected_to new_my_character_path
  end
end
