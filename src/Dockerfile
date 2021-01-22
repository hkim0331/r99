from hkim/roswell:1.4

EXPOSE 4005

CMD ["ros", \
  "-e", "(ql:quickload :swank)", \
  "-e", "(setf swank::*loopback-interface* \"0.0.0.0\")",\
  "-e", "(swank:create-server)", \
  "-e", "(sleep 1000)"]
