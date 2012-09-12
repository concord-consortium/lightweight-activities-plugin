class Portal::OfferingsController < ApplicationController

  def setup_portal_student
    learner = nil
    if portal_student = current_user.portal_student
      # create a learner for the user if one doesnt' exist
      learner = @offering.find_or_create_learner(portal_student)
    end
    learner
  end

  def answers
    @offering = Portal::Offering.find(params[:id])
    if @offering
      # learner = setup_portal_student
      # if learner && params[:questions]
      if params[:questions]
        # create saveables
        params[:questions].each do |dom_id, value|
          # translate the dom id into an actual Embeddable
          embeddable = parse_embeddable(dom_id)
          # create saveable
          # create_saveable(embeddable, @offering, learner, value) if embeddable
          create_saveable(embeddable, @offering, value) if embeddable
        end
      end
      flash[:notice] = "Your answers have been saved."
      redirect_to :back
    else
      render :text => 'problem loading offering', :status => 500
    end
  end

  private

  def parse_embeddable(dom_id)
    # make sure to support at least Embeddable::OpenResponse, Embeddable::MultipleChoice, and Embeddable::MultipleChoiceChoice
    if dom_id =~ /embeddable__([^\d]+)_(\d+)$/
      klass = "Embeddable::#{$1.classify}".constantize
      return klass.find($2.to_i) if klass
    end
    nil
  end

  # def create_saveable(embeddable, offering, learner, answer)
  def create_saveable(embeddable, offering, answer)
    case embeddable
    when Embeddable::OpenResponse
      saveable_open_response = Saveable::OpenResponse.find_or_create_by_offering_id_and_open_response_id(offering.id, embeddable.id)
      if saveable_open_response.response_count == 0 || saveable_open_response.answers.last.answer != answer
        saveable_open_response.answers.create(:answer => answer)
      end
    when Embeddable::MultipleChoice
      choice = parse_embeddable(answer)
      answer = choice ? choice.choice : ""
      if embeddable && choice
        saveable = Saveable::MultipleChoice.find_or_create_by_offering_id_and_multiple_choice_id(offering.id, embeddable.id)
        if saveable.answers.empty? || saveable.answers.last.answer != answer
          saveable.answers.create(:choice_id => choice.id)
        end
      else
        if ! choice
          logger.error("Missing Embeddable::MultipleChoiceChoice id: #{choice_id}")
        elsif ! embeddable
          logger.error("Missing Embeddable::MultipleChoice id: #{choice.multiple_choice_id}")
        end
      end
    else
      nil
    end
  end

end
