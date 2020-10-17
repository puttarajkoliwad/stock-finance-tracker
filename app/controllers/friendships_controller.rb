class FriendshipsController < ApplicationController

  def create
    friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)
    if current_user.save
      flash[:notice] = "Following #{friend.full_name} now!"
    else
      flash[:alert] = "Error! Could not follow #{friend.full_name}. Try again!"
    end
    redirect_to my_friends_path
  end

  def destroy
    friendship = Friendship.where(user_id: current_user, friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = "Unfollowed #{User.find(params[:id]).full_name}!"
    redirect_to my_friends_path
  end

end
