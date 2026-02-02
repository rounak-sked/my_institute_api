  class Ability
    include CanCan::Ability

    def initialize(user)
      return unless user

      if user.admin?
        can :manage, :all

      elsif user.faculty?
        # Courses
        can :read, Course
        can :create, Course
        can [:update, :destroy], Course

        # Batches
        can :read, Batch
        can :create, Batch
        can [:update, :destroy], Batch

        # Enrollments (students in their batches)
        can :read, Enrollment
        can :update, Enrollment
        can :approve, Enrollment  
        can :reject, Enrollment

      elsif user.student?
        can :read, Course
        can :create, Enrollment
        can :read, Enrollment
      end
    end
    
  end
