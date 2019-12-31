FROM koalaman/shellcheck-alpine

RUN apk add --no-cache git make perl \
    && git config --global user.email "you@example.com" \
    && git config --global user.name "Your Name"

ADD ./ /client-git-hooks/
WORKDIR /client-git-hooks/

RUN make
