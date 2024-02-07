class AddAdminToUsers < ActiveRecord::Migration[7.0]
  # def change
  #   add_column :users, :admin, :boolean
  # 何も設定されていない場合nilも含まれてしまうのでデフォルトをfalseにする
    add_column :users, :admin, :boolean, default: false
  end
