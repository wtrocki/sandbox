Feature: BridgeIngress deploy and undeploy

  Background:
    Given create Namespace

  # Using "dummy" image as real BridgeIngress image requires Kafka
  Scenario: BridgeIngress is in phase AVAILABLE
    When deploy BridgeIngress:
    """
    apiVersion: com.redhat.service.bridge/v1alpha1
    kind: BridgeIngress
    metadata:
      name: my-bridge-ingress
      app.kubernetes.io/managed-by: bridge-fleet-shard-operator
    spec:
      image: nginx:1.14.2
      bridgeName: my-bridge
      customerId: customer
      id: my-bridge-ingress
    """
     
     Then the BridgeIngress "my-bridge-ingress" exists within 1 minute
     And the Deployment "my-bridge-ingress" is ready within 1 minute
     And the Service "my-bridge-ingress" exists within 1 minute
     And the Ingress "my-bridge-ingress" is ready within 1 minute
     And the BridgeIngress "my-bridge-ingress" is in phase "AVAILABLE" within 2 minutes

  # Using "dummy" image as real BridgeIngress image requires Kafka
  Scenario: BridgeIngress gets deleted
    Given deploy BridgeIngress:
    """
    apiVersion: com.redhat.service.bridge/v1alpha1
    kind: BridgeIngress
    metadata:
      name: my-deleted-bridge-ingress
      app.kubernetes.io/managed-by: bridge-fleet-shard-operator
    spec:
      image: nginx:1.14.2
      bridgeName: my-bridge
      customerId: customer
      id: my-bridge-ingress
    """
    And the BridgeIngress "my-deleted-bridge-ingress" is in phase "AVAILABLE" within 2 minutes

    When delete BridgeIngress "my-deleted-bridge-ingress"
     
    Then the BridgeIngress "my-deleted-bridge-ingress" does not exist within 1 minute
    And no Deployment exists within 1 minute
    And no Service exists within 1 minute
    And no Ingress exists within 1 minute