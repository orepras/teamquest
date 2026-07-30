class CharactersController < ApplicationController
  before_action :require_character, only: %i[index show]

  # The guild roster
  def index
    @characters = Character.order(xp_total: :desc)
  end

  def show
    @character = Character.find(params[:id])
    @recent_grants = @character.received_grants
                               .includes(:team, :granter)
                               .order(created_at: :desc).limit(15)
  end

  def new
    return redirect_to character_path(current_character) if current_character
    @character = Character.new(Character::ATTRIBUTES.keys.index_with { 5 })
  end

  def create
    @character = Current.user.build_character(character_params)
    if @character.save
      if (token = session.delete(:pending_invite_token)) &&
         (team = Team.active.find_by(invite_token: token))
        team.add_member!(@character)
        redirect_to team_path(team), notice: "Your legend begins in #{team.name}! ⚔️"
      else
        redirect_to character_path(@character), notice: "Your legend begins! ⚔️"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @character = current_character or redirect_to(new_my_character_path)
  end

  def update
    @character = current_character
    if @character.update(character_params)
      redirect_to character_path(@character), notice: "Character sheet updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def character_params
    params.expect(character: [ :name, :character_class, :subclass, :avatar, :backstory,
                               :strength, :intellect, :wisdom, :dexterity, :charisma, :constitution,
                               skill_ids: [] ])
  end
end
