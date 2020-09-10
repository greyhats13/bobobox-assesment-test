# ELK Stack
ELK Stack is designed for logging, analytics and advanced observability.
Our primary ELK stack is using ELastic Cloud Kubernetes such as Elasticsearch, Kibana,
APM Server, and beat family.

ELK Stack covers these following stack:
- ElasticSearch 7.9.0 with Hot-Warm-Cold architecture
- Kibana 7.9.0
- Logstash 7.9.0 with predefined logstash pipeline developed using Grok
- APM Server 7.9.0 with tuned index and predefined ILM policy
- Beat Family:
  - Filebeat as logging agent (daemon-set) and output to logstash
  - Metricbeat as metric agent (daemon-set) and output to logstash with
    predefined kubernetes, system, and AWS modules
 

