FROM jy01095902/ruby:latest

WORKDIR /usr/src/app

COPY Gemfile ./
RUN bundle install

COPY . .

EXPOSE 9293

CMD ["rackup", "--host", "0.0.0.0", "--port", "9293"]



# ruby镜像构建

# FROM ubuntu:latest

# RUN apt-get update && apt-get install sudo
# RUN sudo apt-get install -y ruby-full && sudo gem install bundle
# RUN sudo apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev
# RUN mkdir /usr/src/app