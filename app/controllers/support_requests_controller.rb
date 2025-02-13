class SupportRequestsController < ApplicationController
  def index
    @support_requests =
      SupportRequest.with_all_rich_text.includes(order: [ line_items: :product ])
  end

  def update
    support_request = SupportRequest.find(params[:id])
    support_request.update(params.expect(support_request: [ :response ]))
    SupportRequestMailer.respond(support_request).deliver_now
    redirect_to support_requests_path
  end
end
