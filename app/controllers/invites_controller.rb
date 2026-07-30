class InvitesController < ApplicationController
  before_action :set_team

  def show
    if current_character.nil?
      # Remember the invite so character creation can complete the join.
      session[:pending_invite_token] = @team.invite_token
      redirect_to new_my_character_path,
        notice: "Forge your character first — then you'll join #{@team.name}."
    elsif @team.member?(current_character)
      redirect_to @team, notice: "You're already in this party."
    end
  end

  def accept
    if current_character.nil?
      session[:pending_invite_token] = @team.invite_token
      return redirect_to new_my_character_path
    end
    @team.add_member!(current_character)
    redirect_to @team, notice: "Welcome to #{@team.name}! 🏰"
  end

  private

  def set_team
    @team = Team.active.find_by(invite_token: params[:token])
    redirect_to root_path, alert: "That invite link is invalid or expired." unless @team
  end
end
