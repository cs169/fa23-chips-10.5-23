heroku addons:destroy heroku-postgresql 
heroku addons:create heroku-postgresql 
heroku run rake db:migrate
heroku run rake db:seed