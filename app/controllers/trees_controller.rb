class TreesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_tree, only: %i[ show edit update destroy ]
  before_action :authorize_user!, only: %i[edit update destroy]
  # GET /trees or /trees.json
  def index
    @trees = Tree.by_user(current_user).page(params[:page])
  end

  # GET /trees/1 or /trees/1.json
  def show
  end

  # GET /trees/new
  def new
    @tree = Tree.new
    @tree.x = "https://x.com/"
    @tree.youtube = "https://youtube.com/"
    @tree.instagram = "https://instagram.com/"
  end

  # GET /trees/1/edit
  def edit
  end

  # POST /trees or /trees.json

  def create
    @tree = Tree.new(tree_params)
    @tree.user = current_user

    respond_to do |format|
      if @tree.save
        format.html { redirect_to @tree, notice: "Tree was successfully created." }
        format.json { render :show, status: :created, location: @tree }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trees/1 or /trees/1.json
  def update
    respond_to do |format|
      if @tree.update(tree_params)
        format.html { redirect_to @tree, notice: "Tree was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @tree }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trees/1 or /trees/1.json
  def destroy
    if @tree.destroy
      redirect_to trees_path, notice: "Tree was successfully destroyed.", status: :see_other
    else
      redirect_to trees_path, alert: "Could not destroy tree.", status: :see_other
    end
  end

  def all_trees
    @trees = Tree.page params[:page]
  end

  private
    def set_tree
      @tree = Tree.friendly.find_by!(slug: params[:slug])
    end

    def tree_params
      params.require(:tree).permit(:name, :x, :instagram, :youtube, :style)
    end

    def authorize_user!
      redirect_to  trees_path,  alert: "Not authorized" unless @tree.user == current_user
    end
end
