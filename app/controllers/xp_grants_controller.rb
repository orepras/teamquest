class XpGrantsController < ApplicationController
  before_action :require_character
  before_action :set_team
  before_action :require_team_membership

  def new
    @grant = @team.xp_grants.new
  end

  def create
    recipients = @team.characters.where(id: grant_params[:recipient_ids])
    amount = grant_params[:amount].presence ||
             XpGrant::CATEGORIES.dig(grant_params[:category], :default_xp)

    @grant = XpGrant.record!(
      team: @team,
      granter: current_character,
      category: grant_params[:category],
      amount: amount,
      note: grant_params[:note],
      recipients: recipients
    )
    redirect_to @team, notice: "⚡ #{@grant.amount} XP granted to #{recipients.map(&:name).to_sentence}!"
  rescue ActiveRecord::RecordInvalid => e
    @grant = e.record.is_a?(XpGrant) ? e.record : @team.xp_grants.new
    render :new, status: :unprocessable_entity
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def require_team_membership
    redirect_to @team, alert: "Join the party before granting XP." unless @team.member?(current_character)
  end

  def grant_params
    params.expect(xp_grant: [ :category, :amount, :note, recipient_ids: [] ])
  end
end
