# Vigie Modes

Vigie can be launched in several operating modes. Switching from one mode to another is done by activating features in the config file.

!!! tip "Reminder"
    Bear in mind that a monitoring solution must be more reliable than what you want to monitor.


### Standalone
*Vigie*
Single instance of Vigie, no other software dependencies.
Alerting is present, but the functions are minimal.

#### Great for:
  * Simple monitoring of non-critical services
  * Low footprint

### Complete Simple
*Vigie + TSDB*


An instance of Vigie is coupled to a TimeSeries database (InfluxDB or Warp10 *(WIP)*). Each test result is written in the database.
This allows to log the test returns. Grafana dashboards will allow you to analyze the results. More advanced alerting can be managed throw your TSDB.

#### Great for:
  * Monitoring non-critical services
  * Observability
  * Report SLO
 
### Complete HA
*Vigie + HA VigieState + HA TSDB*

*Draft* 


### Distributed
*Future* 