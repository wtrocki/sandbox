package com.redhat.service.smartevents.processor.actions.slack;

import javax.enterprise.context.ApplicationScoped;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.node.TextNode;
import com.redhat.service.smartevents.infra.models.connectors.ConnectorType;
import com.redhat.service.smartevents.infra.models.gateways.Action;
import com.redhat.service.smartevents.processor.AbstractGatewayConnector;

@ApplicationScoped
public class SlackActionConnector extends AbstractGatewayConnector<Action> implements SlackAction {

    public static final ConnectorType CONNECTOR_TYPE = ConnectorType.SINK;
    public static final String CONNECTOR_TYPE_ID = "slack_sink_0.1";
    public static final String CONNECTOR_CHANNEL_PARAMETER = "slack_channel";
    public static final String CONNECTOR_WEBHOOK_URL_PARAMETER = "slack_webhook_url";

    public SlackActionConnector() {
        super(CONNECTOR_TYPE, CONNECTOR_TYPE_ID);
    }

    @Override
    protected void addConnectorSpecificPayload(Action action, String topicName, ObjectNode definition) {

        String slackChannel = action.getParameter(CHANNEL_PARAM);
        String webHookURL = action.getParameter(WEBHOOK_URL_PARAM);

        definition.set(CONNECTOR_CHANNEL_PARAMETER, new TextNode(slackChannel));
        definition.set(CONNECTOR_WEBHOOK_URL_PARAMETER, new TextNode(webHookURL));
        definition.set(CONNECTOR_TOPIC_PARAMETER, new TextNode(topicName));
    }
}
