# helm-microservices-demo
This project is only for demo purpose.
The deployment will use Helm v3
It contains custom Helm chart template for sample stateless go microservices app.
The chart template contains kubernetes object such as:
1. Deployment: 
  - Pod template for meta data such as label selector that is usually use for service selector, and pod annotation for
  prometheus scrape to collect pod metrics.
  - Spec for specifying container, configmapref, pod resource, probe policy (readiness, liveness), node seleector, etc
2. Service 
  - Service type: to assign service type such as clusterip, nodeport, loadbalancer,etc
  - Port: to assign the port and target port for service exposer and forwarding.
  - protocol: to assign the protocol whether to use http,https,tcp,etc.
  - selector: to match the service with the designated pod/deployment
3. Ingress 
  - Ingress Annotation: to assign ingress nginx policy from ingress nginx controller, loadbalancer, or cert-manager,etc
  - Ingress rule: to specify routing policy and specify with services to exposed by the ingress.
4. Horizontal Pod Autoscaler
  - Min/max replicas: to assign the minimum and max number of pods contstraint
  - Resource utilization: to assign the value of CPU & memory metrics constraint should autoscaling pod is triggered.

All the values of chart template will be assign on values.yaml.
