FROM ruby:2.5-alpine3.10

RUN mkdir /usr/src/app

WORKDIR /usr/src/app

COPY Gemfile ./

RUN bundle install

COPY . .

EXPOSE 9293

CMD ["rackup", "--host", "0.0.0.0", "--port", "9293"]