# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    helper all_helpers_from_path "app/helpers"

    impersonates :user

    # Uncomment this to scope the admin by the current account
    # include SetCurrentRequestDetails

    def authenticate_admin
      redirect_to "/", alert: "Not authorized." unless user_signed_in? && true_user.admin?
    end

    def order
      @order ||= Administrate::Order.new(
        params.fetch(resource_name, {}).fetch(:order, "id"),
        params.fetch(resource_name, {}).fetch(:direction, "asc")
      )
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
