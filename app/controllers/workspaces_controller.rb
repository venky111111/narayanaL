class WorkspacesController < ApplicationController


 def index
    if params[:title].present?
    	
      @work_spaces = Workspace.where("title LIKE ?", "%#{params[:title]}%")
    	
    render json: @work_spaces, each_serializer: WorkspaceSerializer, status: :ok	

    else
      render json: {messages: "no results found with that title"},status: :ok
    end
 end





end
