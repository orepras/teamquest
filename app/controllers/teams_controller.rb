class TeamsController < ApplicationController
  before_action :require_character

  def index
    @teams = Team.active.includes(:characters).order(:name)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    ActiveRecord::Base.transaction do
      @team.save!
      @team.memberships.create!(character: current_character, role: "admin")
    end
    redirect_to @team, notice: "Party assembled! 🏰"
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def show
    @team = Team.find(params[:id])
    @members = @team.characters.order(xp_total: :desc)
    @grants = @team.xp_grants.effective
                   .includes(:granter, :recipients)
                   .order(created_at: :desc).limit(30)
  end

  def join
    team = Team.find(params[:id])
    membership = team.memberships.find_or_initialize_by(character: current_character)
    membership.role = "member" if membership.new_record?
    membership.left_at = nil
    membership.save!
    redirect_to team, notice: "You joined the party!"
  end

  private

  def team_params
    params.expect(team: [ :name, :description, :crest ])
  end
end
