FROM hkim/roswell

RUN ros -e "(ql:quickload :r99)"

EXPOSE 4005

CMD ["ros", \
    "-e", "(ql:quickload :swank)", \
    "-e", "(setf swank::*loopback-interface* \"0.0.0.0\")", \
    "-e", "(swank:create-server)", \
    "-e", "(sleep 99999)"]
