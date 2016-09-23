namespace :reset do
  desc 'Reset passwords'
  task passwords: :environment do
    if User.count < 0
      puts 'Script could not be run. No user on DB.'
    else
      @users = User.all
      @users.each do |user|
        user.password = 'ChangeMe'
        user.save
      end
      puts 'All users password have been reseted'
    end
  end
end
