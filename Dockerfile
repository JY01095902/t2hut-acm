FROM jy01095902/ruby-gm:latest

WORKDIR /usr/src/app

COPY Gemfile ./
RUN bundle install

COPY . .

EXPOSE 9293

CMD ["rackup", "--host", "0.0.0.0", "--port", "9293"]