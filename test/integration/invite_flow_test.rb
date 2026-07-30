require "test_helper"

class InviteFlowTest < ActionDispatch::IntegrationTest
  test "logged-out stranger follows invite link: register, forge, auto-join" do
    team = teams(:phoenix)
    invite = invite_path(team.invite_token)

    # Hitting the invite while logged out bounces to login, remembering the URL
    get invite
    assert_redirected_to new_session_path

    # They register instead — and are sent back to the invite
    post registration_path, params: { user: {
      email_address: "guest@example.com", password: "secret123", password_confirmation: "secret123"
    } }
    assert_redirected_to invite_url(team.invite_token)

    # No character yet → sent to the forge, invite remembered in session
    get invite
    assert_redirected_to new_my_character_path

    # Forging the character completes the join automatically
    post my_character_path, params: { character: {
      name: "Guest", character_class: "oracle", avatar: "🦉",
      strength: 5, intellect: 5, wisdom: 5, dexterity: 5, charisma: 5, constitution: 5
    } }
    assert_redirected_to team_path(team)
    assert team.member?(Character.find_by!(name: "Guest"))
  end

  test "existing member visiting invite is redirected, not duplicated" do
    sign_in_as users(:one) # rana, already a member
    get invite_path(teams(:phoenix).invite_token)
    assert_redirected_to team_path(teams(:phoenix))
    assert_equal 1, teams(:phoenix).memberships.where(character: characters(:rana)).count
  end

  test "user with character joins via accept button" do
    team = Team.create!(name: "Project Griffin", description: "New quest")
    sign_in_as users(:one)

    get invite_path(team.invite_token)
    assert_response :success

    post accept_invite_path(team.invite_token)
    assert_redirected_to team_path(team)
    assert team.member?(characters(:rana))
  end

  test "bogus token is rejected" do
    sign_in_as users(:one)
    get invite_path("not-a-real-token")
    assert_redirected_to root_path
  end

  private

  def sign_in_as(user)
    post session_path, params: { email_address: user.email_address, password: "password" }
  end
end
