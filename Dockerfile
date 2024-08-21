FROM ruby:2.6.5-alpine
 
WORKDIR /app
COPY . .
 
RUN gem install bundler
RUN bundle install
ENV RAILS_ENV=production
RUN bundle exec rails assets:precompile
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]