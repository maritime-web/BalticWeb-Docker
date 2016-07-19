FROM fluent/fluentd:latest
USER fluent
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.2.0/bin:$PATH
RUN gem install fluent-plugin-secure-forward
RUN gem install fluent-plugin-elasticsearch
EXPOSE 24284
EXPOSE 24220
RUN cat /fluentd/etc/fluent.conf
CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT