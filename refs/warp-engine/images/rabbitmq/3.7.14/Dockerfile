FROM rabbitmq:3.7-management

COPY rabbitmq_delayed_message_exchange-20171201-3.7.x.ez /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange-20171201-3.7.x.ez
#RUN rabbitmq-plugins list
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange