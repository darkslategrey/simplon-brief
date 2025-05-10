FROM alpine

ENV BUILD_PACKAGES bash curl curl-dev ruby-dev build-base
ENV RUBY_PACKAGES \
  ruby ruby-io-console ruby-irb \
  ruby-json ruby-etc ruby-bigdecimal ruby-rdoc \
  libffi-dev zlib-dev yaml-dev
ENV TERM=linux
ENV PS1 "\n\n>> ruby \W \$ "

RUN apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES
RUN echo 'gem: --no-document' > /etc/gemrc && \
    gem install bundler

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .
COPY .env .
COPY .env.test .
RUN bundle install

COPY importer.rb .
COPY api.rb .
COPY Rakefile .
COPY config.ru .
COPY tests/ tests/
COPY views/ views/
COPY public/ public/
COPY db/ db/
COPY data/ data/
COPY go.sh .
CMD ["bash"]
