module BasicResources
  class ProducerPresenter
    # @param producer [Producer]
    # @param user [User]
    def initialize(producer, user)
      @producer = producer
      @user = user
    end

    # Checks if the given user has edit rights on the producer
    #
    # @return [Boolean]
    def can_edit
      producer.admin?(user) || group_admin?
    end

    delegate :id, :name, :email, :address, :created_at, :updated_at, to: :producer

    private

    attr_reader :producer, :user

    # Checks if the producer is associated to a group
    # and if the user is an admin of that group
    #
    # @return [Boolean]
    def group_admin?
      return false unless group

      group.admin?(user)
    end

    # Retrieves the group associated to the producer
    #
    # We expect that if a producer has been created through a group
    # there is only one group in the `groups` collection. That's why
    # we blindly pick the first one.
    #
    # @return [Group]
    def group
      @group ||= producer.groups.first
    end
  end
end
